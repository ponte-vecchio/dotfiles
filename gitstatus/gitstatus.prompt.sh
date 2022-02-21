# Simple Bash prompt with Git status.

# Source gitstatus.plugin.sh from $GITSTATUS_DIR or from the same directory
# in which the current script resides if the variable isn't set.
if [[ -n "${GITSTATUS_DIR:-}" ]]; then
  source "$GITSTATUS_DIR"                           || return
elif [[ "${BASH_SOURCE[0]}" == */* ]]; then
  source "${BASH_SOURCE[0]%/*}/gitstatus.plugin.sh" || return
else
  source gitstatus.plugin.sh                        || return
fi

# Unicode Characters from Nerd Fonts
# Assuming that if you have gitstatus you also should have nerd fonts
nf_gitlogo=$'\uf1d2 '
nf_gitbranch=$'\ue725 '
nf_commit=$'\ue729 '
nf_merge=$'\ue727 '
nf_pull=$'\ue726 '
nf_compare=$'\ue728 '
nf_untracked=$'\uf14b '
nf_stashed=$'\ufb1a '


# Sets GITSTATUS_PROMPT to reflect the state of the current git repository.
# The value is empty if not in a git repository. Forwards all arguments to
# gitstatus_query.
#
# Example value of GITSTATUS_PROMPT: master ⇣42⇡42 ⇠42⇢42 *42 merge ~42 +42 !42 ?42
#
#   master  current branch
#      ⇣42  local branch is 42 commits behind the remote
#      ⇡42  local branch is 42 commits ahead of the remote
#      ⇠42  local branch is 42 commits behind the push remote
#      ⇢42  local branch is 42 commits ahead of the push remote
#      *42  42 stashes
#    merge  merge in progress
#      ~42  42 merge conflicts
#      +42  42 staged changes
#      !42  42 unstaged changes
#      ?42  42 untracked files
function gitstatus_prompt_update() {
	GITSTATUS_PROMPT=""

	gitstatus_query "$@"                  || return 1  # error
	[[ "$VCS_STATUS_RESULT" == ok-sync ]] || return 0  # not a git repo

	# Status colours
	# https://i.stack.imgur.com/xjBuI.png (palette)
	local      reset=$'\001\e[0m\002'         # reset
	local      clean=$'\001\e[38;5;070m\002'  # green
	local  committed=$'\001\e[38;5;183m\002'  # light violet
	local  untracked=$'\001\e[38;5;075m\002'  # aquamarine
	local   modified=$'\001\e[38;5;215m\002'  # orange 
	local conflicted=$'\001\e[38;5;088m\002'  # deep red
	local      ahead=$'\001\e[38;5;207m\002'  # magenta
	local      stash=$'\001\e[38;5;241m\002'  # grey
	local p

	local where  # branch name, tag or commit
	if [[ -n "$VCS_STATUS_LOCAL_BRANCH" ]]; then
		where="$VCS_STATUS_LOCAL_BRANCH"
	elif [[ -n "$VCS_STATUS_TAG" ]]; then
		p+="${reset}#"
		where="$VCS_STATUS_TAG"
	else
		p+="${reset}@"
		where="${VCS_STATUS_COMMIT:0:8}"
	fi

	(( ${#where} > 32 )) && where="${where:0:12}…${where: -12}"  # truncate long branch names and tags
	p+="${clean}${where}]"

  # ⇣42 if behind the remote.
	(( VCS_STATUS_COMMITS_BEHIND )) && p+=" ${clean}[⇣${VCS_STATUS_COMMITS_BEHIND}]"
  # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
	(( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && p+=" "
	(( VCS_STATUS_COMMITS_AHEAD  )) && p+="${ahead}[${nf_pull}${VCS_STATUS_COMMITS_AHEAD}]"
  # ⇠42 if behind the push remote.
	(( VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
	(( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && p+=" "
  # ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
	(( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && p+="${clean}[⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}]"
  # *42 if have stashes.
	(( VCS_STATUS_STASHES        )) && p+=" ${clean}[${nf_stashed}${VCS_STATUS_STASHES}]"
  # 'merge' if the repo is in an unusual state.
	[[ -n "$VCS_STATUS_ACTION"   ]] && p+=" ${conflicted}[${VCS_STATUS_ACTION}]"
  # ~42 if have merge conflicts.
	(( VCS_STATUS_NUM_CONFLICTED )) && p+=" ${conflicted}[~${VCS_STATUS_NUM_CONFLICTED}]"
  # +42 if have staged changes.
	(( VCS_STATUS_NUM_STAGED     )) && p+=" ${committed}[${nf_commit}${VCS_STATUS_NUM_STAGED}]"
  # !42 if have unstaged changes.
	(( VCS_STATUS_NUM_UNSTAGED   )) && p+=" ${modified}[${nf_compare}${VCS_STATUS_NUM_UNSTAGED}]"
  # ?42 if have untracked files. It's really a question mark, your font isn't broken.
	(( VCS_STATUS_NUM_UNTRACKED  )) && p+=" ${untracked}[${nf_merge}${VCS_STATUS_NUM_UNTRACKED}]"

	GITSTATUS_PROMPT="${clean}[${nf_gitbranch}${p}${reset}"
}

# Start gitstatusd daemon in the background.
gitstatus_stop && gitstatus_start -s -1 -u -1 -c -1 -d -1

# On every prompt, fetch git status and set GITSTATUS_PROMPT.
PROMPT_COMMAND=gitstatus_prompt_update
PROMPT_DIRTRIM=3

# Enable promptvars so that ${GITSTATUS_PROMPT} in PS1 is expanded.
shopt -s promptvars
rightprompt() {
	printf "%*s" $((COLUMNS - ${#GITSTATUS_PROMPT} - 1)) ""
}
# Customize prompt. Put $GITSTATUS_PROMPT in it reflect git status.
PS1='\[$(tput sc; rightprompt; tput rc)\]\[\033[34m\][ \[\033[1;33m\]\u\[\033[37m\] | \[\033[1;36m\]\h\[\033[37m\] | \[\033[32m\]\w\[\033[1;32m\]\[\033[32m\]\[\033[0;34m\] ]'
PS1+='${GITSTATUS_PROMPT:+ $GITSTATUS_PROMPT}'    # git status (requires promptvars option)
PS1+="\n\[\033[2;35m\]$(echo $0 | sed -e 's^/bin/^^')"
PS1+=" \[\033[01;$((31+!$?))m\]\$\[\033[00m\] "
