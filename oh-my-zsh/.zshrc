# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$USER.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$USER.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# region - System
# ------------------------------------------------------------------------------

alias mem="free -h"                                   # 查看内存使用
alias cpu="top"                                       # 实时进程监控
alias df="df -h"                                      # 磁盘空间（人类可读）
alias h="history"                                     # 查看命令历史
alias ports="netstat -tulpn"                          # 查看监听的端口
alias gpu="nvidia-smi"                                # 查看 GPU 状态（NVIDIA）

# endregion --------------------------------------------------------------------

# region - Network
# ------------------------------------------------------------------------------

# 查看公网 IP
alias myip="curl http://ipecho.net/plain; echo"

# 查看局域网 IP
alias localip="ip route show | grep -i default | awk '{print \$3}'"

# 默认 ping 5 次
alias ping="ping -c 5"

# 支持断点续传
alias wget="wget -c"

# endregion --------------------------------------------------------------------

# region - Others
# ------------------------------------------------------------------------------

alias size="du -sh"                       # 查看文件夹大小
alias untar="tar -zxvf"                   # 解压 .tar.gz 文件
alias zipf="zip -r"                       # 快速压缩文件夹（zip -r）
alias findfile="find . -type f -name"     # 按文件名搜索（如 findfile '*.txt'）

alias sshkey="cat ~/.ssh/id_rsa.pub"      # 快速显示 SSH 公钥
alias please="sudo !!"                    # 用 sudo 重复上条命令（幽默别名）

# endregion --------------------------------------------------------------------

# region - oh-my-zsh
# ------------------------------------------------------------------------------

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

alias zshrc="code ~/.zshrc"               # 编辑 zsh 配置
alias szs="source ~/.zshrc"               # 重载 zsh 配置

ZSH_DISABLE_COMPFIX="true"

# endregion --------------------------------------------------------------------

# region - oh-my-zsh - Plugin
# reference: https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins-Overview
# ------------------------------------------------------------------------------

plugins=(
  extract
  git
  web-search
  z
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# endregion --------------------------------------------------------------------

# region - oh-my-zsh - Theme
# reference: https://github.com/romkatv/powerlevel10k#oh-my-zsh
# reference:https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#configuration-wizard
# ------------------------------------------------------------------------------

ZSH_THEME="powerlevel10k/powerlevel10k"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# The list of segments shown on the left. Fill it with the most important segments.
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon # os identifier
  dir     # current directory
)

# https://ohmyz.sh/
source $ZSH/oh-my-zsh.sh

# endregion --------------------------------------------------------------------

# region - Directories
# default editor: vim
# resource manager: explorer.exe
# default workspace: ~/workspace
# ------------------------------------------------------------------------------

# export EDITOR="code"
# export EDITOR='vim'
export EXPLORER='explorer.exe'
export WORKSPACE="$HOME/workspace"

function dir() {
  mkdir $1 && cd $1
}

# cd to ~/workspace
function w() {
  cd $WORKSPACE/$1
}

# Open a repository in ~/workspace with VSCode
function codew() {
  w && code "$@" && cd -
}

# Clone a repository to ~/workspace and open it with VSCode
function clonew() {
  w && clone "$@" && code . && cd ~2
}

# Create a new repository from template and open it with VSCode
function codet() {
  w && degit $1 && code "$@"
}

# Open current directory with Explorer
function show() {
  if [[ -z $1 ]]; then
    $EXPLORER .
  else
    $EXPLORER $1
  fi
}

# List directory contents with tree command
function list() {
  if [[ -z $2 ]]; then
    tree "$1" -L 2 --dirsfirst
  else
    tree "$1" -L $2 --dirsfirst
  fi
}

# endregion --------------------------------------------------------------------

# region - Git
# reference: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
# ------------------------------------------------------------------------------

# Go to project root
alias grt='cd "$(git rev-parse --show-toplevel)"'

alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gps="git push"
alias gpl="git pull"
alias glg="git log --graph --oneline --decorate"

# alias gs='git status'
# alias gp='git push'
# alias gpf='git push --force'
# alias gpft='git push --follow-tags'
# alias gpl='git pull --rebase'
# alias gcl='git clone'
# alias gst='git stash'
# alias grm='git rm'
# alias gmv='git mv'

# alias main='git checkout main'

# alias gco='git checkout'
# alias gcob='git checkout -b'

# alias gb='git branch'
# alias gbd='git branch -d'

# alias grb='git rebase'
# alias grbom='git rebase origin/master'
# alias grbc='git rebase --continue'

# alias gl='git log'
# alias glo='git log --oneline --graph'

# alias grh='git reset HEAD'
# alias grh1='git reset HEAD~1'

# alias ga='git add'
# alias gA='git add -A'

# alias gc='git commit'
# alias gcm='git commit -m'
# alias gca='git commit -a'
# alias gcam='git add -A && git commit -m'
# alias gfrb='git fetch origin && git rebase origin/master'

# alias gxn='git clean -dn'
# alias gx='git clean -df'

# alias gsha='git rev-parse HEAD | pbcopy'

# alias ghci='gh run list -L 1'

# Show last 10 commits
function gln() {
  if [[ -z $1 ]]; then
    git --no-pager log -10
  else
    git --no-pager log -$1
  fi
}

# Show diff of unstaged changes
function gd() {
  if [[ -z $1 ]]; then
    git diff --color | diff-so-fancy
  else
    git diff --color $1 | diff-so-fancy
  fi
}

# Show diff of staged changes
function gdc() {
  if [[ -z $1 ]]; then
    git diff --color --cached | diff-so-fancy
  else
    git diff --color --cached $1 | diff-so-fancy
  fi
}

# Clone a repository and cd to it
function clone() {
  if [[ -z $2 ]]; then
    git clone "$@" && cd "$(basename "$1" .git)"
  else
    git clone "$@" && cd "$2"
  fi
}

# endregion --------------------------------------------------------------------

# region - Node Package Manager
# reference: https://github.com/antfu/ni
# ------------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"

# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

alias nio="ni --prefer-offline"

alias s="nr start"
alias d="nr dev"
alias b="nr build"
alias bw="nr build --watch"
alias w="nr watch"
alias p="nr play"

alias dd="nr docs:dev"
alias db="nr docs:build"

alias c="nr typecheck"
alias lint="nr lint"
alias lintf="nr lint --fix"

alias t="nr test"
alias tu="nr test -u"
alias tw="nr test --watch"
alias re="nr release"

# endregion --------------------------------------------------------------------
