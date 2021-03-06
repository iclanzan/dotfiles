os_name=$(uname)

# Use pushd instead of cd.
cd () {
  if [ $# -eq 0 ]; then
    DIR="${HOME}"
  else
    DIR="$1"
  fi

  pushd "${DIR}" > /dev/null
}

# Create a directory and change to it.
function take() {
  mkdir -p $1
  cd $1
}

# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

# Directory operations
alias ..='cd ..'
alias cd..='cd ..'
alias ...='cd ../..'
alias cd...='cd ../..'
alias ....='cd ../../..'
alias cd....='cd ../../..'
alias .....='cd ../../../..'
alias cd.....='cd ../../../..'
alias -- -='cd -'

alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias d='dirs -v | head -10'

alias md='mkdir -p'
alias rd=rmdir

# List direcory contents
alias lsa='ls -lah'
alias l='ls -la'
alias ll='ls -l'
alias la='ls -lA'
alias sl=ls # often screw this up

# History
HISTSIZE=10000

# Show history
if [ "$HIST_STAMPS" = "mm/dd/yyyy" ]
then
    alias history='fc -fl 1'
elif [ "$HIST_STAMPS" = "dd.mm.yyyy" ]
then
    alias history='fc -El 1'
elif [ "$HIST_STAMPS" = "yyyy-mm-dd" ]
then
    alias history='fc -il 1'
else
    alias history='fc -l 1'
fi

# Manage dot file configuration with git
# On a new machine: git clone --separate-git-dir=~/.dotfiles /path/to/repo ~
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Git
alias gnew="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative HEAD..dev"

# Colors!
export TERM="xterm-color"

# Make `ls` use colors.
if [[ $os_name == "Darwin" ]] ; then
  export LSCOLORS="exfxcxdxbxagadabafacah"
  alias ls='ls -G'
elif [[ $os_name == "Linux" ]]; then
  export LS_COLORS="di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=0;46:cd=0;43:su=0;41:sg=0;45:tw=0;42:ow=0;47:"
  alias ls='ls --color=tty'
fi

# Editor
export EDITOR='nvim'

alias vim='nvim'
alias v='nvim'

# Color grep results
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'

# Pager
export PAGER="less"
export MANPAGER="nvim -c 'set ft=man' -"
export LESS="-R"

export LC_CTYPE=$LANG

export NODE_ENV="development"

# Use ag instead of find with fzf in order to respect .gitignore
export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_DEFAULT_OPTS='--color 16'
  # ,fg:15,bg:0,hl:3,fg+:15,bg+:8,hl+:3,info:7,prompt:4,pointer:1,marker:1,spinner:12

# Add home bin to PATH
[[ -d $HOME/bin ]] && PATH=$PATH:$HOME/bin

source ~/.bash_prompt

BASH_COMPLETION_PATH=$(brew --prefix)/etc/bash_completion
[ -f $BASH_COMPLETION_PATH ] && source $BASH_COMPLETION_PATH

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Load fzf with all commits from current repo.
fshow() {
  local out shas sha q k
  while out=$(
      git log --graph --color=always \
          --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
      fzf --ansi --multi --no-sort --reverse --query="$q" --tiebreak=index \
          --print-query --expect=ctrl-d --toggle-sort=\`); do
    q=$(head -1 <<< "$out")
    k=$(head -2 <<< "$out" | tail -1)
    shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
    [ -z "$shas" ] && continue
    if [ "$k" = 'ctrl-d' ]; then
      git diff --color=always $shas | less -R
    else
      for sha in $shas; do
        git show --color=always $sha | less -R
      done
    fi
  done
}
