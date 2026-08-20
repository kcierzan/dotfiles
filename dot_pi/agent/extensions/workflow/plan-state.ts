export const PLAN_MODE_TOOLS = ["read", "grep", "find", "ls"] as const;

export const PLAN_MODE_ENTRY = "supervised-workflow-plan";

export interface PlanState {
	enabled: boolean;
	toolsBeforePlan: string[] | null;
}

export const INITIAL_PLAN_STATE: PlanState = {
	enabled: false,
	toolsBeforePlan: null,
};

const planToolNames = new Set<string>(PLAN_MODE_TOOLS);

export function isPlanToolAllowed(toolName: string): boolean {
	return planToolNames.has(toolName);
}

export function enterPlanMode(
	state: PlanState,
	activeTools: readonly string[],
): PlanState {
	if (state.enabled) return state;
	return {
		enabled: true,
		toolsBeforePlan: [...activeTools],
	};
}

export function leavePlanMode(state: PlanState): {
	state: PlanState;
	restoreTools: string[];
} {
	return {
		state: INITIAL_PLAN_STATE,
		restoreTools: [...(state.toolsBeforePlan ?? [])],
	};
}

export function parsePlanState(value: unknown): PlanState | undefined {
	if (typeof value !== "object" || value === null) return undefined;
	const candidate = value as { enabled?: unknown; toolsBeforePlan?: unknown };
	if (typeof candidate.enabled !== "boolean") return undefined;
	if (
		candidate.toolsBeforePlan !== null &&
		!isStringArray(candidate.toolsBeforePlan)
	)
		return undefined;
	if (candidate.enabled && !Array.isArray(candidate.toolsBeforePlan))
		return undefined;
	return {
		enabled: candidate.enabled,
		toolsBeforePlan:
			candidate.toolsBeforePlan === null
				? null
				: [...candidate.toolsBeforePlan],
	};
}

function isStringArray(value: unknown): value is string[] {
	return (
		Array.isArray(value) && value.every((item) => typeof item === "string")
	);
}
