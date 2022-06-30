# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Sources

# source ~/git-completion.bash
source ~/configs/git-prompt.sh

# Effects
Default='0'
Bold='1'
Underline='4'
Flashing='5'
Reverse='7'
Concealed='8'

# Colors
Black="$Default;30"
Red="$Default;31"
Green="$Default;32"
Yellow="$Default;33"
Blue="$Default;34"
Purple="$Default;35"
Cyan="$Default;36"
White="$Default;37"

# Bold Colors
BBlack="$Bold;30"
BRed="$Bold;31"
BGreen="$Bold;32"
BYellow="$Bold;33"
BBlue="$Bold;34"
BPurple="$Bold;35"
BCyan="$Bold;36"
BWhite="$Bold;37"

# High Intensity Colors
IBlack="$Default;90"
IRed="$Default;91"
IGreen="$Default;92"
IYellow="$Default;93"
IBlue="$Default;94"
IPurple="$Default;95"
ICyan="$Default;96"
IWhite="$Default;97"

# Bold High Intensity
BIBlack="$Bold;90"
BIRed="$Bold;91"
BIGreen="$Bold;92"
BIYellow="$Bold;93"
BIBlue="$Bold;94"
BIPurple="$Bold;95"
BICyan="$Bold;96"
BIWhite="$Bold;97"

# Backgrounds
On_Black='40'
On_Red='41'
On_Green='42'
On_Yellow='43'
On_Blue='44'
On_Purple='45'
On_Cyan='46'
On_White='47'

# High Intensity backgrounds
On_IBlack='100'
On_IRed='101'
On_IGreen='102'
On_IYellow='103'
On_IBlue='104'
On_IPurple='105'
On_ICyan='106'
On_IWhite='107'

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

ps1s='\e['
ps1e='m'
if [ "$color_prompt" = yes ]; then
    # PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[$ps1s$Cyan$ps1e\]\$(__git_ps1 '(%s)') \[\033[00m\]\$ "
    PS1="\[$ps1s$BIBlue$ps1e\]\u\[$ps1s$BIWhite$ps1e\]@\[$ps1s$BIGreen$ps1e\]\h\[$ps1s$BIWhite$ps1e\]:\[$ps1s$BIPurple$ps1e\]\w\[$ps1s$BICyan$ps1e\]\$(__git_ps1 '(%s)')\[$ps1s$Default$ps1e"$'\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# ps1s='\e['
# ps1e='m'

# Command prompt color and format
# export PS1="\[$ps1s$BIBlue$ps1e\]\u\[$ps1s$White$ps1e\]@\[$ps1s$Yellow$ps1e\]\h\[$ps1s$White$ps1e\]:\[$ps1s$Purple$ps1e\]\w\[$ps1s$Cyan$ps1e\]\$(__git_ps1 '(%s)') \[$ps1s$Default$ps1e"$'\n\$ '

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias eg='egrep -r -n -i'                     # common egrep flags
    alias egpy='egrep -r -n -i --include=*.py'    # common egrep for python files
    alias findfn='find . -type f -name'           # recursive find file by name
    alias finddn='find . -type d -name'           # recursive find dir by name
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# git alias
alias gst='git status'
alias gf='git fetch --all'
alias gl='git pull'
alias gp='git push'
alias gd='git diff | mate'
alias gdiffci='git diff-tree --name-only -r'  # show all changed files in a commit--needs branch or hash
alias gaa='git add -A'
alias gau='git add --update'
alias gci='git commit'
alias gca='git commit -a'
alias gcam='git commit -a -m'
alias gbr='git branch'
alias gba='git branch -a'
alias gco='git checkout'
alias gcob='git checkout -b'
alias glog='git log'
alias glogp='git log --pretty=format:"%h %s" --graph'
alias gmash='git merge --squash'
alias gsu='git submodule update --init --recursive'
alias gpsu='git submodule update --recursive --remote' # pull all submdules to origin/master
alias grhard='git reset --hard'
alias gwip='git commit -a -m wip'
alias gcap='git branch | cut -c3- | grep arcpatch- | xargs -n1 git branch -D'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/wesley/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/wesley/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/wesley/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/wesley/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

