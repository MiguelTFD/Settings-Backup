#!/usr/bin/env bash

# Copyright (C) 2016-present Arctic Ice Studio <development@arcticicestudio.com>
# Copyright (C) 2016-present Sven Greb <development@svengreb.de>

# Project:    igloo
# Repository: https://github.com/arcticicestudio/igloo
# License:    MIT
# References:
#   http://stackoverflow.com/questions/19092488/custom-bash-prompt-is-overwriting-itself/19501525#19501528
#   http://mywiki.wooledge.org/BashFAQ/053

# +-----------------+
# + Git Integration +
# +-----------------+
# +--- Dirty State ---+
# Show unstaged (*) and staged (+) changes.
# Also configurable per repository via "bash.showDirtyState".
GIT_PS1_SHOWDIRTYSTATE=true

# +--- Stash State ---+
# Show currently stashed ($) changes.
GIT_PS1_SHOWSTASHSTATE=false

# +--- Untracked Files ---+
# Show untracked (%) changes.
# Also configurable per repository via "bash.showUntrackedFiles".
GIT_PS1_SHOWUNTRACKEDFILES=true

# +--- Upstream Difference ---+
# Show indicator for difference between HEAD and its upstream.
#
# <  Behind upstream
# >  Ahead upstream
# <> Diverged upstream
# =  Equal upstream
#
# Control behaviour by setting to a space-separated list of values:
#   auto     Automatically show indicators
#   verbose  Show number of commits ahead/behind (+/-) upstream
#   name     If verbose, then also show the upstream abbrev name
#   legacy   Do not use the '--count' option available in recent versions of git-rev-list
#   git      Always compare HEAD to @{upstream}
#   svn      Always compare HEAD to your SVN upstream
#
# By default, __git_ps1 will compare HEAD to SVN upstream ('@{upstream}' if not available).
# Also configurable per repository via "bash.showUpstream".
GIT_PS1_SHOWUPSTREAM="auto verbose name"

# +--- Describe Style ---+
# Show more information about the identity of commits checked out as a detached HEAD.
#
# Control behaviour by setting to one of these values:
#   contains  Relative to newer annotated tag (v1.6.3.2~35)
#   branch    Relative to newer tag or branch (master~4)
#   describe  Relative to older annotated tag (v1.6.3.1-13-gdd42c2f)
#   default   Exactly matching tag
GIT_PS1_DESCRIBE_STYLE="contains"

# +--- Colored Hints ---+
# Show colored hints about the current dirty state. The colors are based on the colored output of "git status -sb".
# NOTE: Only available when using __git_ps1 for PROMPT_COMMAND!
GIT_PS1_SHOWCOLORHINTS=true

# +--- pwd Ignore ---+
# Disable __git_ps1 output when the current directory is set up to be ignored by git.
# Also configurable per repository via "bash.hideIfPwdIgnored".
GIT_PS1_HIDE_IF_PWD_IGNORED=false

compile_prompt () {
  local EXIT=$?
  local CONNECTBAR_DOWN=$'\u250C\u2500\u257C'
  local CONNECTBAR_UP=$'\u2514\u2500\u257C'
  local GITSPLITBAR=$'\u2570\u257C'
  local SPLITBAR=$'\u257E\u2500\u257C'
  local ARROW=$'\u25B6'
  local c_gray='\e[01;30m'
  local c_blue='\e[0;34m'
  local c_cyan='\e[0;36m'
  local c_reset='\e[0m'
  local c_red='\e[0;31m'  # Nuevo color rojo para errores
  
   # Cambio de color solo si el código de salida está entre 127 y 255
  if (( EXIT >= 127 && EXIT <= 255 )); then
    EXIT="${c_red}${EXIT}${c_gray}"  # Aplicar color rojo
  else
    EXIT="${c_blue}${EXIT}${c_gray}"  # Mantener color azul para otros números
  fi
  
  # > Connectbar Down
  # Format:
  #   (newline)(bright colors)(connectbar down)
  PS1="\n${c_gray}"
  PS1+="$CONNECTBAR_DOWN"

  # > Username
  # Format:
  #   (bracket open)(username)(bracket close)(splitbar)
  PS1+="[${c_blue}\u${c_gray}]"
  PS1+="$SPLITBAR"

  # > Jobs
  # Format:
  #   (bracket open)(jobs)(bracket close)(splitbar)
  PS1+="[${c_blue}\j${c_gray}]"

  # > Exit Status
  # Format:
  #   (bracket open)(last exit status)(bracket close)(splitbar)
  PS1+="[${c_blue}${EXIT}${c_gray}]"
  PS1+="$SPLITBAR"

  # > Time
  # Format:
  #   (bracket open)(time)(bracket close)(newline)(connectbar up)
  PS1+="[${c_blue}\D{%H:%M:%S}${c_gray}]\n"
  PS1+="$CONNECTBAR_UP"

  # > Working Directory
  # Format:
  #   (bracket open)(working directory)(bracket close)(newline)
  PS1+="[${c_blue}\w${c_gray}]\n"

  # > Git
  # Format:
  #   (gitsplitbar)(bracket open)(git branch)(bracket close)(splitbar)
  #   (bracket open)(HEAD-SHA)(bracket close)
  PS1+="$(__git_ps1 " \\u2570\\u257C[${c_cyan}%s${c_gray}]\\u257E\\u2500\\u257C[${c_cyan}$(git rev-parse --short HEAD 2> /dev/null)${c_gray}]")"
  # Append additional newline if in git repository
  if [[ ! -z $(__git_ps1) ]]; then
    PS1+='\n'
  fi

  # > Arrow
  # NOTE: Color must be escaped with '\[\]' to fix the text overflow bug!
  # Format:
  #   (arrow)(color reset)
  PS1+="$ARROW \[\e[0m\]"
}

#=========Aliases=========
alias ct='clear'
alias jc11='source jc 11'
alias jc8='source jc 8'
alias jc17='source jc 17'
alias x='exit'


#-------------------------
set -o vi


PROMPT_COMMAND='compile_prompt'
source /usr/share/bash-completion/bash_completion
 # Establecer Java 17 como predeterminado al iniciar una nueva sesión de terminal
 #
jc17
ct
