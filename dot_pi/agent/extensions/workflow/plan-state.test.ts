import { describe, expect, it } from "vitest";
import {
	enterPlanMode,
	INITIAL_PLAN_STATE,
	isPlanToolAllowed,
	leavePlanMode,
	PLAN_MODE_TOOLS,
	parsePlanState,
} from "./plan-state.ts";

describe("plan tool policy", () => {
	it.each(PLAN_MODE_TOOLS)("allows the read-only tool %s", (toolName) => {
		expect(isPlanToolAllowed(toolName)).toBe(true);
	});

	it.each(["bash", "edit", "write", "hashline_edit", "unknown_custom_tool"])(
		"fails closed for %s",
		(toolName) => {
			expect(isPlanToolAllowed(toolName)).toBe(false);
		},
	);
});

describe("plan state transitions", () => {
	it("captures and restores the exact active tool set", () => {
		const activeTools = ["read", "bash", "hashline_edit"];
		const entered = enterPlanMode(INITIAL_PLAN_STATE, activeTools);
		activeTools.push("write");

		expect(entered).toEqual({
			enabled: true,
			toolsBeforePlan: ["read", "bash", "hashline_edit"],
		});
		expect(leavePlanMode(entered)).toEqual({
			state: INITIAL_PLAN_STATE,
			restoreTools: ["read", "bash", "hashline_edit"],
		});
	});

	it("does not replace the original snapshot when entered twice", () => {
		const entered = enterPlanMode(INITIAL_PLAN_STATE, ["read", "edit"]);
		expect(enterPlanMode(entered, [...PLAN_MODE_TOOLS])).toBe(entered);
	});
});

describe("persisted plan state", () => {
	it("copies valid persisted data", () => {
		const tools = ["read", "bash"];
		const parsed = parsePlanState({ enabled: true, toolsBeforePlan: tools });
		tools.push("write");
		expect(parsed).toEqual({
			enabled: true,
			toolsBeforePlan: ["read", "bash"],
		});
	});

	it.each([
		null,
		{},
		{ enabled: "yes", toolsBeforePlan: [] },
		{ enabled: true, toolsBeforePlan: null },
		{ enabled: true, toolsBeforePlan: ["read", 1] },
	])("rejects malformed state %#", (value) => {
		expect(parsePlanState(value)).toBeUndefined();
	});
});
