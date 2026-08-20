import { createHash } from "node:crypto";
import { readFile } from "node:fs/promises";
import { resolve } from "node:path";
import { StringEnum } from "@earendil-works/pi-ai";
import {
	copyToClipboard,
	type ExtensionAPI,
	type ExtensionCommandContext,
	type ExtensionContext,
	type SessionEntry,
} from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { captureGitSnapshot, type GitSnapshot } from "./git-snapshot.ts";
import {
	enterPlanMode,
	INITIAL_PLAN_STATE,
	isPlanToolAllowed,
	leavePlanMode,
	PLAN_MODE_ENTRY,
	PLAN_MODE_TOOLS,
	type PlanState,
	parsePlanState,
} from "./plan-state.ts";
import { runQualityChecks } from "./quality.ts";
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
	RETRO_STATE_ENTRY,
	type RetroProposal,
	type RetroState,
	recordRetroProposal,
	validateSingleFileDiff,
} from "./retro-state.ts";
import {
	AGENT_REVIEW_TOOL,
	type AgentReviewResult,
	activeReviewTools,
	beginAgentReview,
	type CheckResult,
	checksPassed,
	completeAgentReview,
	INITIAL_REVIEW_STATE,
	isReviewLocked,
	parseReviewState,
	REVIEW_STATE_ENTRY,
	type ReviewState,
} from "./review-state.ts";
import { HumanReviewComponent, type ReviewDecision } from "./review-ui.ts";

const PLAN_INSTRUCTIONS = `## Read-only plan mode

You are in a strictly read-only exploration phase.
- Inspect the project using only read, grep, find, and ls.
- Do not modify files, run shell commands, or start implementation.
- Ask the user for missing requirements in your response.
- Produce a concrete plan with small, reviewable steps, affected files, validation, and risks.
- Stop after presenting the plan. Only the human can approve implementation with /approve-plan.`;

const REVIEW_INSTRUCTIONS = `## Read-only review mode

You are reviewing an already validated patch. Do not modify files or run shell commands. Never commit or push. Report only evidence-backed findings introduced by the patch.`;

const RETRO_INSTRUCTIONS = `## Read-only retrospective mode

You are preparing one evidence-based self-improvement proposal. Inspect only with read, grep, find, and ls. Do not modify files, run commands, apply the proposal, commit, or push. Propose at most one configuration or instruction-file change and submit it through ${RETRO_PROPOSAL_TOOL}.`;

const COMMIT_BLOCK_REASON =
	"Model-issued git commit and git push are disabled. Present the diff and leave publication to the human.";

