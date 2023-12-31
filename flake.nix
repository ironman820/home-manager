{
  description = "My Nix Flakes";

  inputs = {
    blockyalarm = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ironman820/blockyalarm";
    };
    catppuccin-bat = {
      flake = false;
      url = "github:catppuccin/bat";
    };
    catppuccin-btop = {
      flake = false;
      url = "github:catppuccin/btop";
    };
    catppuccin-kitty = {
      flake = false;
      url = "github:catppuccin/kitty";
    };
    catppuccin-lazygit = {
      flake = false;
      url = "github:catppuccin/lazygit";
    };
    catppuccin-neomutt = {
      flake = false;
      url = "github:catppuccin/neomutt";
    };
    catppuccin-rofi = {
      flake = false;
      url = "github:catppuccin/rofi";
    };
    catppuccin-starship = {
      flake = false;
      url = "github:catppuccin/starship";
    };
    catppuccin-tmux = {
      flake = false;
      url = "github:catppuccin/tmux";
    };
    cloak-nvim = {
      flake = false;
      url = "github:laytan/cloak.nvim";
    };
    flake = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:snowfallorg/flake";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-23.11";
    };
    nix-ld = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:mic92/nix-ld";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    # acc5f7b - IcedTea v8 Stable
    nixpkgs-acc5f7b.url = "github:nixos/nixpkgs/acc5f7b";
    # ba45a55 - The last stable update of PHP 7.4
    nixpkgs-ba45a55.url = "github:nixos/nixpkgs/ba45a55";
    nvim-cmp-nerdfont = {
      flake = false;
      url = "github:chrisgrieser/cmp-nerdfont";
    };
    nvim-conceal = {
      flake = false;
      url = "github:Jxstxs/conceal.nvim";
    };
    nvim-undotree = {
      flake = false;
      url = "github:jiaoshijie/undotree";
    };
    obsidian-nvim = {
      flake = false;
      url = "github:epwalsh/obsidian.nvim";
    };
    one-small-step-for-vimkind = {
      flake = false;
      url = "github:jbyuki/one-small-step-for-vimkind";
    };
    ranger-devicons = {
      flake = false;
      url = "github:alexanderjeurissen/ranger_devicons";
    };
    snowfall-lib = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:snowfallorg/lib";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:mic92/sops-nix";
    };
    tmux-session-wizard = {
      flake = false;
      url = "github:27medkamal/tmux-session-wizard";
    };
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    yanky-nvim = {
      flake = false;
      url = "github:gbprod/yanky.nvim";
    };
  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "ironman";
            title = "Ironman Home Config";
          };
          namespace = "ironman";
        };
      };
    in lib.mkFlake {
      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "openssl-1.1.1w" ];
      };

      homes.modules = with inputs; [ sops-nix.homeManagerModules.sops ];

      overlays = with inputs; [
        flake.overlays.default
        blockyalarm.overlays."package/blockyalarm"
      ];

      alias = { shells.default = "ironman-shell"; };
    };
}
