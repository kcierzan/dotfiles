GEOMETRY_PROMPT_TAG_SYMBOL=${GEOMETRY_TAG_SYMBOL:-""}
GEOMETRY_PROMPT_TAG_COLOR=${GEOMETRY_TAG_COLOR:-magenta}

geometry_prompt_tag_setup() {}

geometry_prompt_tag_check() {
  [ -d $PWD/.git ] || return 1
}

get_tags() {
  git describe --tags 2> /dev/null
}

geometry_prompt_tag_render() {
  local TAGS="$(get_tags)"
  if [[ -n "$TAGS" ]]; then
    echo -n ":: $(prompt_geometry_colorize $GEOMETRY_PROMPT_TAG_COLOR "${GEOMETRY_PROMPT_TAG_SYMBOL} ${TAGS}" )"
  fi
}

geometry_plugin_register tag
