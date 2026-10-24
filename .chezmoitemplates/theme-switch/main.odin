package main

import "core:encoding/json"
import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:sort"
import "core:strconv"
import "core:strings"

PROGRAM :: "theme-switch"
USAGE :: "usage: theme-switch [--list | --current | --set THEME_ID]"

CHEZMOI_COMMAND  :: "chezmoi"
FZF_COMMAND      :: "fzf"
NOCTALIA_COMMAND :: "noctalia"
NIRI_COMMAND     :: "niri"

DARWIN_PLATFORM :: "Darwin"
LINUX_PLATFORM  :: "Linux"

PREVIEW_OPTION :: "--preview"
CURRENT_OPTION :: "--current"
LIST_OPTION    :: "--list"
SET_OPTION     :: "--set"

THEME_DATA_PATH       :: ".chezmoidata/theme.yaml"
GHOSTTY_THEME_PATH    :: ".config/ghostty/themes/base16"
VIVID_THEME_PATH      :: ".config/vivid/themes/base16.yml"
LSD_THEME_PATH        :: ".config/lsd/colors.yaml"
NEOVIM_THEME_PATH     :: ".local/share/nvim/base16-colors.lua"
BTOP_THEME_PATH       :: ".config/btop/themes/base16.theme"
LAZYGIT_THEME_PATH    :: ".config/lazygit/config.yml"
NOCTALIA_CONFIG_PATH  :: ".config/noctalia/config.toml"
NOCTALIA_PALETTE_PATH :: ".config/noctalia/palettes/Base16.json"
NIRI_THEME_PATH       :: ".config/niri/noctalia.kdl"

NOCTALIA_SETTINGS_PATH :: "noctalia/settings.toml"
NOCTALIA_SOURCE        :: "custom"
NOCTALIA_PALETTE       :: "Base16"
NOCTALIA_THEME_SECTION :: "[theme]"
NOCTALIA_SOURCE_KEY    :: "source"
NOCTALIA_PALETTE_KEY   :: "custom_palette"
NOCTALIA_MODE_KEY      :: "mode"

Palette :: struct {
	base00: string,
	base01: string,
	base02: string,
	base03: string,
	base04: string,
	base05: string,
	base06: string,
	base07: string,
	base08: string,
	base09: string,
	base0A: string,
	base0B: string,
	base0C: string,
	base0D: string,
	base0E: string,
	base0F: string,
}

Theme :: struct {
	name:    string,
	variant: string,
	palette: Palette,
}

Theme_Data :: struct {
	theme:  string,
	themes: map[string]Theme,
}

App :: struct {
	source_dir: string,
	target_dir: string,
	platform:   string,
	data:       Theme_Data,
}

Command_Result :: struct {
	output:    string,
	error_text: string,
	exit_code: int,
	started:   bool,
}

fail :: proc(message: string) -> ! {
	fmt.eprintf("%s: %s\n", PROGRAM, message)
	os.exit(1)
}

join :: proc(parts: []string) -> string {
	result, err := filepath.join(parts)
	if err != nil {
		fail("could not construct a filesystem path")
	}
	return result
}

run_capture :: proc(command: []string) -> Command_Result {
	state, stdout, stderr, err := os.process_exec(
		os.Process_Desc{command = command},
		context.allocator,
	)
	result := Command_Result{}
	if err != nil {
		return result
	}
	result.started = true
	result.output = string(stdout)
	result.error_text = string(stderr)
	result.exit_code = state.exit_code
	return result
}

run_quiet :: proc(command: []string) -> bool {
	process, err := os.process_start(os.Process_Desc{
		command = command,
		stdin = os.stdin,
		stdout = nil,
		stderr = os.stderr,
	})
	if err != nil {
		return false
	}
	state, wait_err := os.process_wait(process)
	return wait_err == nil && state.exited && state.exit_code == 0
}

command_succeeds :: proc(command: []string) -> bool {
	result := run_capture(command)
	return result.started && result.exit_code == 0
}

