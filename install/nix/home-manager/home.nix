# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "mable";
    homeDirectory = "/home/mable";

    file = {
      ".zshrc".source = ../../../src/default/dotfiles/zshrc;
      ".ideavimrc".source = ../../../src/default/dotfiles/.ideavimrc;

      ".config/starship.toml".source = ../../../src/default/dotfiles/config/starship.toml;
      ".config/git".source = ../../../src/default/dotfiles/config/git;
      ".config/fish".source = ../../../src/default/dotfiles/config/fish;
      ".config/lazygit".source = ../../../src/default/dotfiles/config/lazygit;
      ".config/tmux".source = ../../../src/default/dotfiles/config/tmux;
      ".config/wezterm".source = ../../../src/default/dotfiles/config/wezterm;
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/mable/.dotfiles/src/default/dotfiles/config/nvim";

    };
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [ 
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.starship.enable = true;
  programs.git.enable = true;
  programs.fish.enable = true;
  programs.lazygit.enable = true;
  programs.tmux.enable = true;
  programs.wezterm.enable = true;
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
        fzfWrapper
    ];
    extraPackages = with pkgs; [
        gcc
        cmake
        gnumake
        nodejs_24
        lua5_1

        # rest.nvim
        lua51Packages.xml2lua
        lua51Packages.luarocks
        lua51Packages.mimetypes
    ];
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
