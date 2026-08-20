import { access, readdir, readFile } from "node:fs/promises";
import { join } from "node:path";
import {
	CONFIG_DIR_NAME,
	type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";
import type { CheckName, CheckResult } from "./review-state.ts";

const MAX_OUTPUT_CHARS = 4_000;
const CHECK_TIMEOUT_MS = 10 * 60_000;
const CHECK_NAMES: CheckName[] = ["static", "lint", "tests"];

interface PackageManifest {
	packageManager?: unknown;
	scripts?: unknown;
}

interface CheckCommand {
	name: CheckName;
	label: string;
	executable: string;
	args: string[];
}

interface MissingCheck {
	name: CheckName;
	label: string;
	reason: string;
}

type CheckDefinition = CheckCommand | MissingCheck;
type QualityProfile = Record<CheckName, CheckDefinition>;

export async function runQualityChecks(
	pi: Pick<ExtensionAPI, "exec">,
	cwd: string,
	options: { projectTrusted: boolean } = { projectTrusted: false },
): Promise<CheckResult[]> {
	if (!options.projectTrusted) {
		throw new Error("Quality checks require a trusted project.");
	}
	const profile = await discoverQualityProfile(cwd);
	const results: CheckResult[] = [];
	for (const name of CHECK_NAMES) {
		const check = profile[name];
		if (!("executable" in check)) {
			results.push({
				name,
				command: check.label,
				passed: false,
				durationMs: 0,
				output: check.reason,
			});
			continue;
		}
		results.push(await runCheck(pi, cwd, check));
	}
	return results;
}

async function discoverQualityProfile(cwd: string): Promise<QualityProfile> {
	const configured = await readWorkflowConfig(cwd);
	if (configured) return configured;

	const entries = await readdir(cwd);
	const profiles: Array<{
		name: string;
		load: () => QualityProfile | Promise<QualityProfile>;
	}> = [];
	if (entries.includes("package.json"))
		profiles.push({
			name: "JavaScript/TypeScript",
			load: () => nodeProfile(cwd),
		});
	if (entries.includes("go.mod"))
		profiles.push({ name: "Go", load: () => goProfile(entries) });
	if (entries.includes("Gemfile"))
		profiles.push({ name: "Ruby", load: () => rubyProfile(cwd, entries) });
	if (
		entries.includes("stack.yaml") ||
		entries.some((entry) => entry.endsWith(".cabal"))
	)
		profiles.push({ name: "Haskell", load: () => haskellProfile(entries) });
	if (entries.some((entry) => entry.endsWith(".odin")))
		profiles.push({ name: "Odin", load: async () => odinProfile() });

	if (profiles.length === 0)
		return missingProfile("No supported project manifest was found.");
	if (profiles.length > 1) {
		throw new Error(
			`Multiple project ecosystems detected (${profiles.map((profile) => profile.name).join(", ")}). Define ${CONFIG_DIR_NAME}/workflow.json explicitly.`,
		);
	}
	return profiles[0].load();
}

async function readWorkflowConfig(
	cwd: string,
): Promise<QualityProfile | undefined> {
	const path = join(cwd, CONFIG_DIR_NAME, "workflow.json");
	let text: string;
	try {
		text = await readFile(path, "utf8");
	} catch (error) {
		if (isMissingFile(error)) return undefined;
		throw new Error(
			`Unable to read ${CONFIG_DIR_NAME}/workflow.json: ${errorMessage(error)}`,
		);
	}
	let value: unknown;
	try {
		value = JSON.parse(text);
	} catch (error) {
		throw new Error(
			`Invalid ${CONFIG_DIR_NAME}/workflow.json: ${errorMessage(error)}`,
		);
	}
	if (!isRecord(value) || !isRecord(value.quality)) {
		throw new Error(
			`${CONFIG_DIR_NAME}/workflow.json must contain a quality object.`,
		);
	}
	const quality = value.quality;
	return Object.fromEntries(
		CHECK_NAMES.map((name) => [
			name,
			parseConfiguredCheck(name, quality[name]),
		]),
	) as QualityProfile;
}

function parseConfiguredCheck(name: CheckName, value: unknown): CheckCommand {
	if (
		!isRecord(value) ||
		typeof value.command !== "string" ||
		!value.command.trim()
	) {
		throw new Error(
			`quality.${name}.command must be a non-empty executable name.`,
		);
	}
	if (
		!Array.isArray(value.args) ||
		!value.args.every((arg) => typeof arg === "string")
	) {
		throw new Error(`quality.${name}.args must be an array of strings.`);
	}
	const executable = value.command.trim();
	return command(name, executable, [...value.args]);
}

async function nodeProfile(cwd: string): Promise<QualityProfile> {
	const manifest = (await readJson(
		join(cwd, "package.json"),
	)) as PackageManifest;
	const scripts = parseScripts(manifest.scripts);
	const packageManager = await detectPackageManager(
		cwd,
		manifest.packageManager,
	);
	return {
		static: packageScript(
			"static",
			packageManager,
			["typecheck", "check:types"],
			scripts,
		),
		lint: packageScript("lint", packageManager, ["lint"], scripts),
		tests: packageScript("tests", packageManager, ["test"], scripts),
	};
}

function goProfile(entries: string[]): QualityProfile {
	const golangciConfig = entries.some((entry) =>
		[
			".golangci.yml",
			".golangci.yaml",
			".golangci.toml",
			".golangci.json",
		].includes(entry),
	);
	return {
		static: command("static", "go", ["vet", "./..."]),
		lint: golangciConfig
			? command("lint", "golangci-lint", ["run"])
			: missing(
					"lint",
					"Go lint command not discovered",
					`Add a golangci-lint config or define ${CONFIG_DIR_NAME}/workflow.json.`,
				),
		tests: command("tests", "go", ["test", "./..."]),
	};
}

async function rubyProfile(
	cwd: string,
	entries: string[],
): Promise<QualityProfile> {
	const gemfile = await readFile(join(cwd, "Gemfile"), "utf8");
	const hasSorbet = entries.includes("sorbet") || /\bsorbet\b/.test(gemfile);
	const hasSteep = entries.includes("Steepfile") || /\bsteep\b/i.test(gemfile);
	const hasRubocop =
		entries.includes(".rubocop.yml") || /\brubocop\b/i.test(gemfile);
	const hasRspec = entries.includes("spec") || /\brspec\b/i.test(gemfile);
	return {
		static: hasSorbet
			? command("static", "bundle", ["exec", "srb", "tc"])
			: hasSteep
				? command("static", "bundle", ["exec", "steep", "check"])
				: missing(
						"static",
						"Ruby static-analysis command not discovered",
						`Configure Sorbet, Steep, or ${CONFIG_DIR_NAME}/workflow.json.`,
					),
		lint: hasRubocop
			? command("lint", "bundle", ["exec", "rubocop"])
			: missing(
					"lint",
					"Ruby lint command not discovered",
					`Configure RuboCop or ${CONFIG_DIR_NAME}/workflow.json.`,
				),
		tests: hasRspec
			? command("tests", "bundle", ["exec", "rspec"])
			: entries.includes("bin") && (await pathExists(join(cwd, "bin", "rails")))
				? command("tests", join("bin", "rails"), ["test"])
				: command("tests", "bundle", ["exec", "rake", "test"]),
	};
}

function haskellProfile(entries: string[]): QualityProfile {
	if (entries.includes("stack.yaml")) {
		return {
			static: command("static", "stack", ["build", "--test", "--no-run-tests"]),
			lint: command("lint", "hlint", ["."]),
			tests: command("tests", "stack", ["test"]),
		};
	}
	return {
		static: command("static", "cabal", ["build", "all"]),
		lint: command("lint", "hlint", ["."]),
		tests: command("tests", "cabal", ["test", "all"]),
	};
}

function odinProfile(): QualityProfile {
	return {
		static: command("static", "odin", ["check", "."]),
		lint: missing(
			"lint",
			"Odin has no assumed lint command",
			`Define the formatter or linter used by this project in ${CONFIG_DIR_NAME}/workflow.json.`,
		),
		tests: command("tests", "odin", ["test", "."]),
	};
}

async function runCheck(
	pi: Pick<ExtensionAPI, "exec">,
	cwd: string,
	check: CheckCommand,
): Promise<CheckResult> {
	const started = Date.now();
	try {
		const result = await pi.exec(check.executable, check.args, {
			cwd,
			timeout: CHECK_TIMEOUT_MS,
		});
		const combined = [result.stdout.trim(), result.stderr.trim()]
			.filter(Boolean)
			.join("\n");
		return {
			name: check.name,
			command: check.label,
			passed: result.code === 0 && !result.killed,
			durationMs: Date.now() - started,
			output: truncateTail(combined || "No output."),
		};
	} catch (error) {
		return {
			name: check.name,
			command: check.label,
			passed: false,
			durationMs: Date.now() - started,
			output: truncateTail(errorMessage(error)),
		};
	}
}

function packageScript(
	name: CheckName,
	packageManager: string,
	candidates: string[],
	scripts: Set<string>,
): CheckDefinition {
	const script = candidates.find((candidate) => scripts.has(candidate));
	if (!script) {
		return missing(
			name,
			`missing package script (${candidates.join(" or ")})`,
			"Required validation is not configured.",
		);
	}
	if (packageManager === "npm") return command(name, "npm", ["run", script]);
	if (packageManager === "bun") return command(name, "bun", ["run", script]);
	return command(name, packageManager, [script]);
}

function command(
	name: CheckName,
	executable: string,
	args: string[],
): CheckCommand {
	return {
		name,
		label: [executable, ...args].map(displayArgument).join(" "),
		executable,
		args,
	};
}

function missing(name: CheckName, label: string, reason: string): MissingCheck {
	return { name, label, reason };
}

function missingProfile(reason: string): QualityProfile {
	return Object.fromEntries(
		CHECK_NAMES.map((name) => [
			name,
			missing(
				name,
				`${name} command not discovered`,
				`${reason} Define ${CONFIG_DIR_NAME}/workflow.json.`,
			),
		]),
	) as QualityProfile;
}

function displayArgument(value: string): string {
	return /^[A-Za-z0-9_./:@%+=,-]+$/.test(value) ? value : JSON.stringify(value);
}

async function readJson(path: string): Promise<unknown> {
	try {
		return JSON.parse(await readFile(path, "utf8"));
	} catch (error) {
		throw new Error(`Unable to read ${path}: ${errorMessage(error)}`);
	}
}

function parseScripts(value: unknown): Set<string> {
	if (typeof value !== "object" || value === null) return new Set();
	return new Set(
		Object.entries(value)
			.filter(
				(entry): entry is [string, string] => typeof entry[1] === "string",
			)
			.map(([name]) => name),
	);
}

async function detectPackageManager(
	cwd: string,
	packageManager: unknown,
): Promise<string> {
	if (typeof packageManager === "string") {
		const separator = packageManager.indexOf("@", 1);
		const name =
			separator === -1 ? packageManager : packageManager.slice(0, separator);
		if (["pnpm", "npm", "yarn", "bun"].includes(name)) return name;
	}
	for (const [lockfile, name] of [
		["pnpm-lock.yaml", "pnpm"],
		["yarn.lock", "yarn"],
		["bun.lock", "bun"],
		["bun.lockb", "bun"],
		["package-lock.json", "npm"],
	] as const) {
		if (await pathExists(join(cwd, lockfile))) return name;
	}
	return "npm";
}

async function pathExists(path: string): Promise<boolean> {
	try {
		await access(path);
		return true;
	} catch {
		return false;
	}
}

function isMissingFile(error: unknown): boolean {
	return isRecord(error) && error.code === "ENOENT";
}

function isRecord(value: unknown): value is Record<string, unknown> {
	return typeof value === "object" && value !== null;
}

function errorMessage(error: unknown): string {
	return error instanceof Error ? error.message : String(error);
}

function truncateTail(output: string): string {
	if (output.length <= MAX_OUTPUT_CHARS) return output;
	return `[Earlier output omitted.]\n${output.slice(-MAX_OUTPUT_CHARS)}`;
}