load_app :: proc() -> App {
	source := run_capture([]string{CHEZMOI_COMMAND, "source-path"})
	if !source.started || source.exit_code != 0 {
		fail("could not find the chezmoi source directory")
	}
	target := run_capture([]string{CHEZMOI_COMMAND, "target-path"})
	if !target.started || target.exit_code != 0 {
		fail("could not find the chezmoi target directory")
	}
	data_result := run_capture([]string{CHEZMOI_COMMAND, "data", "--format=json"})
	if !data_result.started || data_result.exit_code != 0 {
		fail("could not read chezmoi theme data")
	}
	platform_result := run_capture([]string{"uname", "-s"})
	if !platform_result.started || platform_result.exit_code != 0 {
		fail("could not determine the operating system")
	}

	data: Theme_Data
	if json.unmarshal_string(data_result.output, &data) != nil ||
	   data.theme == "" || data.themes == nil {
		fail("could not parse chezmoi theme data")
	}

	return App{
		source_dir = strings.trim_space(source.output),
		target_dir = strings.trim_space(target.output),
		platform = strings.trim_space(platform_result.output),
		data = data,
	}
}

sorted_theme_ids :: proc(themes: map[string]Theme) -> []string {
	ids := make([dynamic]string, 0, len(themes))
	for id in themes {
		append(&ids, id)
	}
	slice := ids[:]
	sort.sort(sort.slice_interface(&slice))
	return slice
}

list_themes :: proc(app: ^App) {
	ids := sorted_theme_ids(app.data.themes)
	for id in ids {
		theme := app.data.themes[id]
		marker := "*" if id == app.data.theme else ""
		fmt.printf("%s\t%s\t%s\t%s\n", id, theme.name, theme.variant, marker)
	}
}

picker_rows :: proc(app: ^App) -> string {
	builder := strings.builder_make()
	ids := sorted_theme_ids(app.data.themes)
	for id in ids {
		theme := app.data.themes[id]
		marker := "●" if id == app.data.theme else " "
		fmt.sbprintf(&builder, "%s\t%s\t%s (%s)\n", marker, id, theme.name, theme.variant)
	}
	return strings.to_string(builder)
}

theme_id_from_picker_output :: proc(output: string) -> (string, bool) {
	line := strings.trim_right(output, "\r\n")
	first_tab := strings.index_byte(line, '\t')
	if first_tab < 0 {
		return "", false
	}
	remainder := line[first_tab + 1:]
	second_tab := strings.index_byte(remainder, '\t')
	if second_tab <= 0 {
		return "", false
	}
	return remainder[:second_tab], true
}

hex_component :: proc(color: string, offset: int) -> int {
	value, ok := strconv.parse_int(color[offset:offset + 2], 16)
	if !ok {
		fail(fmt.aprintf("invalid palette color: #%s", color))
	}
	return value
}

normalize_color :: proc(value: string) -> string {
	color := value
	if strings.has_prefix(color, "#") {
		color = color[1:]
	}
	if len(color) != 6 {
		fail(fmt.aprintf("invalid palette color: %s", value))
	}
	for character in color {
		if !(character >= '0' && character <= '9') &&
		   !(character >= 'a' && character <= 'f') &&
		   !(character >= 'A' && character <= 'F') {
			fail(fmt.aprintf("invalid palette color: %s", value))
		}
	}
	return color
}

paint :: proc(background, foreground, text: string) {
	bg := normalize_color(background)
	fg := normalize_color(foreground)
	fmt.printf(
		"\x1b[48;2;%d;%d;%dm\x1b[38;2;%d;%d;%dm%s\x1b[0m",
		hex_component(bg, 0), hex_component(bg, 2), hex_component(bg, 4),
		hex_component(fg, 0), hex_component(fg, 2), hex_component(fg, 4), text,
	)
}

swatch :: proc(value: string) {
	color := normalize_color(value)
	fmt.printf(
		"\x1b[48;2;%d;%d;%dm        \x1b[0m %s",
		hex_component(color, 0), hex_component(color, 2), hex_component(color, 4), value,
	)
}

palette_values :: proc(palette: Palette) -> [16]string {
	return {
		palette.base00, palette.base01, palette.base02, palette.base03,
		palette.base04, palette.base05, palette.base06, palette.base07,
		palette.base08, palette.base09, palette.base0A, palette.base0B,
		palette.base0C, palette.base0D, palette.base0E, palette.base0F,
	}
}

