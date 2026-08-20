import { resolve } from "node:path";
import { pathToFileURL } from "node:url";
import type { Theme } from "@earendil-works/pi-coding-agent";
import {
	type Component,
	matchesKey,
	truncateToWidth,
	visibleWidth,
	wrapTextWithAnsi,
} from "@earendil-works/pi-tui";
import type { GitSnapshot } from "./git-snapshot.ts";
import type { ReviewState } from "./review-state.ts";

export type ReviewDecision = "request-changes" | "approve";

type Focus = "diff" | "actions";

export class HumanReviewComponent implements Component {
	private focus: Focus = "actions";
	private selected = 0;
	private scrollOffset = 0;
	private viewportHeight = 1;
	private readonly rawDiffLines: string[];
	private visualDiffLines: string[] = [];
	private visualDiffWidth = 0;

	constructor(
		private readonly snapshot: GitSnapshot,
		private readonly state: ReviewState,
		private readonly theme: Theme,
		private readonly cwd: string,
		private readonly requestRender: () => void,
		private readonly copyDiff: () => void,
		private readonly done: (decision: ReviewDecision | null) => void,
	) {
		this.rawDiffLines = snapshot.diff.split("\n").map(sanitizeTerminalText);
	}

	invalidate(): void {
		this.visualDiffLines = [];
		this.visualDiffWidth = 0;
	}

	handleInput(data: string): void {
		if (matchesKey(data, "escape")) {
			this.done(null);
			return;
		}
		if (data === "c") {
			this.copyDiff();
			return;
		}
		if (matchesKey(data, "tab") || data === "\t") {
			this.focus = this.focus === "diff" ? "actions" : "diff";
			this.requestRender();
			return;
		}
		if (this.focus === "actions") {
			if (matchesKey(data, "up") || data === "k") this.selected = 0;
			else if (matchesKey(data, "down") || data === "j") this.selected = 1;
			else if (matchesKey(data, "enter") || data === "\n") {
				this.done(this.selected === 0 ? "request-changes" : "approve");
				return;
			} else if (matchesKey(data, "left")) {
				this.focus = "diff";
			} else if (this.handlePageInput(data)) {
				this.focus = "diff";
			}
		} else if (matchesKey(data, "down") || data === "j") {
			this.scrollBy(1);
		} else if (matchesKey(data, "up") || data === "k") {
			this.scrollBy(-1);
		} else if (this.handlePageInput(data)) {
			// Page movement is handled for both focus regions.
		} else if (matchesKey(data, "home") || data === "g") {
			this.scrollOffset = 0;
		} else if (matchesKey(data, "end") || data === "G") {
			this.scrollOffset = this.maxScroll();
		} else if (matchesKey(data, "right") || matchesKey(data, "enter")) {
			this.focus = "actions";
		}
		this.requestRender();
	}

	render(width: number): string[] {
		const safeWidth = Math.max(2, width);
		const innerWidth = safeWidth - 2;
		this.rebuildVisualDiff(innerWidth);
		const terminalHeight = process.stdout.rows || 40;
		const checks = this.state.checks
			.map(
				(check) =>
					`${check.passed ? "✓" : "✗"} ${check.name} ${formatDuration(check.durationMs)}`,
			)
			.join("  ·  ");
		const reviewSummary =
			this.state.agentReview?.summary ?? "Agent review unavailable";
		const meta = `${this.snapshot.files} files  ${this.theme.fg("toolDiffAdded", `+${this.snapshot.added}`)}  ${this.theme.fg("toolDiffRemoved", `-${this.snapshot.removed}`)}`;
		const fixedRows = 11;
		this.viewportHeight = Math.max(5, terminalHeight - fixedRows);
		this.scrollOffset = Math.min(this.scrollOffset, this.maxScroll());

		const lines = [
			topBorder(safeWidth, "Human Review", this.theme),
			boxRow(this.theme.fg("success", checks), innerWidth, this.theme),
			boxRow(this.theme.fg("muted", meta), innerWidth, this.theme),
			boxRow(
				`${this.theme.fg("accent", "Agent review")}  ${this.theme.fg("text", reviewSummary)}`,
				innerWidth,
				this.theme,
			),
			divider(
				safeWidth,
				this.focus === "diff" ? " Changes " : " Changes",
				this.theme,
			),
		];
		for (let index = 0; index < this.viewportHeight; index++) {
			lines.push(
				boxRow(
					this.visualDiffLines[this.scrollOffset + index] ?? "",
					innerWidth,
					this.theme,
				),
			);
		}
		lines.push(divider(safeWidth, " Decision ", this.theme));
		lines.push(
			boxRow(this.actionLine(0, "Request changes"), innerWidth, this.theme),
		);
		lines.push(
			boxRow(this.actionLine(1, "Approve changes"), innerWidth, this.theme),
		);
		lines.push(
			boxRow(
				this.theme.fg(
					"dim",
					"tab regions · ↑↓/jk · ctrl+d/u half-page · space/b page · c copy · esc close",
				),
				innerWidth,
				this.theme,
			),
		);
		lines.push(bottomBorder(safeWidth, this.theme));
		return lines;
	}