export default function supervisedWorkflow(pi: ExtensionAPI): void {
	let planState: PlanState = INITIAL_PLAN_STATE;
	let reviewState: ReviewState = INITIAL_REVIEW_STATE;
	let retroState: RetroState = INITIAL_RETRO_STATE;

	function persistPlan(): void {
		pi.appendEntry(PLAN_MODE_ENTRY, planState);
	}

	function persistReview(): void {
		pi.appendEntry(REVIEW_STATE_ENTRY, reviewState);
	}

	function persistRetro(): void {
		pi.appendEntry(RETRO_STATE_ENTRY, retroState);
	}

	function updateDisplay(ctx: ExtensionContext): void {
		if (planState.enabled) {
			ctx.ui.setStatus(
				"supervised-workflow",
				ctx.ui.theme.fg("warning", "◇ PLAN · read-only"),
			);
			ctx.ui.setWidget("supervised-workflow", [
				ctx.ui.theme.fg("warning", "Read-only plan mode"),
				ctx.ui.theme.fg(
					"dim",
					"/approve-plan to implement · /cancel-plan to exit",
				),
			]);
			return;
		}

		const display =
			retroDisplay(retroState, ctx) ?? reviewDisplay(reviewState, ctx);
		ctx.ui.setStatus("supervised-workflow", display?.status);
		ctx.ui.setWidget("supervised-workflow", display?.widget);
	}

	function enablePlanMode(ctx: ExtensionContext): void {
		if (planState.enabled) {
			ctx.ui.notify("Plan mode is already active.", "info");
			return;
		}
		if (isReviewLocked(reviewState) || isRetroLocked(retroState)) {
			ctx.ui.notify(
				"Finish the active review or retrospective first.",
				"warning",
			);
			return;
		}
		clearApprovedRetro();
		planState = enterPlanMode(planState, pi.getActiveTools());
		pi.setActiveTools([...PLAN_MODE_TOOLS]);
		persistPlan();
		updateDisplay(ctx);
		ctx.ui.notify(
			"Plan mode enabled. Model tools are strictly read-only.",
			"info",
		);
	}

	function disablePlanMode(ctx: ExtensionContext, message: string): void {
		if (!planState.enabled) {
			ctx.ui.notify("Plan mode is not active.", "info");
			return;
		}
		const transition = leavePlanMode(planState);
		planState = transition.state;
		pi.setActiveTools(withoutWorkflowSubmissionTools(transition.restoreTools));
		persistPlan();
		updateDisplay(ctx);
		ctx.ui.notify(message, "info");
	}

	function restoreImplementationTools(): void {
		pi.setActiveTools(
			withoutWorkflowSubmissionTools(
				reviewState.toolsBeforeReview ?? pi.getActiveTools(),
			),
		);
	}

	function resetToImplementation(ctx: ExtensionContext, message: string): void {
		restoreImplementationTools();
		reviewState = INITIAL_REVIEW_STATE;
		persistReview();
		updateDisplay(ctx);
		ctx.ui.notify(message, "warning");
	}

	async function requireCurrentSnapshot(
		ctx: ExtensionContext,
	): Promise<GitSnapshot | undefined> {
		try {
			const snapshot = await captureGitSnapshot(pi, ctx.cwd);
			if (snapshot.hash !== reviewState.snapshotHash) {
				resetToImplementation(
					ctx,
					"The patch changed after validation. Run /quality-check again.",
				);
				return undefined;
			}
			return snapshot;
		} catch (error) {
			resetToImplementation(ctx, errorMessage(error));
			return undefined;
		}
	}

	async function requestChanges(
		ctx: ExtensionCommandContext,
		initialFeedback: string,
	): Promise<void> {
		if (!isReviewLocked(reviewState)) {
			ctx.ui.notify("Review is not active.", "warning");
			return;
		}
		let feedback = initialFeedback.trim();
		if (!feedback && ctx.hasUI) {
			const suggestedFeedback = formatAgentFindings(reviewState.agentReview);
			feedback =
				(
					await ctx.ui.editor(
						"Request changes",
						suggestedFeedback ||
							"Describe the required changes and their evidence.\n",
					)
				)?.trim() ?? "";
		}
		if (!feedback) {
			ctx.ui.notify("Change requests require feedback.", "warning");
			return;
		}
		restoreImplementationTools();
		reviewState = INITIAL_REVIEW_STATE;
		persistReview();
		updateDisplay(ctx);
		ctx.ui.notify("Changes requested. Implementation tools restored.", "info");
		pi.sendUserMessage(`Human review requested these changes:\n\n${feedback}`);
	}

	async function approveReview(
		ctx: ExtensionCommandContext,
		confirmedByReviewUi = false,
	): Promise<void> {
		if (reviewState.stage !== "human-review") {
			ctx.ui.notify("Human review is not awaiting approval.", "warning");
			return;
		}
		if (!(await requireCurrentSnapshot(ctx))) return;
		if (!confirmedByReviewUi) {
			if (!ctx.hasUI) {
				ctx.ui.notify("Approval requires an interactive human.", "error");
				return;
			}
			const approved = await ctx.ui.confirm(
				"Approve validated changes?",
				"This records approval but does not commit or push anything.",
			);
			if (!approved) return;
		}
		restoreImplementationTools();
		reviewState = { ...reviewState, stage: "approved" };
		persistReview();
		updateDisplay(ctx);
		ctx.ui.notify(
			"Changes approved. Commit remains a manual human action.",
			"info",
		);
	}

	async function showHumanReview(ctx: ExtensionCommandContext): Promise<void> {
		if (
			reviewState.stage !== "review-ready" &&
			reviewState.stage !== "human-review"
		) {
			ctx.ui.notify(
				"Run /quality-check and complete the agent review first.",
				"warning",
			);
			return;
		}
		const snapshot = await requireCurrentSnapshot(ctx);
		if (!snapshot) return;
		reviewState = { ...reviewState, stage: "human-review" };
		pi.setActiveTools(activeReviewTools(reviewState));
		persistReview();
		updateDisplay(ctx);

		if (ctx.mode !== "tui") {
			ctx.ui.notify(
				"Review locked. Use /approve or /request-changes in an interactive TUI.",
				"info",
			);
			return;
		}
		const decision = await ctx.ui.custom<ReviewDecision | null>(
			(tui, theme, _keybindings, done) =>
				new HumanReviewComponent(
					snapshot,
					reviewState,
					theme,
					ctx.cwd,
					() => tui.requestRender(),
					() => {
						void copyToClipboard(snapshot.diff)
							.then(() => ctx.ui.notify("Review diff copied.", "info"))
							.catch((error) =>
								ctx.ui.notify(`Copy failed: ${errorMessage(error)}`, "error"),
							);
					},
					done,
				),
		);
		if (decision === "request-changes") await requestChanges(ctx, "");
		else if (decision === "approve") await approveReview(ctx, true);
	}

	function clearApprovedRetro(): void {
		if (retroState.stage !== "approved") return;
		retroState = INITIAL_RETRO_STATE;
		persistRetro();
	}

	function restoreRetroTools(): void {
		pi.setActiveTools(
			withoutWorkflowSubmissionTools(
				retroState.toolsBeforeRetro ?? pi.getActiveTools(),
			),
		);
	}

	function cancelRetro(ctx: ExtensionContext, message: string): void {
		if (retroState.stage === "idle") {
			ctx.ui.notify("No retrospective is active.", "info");
			return;
		}
		const transition = leaveRetro(retroState);
		retroState = transition.state;
		pi.setActiveTools(withoutWorkflowSubmissionTools(transition.restoreTools));
		persistRetro();
		updateDisplay(ctx);
		ctx.ui.notify(message, "info");
	}

	pi.registerTool({
		name: RETRO_PROPOSAL_TOOL,
		label: "Submit Retrospective Proposal",
		description:
			"Submit one evidence-based configuration or instruction-file improvement as an unapplied diff",
		parameters: Type.Object({
			title: Type.String({ maxLength: 160 }),
			targetFile: Type.String({ maxLength: 500 }),
			rationale: Type.String({ maxLength: 2_000 }),
			expectedBenefit: Type.String({ maxLength: 1_000 }),
			evidence: Type.Array(
				Type.Object({
					source: Type.String({ maxLength: 500 }),
					observation: Type.String({ maxLength: 2_000 }),
				}),
				{ minItems: 1, maxItems: 8 },
			),
			risks: Type.Array(Type.String({ maxLength: 1_000 }), { maxItems: 8 }),
			validation: Type.Array(Type.String({ maxLength: 1_000 }), {
				minItems: 1,
				maxItems: 8,
			}),
			diff: Type.String({ maxLength: 50_000 }),
		}),
		async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
			if (retroState.stage !== "collecting") {
				throw new Error("Retrospective collection is not active.");
			}
			const targetFile = normalizeProposalTarget(params.targetFile);
			if (!targetFile)
				throw new Error("Proposal target must be a safe relative path.");
			const diffError = validateSingleFileDiff(params.diff, targetFile);
			if (diffError) throw new Error(diffError);
			const proposal: RetroProposal = {
				title: requireText(params.title, "Proposal title"),
				targetFile,
				rationale: requireText(params.rationale, "Proposal rationale"),
				expectedBenefit: requireText(
					params.expectedBenefit,
					"Expected benefit",
				),
				evidence: params.evidence.map((item) => ({
					source: requireText(item.source, "Evidence source"),
					observation: requireText(item.observation, "Evidence observation"),
				})),
				risks: params.risks.map((risk) => requireText(risk, "Risk")),
				validation: params.validation.map((step) =>
					requireText(step, "Validation step"),
				),
				diff: params.diff,
				cwd: ctx.cwd,
				baseHash: await hashTargetFile(ctx.cwd, targetFile),
			};
			retroState = recordRetroProposal(retroState, proposal);
			pi.setActiveTools(activeRetroTools(retroState));
			persistRetro();
			updateDisplay(ctx);
			return {
				content: [
					{ type: "text" as const, text: formatRetroProposal(proposal) },
				],
				details: proposal,
				terminate: true,
			};
		},
	});

	pi.registerTool({
		name: AGENT_REVIEW_TOOL,
		label: "Submit Agent Review",
		description:
			"Submit the required evidence-based review of the current validated patch",
		parameters: Type.Object({
			verdict: StringEnum(["pass", "changes-requested"] as const),
			summary: Type.String({ maxLength: 1_000 }),
			findings: Type.Array(
				Type.Object({
					severity: StringEnum([
						"blocking",
						"important",
						"suggestion",
					] as const),
					title: Type.String({ maxLength: 160 }),
					evidence: Type.String({ maxLength: 2_000 }),
					file: Type.Optional(Type.String({ maxLength: 500 })),
					line: Type.Optional(Type.Integer({ minimum: 1 })),
				}),
				{ maxItems: 20 },
			),
		}),
		async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
			if (reviewState.stage !== "agent-review") {
				throw new Error("Agent review is not active.");
			}
			if (!params.summary.trim()) {
				throw new Error("Agent review requires a non-empty summary.");
			}
			if (
				params.findings.some(
					(finding) => !finding.title.trim() || !finding.evidence.trim(),
				)
			) {
				throw new Error(
					"Every finding requires a title and concrete evidence.",
				);
			}
			if (params.verdict === "pass" && params.findings.length > 0) {
				throw new Error("A passing review cannot contain findings.");
			}
			if (
				params.verdict === "changes-requested" &&
				params.findings.length === 0
			) {
				throw new Error(
					"Requested changes require at least one evidence-backed finding.",
				);
			}
			if (!(await requireCurrentSnapshot(ctx))) {
				throw new Error("The patch changed after validation.");
			}
			const result: AgentReviewResult = {
				verdict: params.verdict,
				summary: params.summary.trim(),
				findings: params.findings.map((finding) => ({
					...finding,
					title: finding.title.trim(),
					evidence: finding.evidence.trim(),
				})),
			};
			reviewState = completeAgentReview(reviewState, result);
			pi.setActiveTools(activeReviewTools(reviewState));
			persistReview();
			updateDisplay(ctx);
			return {
				content: [
					{
						type: "text" as const,
						text:
							result.verdict === "pass"
								? "Agent review passed. Stop now; the human must run /request-review."
								: "Agent findings recorded. Stop now; the human must run /request-changes before implementation can continue.",
					},
				],
				details: result,
				terminate: true,
			};
		},
	});

	pi.registerCommand("plan", {
		description: "Enter strict read-only plan mode",
		handler: async (_args, ctx) => {
			await ctx.waitForIdle();
			enablePlanMode(ctx);
		},
	});

	pi.registerCommand("approve-plan", {
		description: "Approve the plan and enable implementation tools",
		handler: async (_args, ctx) => {
			await ctx.waitForIdle();
			if (!planState.enabled) {
				ctx.ui.notify("Plan mode is not active.", "info");
				return;
			}
			if (!ctx.hasUI) {
				ctx.ui.notify(
					"Plan approval requires interactive confirmation.",
					"error",
				);
				return;
			}
			const approved = await ctx.ui.confirm(
				"Approve plan?",
				"Exit read-only mode and restore the tools that were active before planning?",
			);
			if (approved)
				disablePlanMode(ctx, "Plan approved. Implementation tools restored.");
		},
	});

	pi.registerCommand("cancel-plan", {
		description: "Exit plan mode without approving the plan",
		handler: async (_args, ctx) => {
			await ctx.waitForIdle();
			disablePlanMode(ctx, "Plan mode cancelled. Previous tools restored.");
		},
	});

	pi.registerCommand("retro", {
		description:
			"Propose one evidence-based workflow improvement without applying it",
		handler: async (args, ctx) => {
			await ctx.waitForIdle();
			if (planState.enabled || isRetroLocked(retroState)) {
				ctx.ui.notify(
					"Finish the active plan or retrospective first.",
					"warning",
				);
				return;
			}
			if (isReviewLocked(reviewState) && reviewState.stage !== "approved") {
				ctx.ui.notify(
					"The current patch must be approved before a retrospective.",
					"warning",
				);
				return;
			}
			const previousTools =
				reviewState.stage === "approved"
					? (reviewState.toolsBeforeReview ?? pi.getActiveTools())
					: pi.getActiveTools();
			if (reviewState.stage === "approved") {
				reviewState = INITIAL_REVIEW_STATE;
				persistReview();
			}
			retroState = beginRetro(withoutWorkflowSubmissionTools(previousTools));
			pi.setActiveTools(activeRetroTools(retroState));
			persistRetro();
			updateDisplay(ctx);
			pi.sendUserMessage(buildRetroPrompt(args));
		},
	});

	pi.registerCommand("approve-retro", {
		description: "Approve a retrospective proposal without applying it",
		handler: async (_args, ctx) => {
			await ctx.waitForIdle();
			const proposal = retroState.proposal;
			if (retroState.stage !== "proposed" || !proposal) {
				ctx.ui.notify(
					"No retrospective proposal is awaiting approval.",
					"warning",
				);
				return;
			}
			if (
				(await hashTargetFile(proposal.cwd, proposal.targetFile)) !==
				proposal.baseHash
			) {
				ctx.ui.notify(
					"The proposal target changed. Cancel and run /retro again.",
					"error",
				);
				return;
			}
			if (!ctx.hasUI) {
				ctx.ui.notify(
					"Retrospective approval requires an interactive human.",
					"error",
				);
				return;
			}
			const approved = await ctx.ui.confirm(
				"Approve retrospective proposal?",
				`${proposal.title}\n\nThis records approval only. It will not modify ${proposal.targetFile}.`,
			);
			if (!approved) return;
			restoreRetroTools();
			retroState = approveRetro(retroState);
			persistRetro();
			updateDisplay(ctx);
			ctx.ui.notify(
				"Proposal approved but not applied. Start a separate plan to implement it.",
				"info",
			);
		},
	});

	pi.registerCommand("cancel-retro", {
		description:
			"Discard the retrospective proposal and restore previous tools",
		handler: async (_args, ctx) => {
			await ctx.waitForIdle();
			cancelRetro(ctx, "Retrospective discarded. Previous tools restored.");
		},
	});

	pi.registerCommand("quality-check", {
		description: "Run static analysis, lint, and tests before agent review",
		handler: async (_args, ctx) => {
			await ctx.waitForIdle();
			if (
				planState.enabled ||
				isReviewLocked(reviewState) ||
				isRetroLocked(retroState)
			) {
				ctx.ui.notify("Quality checks require implementation mode.", "warning");
				return;
			}
			clearApprovedRetro();
			ctx.ui.setStatus(
				"supervised-workflow",
				ctx.ui.theme.fg("warning", "◌ validating"),
			);
			try {
				const before = await captureGitSnapshot(pi, ctx.cwd);
				const checks = await runQualityChecks(pi, ctx.cwd, {
					projectTrusted: ctx.isProjectTrusted(),
				});
				const after = await captureGitSnapshot(pi, ctx.cwd);
				if (before.hash !== after.hash) {
					ctx.ui.notify(
						"Validation changed the patch. Inspect it and run /quality-check again.",
						"error",
					);
					updateDisplay(ctx);
					return;
				}
				if (!checksPassed(checks)) {
					pi.sendMessage({
						customType: "supervised-workflow-quality",
						content: formatQualityFailures(checks),
						display: true,
					});
					reviewState = {
						...INITIAL_REVIEW_STATE,
						snapshotHash: after.hash,
						checks,
					};
					persistReview();
					const failed = checks
						.filter((check) => !check.passed)
						.map((check) => check.name)
						.join(", ");
					ctx.ui.notify(`Validation failed: ${failed}.`, "error");
					updateDisplay(ctx);
					return;
				}
				reviewState = beginAgentReview(checks, after.hash, pi.getActiveTools());
				pi.setActiveTools(activeReviewTools(reviewState));
				persistReview();
				updateDisplay(ctx);
				pi.sendUserMessage(buildAgentReviewPrompt(after));
			} catch (error) {
				ctx.ui.notify(errorMessage(error), "error");
				updateDisplay(ctx);
			}
		},
	});

	pi.registerCommand("request-review", {
		description: "Open human review after validation and agent review pass",
		handler: async (_args, ctx) => {
			await ctx.waitForIdle();
			await showHumanReview(ctx);
		},
	});

	pi.registerCommand("request-changes", {
		description: "Leave review with required human feedback",
		handler: async (args, ctx) => {
			await ctx.waitForIdle();
			await requestChanges(ctx, args);
		},
	});

	pi.registerCommand("approve", {
		description: "Approve the current validated patch without committing it",
		handler: async (_args, ctx) => {
			await ctx.waitForIdle();
			await approveReview(ctx);
		},
	});

	pi.on("tool_call", async (event) => {
		if (
			event.toolName === "bash" &&
			typeof event.input.command === "string" &&
			commandAttemptsGitPublish(event.input.command)
		) {
			return { block: true, reason: COMMIT_BLOCK_REASON };
		}
		if (planState.enabled && !isPlanToolAllowed(event.toolName)) {
			return {
				block: true,
				reason: `Plan mode blocks ${event.toolName}. Only ${PLAN_MODE_TOOLS.join(", ")} are available until the human approves the plan.`,
			};
		}
		if (
			isRetroLocked(retroState) &&
			!activeRetroTools(retroState).includes(event.toolName)
		) {
			return {
				block: true,
				reason: `Retrospective mode blocks ${event.toolName}. The proposal is read-only and cannot be applied.`,
			};
		}
		if (
			isReviewLocked(reviewState) &&
			!activeReviewTools(reviewState).includes(event.toolName)
		) {
			return {
				block: true,
				reason: `Review mode blocks ${event.toolName}. The validated patch is read-only.`,
			};
		}
	});

	pi.on("before_agent_start", async (event) => {
		const instructions = [
			planState.enabled ? PLAN_INSTRUCTIONS : undefined,
			isRetroLocked(retroState) ? RETRO_INSTRUCTIONS : undefined,
			isReviewLocked(reviewState) ? REVIEW_INSTRUCTIONS : undefined,
			"Never run git commit or git push. Commits and publication require a separate explicit human action.",
		].filter(Boolean);
		return {
			systemPrompt: `${event.systemPrompt}\n\n${instructions.join("\n\n")}`,
		};
	});

	function reconcileBranch(ctx: ExtensionContext): void {
		const previousTools = lockRestoreTools(planState, reviewState, retroState);
		planState = restoreEntry(
			ctx.sessionManager.getBranch(),
			PLAN_MODE_ENTRY,
			parsePlanState,
			INITIAL_PLAN_STATE,
		);
		reviewState = restoreEntry(
			ctx.sessionManager.getBranch(),
			REVIEW_STATE_ENTRY,
			parseReviewState,
			INITIAL_REVIEW_STATE,
		);
		retroState = restoreEntry(
			ctx.sessionManager.getBranch(),
			RETRO_STATE_ENTRY,
			parseRetroState,
			INITIAL_RETRO_STATE,
		);
		if (planState.enabled) pi.setActiveTools([...PLAN_MODE_TOOLS]);
		else if (isRetroLocked(retroState))
			pi.setActiveTools(activeRetroTools(retroState));
		else if (isReviewLocked(reviewState))
			pi.setActiveTools(activeReviewTools(reviewState));
		else if (retroState.stage === "approved" && retroState.toolsBeforeRetro)
			pi.setActiveTools(
				withoutWorkflowSubmissionTools(retroState.toolsBeforeRetro),
			);
		else if (previousTools)
			pi.setActiveTools(withoutWorkflowSubmissionTools(previousTools));
		else pi.setActiveTools(withoutWorkflowSubmissionTools(pi.getActiveTools()));
		updateDisplay(ctx);
	}

	pi.on("session_start", async (_event, ctx) => reconcileBranch(ctx));
	pi.on("session_tree", async (_event, ctx) => reconcileBranch(ctx));
}

