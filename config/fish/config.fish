set fish_greeting

# set -gx SSH_AUTH_SOCK "$HOME/.bitwarden-ssh-agent.sock"

if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_config theme choose "ayu Dark"
    fish_config prompt choose scales
end

function fish_prompt
    set_color -o cyan
    printf '» '
    set_color normal
end

function fish_right_prompt
end

set -Ux XDG_CONFIG_HOME "$HOME/.config"

function commit
    git add -A
    git commit --allow-empty-message -m ''
    git push
end

bind \cf 'tmux neww tms'
bind \ck clear
bind \cg lazygit
bind \cd "nvim +DBUI"
bind \cp commit
set -Ux EDITOR nvim
set -Ux DEV_DIR "$HOME/dev"
alias vim nvim
alias cat bat
alias sqlite /opt/homebrew/opt/sqlite/bin/sqlite3
alias sql "nvim +DBUI"

function localw
    tmux new -ds tasks &>/dev/null
    for task in $argv
        echo "Running $task..."
        tmux kill-window -t tasks:$task &>/dev/null
        tmux new-window -n $task -t tasks "$VGW_DIR/scripts/local_run_$task.sh"
    end
end

function local
    tmux new -ds tasks &>/dev/null
    for task in $argv
        echo "Running $task..."
        tmux kill-window -t tasks:$task &>/dev/null
        tmux new-window -n $task -t tasks "$DEV_DIR/scripts/local_run_$task.sh"
    end
end

# git bindings
alias gco="git checkout"
alias gs="git status"
alias gm="git mergetool"
function gcn
    git checkout main
    git fetch upstream main
    git reset --hard upstream/main
    git push -f
    git checkout -b $argv
end

function gr
    git fetch upstream main
    git rebase upstream/main
    git push --force-with-lease
end

tmux new-session -A -s main
clear
zoxide init --cmd cd fish | source
