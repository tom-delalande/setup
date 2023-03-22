({ pkgs, ...}: {
    programs.fish.enable = true;
    environment.shells = [ pkgs.bash pkgs.fish ];
    environment.loginShell = pkgs.fish;
    nix.extraOptions = ''
        experimental-features = nix-command flakes
    '';
    environment.systemPackages = [ pkgs.coreutils ];
    system.keyboard.enableKeyMapping = true;
    system.keyboard.remapCapsLockToEscape = true;
    fonts.fontDir.enable = false;
    fonts.fonts = [ (pkgs.nerdfonts.override {
        fonts = ["JetBrainsMono"];
    })];
    services.nix-daemon.enable = true;
    system.defaults.finder.ShowPathbar = true;
    system.defaults.dock = {
        autohide = true;
        orientation = "right";
    };
    system.defaults.NSGlobalDomain.InitialKeyRepeat = 14;
    system.defaults.NSGlobalDomain.KeyRepeat = 1;
    environment.systemPath = [ "/opt/homebrew/bin" ];
    homebrew = {
      enable = true;
      caskArgs.no_quarantine = false;
      onActivation.cleanup = "zap";
      onActivation.upgrade = true;
      global.brewfile = true;
      masApps = { };
      taps = [ 
        "homebrew/cask"
        "homebrew/cask-versions"
        "homebrew/core"
        "homebrew/services"
        "jesseduffield/lazygit"
        "koekeishiya/formulae"
        "warrensbox/tap"
        "yulrizka/tap"
        "fsouza/prettierd"
      ];
      brews = [
        "awscli"
        "cmake"
        "docker"
        "gh"
        "gnutls"
        "fish"
        "flyway"
        "fzf"
        "git"
        "gradle"
        "openjdk@11"
        "lua"
        "luarocks"
        "maven"
        "neovim"
        "node"
        "opencv"
        "postgresql@14"
        "ripgrep"
        "sqlx-cli"
        "rustup-init"
        "trunk"
        "saml2aws"
        "starship"
        "terraform"
        "tmux"
        "wget"
        "jesseduffield/lazygit/lazygit"
        "koekeishiya/formulae/skhd"
        "koekeishiya/formulae/yabai"
        "fsouza/prettierd/prettierd"
        "zoxide"
      ];
      casks = [
        "browserosaurus"
        "docker"
        "figma"
        "google-chrome"
        "google-drive"
        "handbrake"
        "hiddenbar"
        "maccy"
        "obsidian"
        "postman"
        "raycast"
        "spotify"
        "slack"
        "ticktick"
        "itsycal"
        "vlc"
        "wezterm"
        "discord"
        "league-of-legends"
        "minecraft"
        "notion"
        "intellij-idea-ce"
        "firefox"
      ];
    };
})
