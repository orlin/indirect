#!/usr/bin/env bash

# Prints scripts to install packages, given file[path](s), including glob(s).
# It can also (i.e. instead) produce CSV of: manager, package.

errcho() { >&2 echo "$1"; }

# verify it's bash version >= 4
# for associative arrays, used further down
if [ ${BASH_VERSION%%[^0-9]*} -lt 4 ]; then
  errcho "Bash must be version 4 or greater."
  errcho "Currently it's: '${BASH_VERSION}'."
  exit 1
fi

function indirect() {
  somewhere=$(realpath "$0" | xargs dirname) # it could be a symlink
  source ${somewhere}/indirect-argv.sh # options, arguments, helpers
  items_init
  source ${somewhere}/indirect-vars.sh # expected below
  system=`uname -s`

  # for each file path...
  for path in "${items[@]}"; do
    id=$(basename "$path") # NOTE: maybe rename to $file to avoid ambiguity
    # it seems like * glob-expands in a sed regexp a set -f prevents that
    pm=$(set -f && echo $id | sed s/-.*//) # package manager default
    [[ ${special[$id]+_} ]] && pm=${special[$id]}

    # NOTE: if you swap $pm and $cmd the naming would become clearer
    cmd=$(echo $pm | awk '{print $1;}') # so far due to brew cask

    # make sure the filename / $id passes syscheck - if in whitelist
    [[ ${syscheck[$id]+_} && $system != ${syscheck[$id]} ]] && {
      errcho
      errcho "Skipping \`$id\` - not for this '$system' OS, see syscheck rules."
      continue
    }

    # check the $cmd is installed
    hash $cmd 2>/dev/null || {
      errcho
      errcho "Skipping '$id' because \`$cmd\` not in \$PATH."
      continue
    }

    # output depends on the data option
    if [ -n "$data" ]; then
      # data means csv (pm, pkg) - NOTE the "brew cask" $pm special case
      sed -f ${somewhere}/indirect-keys.sed $path | xargs -n 1 echo "$pm,"
    else
      command="$pm install"
      [[ ${install[$pm]+_} ]] && command=${install[$pm]}

      echo
      echo "# Installing '$id' packages with \`$command\`..."

      # obtain the package names to install one at a time (produces a script)
      sed -f ${somewhere}/indirect-keys.sed $path | xargs -n 1 echo $command
    fi
  done
}

# a best practice, taken from https://github.com/bpkg/bpkg#package-exports
if [[ ${BASH_SOURCE[0]} != $0 ]]; then
  export -f indirect
else
  indirect "${@}"
  exit 0
fi
