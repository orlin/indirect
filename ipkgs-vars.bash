# Sourced by `ipkgs`, this sets up the expected variables.

# some commands can only run on certain operating systems
# these are confirmed by filename
declare -A syscheck=(
  ["apm-darwin"]="Darwin"
  ["apt"]="Linux" # could check for ubuntu or debian, yet presence is enough
  ["brew"]="Darwin"
  ["brew-cask"]="Darwin"
)

# special cases when command isn't the filename
# if a file isn't in this list, the $command is taken up until the first dash
declare -A special=(
  ["apt"]="apt-get"
  ["apt-get"]="apt-get" # just for example, or the '-get' would get truncated
  ["brew-cask"]="brew cask"
)

# it's `$pm install $package` - except for the following special cases
declare -A install=(
  ["npm"]="npm i -g"
)
