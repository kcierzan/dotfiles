import { describe, expect, it } from "vitest";
import {
	activeRetroTools,
	approveRetro,
	beginRetro,
	INITIAL_RETRO_STATE,
	isRetroLocked,
	leaveRetro,
	normalizeProposalTarget,
	parseRetroState,
	RETRO_PROPOSAL_TOOL,
	type RetroProposal,
	recordRetroProposal,
	validateSingleFileDiff,
} from "./retro-state.ts";

function proposal(): RetroProposal {
	return {
		title: "Clarify validation guidance",
		targetFile: "AGENTS.md",
		rationale: "The session exposed ambiguous validation guidance.",
		expectedBenefit: "Fewer failed validation attempts.",
		evidence: [
			{
				source: "tool result",
				observation: "The first check used the wrong command.",
			},
		],
		risks: ["The guidance may become stale."],
		validation: ["Review the rendered instructions."],
		diff: "--- a/AGENTS.md\n+++ b/AGENTS.md\n@@ -1 +1,2 @@\n Existing\n+Run the project checks.\n",
		cwd: "/repo",
		baseHash: "abc",
	};
}

describe("retrospective state", () => {
	it("keeps collection and proposal review read-only", () => {
		const collecting = beginRetro(["read", "bash", "edit"]);
		expect(isRetroLocked(collecting)).toBe(true);
		expect(activeRetroTools(collecting)).toContain(RETRO_PROPOSAL_TOOL);

		const proposed = recordRetroProposal(collecting, proposal());
		expect(proposed.stage).toBe("proposed");
		expect(activeRetroTools(proposed)).not.toContain(RETRO_PROPOSAL_TOOL);
		expect(approveRetro(proposed).stage).toBe("approved");

		const transition = leaveRetro(proposed);
		expect(transition.state).toEqual(INITIAL_RETRO_STATE);
		expect(transition.restoreTools).toEqual(["read", "bash", "edit"]);
	});

	it("parses valid persisted state and rejects inconsistent stages", () => {
		const proposed = recordRetroProposal(
			beginRetro(["read", "bash"]),
			proposal(),
		);
		expect(parseRetroState(proposed)).toEqual(proposed);
		expect(parseRetroState({ ...proposed, proposal: null })).toBeUndefined();
		expect(
			parseRetroState({ ...INITIAL_RETRO_STATE, toolsBeforeRetro: [] }),
		).toBeUndefined();
	});

	it("normalizes safe relative targets and rejects traversal", () => {
		expect(normalizeProposalTarget("docs/../AGENTS.md")).toBe("AGENTS.md");
		expect(normalizeProposalTarget("../AGENTS.md")).toBeUndefined();
		expect(normalizeProposalTarget("/tmp/AGENTS.md")).toBeUndefined();
	});

	it("requires one matching unified-file diff without terminal controls", () => {
		const valid = proposal().diff;
		expect(validateSingleFileDiff(valid, "AGENTS.md")).toBeUndefined();
		expect(validateSingleFileDiff(valid, "other.md")).toContain("Diff target");
		expect(
			validateSingleFileDiff(
				`${valid}\n--- a/other\n+++ b/other\n@@ -0,0 +1 @@\n+x`,
				"AGENTS.md",
			),
		).toContain("exactly one file");
		expect(validateSingleFileDiff(`${valid}\u001b[2J`, "AGENTS.md")).toContain(
			"control",
		);
	});
});
