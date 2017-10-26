#!/usr/bin/env zsh

#
# BLOX - zsh theme
#
# Author: Yarden Sod-Moriah <yardnsm@gmail.com> (yardnsm.net)
# License: MIT
# Repository: https://github.com/yardnsm/blox-zsh-theme
#

# --------------------------------------------- #
# | Background jobs block options
# --------------------------------------------- #
BLOX_BLOCK__BGJOBS_SYMBOL="${BLOX_BLOCK__BGJOBS_SYMBOL:-}"
BLOX_BLOCK__BGJOBS_COLOR="${BLOX_BLOCK__BGJOBS_COLOR:-magenta}"

# --------------------------------------------- #
# | The block itself
# --------------------------------------------- #
function blox_block__bgjobs() {

  # The jobs
  bgjobs=$(jobs | wc -l | awk '{print $1}' 2> /dev/null)

  # The result
  res=""

  # Check if there any
  if [[ ! $bgjobs == "0" ]]; then
    res+="%{$fg[${BLOX_BLOCK__BGJOBS_COLOR}]%}"
    res+="${BLOX_CONF__BLOCK_PREFIX}${BLOX_BLOCK__BGJOBS_SYMBOL}${bgjobs}${BLOX_CONF__BLOCK_SUFFIX}";
    res+="%{$reset_color%}"
  fi

  # Echo the block
  echo $res
}
# --------------------------------------------- #
# | CWD block options
# --------------------------------------------- #
BLOX_BLOCK__CWD_COLOR="${BLOX_BLOCK__CWD_COLOR:-blue}"
BLOX_BLOCK__CWD_TRUNC="${BLOX_BLOCK__CWD_TRUNC:-0}"

# --------------------------------------------- #
# | The block itself
# --------------------------------------------- #
function blox_block__cwd() {

  # Final result
  res=""

  # Append those
  res+="%{$fg_bold[${BLOX_BLOCK__CWD_COLOR}]%}"
  res+="%${BLOX_BLOCK__CWD_TRUNC}~";
  res+="%{$reset_color%}"

  # Echo result
  echo $res
}
# --------------------------------------------- #
# | Git block options
# --------------------------------------------- #

# Clean
BLOX_BLOCK__GIT_CLEAN_COLOR="${BLOX_BLOCK__GIT_CLEAN_COLOR:-green}"
BLOX_BLOCK__GIT_CLEAN_SYMBOL="${BLOX_BLOCK__GIT_CLEAN_SYMBOL:-✔︎%{ %}}"

# Dirty
BLOX_BLOCK__GIT_DIRTY_COLOR="${BLOX_BLOCK__GIT_DIRTY_COLOR:-red}"
BLOX_BLOCK__GIT_DIRTY_SYMBOL="${BLOX_BLOCK__GIT_DIRTY_SYMBOL:-✘}"

# Unpulled
BLOX_BLOCK__GIT_UNPULLED_COLOR="${BLOX_BLOCK__GIT_UNPULLED_COLOR:-red}"
BLOX_BLOCK__GIT_UNPULLED_SYMBOL="${BLOX_BLOCK__GIT_UNPULLED_SYMBOL:-⇣}"

# Unpushed
BLOX_BLOCK__GIT_UNPUSHED_COLOR="${BLOX_BLOCK__GIT_UNPUSHED_COLOR:-blue}"
BLOX_BLOCK__GIT_UNPUSHED_SYMBOL="${BLOX_BLOCK__GIT_UNPUSHED_SYMBOL:-⇡}"

# --------------------------------------------- #
# | Themes
# --------------------------------------------- #
BLOX_BLOCK__GIT_THEME_CLEAN="%{$fg[${BLOX_BLOCK__GIT_CLEAN_COLOR}]%}$BLOX_BLOCK__GIT_CLEAN_SYMBOL%{$reset_color%}"
BLOX_BLOCK__GIT_THEME_DIRTY="%{$fg[${BLOX_BLOCK__GIT_DIRTY_COLOR}]%}$BLOX_BLOCK__GIT_DIRTY_SYMBOL%{$reset_color%}"
BLOX_BLOCK__GIT_THEME_UNPULLED="%{$fg[${BLOX_BLOCK__GIT_UNPULLED_COLOR}]%}$BLOX_BLOCK__GIT_UNPULLED_SYMBOL%{$reset_color%}"
BLOX_BLOCK__GIT_THEME_UNPUSHED="%{$fg[${BLOX_BLOCK__GIT_UNPUSHED_COLOR}]%}$BLOX_BLOCK__GIT_UNPUSHED_SYMBOL%{$reset_color%}"

