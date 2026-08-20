import type { Theme } from "@earendil-works/pi-coding-agent";
import { visibleWidth } from "@earendil-works/pi-tui";
import { describe, expect, it, vi } from "vitest";
import type { GitSnapshot } from "./git-snapshot.ts";
import type { ReviewState } from "./review-state.ts";
import { HumanReviewComponent } from "./review-ui.ts";

const theme = {
	bg: (_color: string, text: string) => text,
	bold: (text: string) => text,
	fg: (_color: string, text: string) => text,
} as unknown as Theme;

const state: ReviewState = {
	stage: "human-review",
	snapshotHash: "abc",
	checks: [
		{
			name: "static",
			command: "pnpm typecheck",
			passed: true,
			durationMs: 10,
			output: "ok",
		},
		{
			name: "lint",
			command: "pnpm lint",
			passed: true,
			durationMs: 20,
			output: "ok",
		},
		{
			name: "tests",
			command: "pnpm test",
			passed: true,
			durationMs: 30,
			output: "ok",
		},
	],
	agentReview: { verdict: "pass", summary: "No findings.", findings: [] },
	toolsBeforeReview: ["read", "bash"],
};

function snapshot(): GitSnapshot {
	return {
		hash: "abc",
		diff: Array.from({ length: 100 }, (_, index) => `+line ${index}`).join(
			"\n",
		),
		files: 2,
		added: 100,
		removed: 0,
	};
}

function createComponent(
	value = snapshot(),
	done = vi.fn(),
	copyDiff = vi.fn(),
): HumanReviewComponent {
	return new HumanReviewComponent(
		value,
		state,
		theme,
		"/repo",
		vi.fn(),
		copyDiff,
		done,
	);
}

describe("human review component", () => {
	it("renders a bounded validation, review, diff, and decision surface", () => {
		const unsafeSnapshot = snapshot();
		unsafeSnapshot.diff = `+unsafe\u001b[2J\n${unsafeSnapshot.diff}`;
		const component = createComponent(unsafeSnapshot);
		const lines = component.render(60);
		expect(lines.join("\n")).toContain("Human Review");
		expect(lines.join("\n")).toContain("✓ static");
		expect(lines.join("\n")).toContain("No findings.");
		expect(lines.join("\n")).toContain("Request changes");
		expect(lines.every((line) => visibleWidth(line) <= 60)).toBe(true);
		expect(lines.join("\n")).not.toContain("\u001b[2J");
		expect(component.render(10).every((line) => visibleWidth(line) <= 10)).toBe(
			true,
		);
	});

	it("wraps long diff lines so their complete content remains reviewable", () => {
		const long = snapshot();
		long.diff = `+${"x".repeat(72)}VISIBLE_TAIL`;
		const rendered = createComponent(long).render(20).join("\n");
		expect(rendered).toContain("VISIBLE_TAIL");
		expect(rendered.split("\n").every((line) => visibleWidth(line) <= 20)).toBe(
			true,
		);
	});

	it("defaults to requesting changes and requires navigation to approve", () => {
		const done = vi.fn();
		const component = createComponent(snapshot(), done);
		component.render(60);
		component.handleInput("\r");
		expect(done).toHaveBeenCalledWith("request-changes");

		const approve = vi.fn();
		const second = createComponent(snapshot(), approve);
		second.render(60);
		second.handleInput("\x1b[B");
		second.handleInput("\r");
		expect(approve).toHaveBeenCalledWith("approve");
	});

	it("copies the diff and emits Ghostty-compatible file hyperlinks", () => {
		const copyDiff = vi.fn();
		const linked = snapshot();
		linked.diff = "diff --git a/src/a.ts b/src/a.ts";
		const component = createComponent(linked, vi.fn(), copyDiff);
		const rendered = component.render(100).join("\n");
		expect(rendered).toContain("\u001b]8;;file:///repo/src/a.ts");
		component.handleInput("c");
		expect(copyDiff).toHaveBeenCalledOnce();
	});

	it("supports MacBook and vim-style paging without dedicated page keys", () => {
		const component = createComponent();
		component.render(60);
		component.handleInput("\x04");
		expect(component.render(60).join("\n")).toContain("+line 14");
		component.handleInput("b");
		expect(component.render(60).join("\n")).toContain("+line 0");
	});

	it("scrolls the diff independently of the decision region", () => {
		const component = createComponent();
		component.render(60);
		component.handleInput("\t");
		component.handleInput("G");
		expect(component.render(60).join("\n")).toContain("+line 99");
	});
});