export function commandAttemptsGitPublish(command: string): boolean {
	const gitInvocation = /(?:^|[\s;&|()])(?:[^\s;&|()]*\/)?git\b/gi;
	for (const match of command.matchAll(gitInvocation)) {
		const invocation = command.slice((match.index ?? 0) + match[0].length);
		const segment = invocation.split(/[;&|()]/, 1)[0] ?? "";
		if (/(?:^|[\s"'`])(?:commit|push)(?=$|[\s"'`])/i.test(segment)) return true;
	}
	return false;
}

function buildAgentReviewPrompt(snapshot: GitSnapshot): string {
	const maxDiffChars = 50_000;
	const diff =
		snapshot.diff.length > maxDiffChars
			? `${snapshot.diff.slice(0, maxDiffChars)}\n\n[Inline diff truncated. Read changed files for complete context.]`
			: snapshot.diff;
	return `Perform the mandatory read-only agent review of this validated patch.

Review for:
- Exact functionality and patch-introduced correctness defects.
- Extensibility and flexibility without speculative abstraction.
- Clarity, single responsibility, and lack of complection.
- Data-oriented state and transitions where appropriate.
- Reuse of installed dependencies and platform APIs instead of reimplementation.
- Valuable tests of our behavior, including adversarial cases and fuzzing only where it is genuinely useful.

Every finding must be specific, actionable, evidence-backed, and introduced by this patch. Read full changed-file context as needed. Do not edit files or run commands. Finish by calling ${AGENT_REVIEW_TOOL} exactly once. Use verdict "pass" only with zero findings.

Patch: ${snapshot.files} files, +${snapshot.added}/-${snapshot.removed}

\`\`\`diff
${diff}
\`\`\``;
}

function reviewDisplay(
	state: ReviewState,
	ctx: ExtensionContext,
): { status: string; widget: string[] } | undefined {
	switch (state.stage) {
		case "implementing": {
			const failed = state.checks.filter((check) => !check.passed);
			if (failed.length === 0) return undefined;
			return {
				status: ctx.ui.theme.fg("error", "◆ VALIDATION FAILED"),
				widget: [
					ctx.ui.theme.fg(
						"error",
						`Failed: ${failed.map((check) => check.name).join(", ")}`,
					),
					ctx.ui.theme.fg("dim", "Fix the failures, then run /quality-check"),
				],
			};
		}
		case "agent-review":
			return {
				status: ctx.ui.theme.fg("warning", "◇ AGENT REVIEW · read-only"),
				widget: [
					ctx.ui.theme.fg("warning", "Validated patch awaiting agent verdict"),
					ctx.ui.theme.fg("dim", "Static analysis · lint · tests passed"),
				],
			};
		case "agent-findings":
			return {
				status: ctx.ui.theme.fg("error", "◆ AGENT FINDINGS · read-only"),
				widget: [
					ctx.ui.theme.fg(
						"error",
						`${state.agentReview?.findings.length ?? 0} evidence-backed finding(s)`,
					),
					ctx.ui.theme.fg(
						"dim",
						"/request-changes to review and release implementation tools",
					),
				],
			};
		case "review-ready":
			return {
				status: ctx.ui.theme.fg("accent", "◇ REVIEW READY · read-only"),
				widget: [
					ctx.ui.theme.fg("success", "Validation and agent review passed"),
					ctx.ui.theme.fg("dim", "/request-review to inspect the patch"),
				],
			};
		case "human-review":
			return {
				status: ctx.ui.theme.fg("warning", "◇ HUMAN REVIEW · locked"),
				widget: [
					ctx.ui.theme.fg(
						"warning",
						"Validated patch is locked for human review",
					),
					ctx.ui.theme.fg("dim", "/approve · /request-changes <feedback>"),
				],
			};
		case "approved":
			return {
				status: ctx.ui.theme.fg("success", "◆ APPROVED"),
				widget: [
					ctx.ui.theme.fg("success", "Human review approved this patch"),
					ctx.ui.theme.fg("dim", "Commit remains a manual action"),
				],
			};
	}
}

function retroDisplay(
	state: RetroState,
	ctx: ExtensionContext,
): { status: string; widget: string[] } | undefined {
	switch (state.stage) {
		case "idle":
			return undefined;
		case "collecting":
			return {
				status: ctx.ui.theme.fg("warning", "◇ RETRO · read-only"),
				widget: [
					ctx.ui.theme.fg("warning", "Collecting one evidence-based proposal"),
					ctx.ui.theme.fg("dim", "/cancel-retro to exit without a proposal"),
				],
			};
		case "proposed":
			return {
				status: ctx.ui.theme.fg("accent", "◇ RETRO PROPOSAL · read-only"),
				widget: [
					ctx.ui.theme.fg(
						"accent",
						state.proposal?.title ?? "Proposal awaiting human review",
					),
					ctx.ui.theme.fg("dim", "/approve-retro · /cancel-retro"),
				],
			};
		case "approved":
			return {
				status: ctx.ui.theme.fg("success", "◆ RETRO APPROVED · unapplied"),
				widget: [
					ctx.ui.theme.fg(
						"success",
						"Proposal approved; no files were changed",
					),
					ctx.ui.theme.fg("dim", "Use /plan for any separate implementation"),
				],
			};
	}
}

export function formatQualityFailures(checks: readonly CheckResult[]): string {
	const failed = checks.filter((check) => !check.passed);
	const sections = failed.map((check) => {
		const output = sanitizeTerminalText(check.output);
		return `## ${check.name}\nCommand: ${check.command}\nDuration: ${check.durationMs}ms\n\n${output}`;
	});
	return `Quality validation failed. Fix these diagnostics before running /quality-check again.\n\n${sections.join("\n\n---\n\n")}`;
}

function sanitizeTerminalText(text: string): string {
	return [...text]
		.map((character) => {
			if (character === "\n" || character === "\t") return character;
			const codePoint = character.codePointAt(0) ?? 0;
			return codePoint < 32 || (codePoint >= 127 && codePoint <= 159)
				? "�"
				: character;
		})
		.join("");
}

function formatAgentFindings(review: AgentReviewResult | null): string {
	if (review?.verdict !== "changes-requested") return "";
	const lines = [`Agent review: ${review.summary}`, ""];
	for (const finding of review.findings) {
		const location = finding.file
			? ` (${finding.file}${finding.line ? `:${finding.line}` : ""})`
			: "";
		lines.push(
			`- [${finding.severity}] ${finding.title}${location}`,
			`  ${finding.evidence}`,
		);
	}
	return `${lines.join("\n")}\n`;
}

function lockRestoreTools(
	planState: PlanState,
	reviewState: ReviewState,
	retroState: RetroState,
): string[] | undefined {
	if (planState.enabled) return [...(planState.toolsBeforePlan ?? [])];
	if (isRetroLocked(retroState))
		return [...(retroState.toolsBeforeRetro ?? [])];
	if (isReviewLocked(reviewState))
		return [...(reviewState.toolsBeforeReview ?? [])];
	return undefined;
}

function withoutWorkflowSubmissionTools(tools: readonly string[]): string[] {
	return tools.filter(
		(tool) => tool !== AGENT_REVIEW_TOOL && tool !== RETRO_PROPOSAL_TOOL,
	);
}

function restoreEntry<T>(
	branch: readonly SessionEntry[],
	customType: string,
	parse: (value: unknown) => T | undefined,
	initial: T,
): T {
	for (let index = branch.length - 1; index >= 0; index--) {
		const entry = branch[index];
		if (entry.type !== "custom" || entry.customType !== customType) continue;
		return parse(entry.data) ?? initial;
	}
	return initial;
}

function buildRetroPrompt(focus: string): string {
	const requestedFocus = focus.trim()
		? `\nHuman-provided focus: ${focus.trim()}\n`
		: "";
	return `Perform a read-only retrospective of this session and the relevant agent configuration.${requestedFocus}
Identify one small, high-leverage improvement to configuration, instructions, or workflow documentation. Base it on concrete evidence observed in this session or inspected files—not preference or speculation. Prefer simplifying or correcting existing guidance over adding machinery.

Submit exactly one target file and a valid unified diff through ${RETRO_PROPOSAL_TOOL}. Include the evidence source, expected benefit, risks, and validation steps. Do not apply the diff. If evidence is insufficient, explain that to the human without submitting a proposal; /cancel-retro will exit safely.`;
}

function formatRetroProposal(proposal: RetroProposal): string {
	const evidence = proposal.evidence
		.map((item) => `- ${item.source}: ${item.observation}`)
		.join("\n");
	const risks = proposal.risks.length
		? proposal.risks.map((risk) => `- ${risk}`).join("\n")
		: "- None identified.";
	const validation = proposal.validation.map((step) => `- ${step}`).join("\n");
	return `Retrospective proposal recorded for human review. It has not been applied.

## ${proposal.title}
Target: ${proposal.targetFile}

Rationale: ${proposal.rationale}
Expected benefit: ${proposal.expectedBenefit}

Evidence:
${evidence}

Risks:
${risks}

Validation:
${validation}

\`\`\`diff
${proposal.diff}
\`\`\`

Run /approve-retro to record approval without applying it, or /cancel-retro to discard it.`;
}

async function hashTargetFile(
	cwd: string,
	targetFile: string,
): Promise<string | null> {
	try {
		const content = await readFile(resolve(cwd, targetFile));
		return createHash("sha256").update(content).digest("hex");
	} catch (error) {
		if (isRecord(error) && error.code === "ENOENT") return null;
		throw new Error(`Unable to read proposal target: ${errorMessage(error)}`);
	}
}

function requireText(value: string, label: string): string {
	const trimmed = value.trim();
	if (!trimmed) throw new Error(`${label} must not be empty.`);
	return trimmed;
}

function isRecord(value: unknown): value is Record<string, unknown> {
	return typeof value === "object" && value !== null;
}

function errorMessage(error: unknown): string {
	return error instanceof Error ? error.message : String(error);
}