# --------------------------------------------- #
# | Helper functions
# --------------------------------------------- #

# Get commit hash (short)
function blox_block__git_helper__commit() {
  echo $(command git rev-parse --short HEAD  2> /dev/null)
}

# Get the current branch
function blox_block__git_helper__branch() {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
  echo "${ref#refs/heads/}";
}

# Echo the appropriate symbol for branch's status
blox_block__git_helper__status() {

  if [[ -z "$(git status --porcelain --ignore-submodules)" ]]; then

    # Clean
    echo $BLOX_BLOCK__GIT_THEME_CLEAN
  else

    # Dirty
    echo $BLOX_BLOCK__GIT_THEME_DIRTY
  fi
}

# Echo the appropriate symbol for branch's remote status (pull/push)
# Need to do 'git fetch' before
function blox_block__git_helper__remote_status() {

  local git_local=$(command git rev-parse @ 2> /dev/null)
  local git_remote=$(command git rev-parse @{u} 2> /dev/null)
  local git_base=$(command git merge-base @ @{u} 2> /dev/null)

  # First check that we have a remote
  if ! [[ ${git_remote} = "" ]]; then

    # Now do all that shit
    if [[ ${git_local} = ${git_remote} ]]; then
      echo ""
    elif [[ ${git_local} = ${git_base} ]]; then
      echo " $BLOX_BLOCK__GIT_THEME_UNPULLED"
    elif [[ ${git_remote} = ${git_base} ]]; then
      echo " $BLOX_BLOCK__GIT_THEME_UNPUSHED"
    else
      echo " $BLOX_BLOCK__GIT_THEME_UNPULLED $BLOX_BLOCK__GIT_THEME_UNPUSHED"
    fi
  fi
}

# Checks if cwd is a git repo
function blox_block__git_helper__is_git_repo() {
  return $(git rev-parse --git-dir > /dev/null 2>&1)
}

# --------------------------------------------- #
# | The block itself
# --------------------------------------------- #
function blox_block__git() {

  if blox_block__git_helper__is_git_repo; then

    local branch="%{$fg[magenta]%}[$(blox_block__git_helper__branch)]%{$reset_color%}"
    local remote="$(blox_block__git_helper__remote_status)"
    local b_status="$(blox_block__git_helper__status)"

	  echo "${branch} ${b_status}${remote}"
  fi
}
# --------------------------------------------- #
# | Host info block options
# --------------------------------------------- #

# User
BLOX_BLOCK__HOST_USER_DEFAULT_USER="${BLOX_BLOCK__HOST_USER_DEFAULT_USER:-gustav}"
BLOX_BLOCK__HOST_USER_SHOW_ALWAYS="${BLOX_BLOCK__HOST_USER_SHOW_ALWAYS:-false}"
BLOX_BLOCK__HOST_USER_COLOR="${BLOX_BLOCK__HOST_USER_COLOR:-yellow}"
BLOX_BLOCK__HOST_USER_ROOT_COLOR="${BLOX_BLOCK__HOST_USER_ROOT_COLOR:-red}"

# Machine
BLOX_BLOCK__HOST_MACHINE_SHOW_ALWAYS="${BLOX_BLOCK__HOST_MACHINE_SHOW_ALWAYS:-false}"
BLOX_BLOCK__HOST_MACHINE_COLOR="${BLOX_BLOCK__HOST_MACHINE_COLOR:-cyan}"

# --------------------------------------------- #
# | The block itself
# --------------------------------------------- #
function blox_block__host() {

  # The user's color
  USER_COLOR=$BLOX_BLOCK__HOST_USER_COLOR

  # Make the color red if the current user is root
  [[ $USER == "root" ]] && USER_COLOR=$BLOX_BLOCK__HOST_USER_ROOT_COLOR

  # The info
  info=""

  # Check if the user info is needed
  if [[ $BLOX_BLOCK__HOST_USER_SHOW_ALWAYS == true ]] || [[ $BLOX_BLOCK__HOST_USER_DEFAULT_USER != $USER ]]; then
    info+="%{$fg[$USER_COLOR]%}%n%{$reset_color%}"
  fi

  # Check if the machine name is needed
  if [[ $BLOX_BLOCK__HOST_MACHINE_SHOW_ALWAYS == true ]] || [[ -n $SSH_CONNECTION ]]; then
    [[ $info != "" ]] && info+="@"
    info+="%{$fg[${BLOX_BLOCK__HOST_MACHINE_COLOR}]%}%m%{$reset_color%}"
  fi

  # Echo the info in need
  if [[ $info != "" ]]; then
    echo "$info:"
  fi
}
# --------------------------------------------- #
# | NodeJS block options
# --------------------------------------------- #
BLOX_BLOCK__NODEJS_SYMBOL="${BLOX_BLOCK__NODEJS_SYMBOL:-⬢}"
BLOX_BLOCK__NODEJS_COLOR="${BLOX_BLOCK__NODEJS_COLOR:-green}"

