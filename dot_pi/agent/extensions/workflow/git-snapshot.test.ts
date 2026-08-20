import type { ExecResult, ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { describe, expect, it, vi } from "vitest";
import { captureGitSnapshot } from "./git-snapshot.ts";

function result(stdout: string, code = 0, stderr = ""): ExecResult {
	return { stdout, stderr, code, killed: false };
}

function gitHarness(trackedDiff: string, untrackedDiff = "") {
	return {
		exec: vi.fn(async (_command: string, args: string[]) => {
			if (args[0] === "rev-parse") return result("true\n");
			if (args[0] === "ls-files")
				return result(untrackedDiff ? "new.ts\0" : "");
			if (args[0] === "diff" && args.includes("--no-index"))
				return result(untrackedDiff, 1);
			return result(trackedDiff);
		}),
	} as unknown as Pick<ExtensionAPI, "exec">;
}

const tracked = `diff --git a/src/a.ts b/src/a.ts
--- a/src/a.ts
+++ b/src/a.ts
@@ -1 +1 @@
-old
+new
`;
const untracked = `diff --git a/new.ts b/new.ts
new file mode 100644
--- /dev/null
+++ b/new.ts
@@ -0,0 +1 @@
+added
`;

describe("Git review snapshots", () => {
	it("includes tracked and untracked changes in stats and fingerprint", async () => {
		const snapshot = await captureGitSnapshot(
			gitHarness(tracked, untracked),
			"/repo",
		);
		expect(snapshot).toMatchObject({
			files: 2,
			added: 2,
			removed: 1,
		});
		expect(snapshot.diff).toContain("a/new.ts");
		expect(snapshot.hash).toMatch(/^[a-f0-9]{64}$/);
	});

	it("keeps the complete diff available for human review", async () => {
		const longLine = `+${"x".repeat(210_000)}`;
		const largeDiff = `${tracked}${longLine}\n`;
		const snapshot = await captureGitSnapshot(gitHarness(largeDiff), "/repo");
		expect(snapshot.diff).toBe(largeDiff);
	});

	it("changes the fingerprint when untracked content changes", async () => {
		const first = await captureGitSnapshot(
			gitHarness(tracked, untracked),
			"/repo",
		);
		const second = await captureGitSnapshot(
			gitHarness(tracked, untracked.replace("+added", "+different")),
			"/repo",
		);
		expect(second.hash).not.toBe(first.hash);
	});

	it("rejects empty patches and non-Git directories", async () => {
		await expect(captureGitSnapshot(gitHarness(""), "/repo")).rejects.toThrow(
			"no changes",
		);
		const outside = {
			exec: vi.fn(async () => result("false\n", 128, "not a git repository")),
		} as unknown as Pick<ExtensionAPI, "exec">;
		await expect(captureGitSnapshot(outside, "/tmp")).rejects.toThrow(
			"Git working tree",
		);
	});
});