preview_theme :: proc(app: ^App, theme_id: string) {
	theme, found := app.data.themes[theme_id]
	if !found {
		fail(fmt.aprintf("unknown theme: %s", theme_id))
	}
	p := theme.palette
	fmt.printf("\n  %s  ·  %s\n\n", theme.name, theme.variant)
	paint(p.base00, p.base05, "  Normal text on editor background       ")
	fmt.println()
	paint(p.base02, p.base05, "  Selected text                          ")
	fmt.println()
	paint(p.base00, p.base0E, "  local ")
	paint(p.base00, p.base0D, "theme")
	paint(p.base00, p.base05, " = ")
	paint(p.base00, p.base0B, "\"colors\"")
	fmt.println("\n")

	values := palette_values(p)
	keys := [16]string{
		"base00", "base01", "base02", "base03", "base04", "base05", "base06", "base07",
		"base08", "base09", "base0A", "base0B", "base0C", "base0D", "base0E", "base0F",
	}
	for index in 0..<8 {
		fmt.printf("  %-6s ", keys[index])
		swatch(values[index])
		fmt.printf("    %-6s ", keys[index + 8])
		swatch(values[index + 8])
		fmt.println()
	}
}

choose_theme :: proc(app: ^App) -> (string, bool) {
	if !command_succeeds([]string{FZF_COMMAND, "--version"}) {
		fail("fzf is required")
	}
	rows := picker_rows(app)
	temporary, err := os.create_temp_file("", "theme-switch-picker-*.tsv")
	if err != nil {
		fail("could not create the picker input")
	}
	temporary_name := strings.clone(os.name(temporary))
	defer os.remove(temporary_name)
	if _, write_err := os.write(temporary, transmute([]byte)rows); write_err != nil {
		os.close(temporary)
		fail("could not write the picker input")
	}
	os.close(temporary)

	command := []string{
		"/bin/sh", "-c",
		`fzf --delimiter="$(printf '\t')" --with-nth=1,3 --prompt='Theme> ' --preview 'theme-switch --preview {2}' --preview-window='right,55%,border-left,<90(up,60%,border-bottom)' < "$1"`,
		"theme-switch", temporary_name,
	}
	result := run_capture(command)
	if !result.started || result.exit_code != 0 {
		return "", false
	}
	return theme_id_from_picker_output(result.output)
}

replace_theme_line :: proc(contents, theme_id: string) -> (string, bool) {
	builder := strings.builder_make()
	found := false
	remaining := contents
	for line in strings.split_lines_after_iterator(&remaining) {
		trimmed := strings.trim_left(line, " \t")
		if strings.has_prefix(trimmed, "theme:") {
			prefix_length := len(line) - len(trimmed)
			strings.write_string(&builder, line[:prefix_length])
			fmt.sbprintf(&builder, "theme: %s", theme_id)
			if strings.has_suffix(line, "\n") {
				strings.write_string(&builder, "\n")
			}
			found = true
		} else {
			strings.write_string(&builder, line)
		}
	}
	return strings.to_string(builder), found
}

save_theme :: proc(app: ^App, theme_id: string) {
	theme_file := join([]string{app.source_dir, THEME_DATA_PATH})
	contents, read_err := os.read_entire_file(theme_file, context.allocator)
	if read_err != nil {
		fail(fmt.aprintf("could not read %s", theme_file))
	}
	updated, found := replace_theme_line(string(contents), theme_id)
	if !found {
		fail(fmt.aprintf("could not update %s", theme_file))
	}
	directory, _ := filepath.split(theme_file)
	temporary, temp_err := os.create_temp_file(directory, ".theme.yaml.*")
	if temp_err != nil {
		fail("could not create temporary theme file")
	}
	temporary_name := strings.clone(os.name(temporary))
	defer os.remove(temporary_name)
	if _, write_err := os.write(temporary, transmute([]byte)updated); write_err != nil {
		os.close(temporary)
		fail(fmt.aprintf("could not save %s", theme_file))
	}
	if os.sync(temporary) != nil || os.close(temporary) != nil ||
	   os.chmod(temporary_name, os.perm(0o644)) != nil ||
	   os.rename(temporary_name, theme_file) != nil {
		fail(fmt.aprintf("could not save %s", theme_file))
	}
}

apply_theme_files :: proc(app: ^App) {
	targets := make([dynamic]string, 0, 9)
	append(&targets,
		join([]string{app.target_dir, GHOSTTY_THEME_PATH}),
		join([]string{app.target_dir, VIVID_THEME_PATH}),
		join([]string{app.target_dir, LSD_THEME_PATH}),
		join([]string{app.target_dir, NEOVIM_THEME_PATH}),
		join([]string{app.target_dir, BTOP_THEME_PATH}),
		join([]string{app.target_dir, LAZYGIT_THEME_PATH}),
	)
	if app.platform == LINUX_PLATFORM {
		append(&targets,
			join([]string{app.target_dir, NOCTALIA_CONFIG_PATH}),
			join([]string{app.target_dir, NOCTALIA_PALETTE_PATH}),
			join([]string{app.target_dir, NIRI_THEME_PATH}),
		)
	}
	command := make([dynamic]string, 0, len(targets) + 4)
	append(&command, CHEZMOI_COMMAND, "apply", "--force", "--parent-dirs")
	append(&command, ..targets[:])
	if !run_quiet(command[:]) {
		fail("chezmoi apply failed; the selection was saved but theme files were not updated")
	}
}

