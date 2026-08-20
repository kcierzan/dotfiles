import { mkdir, mkdtemp, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { dirname, join } from "node:path";
import type { ExecResult, ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { afterEach, describe, expect, it, vi } from "vitest";
import { runQualityChecks } from "./quality.ts";

const temporaryDirectories: string[] = [];

afterEach(async () => {
	await Promise.all(
		temporaryDirectories.splice(0).map((path) => rm(path, { recursive: true })),
	);
});

async function project(files: Record<string, string>): Promise<string> {
	const cwd = await mkdtemp(join(tmpdir(), "pi-workflow-"));
	temporaryDirectories.push(cwd);
	for (const [path, content] of Object.entries(files)) {
		const target = join(cwd, path);
		await mkdir(dirname(target), { recursive: true });
		await writeFile(target, content);
	}
	return cwd;
}

function success(stdout = "ok"): ExecResult {
	return { stdout, stderr: "", code: 0, killed: false };
}

async function discoveredCommands(
	files: Record<string, string>,
): Promise<{ commands: string[]; passed: boolean[] }> {
	const cwd = await project(files);
	const checks = await runQualityChecks(
		{ exec: vi.fn(async () => success()) } as unknown as Pick<
			ExtensionAPI,
			"exec"
		>,
		cwd,
		{ projectTrusted: true },
	);
	return {
		commands: checks.map((check) => check.command),
		passed: checks.map((check) => check.passed),
	};
}

describe("quality-check discovery", () => {
	it("keeps package-script validation for Pi and web extensions", async () => {
		const manifest = JSON.stringify({
			packageManager: "pnpm@11.22.0",
			scripts: { typecheck: "tsgo", lint: "biome", test: "vitest" },
		});
		expect(await discoveredCommands({ "package.json": manifest })).toEqual({
			commands: ["pnpm typecheck", "pnpm lint", "pnpm test"],
			passed: [true, true, true],
		});
	});

	it("discovers Go vet, golangci-lint, and package tests", async () => {
		expect(
			await discoveredCommands({
				"go.mod": "module example.com/app\n",
				".golangci.yml": "linters: {}\n",
			}),
		).toEqual({
			commands: ["go vet ./...", "golangci-lint run", "go test ./..."],
			passed: [true, true, true],
		});
	});

	it("discovers Sorbet, RuboCop, and RSpec for Ruby", async () => {
		const gemfile = 'gem "sorbet"\ngem "rubocop"\ngem "rspec"\n';
		expect(await discoveredCommands({ Gemfile: gemfile })).toEqual({
			commands: [
				"bundle exec srb tc",
				"bundle exec rubocop",
				"bundle exec rspec",
			],
			passed: [true, true, true],
		});
	});

	it.each([
		[
			"Stack",
			{ "stack.yaml": "resolver: lts-22.0\n" },
			["stack build --test --no-run-tests", "hlint .", "stack test"],
		],
		[
			"Cabal",
			{ "app.cabal": "name: app\n" },
			["cabal build all", "hlint .", "cabal test all"],
		],
	] as const)(
		"discovers the %s Haskell toolchain",
		async (_name, files, commands) => {
			expect(await discoveredCommands(files)).toEqual({
				commands: [...commands],
				passed: [true, true, true],
			});
		},
	);

	it("uses Odin compiler checks and tests without inventing a linter", async () => {
		expect(await discoveredCommands({ "main.odin": "package main\n" })).toEqual(
			{
				commands: [
					"odin check .",
					"Odin has no assumed lint command",
					"odin test .",
				],
				passed: [true, false, true],
			},
		);
	});

	it("uses explicit argv commands for ambiguous or project-specific toolchains", async () => {
		const config = JSON.stringify({
			quality: {
				static: { command: "odin", args: ["check", "src"] },
				lint: { command: "my-odin-lint", args: ["src"] },
				tests: { command: "odin", args: ["test", "tests"] },
			},
		});
		expect(
			await discoveredCommands({
				".pi/workflow.json": config,
				"main.odin": "package main\n",
				"package.json": "{}",
			}),
		).toEqual({
			commands: ["odin check src", "my-odin-lint src", "odin test tests"],
			passed: [true, true, true],
		});
	});

	it("fails closed for untrusted projects and ambiguous polyglot roots", async () => {
		const cwd = await project({ "go.mod": "module app\n" });
		const pi = { exec: vi.fn(async () => success()) } as unknown as Pick<
			ExtensionAPI,
			"exec"
		>;
		await expect(runQualityChecks(pi, cwd)).rejects.toThrow("trusted project");

		const polyglot = await project({
			"go.mod": "module app\n",
			"package.json": "{}",
		});
		await expect(
			runQualityChecks(pi, polyglot, { projectTrusted: true }),
		).rejects.toThrow("Multiple project ecosystems");
	});

	it("records process failures and bounded diagnostics without skipping later gates", async () => {
		const cwd = await project({
			"package.json": JSON.stringify({
				scripts: { typecheck: "tsgo", lint: "biome", test: "vitest" },
			}),
		});
		const exec = vi.fn(async (_command: string, args: string[]) => {
			if (args.at(-1) === "lint") throw new Error("x".repeat(5_000));
			return success();
		});
		const checks = await runQualityChecks(
			{ exec } as unknown as Pick<ExtensionAPI, "exec">,
			cwd,
			{ projectTrusted: true },
		);
		expect(checks.map((check) => check.passed)).toEqual([true, false, true]);
		expect(checks[1].output.length).toBeLessThan(4_100);
		expect(checks[1].output).toContain("Earlier output omitted");
	});
});
