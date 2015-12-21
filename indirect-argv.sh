# Sourced by `indirect`, this provides helpers.

indirect_usage() {
  echo "Usage: $(basename $0) [-d] [-p] file(s)"
}

indirect_help() {
  echo
  indirect_usage
  echo
  echo "  <file(s)> can be globs / paths:"
  echo "  relative to a configured \$INDIRECT_PACKAGES location or"
  echo "  a packages symbolic link in your installation directory."
  echo "  Or else, one can use any paths with the --path option..."
  echo
  echo "  -d, --data     Get CSV data rather than installation scripts"
  echo "  -p, --path     Provide real paths, skip convenient shortcuts"
  echo "  -h, --help     Display this help"
  echo
  echo "  For more information, see https://github.com/orlin/indirect"
  echo
}

indirect_items() {
  # NOTE: counts on `items=()` in an outer scope
  options=()
  arguments=() # these will become proper $items

  for arg in "$@"; do
    if [ "${arg:0:1}" = "-" ]; then
      if [ "${arg:1:1}" = "-" ]; then
        options[${#options[*]}]="${arg:2}"
      else
        index=1
        while option="${arg:$index:1}"; do
          [ -n "$option" ] || break
          options[${#options[*]}]="$option"
          let index+=1
        done
      fi
    else
      arguments[${#arguments[*]}]="$arg"
    fi
  done

  # the options below could be declared / used from an outer scope
  unset data paths

  for option in "${options[@]}"; do
    case "$option" in
    "h" | "help" )
      indirect_help
      exit 0
      ;;
    "p" | "paths" )
      paths="1"
      ;;
    "d" | "data" )
      data="1"
      ;;
    * )
      indirect_usage >&2
      exit 1
      ;;
    esac
  done

  if [ "${#arguments[@]}" -eq 0 ]; then
    indirect_usage >&2
    exit 1
  fi

  declare where # a path prefix
  if [ -n "$paths" ]; then
    # the --paths flag, meaning...
    # valid paths provided as part of the files - either relative or absolute
    where='' # no need to adjust location
  else
    # less typing - uses env var or the relative default
    where="${INDIRECT_PACKAGES:-$(realpath "$(realpath "$0" | xargs dirname)/packages")}/"
    [[ -n "$data" ]] || echo "# Using \$INDIRECT_PACKAGES = '$where'."
  fi

  # do glob expansion with correct paths
  shopt -s nullglob
  for item in "${arguments[@]}"; do
    path=${where}${item}
    items+=($path)
  done
}