	private actionLine(index: number, label: string): string {
		const selected = this.selected === index;
		const cursor = selected ? "› " : "  ";
		if (!selected) return this.theme.fg("muted", `${cursor}${label}`);
		const text = `${cursor}${label}`;
		return this.focus === "actions"
			? this.theme.bg(
					"selectedBg",
					this.theme.bold(this.theme.fg("accent", text)),
				)
			: this.theme.fg("dim", text);
	}

	private handlePageInput(data: string): boolean {
		if (
			matchesKey(data, "pageDown") ||
			matchesKey(data, "ctrl+f") ||
			data === " "
		) {
			this.scrollBy(this.viewportHeight);
			return true;
		}
		if (
			matchesKey(data, "pageUp") ||
			matchesKey(data, "ctrl+b") ||
			data === "b"
		) {
			this.scrollBy(-this.viewportHeight);
			return true;
		}
		if (matchesKey(data, "ctrl+d")) {
			this.scrollBy(Math.max(1, Math.floor(this.viewportHeight / 2)));
			return true;
		}
		if (matchesKey(data, "ctrl+u")) {
			this.scrollBy(-Math.max(1, Math.floor(this.viewportHeight / 2)));
			return true;
		}
		return false;
	}

	private scrollBy(delta: number): void {
		this.scrollOffset = Math.max(
			0,
			Math.min(this.maxScroll(), this.scrollOffset + delta),
		);
	}

	private maxScroll(): number {
		return Math.max(0, this.visualDiffLines.length - this.viewportHeight);
	}

	private rebuildVisualDiff(width: number): void {
		if (this.visualDiffWidth === width && this.visualDiffLines.length > 0)
			return;
		this.visualDiffWidth = width;
		this.visualDiffLines = this.rawDiffLines.flatMap((line) =>
			wrapTextWithAnsi(
				styleDiffLine(line, this.theme, this.cwd),
				Math.max(1, width),
			),
		);
	}
}

function sanitizeTerminalText(text: string): string {
	let result = "";
	for (const character of text) {
		if (character === "\t") {
			result += "    ";
			continue;
		}
		const codePoint = character.codePointAt(0) ?? 0;
		result +=
			codePoint < 32 || (codePoint >= 127 && codePoint <= 159)
				? "�"
				: character;
	}
	return result;
}

function styleDiffLine(line: string, theme: Theme, cwd: string): string {
	if (
		line.startsWith("diff --git ") ||
		line.startsWith("+++ ") ||
		line.startsWith("--- ")
	) {
		const linked = linkDiffHeader(line, cwd);
		return theme.bold(theme.fg("accent", linked));
	}
	if (line.startsWith("@@")) return theme.fg("warning", line);
	if (line.startsWith("+")) return theme.fg("toolDiffAdded", line);
	if (line.startsWith("-")) return theme.fg("toolDiffRemoved", line);
	return theme.fg("toolDiffContext", line);
}

function linkDiffHeader(line: string, cwd: string): string {
	const match = /(?:^|\s)b\/(.+)$/.exec(line);
	if (!match?.[1]) return line;
	const url = pathToFileURL(resolve(cwd, match[1])).href;
	return `\u001b]8;;${url}\u001b\\${line}\u001b]8;;\u001b\\`;
}

function formatDuration(durationMs: number): string {
	return durationMs < 1_000
		? `${durationMs}ms`
		: `${(durationMs / 1_000).toFixed(1)}s`;
}

function topBorder(width: number, title: string, theme: Theme): string {
	const label = truncateToWidth(` ${title} `, Math.max(0, width - 2), "");
	const fill = Math.max(0, width - visibleWidth(label) - 2);
	return theme.fg("borderAccent", `┌${label}${"─".repeat(fill)}┐`);
}

function divider(width: number, label: string, theme: Theme): string {
	const safeLabel = truncateToWidth(label, Math.max(0, width - 2), "");
	const fill = Math.max(0, width - visibleWidth(safeLabel) - 2);
	return theme.fg("borderMuted", `├${safeLabel}${"─".repeat(fill)}┤`);
}

function bottomBorder(width: number, theme: Theme): string {
	return theme.fg("borderAccent", `└${"─".repeat(Math.max(0, width - 2))}┘`);
}

function boxRow(content: string, width: number, theme: Theme): string {
	const clipped = truncateToWidth(content, width, "…");
	const padding = " ".repeat(Math.max(0, width - visibleWidth(clipped)));
	return `${theme.fg("borderMuted", "│")}${clipped}${padding}${theme.fg("borderMuted", "│")}`;
}
