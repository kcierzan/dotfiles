package main

import "core:strings"
import "core:testing"

@(test)
replace_theme_line_test :: proc(t: ^testing.T) {
	input := "# Global theme selector\ntheme: old-theme\n"
	actual, found := replace_theme_line(input, "new-theme")
	defer delete(actual)
	testing.expect(t, found)
	testing.expect_value(t, actual, "# Global theme selector\ntheme: new-theme\n")
}

@(test)
replace_theme_line_missing_test :: proc(t: ^testing.T) {
	actual, found := replace_theme_line("other: value\n", "new-theme")
	defer delete(actual)
	testing.expect(t, !found)
	testing.expect_value(t, actual, "other: value\n")
}

@(test)
update_existing_noctalia_theme_test :: proc(t: ^testing.T) {
	input := "[general]\nfoo = true\n\n[theme]\nsource = \"system\"\nmode = \"light\"\n\n[other]\nbar = true\n"
	actual := update_noctalia_settings(input, "dark")
	defer delete(actual)
	testing.expect(t, strings.contains(actual, "source = \"custom\"\n"))
	testing.expect(t, strings.contains(actual, "custom_palette = \"Base16\"\n"))
	testing.expect(t, strings.contains(actual, "mode = \"dark\"\n"))
	testing.expect(t, strings.contains(actual, "[other]\nbar = true\n"))
}

@(test)
append_missing_noctalia_theme_test :: proc(t: ^testing.T) {
	actual := update_noctalia_settings("[general]\nfoo = true\n", "light")
	defer delete(actual)
	expected := "\n[theme]\nsource = \"custom\"\ncustom_palette = \"Base16\"\nmode = \"light\"\n"
	testing.expect(t, strings.has_suffix(actual, expected))
}

@(test)
parse_non_current_picker_row_test :: proc(t: ^testing.T) {
	id, ok := theme_id_from_picker_output(" \tdoom-one\tDoom One (dark)\n")
	testing.expect(t, ok)
	testing.expect_value(t, id, "doom-one")
}

@(test)
parse_current_picker_row_test :: proc(t: ^testing.T) {
	id, ok := theme_id_from_picker_output("●\tbreakers\tBreakers (light)\n")
	testing.expect(t, ok)
	testing.expect_value(t, id, "breakers")
}