# --------------------------------------------- #
# | The block itself
# --------------------------------------------- #
function blox_block__nodejs() {

  [[ ! -f "$(pwd)/package.json" ]] && return
  local node_version=$(node -v 2>/dev/null)

  # The result
  res=""

  # Build the block
  if [[ ! -z "${node_version}" ]]; then
    res+="%{$fg[${BLOX_BLOCK__NODEJS_COLOR}]%}"
    res+="${BLOX_CONF__BLOCK_PREFIX}${BLOX_BLOCK__NODEJS_SYMBOL} ${node_version:1}${BLOX_CONF__BLOCK_SUFFIX}"
    res+="%{$reset_color%}"
  fi

  # Echo the block
  echo $res
}
# --------------------------------------------- #
# | Symbol block options
# --------------------------------------------- #

# Colors
BLOX_BLOCK__SYMBOL_COLOR="${BLOX_BLOCK__SYMBOL_COLOR:-cyan}"
BLOX_BLOCK__SYMBOL_EXIT_COLOR="${BLOX_BLOCK__SYMBOL_EXIT_COLOR:-red}"

# Symbols
BLOX_BLOCK__SYMBOL_SYMBOL="${BLOX_BLOCK__SYMBOL_SYMBOL:-❯}"
BLOX_BLOCK__SYMBOL_EXIT_SYMBOL="${BLOX_BLOCK__SYMBOL_EXIT_SYMBOL:-$BLOX_BLOCK__SYMBOL_SYMBOL}"
BLOX_BLOCK__SYMBOL_ALTERNATE="${BLOX_BLOCK__SYMBOL_ALTERNATE:-|}"

# --------------------------------------------- #
# | The block itself
# --------------------------------------------- #
function blox_block__symbol() {

  # Final result
  res=""

  # Append those
  res+="%{$fg[${BLOX_BLOCK__SYMBOL_COLOR}]%}"
  res+="%(?.$BLOX_BLOCK__SYMBOL_SYMBOL.%{$fg[$BLOX_BLOCK__SYMBOL_EXIT_COLOR]%}$BLOX_BLOCK__SYMBOL_EXIT_SYMBOL)";
  res+="%{$reset_color%}"

  # Echo the result
  echo $res
}
# --------------------------------------------- #
# | Time block
# --------------------------------------------- #
function blox_block__time() {
  echo "${BLOX_CONF__BLOCK_PREFIX}%T${BLOX_CONF__BLOCK_SUFFIX}"
}
# --------------------------------------------- #
# | Initialize stuff
# --------------------------------------------- #

# Enable command substitution in prompt
setopt prompt_subst

# Initialize prompt
autoload -Uz promptinit && promptinit

# Initialize colors
autoload -Uz colors && colors

# Hooks
autoload -U add-zsh-hook

# --------------------------------------------- #
# | Core options
# --------------------------------------------- #
BLOX_CONF__BLOCK_PREFIX="${BLOX_CONF__BLOCK_PREFIX:-[}"
BLOX_CONF__BLOCK_SUFFIX="${BLOX_CONF__BLOCK_SUFFIX:-]}"
BLOX_CONF__ONELINE="${BLOX_CONF__ONELINE:-false}"
BLOX_CONF__NEWLINE="${BLOX_CONF__NEWLINE:-true}"

# --------------------------------------------- #
# | Some charcters
# --------------------------------------------- #
BLOX_CHAR__SPACE=" "
BLOX_CHAR__NEWLINE="
"

# --------------------------------------------- #
# | Segments
# --------------------------------------------- #

# Defualts
BLOX_SEG_DEFAULT__UPPER_LEFT=(blox_block__host blox_block__cwd blox_block__git blox_block__bgjobs blox_block__nodejs)
BLOX_SEG_DEFAULT__UPPER_RIGHT=()
BLOX_SEG_DEFAULT__LOWER_LEFT=(blox_block__symbol)
BLOX_SEG_DEFAULT__LOWER_RIGHT=()

