export const REVIEW_STATE_ENTRY = "supervised-workflow-review";

export const REVIEW_READ_ONLY_TOOLS = ["read", "grep", "find", "ls"] as const;
export const AGENT_REVIEW_TOOL = "submit_agent_review";

export type CheckName = "static" | "lint" | "tests";
export type ReviewStage =
	| "implementing"
	| "agent-review"
	| "agent-findings"
	| "review-ready"
	| "human-review"
	| "approved";

export interface CheckResult {
	name: CheckName;
	command: string;
	passed: boolean;
	durationMs: number;
	output: string;
}

export interface AgentFinding {
	severity: "blocking" | "important" | "suggestion";
	title: string;
	evidence: string;
	file?: string;
	line?: number;
}

export interface AgentReviewResult {
	verdict: "pass" | "changes-requested";
	summary: string;
	findings: AgentFinding[];
}

export interface ReviewState {
	stage: ReviewStage;
	snapshotHash: string | null;
	checks: CheckResult[];
	agentReview: AgentReviewResult | null;
	toolsBeforeReview: string[] | null;
}

export const INITIAL_REVIEW_STATE: ReviewState = {
	stage: "implementing",
	snapshotHash: null,
	checks: [],
	agentReview: null,
	toolsBeforeReview: null,
};

const stages = new Set<ReviewStage>([
	"implementing",
	"agent-review",
	"agent-findings",
	"review-ready",
	"human-review",
	"approved",
]);
const checkNames = new Set<CheckName>(["static", "lint", "tests"]);
const severities = new Set<AgentFinding["severity"]>([
	"blocking",
	"important",
	"suggestion",
]);

export function isReviewLocked(state: ReviewState): boolean {
	return state.stage !== "implementing" && state.stage !== "approved";
}

export function activeReviewTools(state: ReviewState): string[] {
	return state.stage === "agent-review"
		? [...REVIEW_READ_ONLY_TOOLS, AGENT_REVIEW_TOOL]
		: [...REVIEW_READ_ONLY_TOOLS];
}

export function checksPassed(checks: readonly CheckResult[]): boolean {
	return (
		checks.length === checkNames.size &&
		checkNames.size === new Set(checks.map((check) => check.name)).size &&
		checks.every((check) => check.passed)
	);
}

export function beginAgentReview(
	checks: CheckResult[],
	snapshotHash: string,
	activeTools: readonly string[],
): ReviewState {
	if (!checksPassed(checks)) return INITIAL_REVIEW_STATE;
	return {
		stage: "agent-review",
		snapshotHash,
		checks: checks.map(copyCheck),
		agentReview: null,
		toolsBeforeReview: [...activeTools],
	};
}

export function completeAgentReview(
	state: ReviewState,
	result: AgentReviewResult,
): ReviewState {
	if (state.stage !== "agent-review") return state;
	return {
		...state,
		stage: result.verdict === "pass" ? "review-ready" : "agent-findings",
		agentReview: copyAgentReview(result),
	};
}

export function parseReviewState(value: unknown): ReviewState | undefined {
	if (!isRecord(value) || !stages.has(value.stage as ReviewStage))
		return undefined;
	if (value.snapshotHash !== null && typeof value.snapshotHash !== "string")
		return undefined;
	if (!Array.isArray(value.checks)) return undefined;
	const checks = value.checks.map(parseCheck);
	if (checks.some((check) => check === undefined)) return undefined;
	if (
		value.toolsBeforeReview !== null &&
		!isStringArray(value.toolsBeforeReview)
	)
		return undefined;
	const agentReview =
		value.agentReview === null ? null : parseAgentReview(value.agentReview);
	if (agentReview === undefined) return undefined;
	const state: ReviewState = {
		stage: value.stage as ReviewStage,
		snapshotHash: value.snapshotHash as string | null,
		checks: checks as CheckResult[],
		agentReview,
		toolsBeforeReview:
			value.toolsBeforeReview === null ? null : [...value.toolsBeforeReview],
	};
	if (isReviewLocked(state) && !state.toolsBeforeReview) return undefined;
	if (state.stage !== "implementing" && !state.snapshotHash) return undefined;
	if (state.stage !== "implementing" && !checksPassed(state.checks))
		return undefined;
	if (
		(state.stage === "review-ready" ||
			state.stage === "human-review" ||
			state.stage === "approved") &&
		state.agentReview?.verdict !== "pass"
	)
		return undefined;
	if (
		state.stage === "agent-findings" &&
		state.agentReview?.verdict !== "changes-requested"
	)
		return undefined;
	return state;
}

function parseCheck(value: unknown): CheckResult | undefined {
	if (!isRecord(value) || !checkNames.has(value.name as CheckName))
		return undefined;
	if (
		typeof value.command !== "string" ||
		typeof value.passed !== "boolean" ||
		typeof value.durationMs !== "number" ||
		typeof value.output !== "string"
	)
		return undefined;
	return copyCheck(value as unknown as CheckResult);
}

function parseAgentReview(value: unknown): AgentReviewResult | undefined {
	if (!isRecord(value)) return undefined;
	if (value.verdict !== "pass" && value.verdict !== "changes-requested")
		return undefined;
	if (typeof value.summary !== "string" || !Array.isArray(value.findings))
		return undefined;
	const findings = value.findings.map(parseFinding);
	if (findings.some((finding) => finding === undefined)) return undefined;
	if (value.verdict === "pass" && findings.length > 0) return undefined;
	if (value.verdict === "changes-requested" && findings.length === 0)
		return undefined;
	return {
		verdict: value.verdict,
		summary: value.summary,
		findings: findings as AgentFinding[],
	};
}

function parseFinding(value: unknown): AgentFinding | undefined {
	if (
		!isRecord(value) ||
		!severities.has(value.severity as AgentFinding["severity"])
	)
		return undefined;
	if (typeof value.title !== "string" || typeof value.evidence !== "string")
		return undefined;
	if (value.file !== undefined && typeof value.file !== "string")
		return undefined;
	if (value.line !== undefined && typeof value.line !== "number")
		return undefined;
	return {
		severity: value.severity as AgentFinding["severity"],
		title: value.title,
		evidence: value.evidence,
		...(typeof value.file === "string" ? { file: value.file } : {}),
		...(typeof value.line === "number" ? { line: value.line } : {}),
	};
}

function copyCheck(check: CheckResult): CheckResult {
	return { ...check };
}

function copyAgentReview(review: AgentReviewResult): AgentReviewResult {
	return {
		...review,
		findings: review.findings.map((finding) => ({ ...finding })),
	};
}

function isRecord(value: unknown): value is Record<string, unknown> {
	return typeof value === "object" && value !== null;
}

function isStringArray(value: unknown): value is string[] {
	return (
		Array.isArray(value) && value.every((item) => typeof item === "string")
	);
}
