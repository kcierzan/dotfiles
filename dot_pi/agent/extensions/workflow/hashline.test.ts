import { mkdtemp, readFile, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import type {
	ExtensionAPI,
	ExtensionContext,
} from "@earendil-works/pi-coding-agent";
import { afterEach, describe, expect, it } from "vitest";
import hashlineExtension from "../hashline.ts";

interface RegisteredTool {
	name: string;
	execute: (
		id: string,
		params: Record<string, unknown>,
		signal: undefined,
		update: undefined,
		ctx: ExtensionContext,
	) => Promise<{ content: Array<{ type: string; text?: string }> }>;
}

const temporaryDirectories: string[] = [];

afterEach(async () => {
	await Promise.all(
		temporaryDirectories.splice(0).map((path) => rm(path, { recursive: true })),
	);
});

async function harness() {
	const cwd = await mkdtemp(join(tmpdir(), "pi-hashline-"));
	temporaryDirectories.push(cwd);
	const tools = new Map<string, RegisteredTool>();
	const pi = {
		registerTool(tool: RegisteredTool) {
			tools.set(tool.name, tool);
		},
	};
	hashlineExtension(pi as unknown as ExtensionAPI);
	const read = tools.get("hashline_read");
	const edit = tools.get("hashline_edit");
	if (!read || !edit) throw new Error("Hashline tools were not registered.");
	const ctx = { cwd } as ExtensionContext;
	return { cwd, ctx, read, edit };
}

function text(result: {
	content: Array<{ type: string; text?: string }>;
}): string {
	return result.content.map((item) => item.text ?? "").join("\n");
}

function header(output: string): string {
	const value = output.split("\n")[0];
	if (!value?.startsWith("["))
		throw new Error(`Missing snapshot header: ${output}`);
	return value;
}

describe("hashline extension", () => {
	it("does not override Pi's built-in read tool", async () => {
		const app = await harness();
		expect(app.read.name).toBe("hashline_read");
	});

	it("does not expose a phantom line for a trailing newline", async () => {
		const app = await harness();
		const path = join(app.cwd, "one.txt");
		await writeFile(path, "one\n");

		const output = text(
			await app.read.execute(
				"read",
				{ path: "one.txt" },
				undefined,
				undefined,
				app.ctx,
			),
		);
		expect(output).toContain("1:one");
		expect(output).not.toContain("\n2:");

		await app.edit.execute(
			"edit",
			{ patch: `${header(output)}\nPUT 1.=1:\n+updated` },
			undefined,
			undefined,
			app.ctx,
		);
		expect(await readFile(path, "utf8")).toBe("updated\n");
	});

	it("round-trips snapshot headers for paths containing hash characters", async () => {
		const app = await harness();
		const path = join(app.cwd, "name#part.txt");
		await writeFile(path, "before\n");
		const output = text(
			await app.read.execute(
				"read",
				{ path: "name#part.txt" },
				undefined,
				undefined,
				app.ctx,
			),
		);

		await app.edit.execute(
			"edit",
			{ patch: `${header(output)}\nPUT 1.=1:\n+after` },
			undefined,
			undefined,
			app.ctx,
		);
		expect(await readFile(path, "utf8")).toBe("after\n");
	});

	it("preflights every section before mutating any file", async () => {
		const app = await harness();
		const firstPath = join(app.cwd, "first.txt");
		const secondPath = join(app.cwd, "second.txt");
		await writeFile(firstPath, "first\n");
		await writeFile(secondPath, "second\n");
		const first = text(
			await app.read.execute(
				"read",
				{ path: "first.txt" },
				undefined,
				undefined,
				app.ctx,
			),
		);
		const second = text(
			await app.read.execute(
				"read",
				{ path: "second.txt" },
				undefined,
				undefined,
				app.ctx,
			),
		);
		await writeFile(secondPath, "changed externally\n");

		await expect(
			app.edit.execute(
				"edit",
				{
					patch: `${header(first)}\nPUT 1.=1:\n+mutated\n${header(second)}\nPUT 1.=1:\n+also mutated`,
				},
				undefined,
				undefined,
				app.ctx,
			),
		).rejects.toThrow("stale");
		expect(await readFile(firstPath, "utf8")).toBe("first\n");
		expect(await readFile(secondPath, "utf8")).toBe("changed externally\n");
	});

	it("anchors an empty file without inventing an editable line", async () => {
		const app = await harness();
		await writeFile(join(app.cwd, "empty.txt"), "");
		const output = text(
			await app.read.execute(
				"read",
				{ path: "empty.txt" },
				undefined,
				undefined,
				app.ctx,
			),
		);
		expect(output).toContain("[File is empty.]");
		expect(output).not.toMatch(/\n\d+:/);
	});
});
