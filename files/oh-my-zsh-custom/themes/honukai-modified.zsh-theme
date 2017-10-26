# Based on the great ys theme (http://ysmood.org/wp/2013/03/my-ys-terminal-theme/)

# Directory info.
local current_dir='${PWD/#$HOME/~}'

# VCS
YS_VCS_PROMPT_PREFIX1=" %{$fg[white]%}(%{$reset_color%}"
YS_VCS_PROMPT_PREFIX2="%{$fg[cyan]%}"
YS_VCS_PROMPT_SUFFIX="%{$fg[white]%})%{$reset_color%}"
YS_VCS_PROMPT_DIRTY=" %{$fg[red]%}✖︎"
YS_VCS_PROMPT_CLEAN=" %{$fg[green]%}●"

# Git info.
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

local ret_status="%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜)"

# Prompt format: \n # USER at MACHINE in DIRECTORY on git:BRANCH STATE [TIME] \n $
PROMPT="
%{$terminfo[bold]$fg[blue]%}${current_dir}%{$reset_color%}\
${git_info}
${ret_status}%{$reset_color%} "

