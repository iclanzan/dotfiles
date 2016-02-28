#!/bin/bash

# Exit if any command fails
set -e

# In non-interactive shells aliases are not expanded without this
shopt -s expand_aliases

declare -ra TAPS=(
  'neovim/neovim'
)

declare -ra FORMULAE=(
  'bash'
  'git'
  'fzf'
  'mutt'
  'neovim'
  'nvm'
  'the_silver_searcher'
  'vifm'
)

declare -ra CASKS=(
  'firefox'
  'google-chrome'
  'vlc'
  'virtualbox'
)

declare -xr RED='\033[0;31m'
declare -xr GREEN='\033[0;32m'
declare -xr YELLOW='\033[0;33m'
declare -xr MAGENTA='\033[0;95m'
declare -xr BLUE='\033[0;94m'
declare -xr RESET='\033[0m'

printError() {
  printf "${RED}$1${NC}\n" 1>&2;
}

printWarn() {
  printf "${YELLOW}$1${NC}\n" 1>&2;
}

printSuccess() {
  printf "${GREEN}$1${NC}\n" 1>&2;
}

printInfo() {
  printf "${BLUE}$1${NC}\n" 1>&2;
}

commandExists() {
  which "$1" &>/dev/null
}

isFormulaInstalled() {
  brew list "$1" &>/dev/null
}

isFormulaOutdated() {
  ! brew outdated "$1" &>/dev/null
}

isCaskInstalled() {
  brew cask list "$1" &>/dev/null
}

installOrUpgradeFormula() {
  if isFormulaInstalled "$1"; then
    if isFormulaOutdated "$1"; then
      brew upgrade "$@"
    fi
  else
    brew install "$@"
  fi
}

installCask() {
  if ! isCaskInstalled "$1"; then
    brew cask install "$@"
  fi
}

if ! commandExists brew; then
  printInfo 'Installing Homebrew'
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

for i in "${TAPS[@]}"
do
  brew tap "$i"
done

brew update

for i in "${FORMULAE[@]}"
do
  installOrUpgradeFormula "$i"
done

for i in "${CASKS[@]}"
do
  installCask "$i"
done

printInfo "Cloning dotfiles from $1"
git clone --bare "$1" "$HOME/.dotfiles"
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout
