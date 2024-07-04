function my_git_prompt() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return

  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  # is branch ahead?
  BRANCH=origin
  # if upstream exist, track upstream
  if [[ $(git remote -v | grep -w upstream 2> /dev/null) ]]; then
      BRANCH="upstream"
  fi
  if $(echo "$(git log $BRANCH/$(git_current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
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

function virtual_env() {
  if [ -z ${VIRTUAL_ENV+x} ]; then
    echo ""
  else echo "${bold_green}($(basename $VIRTUAL_ENV))${normal} ";
  fi
}

function container_env() {
  if [ -z ${container+x} ]; then
    echo ""
  else echo "${bold_blue}[$container]${normal} ";
  fi
}

function working_dir() {

MPATH=$PWD

if [[ -z "${PWD//*\/home\/*/}" ]]; then

    MPATH=${MPATH/${HOME}/\~}

    if [ "${PWD}" == "~" ]; then
        MPATH="~"
    elif [ "${PWD}" == "${HOME}" ]; then
        MPATH="~"
    else
        MDIR="${MPATH##*/}"
        MPARENT=$(dirname $PWD)
        # reduce path to initials
        MALLPARENTS=$(echo "${MPATH%/*}" | grep -oP '\/.' | tr -d '\n' )/

        # if more than 2 folders deep from home
        if [[ ${MPARENT} != ${HOME} ]]; then

            MPARENT="${MPARENT##*/}/"
            # remove last folder
            MALLPARENTS=${MALLPARENTS::-2}
        else
            MPARENT=""
        fi
        MPATH=\~${MALLPARENTS}${MPARENT}${MDIR}
    fi
fi

echo $MPATH

}

PROMPT_RETURNCODE_PREFIX="${bold_red}"
GIT_PROMPT_PREFIX=": ${white}‹ ${bold_yellow}"
GIT_PROMPT_AHEAD="${bold_magenta}↑"
GIT_PROMPT_STAGED="${bold_green}●"
GIT_PROMPT_UNSTAGED="${bold_red}●"
GIT_PROMPT_UNTRACKED="${bold_white}●"
GIT_PROMPT_UNMERGED="${bold_red}✕"
GIT_PROMPT_SUFFIX=" ${bold_white}›${normal} "


function prompt_command(){
  local status=$?
  if [ $status -ne 0 ]
  then
    ret_status="${bold_red}$status${normal}"
  else
    ret_status="${bold_green}🦆${normal}"
  fi

  export PS1="${ret_status} ${normal}$(my_git_prompt)$(container_env)$(virtual_env)$(ssh_connection)\n${normal}${bold_green}$USER@$HOSTNAME:${bold_blue}$(working_dir)${normal}\$ "
}

safe_append_prompt_command prompt_command
