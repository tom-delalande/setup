{
    description = "MacOS Configuration";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        home-manager.url = "github:nix-community/home-manager/master";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        darwin.url = "github:lnl7/nix-darwin";
        darwin.inputs.nixpkgs.follows = "nixpkgs";
        flake-utils.url = "github:numtide/flake-utils";
    };
    outputs = inputs:
        inputs.flake-utils.lib.eachDefaultSystem (system: {
        darwinConfigurations.thomas = inputs.darwin.lib.darwinSystem {
            system = system;
            pkgs = import inputs.nixpkgs {
                system = system;
                config.allowUnfree = true;
                config.allowUnsupportedSystem = true;
                config.allowBroken = true;
            };
            modules = [
                ./modules/darwin-config
                ({ pkgs, lib, ...}: {
                    homebrew.casks = lib.mkForce [
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
                        "intellij-idea-ce"
                    ];
                })
                inputs.home-manager.darwinModules.home-manager {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.thomas-delalande.imports = [
                            ./modules/home-manager
                            ({pkgs, lib, ...}: {
                                programs.git.userName = lib.mkForce "Tom Delalande";
                                programs.git.userEmail = lib.mkForce "thomas.delalande@vgw.co";
                                programs.git.includes = [];
                            })
                        ];
                    };
                }
            ];
        };
    });
}
