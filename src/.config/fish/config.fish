if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_config theme choose "ayu Dark"
    fish_config prompt choose scales
end

function brew-install
    echo "brew install" $argv >> $HOME/setup/scripts/1-install/1-3-install-brew-formulae.sh
    brew install $argv
end

function brew-cask
    echo "brew install --cask" $argv >> $HOME/setup/scripts/1-install/1-4-install-brew-casks.sh
    brew install --cask $argv
end

function gwc
    set repo $argv[1]
    git clone git@github-vgw:vgw-tom/$repo $VGW_DIR/$repo
    cd $VGW_DIR/$repo
    git remote add upstream git@github-vgw:vgw/$repo
end

funcsave brew-install

function commit
    git add -A 
    git commit --allow-empty-message -m '' 
    git push
end

bind \cf 'tmux neww tms'
bind \ck 'clear'
bind \cq 'vim . +:CHADopen'
bind \cg 'lazygit'
bind \cp 'commit'
set -Ux EDITOR 'nvim'
set -Ux VGW_DIR "$HOME/vgw"
set -Ux DEV_DIR "$HOME/dev"

function localw
    tmux new -ds tasks &> /dev/null
    for task in $argv
        echo "Running $task..."
        tmux kill-window -t tasks:$task &> /dev/null
        tmux new-window -n $task -t tasks "$VGW_DIR/scripts/local_run_$task.sh"
    end
end

function local
    tmux new -ds tasks &> /dev/null
    for task in $argv
        echo "Running $task..."
        tmux kill-window -t tasks:$task &> /dev/null
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
starship init fish | source