# Upper
BLOX_SEG__UPPER_LEFT=${BLOX_SEG__UPPER_LEFT:-$BLOX_SEG_DEFAULT__UPPER_LEFT}
BLOX_SEG__UPPER_RIGHT=${BLOX_SEG__UPPER_RIGHT:-$BLOX_SEG_DEFAULT__UPPER_RIGHT}

# Lower
BLOX_SEG__LOWER_LEFT=${BLOX_SEG__LOWER_LEFT:-$BLOX_SEG_DEFAULT__LOWER_LEFT}
BLOX_SEG__LOWER_RIGHT=${BLOX_SEG__LOWER_RIGHT:-$BLOX_SEG_DEFAULT__LOWER_RIGHT}

# --------------------------------------------- #
# | Helper functions
# --------------------------------------------- #

# Build a given segment
function blox_helper__build_segment() {

  # The segment to build
  segment=(`echo $@`)

  # The final segment
  res=""

  # Loop on each block
  for block in ${segment[@]}; do

    # Get the block data
    blockData="$($block)"

    # Append to result
    [[ $blockData != "" ]] && [[ -n $blockData ]] && res+=" $blockData"
  done

  # Echo the result
  echo $res
}

# Calculate how many spaces we need to put
# between two strings
function blox_helper__calculate_spaces() {

  # The segments
  left=$1
  right=$2

  # The filter (to ignore ansi escapes)
  local zero='%([BSUbfksu]|([FBK]|){*})'

  # Filtering
  left=${#${(S%%)left//$~zero/}}
  right=${#${(S%%)right//$~zero/}}

  # Desired spaces length
  local termwidth
  (( termwidth = ${COLUMNS} - ${left} - ${right} ))

  # Calculate spaces
  local spacing=""
  for i in {1..$termwidth}; do
    spacing="${spacing} "
  done

  # Echo'em
  echo $spacing
}

# --------------------------------------------- #
# | Hooks
# --------------------------------------------- #

# Set the title
function blox_hook__title() {

  # Show working directory in the title
  tab_label=${PWD/${HOME}/\~}
  echo -ne "\e]2;${tab_label}\a"
}

# Build the prompt
function blox_hook__build_prompt() {

  # Show working directory in the title
  tab_label=${PWD/${HOME}/\~}
  echo -ne "\e]2;${tab_label}\a"

  # The prompt consists of two part: PROMPT
  # and RPROMPT. In multiline prompt, RPROMPT goes
  # to the lower line. To solve this, we need to do stupid stuff.

  # Segments
  upper_left="$(blox_helper__build_segment $BLOX_SEG__UPPER_LEFT)"
  upper_right="$(blox_helper__build_segment $BLOX_SEG__UPPER_RIGHT) "
  lower_left="$(blox_helper__build_segment $BLOX_SEG__LOWER_LEFT)"
  lower_right="$(blox_helper__build_segment $BLOX_SEG__LOWER_RIGHT) "

  # Spacessss
  spacing="$(blox_helper__calculate_spaces ${upper_left} ${upper_right})"

  # Check if a newline char is needed
  [[ $BLOX_CONF__NEWLINE == false ]] && BLOX_CHAR__NEWLINE=""

  # In oneline mode, we set $PROMPT to the
  # upper left segment and $RPROMPT to the upper
  # right. In multiline mode, $RPROMPT goes to the bottom
  # line so we set the first line of $PROMPT to the upper segments
  # while the second line to only the the lower left. Then,
  # $RPROMPT is set to the lower right segment.

  # Check if in oneline mode
  if [[ $BLOX_CONF__ONELINE == true ]]; then

    # Setting only the upper segments
    PROMPT='${BLOX_CHAR__NEWLINE}${upper_left} '

    # Right segment
    RPROMPT='${upper_right}'
  else

    # The prompt
    PROMPT='${BLOX_CHAR__NEWLINE}${upper_left}${spacing}${upper_right}
${lower_left} '

    # Right prompt
    RPROMPT='${lower_right}'
  fi

  # PROMPT2 (continuation interactive prompt)
  PROMPT2=' ${BLOX_BLOCK__SYMBOL_ALTERNATE} %_'
}

# --------------------------------------------- #
# | Setup hooks
# --------------------------------------------- #

# Build the prompt
add-zsh-hook precmd blox_hook__build_prompt

# Set title
add-zsh-hook precmd blox_hook__title
