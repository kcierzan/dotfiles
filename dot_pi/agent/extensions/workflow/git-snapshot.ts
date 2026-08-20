import { createHash } from "node:crypto";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export interface GitSnapshot {
	hash: string;
	diff: string;
	files: number;
	added: number;
	removed: number;
}

export async function captureGitSnapshot(
	pi: Pick<ExtensionAPI, "exec">,
	cwd: string,
): Promise<GitSnapshot> {
	const inside = await pi.exec("git", ["rev-parse", "--is-inside-work-tree"], {
		cwd,
		timeout: 5_000,
	});
	if (inside.code !== 0 || inside.stdout.trim() !== "true") {
		throw new Error("Review requires a Git working tree.");
	}

	const tracked = await pi.exec(
		"git",
		["diff", "--no-ext-diff", "--binary", "HEAD", "--"],
		{ cwd, timeout: 30_000 },
	);
	if (tracked.code !== 0) {
		throw new Error(tracked.stderr.trim() || "Unable to read the Git diff.");
	}

	const untrackedResult = await pi.exec(
		"git",
		["ls-files", "--others", "--exclude-standard", "-z"],
		{ cwd, timeout: 10_000 },
	);
	if (untrackedResult.code !== 0) {
		throw new Error(
			untrackedResult.stderr.trim() || "Unable to list untracked files.",
		);
	}

	const parts = [tracked.stdout];
	for (const path of untrackedResult.stdout.split("\0").filter(Boolean)) {
		const result = await pi.exec(
			"git",
			["diff", "--no-index", "--no-ext-diff", "--", "/dev/null", path],
			{ cwd, timeout: 30_000 },
		);
		if (result.code !== 0 && result.code !== 1) {
			throw new Error(
				result.stderr.trim() || `Unable to create a diff for ${path}.`,
			);
		}
		parts.push(result.stdout);
	}

	const fullDiff = parts.filter(Boolean).join("\n");
	if (!fullDiff.trim()) throw new Error("There are no changes to review.");
	const stats = countDiff(fullDiff);
	return {
		hash: createHash("sha256").update(fullDiff).digest("hex"),
		diff: fullDiff,
		...stats,
	};
}

function countDiff(diff: string): {
	files: number;
	added: number;
	removed: number;
} {
	let files = 0;
	let added = 0;
	let removed = 0;
	for (const line of diff.split("\n")) {
		if (line.startsWith("diff --git ")) files++;
		else if (line.startsWith("+") && !line.startsWith("+++")) added++;
		else if (line.startsWith("-") && !line.startsWith("---")) removed++;
	}
	return { files, added, removed };
}