update_noctalia_settings :: proc(contents, variant: string) -> string {
	builder := strings.builder_make()
	in_theme := false
	found_theme := false
	source_seen, palette_seen, mode_seen := false, false, false

	add_missing := proc(
		builder: ^strings.Builder,
		variant: string,
		source_seen, palette_seen, mode_seen: bool,
	) {
		if !source_seen do fmt.sbprintf(builder, "%s = \"%s\"\n", NOCTALIA_SOURCE_KEY, NOCTALIA_SOURCE)
		if !palette_seen do fmt.sbprintf(builder, "%s = \"%s\"\n", NOCTALIA_PALETTE_KEY, NOCTALIA_PALETTE)
		if !mode_seen do fmt.sbprintf(builder, "%s = \"%s\"\n", NOCTALIA_MODE_KEY, variant)
	}

	remaining := contents
	for line in strings.split_lines_after_iterator(&remaining) {
		trimmed := strings.trim_space(line)
		if trimmed == NOCTALIA_THEME_SECTION {
			if in_theme {
				add_missing(&builder, variant, source_seen, palette_seen, mode_seen)
			}
			in_theme, found_theme = true, true
			source_seen, palette_seen, mode_seen = false, false, false
			strings.write_string(&builder, line)
			continue
		}
		if in_theme && strings.has_prefix(trimmed, "[") {
			add_missing(&builder, variant, source_seen, palette_seen, mode_seen)
			in_theme = false
		}
		if in_theme && strings.has_prefix(trimmed, NOCTALIA_SOURCE_KEY) && strings.contains(trimmed, "=") {
			fmt.sbprintf(&builder, "%s = \"%s\"\n", NOCTALIA_SOURCE_KEY, NOCTALIA_SOURCE)
			source_seen = true
			continue
		}
		if in_theme && strings.has_prefix(trimmed, NOCTALIA_PALETTE_KEY) && strings.contains(trimmed, "=") {
			fmt.sbprintf(&builder, "%s = \"%s\"\n", NOCTALIA_PALETTE_KEY, NOCTALIA_PALETTE)
			palette_seen = true
			continue
		}
		if in_theme && strings.has_prefix(trimmed, NOCTALIA_MODE_KEY) && strings.contains(trimmed, "=") {
			fmt.sbprintf(&builder, "%s = \"%s\"\n", NOCTALIA_MODE_KEY, variant)
			mode_seen = true
			continue
		}
		strings.write_string(&builder, line)
	}
	if in_theme {
		add_missing(&builder, variant, source_seen, palette_seen, mode_seen)
	}
	if !found_theme {
		if len(contents) > 0 && !strings.has_suffix(contents, "\n") do strings.write_string(&builder, "\n")
		fmt.sbprintf(
			&builder,
			"\n%s\n%s = \"%s\"\n%s = \"%s\"\n%s = \"%s\"\n",
			NOCTALIA_THEME_SECTION,
			NOCTALIA_SOURCE_KEY, NOCTALIA_SOURCE,
			NOCTALIA_PALETTE_KEY, NOCTALIA_PALETTE,
			NOCTALIA_MODE_KEY, variant,
		)
	}
	return strings.to_string(builder)
}

persist_noctalia_theme :: proc(variant: string) -> bool {
	state_home := os.get_env("XDG_STATE_HOME", context.temp_allocator)
	if state_home == "" {
		home := os.get_env("HOME", context.temp_allocator)
		if home == "" do return false
		state_home = join([]string{home, ".local/state"})
	}
	settings := join([]string{state_home, NOCTALIA_SETTINGS_PATH})
	contents, read_err := os.read_entire_file(settings, context.allocator)
	if read_err == .Not_Exist do return true
	if read_err != nil do return false
	info, stat_err := os.stat(settings, context.allocator)
	if stat_err != nil do return false
	updated := update_noctalia_settings(string(contents), variant)
	directory, _ := filepath.split(settings)
	temporary, temp_err := os.create_temp_file(directory, ".settings.toml.*")
	if temp_err != nil do return false
	temporary_name := strings.clone(os.name(temporary))
	defer os.remove(temporary_name)
	if _, write_err := os.write(temporary, transmute([]byte)updated); write_err != nil {
		os.close(temporary)
		return false
	}
	if os.sync(temporary) != nil || os.close(temporary) != nil ||
	   os.chmod(temporary_name, info.mode) != nil ||
	   os.rename(temporary_name, settings) != nil {
		return false
	}
	return true
}

