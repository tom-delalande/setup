{
    description = "MacOS Configuration";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        home-manager.url = "github:nix-community/home-manager/master";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        darwin.url = "github:lnl7/nix-darwin";
        darwin.inputs.nixpkgs.follows = "nixpkgs";
    };
    outputs = inputs: {
        darwinConfigurations.thomas = inputs.darwin.lib.darwinSystem {
            system = "x86_64-darwin";
            pkgs = import inputs.nixpkgs { 
                system = "x86_64-darwin";
                config.allowUnfree = true;
                config.allowUnsupportedSystem = true;
                config.allowBroken = true;
            };
            modules = [
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
                        "openvpn-connect"
                        "webex"
                        "intellij-idea"
                      ];
                    };
                })
                inputs.home-manager.darwinModules.home-manager {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.thomas-delalande.imports = [
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
                                    extraConfig = builtins.readFile ./.config/wezterm/wezterm.lua;
                                };
                                programs.tmux = {
                                    enable = true;
                                    extraConfig = builtins.readFile ./.config/tmux/tmux.conf;
                                };
                                programs.fish = {
                                    enable = true;
                                    shellInit = builtins.readFile ./.config/fish/config.fish;
                                };
                                programs.neovim = {
                                    enable = true;
                                };
                                programs.lazygit = {
                                    enable = true;
                                    settings = builtins.readFile ./.config/lazygit/config.yml;
                                };
                                home.file.".config/git" = {
                                    source = ./.config/git;
                                    recursive = true;
                                };
                                home.file.".config/nvim" = {
                                    source = ./.config/nvim;
                                    recursive = true;
                                };
                                home.file.".config/skhd" = {
                                    source = ./.config/skhd;
                                    recursive = true;
                                };
                                home.file.".config/yabai" = {
                                    source = ./.config/yabai;
                                    recursive = true;
                                };
                                home.file.".zshrc" = {
                                    source = ./.zshrc;
                                };
                            })
                        ];
                    };
                }
            ];
        };
        darwinConfigurations.yellow-child = inputs.darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            pkgs = import inputs.nixpkgs { 
                system = "aarch64-darwin";
                config.allowUnfree = true;
                config.allowUnsupportedSystem = true;
                config.allowBroken = true;
            };
            modules = [
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
                inputs.home-manager.darwinModules.home-manager {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.thomas-delalande.imports = [
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
                                    extraConfig = builtins.readFile ./.config/wezterm/wezterm.lua;
                                };
                                programs.tmux = {
                                    enable = true;
                                    extraConfig = builtins.readFile ./.config/tmux/tmux.conf;
                                };
                                programs.fish = {
                                    enable = true;
                                    shellInit = builtins.readFile ./.config/fish/config.fish;
                                };
                                programs.neovim = {
                                    enable = true;
                                };
                                programs.lazygit = {
                                    enable = true;
                                    settings = builtins.readFile ./.config/lazygit/config.yml;
                                };
                                home.file.".config/git" = {
                                    source = ./.config/git;
                                    recursive = true;
                                };
                                home.file.".config/nvim" = {
                                    source = ./.config/nvim;
                                    recursive = true;
                                };
                                home.file.".config/skhd" = {
                                    source = ./.config/skhd;
                                    recursive = true;
                                };
                                home.file.".config/yabai" = {
                                    source = ./.config/yabai;
                                    recursive = true;
                                };
                                home.file.".zshrc" = {
                                    source = ./.zshrc;
                                };
                            })
                        ];
                    };
                }
            ];
        };
    };
}
