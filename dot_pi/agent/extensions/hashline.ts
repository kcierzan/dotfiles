import { createHash } from "node:crypto";
import { readFile, realpath, writeFile } from "node:fs/promises";
import { isAbsolute, relative, resolve } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { withFileMutationQueue } from "@earendil-works/pi-coding-agent";
import { Text } from "@earendil-works/pi-tui";
import { Type } from "typebox";

const MAX_SNAPSHOT_BYTES = 4 * 1024 * 1024;
const MAX_OUTPUT_BYTES = 50 * 1024;
const MAX_OUTPUT_LINES = 2000;

type Snapshot = { text: string; tag: string };
type Edit =
	| {
			kind: "replace";
			start: number;
			end: number;
			body: string[];
			index: number;
	  }
	| { kind: "delete"; start: number; end: number; index: number }
	| {
			kind: "insert";
			at: number;
			after: boolean;
			body: string[];
			index: number;
	  };

function normalize(text: string): string {
	return text.startsWith("\uFEFF")
		? text.slice(1).replaceAll("\r\n", "\n")
		: text.replaceAll("\r\n", "\n");
}

function tagFor(text: string): string {
	return createHash("sha256")
		.update(text)
		.digest("hex")
		.slice(0, 8)
		.toUpperCase();
}

function displayPath(cwd: string, path: string): string {
	const value = relative(cwd, path);
	return value === "" ? "." : value;
}

function contentLines(text: string): string[] {
	if (text === "") return [];
	return text.endsWith("\n") ? text.slice(0, -1).split("\n") : text.split("\n");
}

function formatSnapshot(
	path: string,
	lines: string[],
	startLine = 1,
	tag?: string,
): string {
	const output = tag ? [`[${path}#${tag}]`] : [];
	let bytes = output.length === 0 ? 0 : Buffer.byteLength(output[0]);
	let shown = 0;
	for (
		let index = 0;
		index < lines.length && shown < MAX_OUTPUT_LINES;
		index++
	) {
		const row = `${startLine + index}:${lines[index]}`;
		if (bytes + Buffer.byteLength(row) + 1 > MAX_OUTPUT_BYTES) break;
		output.push(row);
		bytes += Buffer.byteLength(row) + 1;
		shown++;
	}
	if (shown < lines.length) {
		output.push(
			`\n[Showing lines ${startLine}-${startLine + shown - 1} of ${startLine + lines.length - 1}. Read the remaining range before editing it.]`,
		);
	}
	return output.join("\n");
}