reload_ghostty_on_macos :: proc() {
	command := []string{
		"osascript",
		"-e", `if application "Ghostty" is running then`,
		"-e", `tell application "Ghostty"`,
		"-e", `repeat with t in terminals`,
		"-e", `perform action "reload_config" on t`,
		"-e", `end repeat`,
		"-e", `end tell`,
		"-e", `end if`,
	}
	if !run_quiet(command) {
		fail("Ghostty reload failed; check macOS Automation permission for Ghostty")
	}
}

reload_noctalia :: proc(variant: string) {
	if command_succeeds([]string{NOCTALIA_COMMAND, "msg", "status"}) {
		if !run_quiet([]string{NOCTALIA_COMMAND, "msg", "color-scheme-set", NOCTALIA_SOURCE, NOCTALIA_PALETTE}) {
			fail("Noctalia palette reload failed")
		}
		if !run_quiet([]string{NOCTALIA_COMMAND, "msg", "theme-mode-set", variant}) {
			fail("Noctalia theme mode reload failed")
		}
	} else if !persist_noctalia_theme(variant) {
		fail("could not persist the Noctalia theme selection")
	}
}

reload_niri :: proc(app: ^App) {
	niri_theme := join([]string{app.target_dir, NIRI_THEME_PATH})
	if !run_quiet([]string{CHEZMOI_COMMAND, "apply", "--force", "--parent-dirs", niri_theme}) {
		fail("could not restore the managed Niri theme")
	}
	if command_succeeds([]string{NIRI_COMMAND, "msg", "version"}) &&
	   !run_quiet([]string{NIRI_COMMAND, "msg", "action", "load-config-file"}) {
		fail("Niri theme reload failed")
	}
}

reload_ghostty_on_linux :: proc() {
	uid := fmt.aprintf("%d", os.get_uid())
	result := run_capture([]string{"pgrep", "-u", uid, "-x", "ghostty"})
	if !result.started || (result.exit_code != 0 && result.exit_code != 1) do return
	remaining := result.output
	for line in strings.split_lines_iterator(&remaining) {
		pid := strings.trim_space(line)
		if pid == "" do continue
		if !command_succeeds([]string{"kill", "-USR2", pid}) {
			proc_path := join([]string{"/proc", pid})
			if _, stat_err := os.stat(proc_path, context.temp_allocator); stat_err == nil {
				fail(fmt.aprintf("Ghostty reload failed for process %s", pid))
			}
		}
	}
}

reload_apps :: proc(app: ^App, theme: Theme) {
	switch app.platform {
	case DARWIN_PLATFORM:
		reload_ghostty_on_macos()
	case LINUX_PLATFORM:
		reload_noctalia(theme.variant)
		reload_niri(app)
		reload_ghostty_on_linux()
	}
}

switch_theme :: proc(app: ^App, theme_id: string) {
	theme, found := app.data.themes[theme_id]
	if !found {
		fail(fmt.aprintf("unknown theme: %s", theme_id))
	}
	save_theme(app, theme_id)
	apply_theme_files(app)
	reload_apps(app, theme)
}

main :: proc() {
	app := load_app()
	args := os.args[1:]
	if len(args) == 0 {
		selected, ok := choose_theme(&app)
		if ok do switch_theme(&app, selected)
		return
	}
	switch args[0] {
	case PREVIEW_OPTION:
		if len(args) != 2 do fail("usage: theme-switch --preview THEME_ID")
		preview_theme(&app, args[1])
	case CURRENT_OPTION:
		if len(args) != 1 do fail(USAGE)
		fmt.println(app.data.theme)
	case LIST_OPTION:
		if len(args) != 1 do fail(USAGE)
		list_themes(&app)
	case SET_OPTION:
		if len(args) != 2 do fail("usage: theme-switch --set THEME_ID")
		switch_theme(&app, args[1])
	case:
		fail(USAGE)
	}
}
