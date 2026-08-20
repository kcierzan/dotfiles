import { describe, expect, it } from "vitest";
import {
	AGENT_REVIEW_TOOL,
	activeReviewTools,
	beginAgentReview,
	type CheckResult,
	checksPassed,
	completeAgentReview,
	INITIAL_REVIEW_STATE,
	isReviewLocked,
	parseReviewState,
} from "./review-state.ts";

const passingChecks: CheckResult[] = [
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
];

describe("review state transitions", () => {
	it("requires one passing result for every quality gate", () => {
		expect(checksPassed(passingChecks)).toBe(true);
		expect(checksPassed(passingChecks.slice(1))).toBe(false);
		expect(
			checksPassed([passingChecks[0], passingChecks[0], passingChecks[2]]),
		).toBe(false);
		expect(
			checksPassed(
				passingChecks.map((check) =>
					check.name === "lint" ? { ...check, passed: false } : check,
				),
			),
		).toBe(false);
	});

	it("locks an immutable validation snapshot for agent review", () => {
		const tools = ["read", "bash", "hashline_edit"];
		const checks = passingChecks.map((check) => ({ ...check }));
		const state = beginAgentReview(checks, "abc", tools);
		tools.push("write");
		checks[0].output = "changed";
		expect(state).toMatchObject({
			stage: "agent-review",
			snapshotHash: "abc",
			toolsBeforeReview: ["read", "bash", "hashline_edit"],
		});
		expect(state.checks[0].output).toBe("ok");
		expect(activeReviewTools(state)).toContain(AGENT_REVIEW_TOOL);
	});

	it("keeps a passing review locked for the human", () => {
		const state = beginAgentReview(passingChecks, "abc", ["read", "bash"]);
		const completed = completeAgentReview(state, {
			verdict: "pass",
			summary: "No findings.",
			findings: [],
		});
		expect(completed.stage).toBe("review-ready");
		expect(isReviewLocked(completed)).toBe(true);
		expect(activeReviewTools(completed)).not.toContain(AGENT_REVIEW_TOOL);
	});

	it("releases the review lock after human approval", () => {
		expect(
			isReviewLocked({
				...INITIAL_REVIEW_STATE,
				stage: "approved",
			}),
		).toBe(false);
	});

	it("keeps evidence-backed findings locked for human disposition", () => {
		const state = beginAgentReview(passingChecks, "abc", ["read", "bash"]);
		const completed = completeAgentReview(state, {
			verdict: "changes-requested",
			summary: "One defect.",
			findings: [
				{
					severity: "important",
					title: "Restore the previous tools",
					evidence: "The branch transition discards the snapshot.",
				},
			],
		});
		expect(completed).toMatchObject({
			stage: "agent-findings",
			snapshotHash: "abc",
			checks: passingChecks,
			toolsBeforeReview: ["read", "bash"],
		});
		expect(activeReviewTools(completed)).not.toContain(AGENT_REVIEW_TOOL);
	});
});

describe("persisted review state", () => {
	it("round-trips a valid locked state without sharing arrays", () => {
		const original = completeAgentReview(
			beginAgentReview(passingChecks, "abc", ["read", "bash"]),
			{ verdict: "pass", summary: "Clean.", findings: [] },
		);
		const parsed = parseReviewState(original);
		expect(parsed).toEqual(original);
		expect(parsed?.checks).not.toBe(original.checks);
		expect(parsed?.toolsBeforeReview).not.toBe(original.toolsBeforeReview);
	});

	it.each([
		null,
		{},
		{ ...INITIAL_REVIEW_STATE, stage: "unknown" },
		{ ...INITIAL_REVIEW_STATE, stage: "agent-review" },
		{
			...INITIAL_REVIEW_STATE,
			stage: "review-ready",
			snapshotHash: "abc",
			checks: passingChecks,
			toolsBeforeReview: ["read"],
			agentReview: null,
		},
	])("rejects malformed or impossible state %#", (value) => {
		expect(parseReviewState(value)).toBeUndefined();
	});
});
