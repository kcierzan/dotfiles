import { posix } from "node:path";

export const RETRO_STATE_ENTRY = "supervised-workflow-retro";
export const RETRO_PROPOSAL_TOOL = "submit_retro_proposal";
export const RETRO_READ_ONLY_TOOLS = ["read", "grep", "find", "ls"] as const;

export type RetroStage = "idle" | "collecting" | "proposed" | "approved";

export interface RetroEvidence {
	source: string;
	observation: string;
}

export interface RetroProposal {
	title: string;
	targetFile: string;
	rationale: string;
	expectedBenefit: string;
	evidence: RetroEvidence[];
	risks: string[];
	validation: string[];
	diff: string;
	cwd: string;
	baseHash: string | null;
}

export interface RetroState {
	stage: RetroStage;
	proposal: RetroProposal | null;
	toolsBeforeRetro: string[] | null;
}

export const INITIAL_RETRO_STATE: RetroState = {
	stage: "idle",
	proposal: null,
	toolsBeforeRetro: null,
};

const stages = new Set<RetroStage>([
	"idle",
	"collecting",
	"proposed",
	"approved",
]);

export function isRetroLocked(state: RetroState): boolean {
	return state.stage === "collecting" || state.stage === "proposed";
}

export function activeRetroTools(state: RetroState): string[] {
	return state.stage === "collecting"
		? [...RETRO_READ_ONLY_TOOLS, RETRO_PROPOSAL_TOOL]
		: [...RETRO_READ_ONLY_TOOLS];
}

export function beginRetro(activeTools: readonly string[]): RetroState {
	return {
		stage: "collecting",
		proposal: null,
		toolsBeforeRetro: [...activeTools],
	};
}

export function recordRetroProposal(
	state: RetroState,
	proposal: RetroProposal,
): RetroState {
	if (state.stage !== "collecting") return state;
	return {
		...state,
		stage: "proposed",
		proposal: copyProposal(proposal),
	};
}

export function approveRetro(state: RetroState): RetroState {
	if (state.stage !== "proposed") return state;
	return { ...state, stage: "approved" };
}

export function leaveRetro(state: RetroState): {
	state: RetroState;
	restoreTools: string[];
} {
	return {
		state: INITIAL_RETRO_STATE,
		restoreTools: [...(state.toolsBeforeRetro ?? [])],
	};
}

export function normalizeProposalTarget(target: string): string | undefined {
	const normalized = posix.normalize(target.trim().replaceAll("\\", "/"));
	if (
		!normalized ||
		normalized === "." ||
		normalized === ".." ||
		normalized.startsWith("../") ||
		normalized.startsWith("/")
	)
		return undefined;
	return normalized;
}

export function validateSingleFileDiff(
	diff: string,
	targetFile: string,
): string | undefined {
	if (!diff.trim()) return "Proposal diff must not be empty.";
	if (diff.length > 50_000) return "Proposal diff exceeds 50,000 characters.";
	if (/[^\t\n\r\x20-\x7e\x80-\uffff]/u.test(diff))
		return "Proposal diff contains terminal control characters.";
	const oldHeaders = [...diff.matchAll(/^--- (.+)$/gm)].map(
		(match) => match[1],
	);
	const newHeaders = [...diff.matchAll(/^\+\+\+ (.+)$/gm)].map(
		(match) => match[1],
	);
	if (oldHeaders.length !== 1 || newHeaders.length !== 1)
		return "Proposal must be a unified diff for exactly one file.";
	const expected = `b/${targetFile}`;
	if (newHeaders[0] !== expected && newHeaders[0] !== "/dev/null")
		return `Diff target must be ${expected}.`;
	if (oldHeaders[0] !== `a/${targetFile}` && oldHeaders[0] !== "/dev/null")
		return `Diff source must be a/${targetFile} or /dev/null.`;
	if (!/^@@ /m.test(diff))
		return "Proposal diff must contain a unified-diff hunk.";
	return undefined;
}

export function parseRetroState(value: unknown): RetroState | undefined {
	if (!isRecord(value) || !stages.has(value.stage as RetroStage))
		return undefined;
	if (value.toolsBeforeRetro !== null && !isStringArray(value.toolsBeforeRetro))
		return undefined;
	const proposal =
		value.proposal === null ? null : parseProposal(value.proposal);
	if (proposal === undefined) return undefined;
	const state: RetroState = {
		stage: value.stage as RetroStage,
		proposal,
		toolsBeforeRetro:
			value.toolsBeforeRetro === null ? null : [...value.toolsBeforeRetro],
	};
	if (state.stage === "idle") {
		if (state.proposal || state.toolsBeforeRetro) return undefined;
		return state;
	}
	if (!state.toolsBeforeRetro) return undefined;
	if (
		(state.stage === "proposed" || state.stage === "approved") &&
		!state.proposal
	)
		return undefined;
	if (state.stage === "collecting" && state.proposal) return undefined;
	return state;
}

function parseProposal(value: unknown): RetroProposal | undefined {
	if (!isRecord(value)) return undefined;
	if (
		typeof value.title !== "string" ||
		typeof value.targetFile !== "string" ||
		typeof value.rationale !== "string" ||
		typeof value.expectedBenefit !== "string" ||
		typeof value.diff !== "string" ||
		typeof value.cwd !== "string" ||
		(value.baseHash !== null && typeof value.baseHash !== "string") ||
		!Array.isArray(value.evidence) ||
		!isStringArray(value.risks) ||
		!isStringArray(value.validation)
	)
		return undefined;
	const evidence = value.evidence.map(parseEvidence);
	if (evidence.length === 0 || evidence.some((item) => item === undefined))
		return undefined;
	const targetFile = normalizeProposalTarget(value.targetFile);
	if (!targetFile || validateSingleFileDiff(value.diff, targetFile))
		return undefined;
	return {
		title: value.title,
		targetFile,
		rationale: value.rationale,
		expectedBenefit: value.expectedBenefit,
		evidence: evidence as RetroEvidence[],
		risks: [...value.risks],
		validation: [...value.validation],
		diff: value.diff,
		cwd: value.cwd,
		baseHash: value.baseHash as string | null,
	};
}

function parseEvidence(value: unknown): RetroEvidence | undefined {
	if (
		!isRecord(value) ||
		typeof value.source !== "string" ||
		typeof value.observation !== "string"
	)
		return undefined;
	return { source: value.source, observation: value.observation };
}

function copyProposal(proposal: RetroProposal): RetroProposal {
	return {
		...proposal,
		evidence: proposal.evidence.map((item) => ({ ...item })),
		risks: [...proposal.risks],
		validation: [...proposal.validation],
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
