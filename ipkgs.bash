# Sourced by `ipkgs`, this provides helpers.

alias errcho='>&2 echo'

# verify it's bash version >= 4
# for associative arrays, in use by ipkgs
if [ ${BASH_VERSION%%[^0-9]*} -lt 4 ]; then
  errcho "Bash must be version 4 or greater."
  errcho "Currently it's: '${BASH_VERSION}'."
  exit 1
fi

usage() {
  echo "Usage: $(basename $0) [-d] [-p] file(s)"
}

options=()
arguments=() # these will become proper $items after items_init is called
items=() # NOTE: make it an associative array keyed by $item, to preserve state?
declare data # option to keep in mind for later use

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

if [ "${#arguments[@]}" -eq 0 ]; then
  usage >&2
  exit 1
fi

unset data paths

for option in "${options[@]}"; do
  case "$option" in
  "p" | "paths" )
    paths="1"
    ;;
  "d" | "data" )
    data="1"
    ;;
  * )
    usage >&2
    exit 1
    ;;
  esac
done

items_init() {
  # uses $paths (an option) and $arguments in order to initialize $items

  declare where # a path prefix
  if [ -n "$paths" ]; then
    # the --paths flag, meaning...
    # valid paths provided as part of the files - either relative or absolute
    where='' # no need to adjust location
  else
    # less typing - uses env var or the relative default
    where="${IPKGS_PATH:-$(realpath "$(dirname $0)/../install/packages")}/"
    [[ -n "$data" ]] || echo "# Using \$IPKGS_PATH = '$where'."
  fi

  # do glob expansion with correct paths
  shopt -s nullglob
  for item in "${arguments[@]}"; do
    path=${where}${item}
    items+=($path)
  done
}