function parsePatch(
	input: string,
): Array<{ path: string; tag: string; edits: Edit[] }> {
	const sections: Array<{ path: string; tag: string; edits: Edit[] }> = [];
	let section: { path: string; tag: string; edits: Edit[] } | undefined;
	let pending: { edit: Edit; body: string[] } | undefined;

	const flush = () => {
		if (!pending) return;
		if (pending.edit.kind !== "delete" && pending.body.length === 0) {
			throw new Error(
				"PUT operations require at least one + body row. Use CUT to delete lines.",
			);
		}
		if (pending.edit.kind !== "delete") pending.edit.body = pending.body;
		if (!section)
			throw new Error("Hashline operation is missing a section header.");
		section.edits.push(pending.edit);
		pending = undefined;
	};

	for (const [offset, raw] of input
		.replaceAll("\r\n", "\n")
		.split("\n")
		.entries()) {
		const line = offset + 1;
		const header = /^\[(.+)#([0-9A-Fa-f]{8})\]$/.exec(raw.trim());
		if (header) {
			flush();
			section = { path: header[1], tag: header[2].toUpperCase(), edits: [] };
			sections.push(section);
			continue;
		}
		if (!section) {
			if (raw.trim() === "" || raw.startsWith("*** ")) continue;
			throw new Error(`Line ${line}: expected a [path#TAG] section header.`);
		}
		if (pending && raw.startsWith("+")) {
			pending.body.push(raw.slice(1));
			continue;
		}
		if (raw.trim() === "") continue;
		flush();
		const index = section.edits.length;
		let match = /^PUT\s+(\d+)\.=(\d+):$/.exec(raw);
		if (match) {
			pending = {
				edit: {
					kind: "replace",
					start: Number(match[1]),
					end: Number(match[2]),
					body: [],
					index,
				},
				body: [],
			};
			continue;
		}
		match = /^CUT\s+(\d+)\.=(\d+)$/.exec(raw);
		if (match) {
			section.edits.push({
				kind: "delete",
				start: Number(match[1]),
				end: Number(match[2]),
				index,
			});
			continue;
		}
		match = /^PUT\s+([<>])(\d+|\$):$/.exec(raw);
		if (match) {
			pending = {
				edit: {
					kind: "insert",
					at: match[2] === "$" ? -1 : Number(match[2]),
					after: match[1] === ">",
					body: [],
					index,
				},
				body: [],
			};
			continue;
		}
		throw new Error(
			`Line ${line}: invalid hashline operation. Use PUT N.=M:, CUT N.=M, PUT <N:, or PUT >N:.`,
		);
	}
	flush();
	if (sections.length === 0) throw new Error("No hashline sections found.");
	return sections;
}

function applyEdits(text: string, edits: Edit[]): string {
	const trailingNewline = text.endsWith("\n");
	const lines = contentLines(text);
	const occupied = new Set<number>();
	for (const edit of edits) {
		if (edit.kind === "insert") {
			const anchor = edit.at === -1 ? lines.length : edit.at;
			const valid =
				edit.at === -1 ||
				(edit.at >= 1 && edit.at <= lines.length) ||
				(lines.length === 0 && edit.at === 1 && !edit.after);
			if (!valid)
				throw new Error(
					`Invalid insertion anchor ${edit.at}; file has ${lines.length} lines.`,
				);
			if (occupied.has(anchor))
				throw new Error(
					`Overlapping edits at original line ${anchor}. Combine them into one tight operation.`,
				);
			occupied.add(anchor);
			continue;
		}
		if (
			!Number.isSafeInteger(edit.start) ||
			!Number.isSafeInteger(edit.end) ||
			edit.start < 1 ||
			edit.end < edit.start ||
			edit.end > lines.length
		) {
			throw new Error(
				`Invalid line range ${edit.start}.=${edit.end}; file has ${lines.length} lines.`,
			);
		}
		for (let line = edit.start; line <= edit.end; line++) {
			if (occupied.has(line))
				throw new Error(
					`Overlapping edits at original line ${line}. Combine them into one tight operation.`,
				);
			occupied.add(line);
		}
	}
	for (const edit of [...edits].sort((a, b) => {
		const aLine =
			a.kind === "insert"
				? a.at === -1
					? Number.MAX_SAFE_INTEGER
					: a.at
				: a.start;
		const bLine =
			b.kind === "insert"
				? b.at === -1
					? Number.MAX_SAFE_INTEGER
					: b.at
				: b.start;
		return bLine - aLine || b.index - a.index;
	})) {
		if (edit.kind === "replace")
			lines.splice(edit.start - 1, edit.end - edit.start + 1, ...edit.body);
		else if (edit.kind === "delete")
			lines.splice(edit.start - 1, edit.end - edit.start + 1);
		else
			lines.splice(
				edit.at === -1 ? lines.length : edit.after ? edit.at : edit.at - 1,
				0,
				...edit.body,
			);
	}
	return `${lines.join("\n")}${trailingNewline && lines.length > 0 ? "\n" : ""}`;
}

export default function (pi: ExtensionAPI) {
	const snapshots = new Map<string, Snapshot[]>();

	function record(path: string, text: string): string | undefined {
		if (Buffer.byteLength(text) > MAX_SNAPSHOT_BYTES) return undefined;
		const tag = tagFor(text);
		const history = snapshots.get(path) ?? [];
		snapshots.set(
			path,
			[
				{ text, tag },
				...history.filter((snapshot) => snapshot.text !== text),
			].slice(0, 4),
		);
		return tag;
	}

	pi.registerTool({
		name: "hashline_read",
		label: "Hashline Read",
		description:
			"Read a text file with hashline anchors ([path#TAG] and LINE:text) for a later hashline_edit call. Use Pi's built-in read for normal reading and images. Text output is capped at 2,000 lines or 50KB.",
		promptSnippet:
			"Opt-in text reads with stable hashline anchors for concurrent editing",
		promptGuidelines: [
			"Use built-in read and edit by default. Use hashline_read followed by hashline_edit only when stale-write protection is useful, such as concurrent editing.",
			"Copy hashline_read's current [path#TAG] header and original line numbers into hashline_edit. Re-read only after a stale-tag error, to verify sensitive changes, or before another edit that needs current content or line numbers.",
		],
		parameters: Type.Object({
			path: Type.String(),
			offset: Type.Optional(Type.Integer({ minimum: 1 })),
			limit: Type.Optional(Type.Integer({ minimum: 1 })),
		}),
		async execute(_id, params, _signal, _update, ctx) {
			const requested = params.path.startsWith("@")
				? params.path.slice(1)
				: params.path;
			const absolute = await realpath(resolve(ctx.cwd, requested));
			const text = normalize(await readFile(absolute, "utf8"));
			if (text.includes("\0"))
				throw new Error("Binary files are not supported by hashline read.");
			const snapshotTag = record(absolute, text);
			const all = contentLines(text);
			const start = (params.offset ?? 1) - 1;
			if (all.length === 0 && start === 0) {
				const path = displayPath(ctx.cwd, absolute);
				return {
					content: [
						{
							type: "text",
							text: `[${path}#${snapshotTag}]\n[File is empty.]`,
						},
					],
					details: {},
				};
			}
			if (start >= all.length)
				throw new Error(
					`Offset ${params.offset} is beyond end of file (${all.length} lines).`,
				);
			const end =
				params.limit === undefined
					? all.length
					: Math.min(all.length, start + params.limit);
			const selected = all.slice(start, end);
			const path = displayPath(ctx.cwd, absolute);
			let output = formatSnapshot(path, selected, start + 1, snapshotTag);
			if (!snapshotTag)
				output = `[${path} is larger than 4MB and cannot receive hashline anchors; use write or a narrower editing method.]\n${output}`;
			if (end < all.length)
				output += `\n\n[${all.length - end} more lines in file. Use offset=${end + 1} to continue.]`;
			return { content: [{ type: "text", text: output }], details: {} };
		},
	});

	pi.registerTool({
		name: "hashline_edit",
		label: "Hashline Edit",
		description:
			"Apply line-anchored edits to existing text files. Input uses [path#TAG] sections from hashline_read, PUT N.=M: +body rows for replacement, CUT N.=M for deletion, and PUT <N:/PUT >N: for insertion.",
		promptSnippet:
			"Edit existing files by current hashline snapshot tag and original line numbers",
		promptGuidelines: [
			"Use hashline_edit only after hashline_read. Its patch must use a current [path#TAG] from hashline_read.",
			"For hashline_edit: PUT N.=M: replaces only original changed lines and each final-content body row begins +; CUT N.=M deletes; PUT <N: and PUT >N: insert. Use hashline_read again only when verification or another current-line edit requires it.",
		],
		parameters: Type.Object({
			patch: Type.String({
				description:
					"Hashline patch using [path#TAG] sections and PUT/CUT operations.",
			}),
		}),
		renderCall(args, theme, context) {
			const text =
				(context.lastComponent as Text | undefined) ?? new Text("", 0, 0);
			const header =
				typeof args.patch === "string"
					? args.patch.match(/^\[[^\n]+\]/)?.[0]
					: undefined;
			text.setText(
				theme.fg("toolTitle", theme.bold("hashline edit ")) +
					theme.fg("accent", header ?? "patch"),
			);
			return text;
		},
		renderResult(result, { isPartial }, theme, context) {
			const text =
				(context.lastComponent as Text | undefined) ?? new Text("", 0, 0);
			if (isPartial) {
				text.setText(theme.fg("warning", "Applying hashline patch..."));
			} else if (context.isError) {
				const output = result.content
					.filter((item) => item.type === "text")
					.map((item) => item.text ?? "")
					.join("\n");
				text.setText(theme.fg("error", output));
			} else {
				text.setText(theme.fg("success", "Applied hashline patch."));
			}
			return text;
		},
		async execute(_id, params, _signal, _update, ctx) {
			const sections = parsePatch(params.patch);
			const seenPaths = new Set<string>();
			const targets: Array<{
				section: (typeof sections)[number];
				absolute: string;
			}> = [];
			for (const section of sections) {
				const requested = section.path.startsWith("@")
					? section.path.slice(1)
					: section.path;
				const absolute = await realpath(
					isAbsolute(requested) ? requested : resolve(ctx.cwd, requested),
				);
				if (seenPaths.has(absolute))
					throw new Error(
						`Multiple sections target ${section.path}; combine its operations into one section.`,
					);
				seenPaths.add(absolute);
				targets.push({ section, absolute });
			}

			const lockPaths = [...seenPaths].sort();
			const results: string[] = [];
			const applyLocked = async (index: number): Promise<void> => {
				if (index < lockPaths.length) {
					await withFileMutationQueue(lockPaths[index], () =>
						applyLocked(index + 1),
					);
					return;
				}

				const writes: Array<{
					absolute: string;
					next: string;
					section: (typeof sections)[number];
				}> = [];
				for (const target of targets) {
					const current = normalize(await readFile(target.absolute, "utf8"));
					const snapshot = snapshots
						.get(target.absolute)
						?.find((item) => item.tag === target.section.tag);
					if (!snapshot)
						throw new Error(
							`Unknown snapshot tag ${target.section.tag} for ${target.section.path}. Run read first.`,
						);
					if (snapshot.text !== current)
						throw new Error(
							`Snapshot ${target.section.tag} for ${target.section.path} is stale. Run read again before editing.`,
						);
					writes.push({
						absolute: target.absolute,
						next: applyEdits(current, target.section.edits),
						section: target.section,
					});
				}

				for (const write of writes) {
					await writeFile(write.absolute, write.next, "utf8");
					const nextTag = record(write.absolute, write.next);
					const path = displayPath(ctx.cwd, write.absolute);
					results.push(
						`Applied ${write.section.edits.length} edit${write.section.edits.length === 1 ? "" : "s"} to ${path}. New snapshot: [${path}#${nextTag}]. Verify with read if needed.`,
					);
				}
			};
			await applyLocked(0);
			return {
				content: [{ type: "text", text: results.join("\n\n") }],
				details: {},
			};
		},
	});
}
