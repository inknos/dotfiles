function my_git_prompt() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return

  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  # is branch ahead?
  if $(echo "$(git log origin/$(git_current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$GIT_PROMPT_AHEAD"
  fi

# is anything staged?
  if $(echo "$INDEX" | command grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$GIT_PROMPT_STAGED"
  fi

# is anything unstaged?
if $(echo "$INDEX" | command grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS$GIT_PROMPT_UNSTAGED"
fi

  # is anything untracked?
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS$GIT_PROMPT_UNTRACKED"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | command grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS$GIT_PROMPT_UNMERGED"
  fi

  if [[ -n $STATUS ]]; then
    STATUS=" $STATUS"
  fi

  echo "$GIT_PROMPT_PREFIX$(my_current_branch)$STATUS$GIT_PROMPT_SUFFIX"
}

function my_current_branch() {
  echo $(git_current_branch || echo "(no branch)")
}

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "${bold_red}(ssh) "
  fi
}

PROMPT_RETURNCODE_PREFIX="${bold_red}"
GIT_PROMPT_PREFIX=" ${white}‹ ${bold_yellow}"
GIT_PROMPT_AHEAD="${bold_magenta}↑"
GIT_PROMPT_STAGED="${bold_green}●"
GIT_PROMPT_UNSTAGED="${bold_red}●"
GIT_PROMPT_UNTRACKED="${bold_white}●"
GIT_PROMPT_UNMERGED="${bold_red}✕"
GIT_PROMPT_SUFFIX=" ${bold_white}›${normal}"


function prompt_command(){
  local status=$?
  if [ $status -ne 0 ]
  then
    ret_status="${bold_red}$status${normal}"
  else
    ret_status="${bold_green}$status${normal}"
  fi
  export PS1="\n$(ssh_connection)${bold_cyan}$USER${normal}$(my_git_prompt)${bold_green} : ${bold_blue}$(dirs)\n${normal}[${ret_status}] ${bold_yellow}\$${normal} "
}

safe_append_prompt_command prompt_command
function my_git_prompt() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return

  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  # is branch ahead?
  if $(echo "$(git log origin/$(git_current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$GIT_PROMPT_AHEAD"
  fi

# is anything staged?
  if $(echo "$INDEX" | command grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$GIT_PROMPT_STAGED"
  fi

# is anything unstaged?
if $(echo "$INDEX" | command grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS$GIT_PROMPT_UNSTAGED"
fi

  # is anything untracked?
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS$GIT_PROMPT_UNTRACKED"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | command grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS$GIT_PROMPT_UNMERGED"
  fi

  if [[ -n $STATUS ]]; then
    STATUS=" $STATUS"
  fi

  echo "$GIT_PROMPT_PREFIX$(my_current_branch)$STATUS$GIT_PROMPT_SUFFIX"
}

function my_current_branch() {
  echo $(git_current_branch || echo "(no branch)")
}

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "${bold_red}(ssh) "
  fi
}

PROMPT_RETURNCODE_PREFIX="${bold_red}"
GIT_PROMPT_PREFIX=" ${white}‹ ${bold_yellow}"
GIT_PROMPT_AHEAD="${bold_magenta}↑"
GIT_PROMPT_STAGED="${bold_green}●"
GIT_PROMPT_UNSTAGED="${bold_red}●"
GIT_PROMPT_UNTRACKED="${bold_white}●"
GIT_PROMPT_UNMERGED="${bold_red}✕"
GIT_PROMPT_SUFFIX=" ${bold_white}›${normal}"


function prompt_command(){
  local status=$?
  if [ $status -ne 0 ]
  then
    ret_status="${bold_red}$status${normal}"
  else
    ret_status="${bold_green}$status${normal}"
  fi
  export PS1="\n$(ssh_connection)${bold_red}$USER${normal}$(my_git_prompt)${bold_green} : ${bold_blue}$(dirs)\n${normal}[${ret_status}] ${bold_yellow}#${normal} "
}

safe_append_prompt_command prompt_command
