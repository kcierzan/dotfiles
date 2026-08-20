import { createHash } from "node:crypto";
import { mkdtemp, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import type {
	ExtensionAPI,
	ExtensionCommandContext,
	ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import { afterEach, describe, expect, it, vi } from "vitest";
import supervisedWorkflow, {
	commandAttemptsGitPublish,
	formatQualityFailures,
} from "./index.ts";
import { PLAN_MODE_ENTRY, PLAN_MODE_TOOLS } from "./plan-state.ts";
import {
	RETRO_PROPOSAL_TOOL,
	RETRO_READ_ONLY_TOOLS,
	RETRO_STATE_ENTRY,
} from "./retro-state.ts";
import { AGENT_REVIEW_TOOL, REVIEW_STATE_ENTRY } from "./review-state.ts";

type CommandHandler = (
	args: string,
	ctx: ExtensionCommandContext,
) => Promise<void>;
type EventHandler = (event: unknown, ctx: ExtensionContext) => unknown;

const temporaryDirectories: string[] = [];

afterEach(async () => {
	await Promise.all(
		temporaryDirectories.splice(0).map((path) => rm(path, { recursive: true })),
	);
});

function createHarness(cwd = "/repo") {
	const commands = new Map<string, CommandHandler>();
	const handlers = new Map<string, EventHandler[]>();
	const tools = new Map<string, unknown>();
	const entries: Array<{ customType: string; data: unknown }> = [];
	let activeTools = ["read", "bash", "edit", "hashline_edit"];
	let branch: unknown[] = [];

	const pi = {
		appendEntry(customType: string, data: unknown) {
			entries.push({ customType, data });
		},
		exec: vi.fn(),
		getActiveTools() {
			return [...activeTools];
		},
		on(eventName: string, handler: EventHandler) {
			handlers.set(eventName, [...(handlers.get(eventName) ?? []), handler]);
		},
		registerCommand(name: string, options: { handler: CommandHandler }) {
			commands.set(name, options.handler);
		},
		registerTool(tool: { name: string }) {
			tools.set(tool.name, tool);
		},
		sendMessage: vi.fn(),
		sendUserMessage: vi.fn(),
		setActiveTools(toolNames: string[]) {
			activeTools = [...toolNames];
		},
	};

	const ui = {
		confirm: vi.fn(async () => true),
		custom: vi.fn(),
		editor: vi.fn(),
		notify: vi.fn(),
		setStatus: vi.fn(),
		setWidget: vi.fn(),
		theme: { fg: (_color: string, text: string) => text },
	};
	const ctx = {
		cwd,
		hasUI: true,
		isProjectTrusted: () => true,
		mode: "tui",
		sessionManager: { getBranch: () => branch },
		ui,
		waitForIdle: vi.fn(async () => undefined),
	} as unknown as ExtensionCommandContext;

	supervisedWorkflow(pi as unknown as ExtensionAPI);

	return {
		commands,
		ctx,
		entries,
		exec: pi.exec,
		getActiveTools: () => activeTools,
		handler: (eventName: string) => {
			const handler = handlers.get(eventName)?.[0];
			if (!handler) throw new Error(`Missing ${eventName} handler`);
			return handler;
		},
		setBranch: (entries: unknown[]) => {
			branch = entries;
		},
		sendMessage: pi.sendMessage,
		tools,
		ui,
	};
}

describe("git publication policy", () => {
	it.each([
		"git commit -m done",
		"git -C ../repo push origin main",
		"/usr/bin/git commit --amend",
		"git --git-dir .git commit -m done",
		"git --work-tree=. --git-dir=.git push origin main",
		"command git -c user.name=bot commit",
		"pnpm test && git push",
	])("blocks %s", (command) => {
		expect(commandAttemptsGitPublish(command)).toBe(true);
	});

	it.each([
		"git status",
		"git diff --cached",
		"git commit-tree HEAD^{tree}",
		"echo commit",
		"pnpm test",
	])("allows %s", (command) => {
		expect(commandAttemptsGitPublish(command)).toBe(false);
	});
});

describe("quality diagnostics", () => {
	it("persists failed check output in a visible transcript message", async () => {
		const cwd = await mkdtemp(join(tmpdir(), "pi-workflow-index-"));
		temporaryDirectories.push(cwd);
		await writeFile(
			join(cwd, "package.json"),
			JSON.stringify({
				scripts: { typecheck: "tsgo", lint: "biome", test: "vitest" },
			}),
		);
		const harness = createHarness(cwd);
		const diff =
			"diff --git a/a.ts b/a.ts\n--- a/a.ts\n+++ b/a.ts\n@@ -1 +1 @@\n-old\n+new\n";
		harness.exec.mockImplementation(async (command: string, args: string[]) => {
			if (command === "git" && args[0] === "rev-parse")
				return { stdout: "true\n", stderr: "", code: 0, killed: false };
			if (command === "git" && args[0] === "ls-files")
				return { stdout: "", stderr: "", code: 0, killed: false };
			if (command === "git")
				return { stdout: diff, stderr: "", code: 0, killed: false };
			const failed = args.at(-1) === "lint";
			return {
				stdout: failed ? "lint diagnostic" : "ok",
				stderr: "",
				code: failed ? 1 : 0,
				killed: false,
			};
		});

		await harness.commands.get("quality-check")?.("", harness.ctx);
		expect(harness.sendMessage).toHaveBeenCalledWith(
			expect.objectContaining({
				customType: "supervised-workflow-quality",
				display: true,
				content: expect.stringContaining("lint diagnostic"),
			}),
		);
	});

	it("shows bounded failure output without terminal control sequences", () => {
		const message = formatQualityFailures([
			{
				name: "lint",
				command: "pnpm lint",
				passed: false,
				durationMs: 42,
				output: "bad rule\u001b[2J\nline two",
			},
		]);
		expect(message).toContain("pnpm lint");
		expect(message).toContain("bad rule");
		expect(message).toContain("line two");
		expect(message).not.toContain("\u001b[2J");
	});
});

describe("review workflow extension", () => {
	it("accepts a passing agent review only for the current validated patch", async () => {
		const harness = createHarness();
		const diff = `diff --git a/a.ts b/a.ts\n--- a/a.ts\n+++ b/a.ts\n@@ -1 +1 @@\n-old\n+new\n`;
		const hash = createHash("sha256").update(diff).digest("hex");
		harness.exec.mockImplementation(
			async (_command: string, args: string[]) => {
				if (args[0] === "rev-parse")
					return { stdout: "true\n", stderr: "", code: 0, killed: false };
				if (args[0] === "ls-files")
					return { stdout: "", stderr: "", code: 0, killed: false };
				return { stdout: diff, stderr: "", code: 0, killed: false };
			},
		);
		harness.setBranch([
			{
				type: "custom",
				customType: REVIEW_STATE_ENTRY,
				data: {
					stage: "agent-review",
					snapshotHash: hash,
					checks: [
						{
							name: "static",
							command: "pnpm typecheck",
							passed: true,
							durationMs: 1,
							output: "ok",
						},
						{
							name: "lint",
							command: "pnpm lint",
							passed: true,
							durationMs: 1,
							output: "ok",
						},
						{
							name: "tests",
							command: "pnpm test",
							passed: true,
							durationMs: 1,
							output: "ok",
						},
					],
					agentReview: null,
					toolsBeforeReview: ["read", "bash", "hashline_edit"],
				},
			},
		]);
		await harness.handler("session_tree")({}, harness.ctx);
		expect(harness.getActiveTools()).toContain(AGENT_REVIEW_TOOL);
		const tool = harness.tools.get(AGENT_REVIEW_TOOL) as {
			execute: (
				id: string,
				params: { verdict: "pass"; summary: string; findings: [] },
				signal: undefined,
				update: undefined,
				ctx: ExtensionContext,
			) => Promise<unknown>;
		};
		await tool.execute(
			"review",
			{ verdict: "pass", summary: "No findings.", findings: [] },
			undefined,
			undefined,
			harness.ctx,
		);
		expect(harness.getActiveTools()).not.toContain(AGENT_REVIEW_TOOL);
		expect(harness.entries.at(-1)).toMatchObject({
			customType: REVIEW_STATE_ENTRY,
			data: { stage: "review-ready" },
		});

		await harness.commands.get("request-review")?.("", harness.ctx);
		expect(harness.getActiveTools()).toEqual(["read", "grep", "find", "ls"]);
		await harness.commands.get("approve")?.("", harness.ctx);
		expect(harness.getActiveTools()).toEqual(["read", "bash", "hashline_edit"]);
		expect(harness.entries.at(-1)).toMatchObject({
			customType: REVIEW_STATE_ENTRY,
			data: { stage: "approved" },
		});
	});
});

describe("retrospective workflow extension", () => {
	it("records one evidence-based diff without applying it and requires human approval", async () => {
		const harness = createHarness();
		await harness.commands.get("retro")?.("validation friction", harness.ctx);
		expect(harness.getActiveTools()).toEqual([
			...RETRO_READ_ONLY_TOOLS,
			RETRO_PROPOSAL_TOOL,
		]);
		expect(harness.entries.at(-1)).toMatchObject({
			customType: RETRO_STATE_ENTRY,
			data: { stage: "collecting" },
		});
		expect(harness.ui.confirm).not.toHaveBeenCalled();

		const toolCall = harness.handler("tool_call");
		expect(await toolCall({ toolName: "write" }, harness.ctx)).toMatchObject({
			block: true,
			reason: expect.stringContaining("read-only"),
		});
		const beforeAgentStart = harness.handler("before_agent_start");
		expect(
			await beforeAgentStart({ systemPrompt: "base" }, harness.ctx),
		).toMatchObject({
			systemPrompt: expect.stringContaining("retrospective mode"),
		});

		const tool = harness.tools.get(RETRO_PROPOSAL_TOOL) as {
			execute: (
				id: string,
				params: {
					title: string;
					targetFile: string;
					rationale: string;
					expectedBenefit: string;
					evidence: Array<{ source: string; observation: string }>;
					risks: string[];
					validation: string[];
					diff: string;
				},
				signal: undefined,
				update: undefined,
				ctx: ExtensionContext,
			) => Promise<{ content: Array<{ text: string }> }>;
		};
		const result = await tool.execute(
			"retro",
			{
				title: "Clarify validation",
				targetFile: "AGENTS.md",
				rationale: "Observed command ambiguity.",
				expectedBenefit: "Fewer failed checks.",
				evidence: [
					{ source: "session", observation: "A command had to be corrected." },
				],
				risks: [],
				validation: ["Review the instruction."],
				diff: "--- /dev/null\n+++ b/AGENTS.md\n@@ -0,0 +1 @@\n+Run documented checks.\n",
			},
			undefined,
			undefined,
			harness.ctx,
		);
		expect(result.content[0].text).toContain("has not been applied");
		expect(harness.getActiveTools()).toEqual(RETRO_READ_ONLY_TOOLS);
		expect(harness.entries.at(-1)).toMatchObject({
			customType: RETRO_STATE_ENTRY,
			data: { stage: "proposed" },
		});

		await harness.commands.get("approve-retro")?.("", harness.ctx);
		expect(harness.ui.confirm).toHaveBeenCalledOnce();
		expect(harness.getActiveTools()).toEqual([
			"read",
			"bash",
			"edit",
			"hashline_edit",
		]);
		expect(harness.entries.at(-1)).toMatchObject({
			customType: RETRO_STATE_ENTRY,
			data: { stage: "approved" },
		});
	});
});

describe("strict plan mode extension", () => {
	it("restricts tools, fails closed, injects instructions, and restores the snapshot after approval", async () => {
		const harness = createHarness();
		await harness.commands.get("plan")?.("", harness.ctx);

		expect(harness.getActiveTools()).toEqual(PLAN_MODE_TOOLS);
		expect(harness.entries.at(-1)).toEqual({
			customType: PLAN_MODE_ENTRY,
			data: {
				enabled: true,
				toolsBeforePlan: ["read", "bash", "edit", "hashline_edit"],
			},
		});

		const toolCall = harness.handler("tool_call");
		expect(await toolCall({ toolName: "read" }, harness.ctx)).toBeUndefined();
		expect(
			await toolCall({ toolName: "hashline_edit" }, harness.ctx),
		).toMatchObject({ block: true });

		const beforeAgentStart = harness.handler("before_agent_start");
		expect(
			await beforeAgentStart({ systemPrompt: "base" }, harness.ctx),
		).toMatchObject({
			systemPrompt: expect.stringContaining("strictly read-only"),
		});

		await harness.commands.get("approve-plan")?.("", harness.ctx);
		expect(harness.ui.confirm).toHaveBeenCalledOnce();
		expect(harness.getActiveTools()).toEqual([
			"read",
			"bash",
			"edit",
			"hashline_edit",
		]);
		expect(harness.entries.at(-1)).toEqual({
			customType: PLAN_MODE_ENTRY,
			data: { enabled: false, toolsBeforePlan: null },
		});
	});

	it("keeps plan mode active when approval is declined", async () => {
		const harness = createHarness();
		harness.ui.confirm.mockResolvedValueOnce(false);
		await harness.commands.get("plan")?.("", harness.ctx);
		await harness.commands.get("approve-plan")?.("", harness.ctx);
		expect(harness.getActiveTools()).toEqual(PLAN_MODE_TOOLS);
	});

	it("restores tools when tree navigation leaves the plan branch", async () => {
		const harness = createHarness();
		await harness.commands.get("plan")?.("", harness.ctx);
		harness.setBranch([]);
		await harness.handler("session_tree")({}, harness.ctx);
		expect(harness.getActiveTools()).toEqual([
			"read",
			"bash",
			"edit",
			"hashline_edit",
		]);
	});

	it("restores plan mode from the selected session branch", async () => {
		const harness = createHarness();
		harness.setBranch([
			{
				type: "custom",
				customType: PLAN_MODE_ENTRY,
				data: { enabled: true, toolsBeforePlan: ["read", "bash"] },
			},
		]);
		await harness.handler("session_tree")({}, harness.ctx);
		expect(harness.getActiveTools()).toEqual(PLAN_MODE_TOOLS);
		await harness.commands.get("cancel-plan")?.("", harness.ctx);
		expect(harness.getActiveTools()).toEqual(["read", "bash"]);
	});
});
