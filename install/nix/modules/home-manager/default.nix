({pkgs, ...}: {
    home.stateVersion = "23.05";
    home.packages = [
    ];
    home.sessionVariables = {
        EDITOR = "nvim";
    };
    programs.git = {
        enable = true;
        userName = "Tom Delalande";
        userEmail = "80664757+thomas-delalande@users.noreply.github.com";
        extraConfig = {
            core = {
                editor = "nvim";
            };
            pull = {
                rebase = true;
            };
            push = {
                autoSetupRemote = true;
                default = "current";
            };
            rebase = {
                autoStash = true;
            };
        };
        includes = [
            {
                condition = "gitdir:~/vgw/";
                path = "./vgw";
            }
        ];

    };
    programs.starship = {
        enable = true;
        enableFishIntegration = true;
        settings = {
            aws = {
                disabled = true;
            };
        };
    };
    programs.wezterm = {
        enable = true;
        extraConfig = builtins.readFile ../../../../src/.config/wezterm/wezterm.lua;
    };
    programs.tmux = {
        enable = true;
        extraConfig = builtins.readFile ../../../../src/.config/tmux/tmux.conf;
    };
    programs.fish = {
        enable = true;
        shellInit = builtins.readFile ../../../../src/.config/fish/config.fish;
    };
    programs.neovim = {
        enable = true;
    };
    programs.lazygit = {
        enable = true;
        settings = builtins.readFile ../../../../src/.config/lazygit/config.yml;
    };
    home.file.".config/git" = {
        source = ../../../../src/.config/git;
        recursive = true;
    };
    home.file.".config/nvim" = {
        source = ../../../../src/.config/nvim;
        recursive = true;
    };
    home.file.".config/skhd" = {
        source = ../../../../src/.config/skhd;
        recursive = true;
    };
    home.file.".config/yabai" = {
        source = ../../../../src/.config/yabai;
        recursive = true;
    };
    home.file.".zshrc" = {
        source = ../../../../src/.zshrc;
    };
})
