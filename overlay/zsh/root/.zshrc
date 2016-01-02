export ZSH=/root/.oh-my-zsh
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export UPDATE_ZSH_DAYS=30

ZSH_THEME="ys"
CASE_SENSITIVE="true"
ENABLE_CORRECTION="false"
HYPHEN_INSENSITIVE="false"
COMPLETION_WAITING_DOTS="true"
DISABLE_LS_COLORS="false"
DISABLE_AUTO_TITLE="false"
DISABLE_AUTO_UPDATE="false"
DISABLE_UNTRACKED_FILES_DIRTY="false"

plugins=(composer docker extract git git-extras history last-working-dir vagrant)

source $ZSH/oh-my-zsh.sh

[[ -f /usr/local/bin/direnv ]] && eval "$(direnv hook zsh)"
[[ -f ~/.gvm/scripts/gvm ]] && source ~/.gvm/scripts/gvm
[[ -f /etc/profile.d/go.sh ]] && source /etc/profile.d/go.sh
[[ -f /etc/profile.d/nodejs.sh ]] && source /etc/profile.d/nodejs.sh
