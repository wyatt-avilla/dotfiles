ufetch

export EDITOR=/usr/bin/nvim
export PATH="${HOME}/.cargo/bin:$PATH"
export HYPRSHOT_DIR=/home/spebby/media/screenshots

# omzsh
export ZSH=/usr/share/oh-my-zsh/
export ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# aliases
alias vim="nvim"
alias ls="eza --icons"
alias cat="bat"
alias grep="rg"
alias lf="ya-with-dir-change"

alias obsidian="hyprctl dispatch killactive && hyprctl dispatch exec \"obsidian --enable-features=UseOzonePlatform --ozone-platform-hint=wayland\""
alias spotify="hyprctl dispatch killactive && hyprctl dispatch exec \"spotify\""
alias discord="hyprctl dispatch killactive && hyprctl dispatch exec \"discord\""
alias chrome="google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland"
alias objdiff="hyprctl dispatch killactive && hyprctl dispatch exec \"/home/wyatt/.cargo/bin/objdiff\""
alias firefox="exec firefox"

# emerge
alias pacman="doas pacman"


function ya-with-dir-change() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# history
HISTFILE=~/.config/zsh/history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST

# vimcel
bindkey -v
bindkey -M vicmd 'h' backward-char
bindkey -M vicmd 'j' down-line-or-history
bindkey -M vicmd 'k' up-line-or-history
bindkey -M vicmd 'l' forward-char
bindkey -M vicmd 'i' vi-insert
bindkey -v '^?' backward-delete-char
export KEYTIMEOUT=1

# Change cursor shape for different vi modes
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


# starship
eval "$(starship init zsh)"

# syntax highligting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# autocomplete
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
