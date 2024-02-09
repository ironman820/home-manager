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
      url = "https://flakehub.com/f/snowfallorg/flake/1.*.tar.gz";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://flakehub.com/f/nix-community/home-manager/0.2311.*.tar.gz";
    };
    nix-ld = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:mic92/nix-ld";
    };
    nixos-hardware.url = "https://flakehub.com/f/NixOS/nixos-hardware/0.1.*.tar.gz";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    # acc5f7b - IcedTea v8 Stable
    nixpkgs-acc5f7b.url = "https://flakehub.com/f/NixOS/nixpkgs/=0.2105.296223.tar.gz";
    # ba45a55 - The last stable update of PHP 7.4
    nixpkgs-ba45a55.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2205.384653.tar.gz";
    nixvim = {
      inputs.nixpkgs.follows = "unstable";
      url = "git+file:./packages/nvim";
    };
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
      url = "https://flakehub.com/f/snowfallorg/lib/2.*.tar.gz";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://flakehub.com/f/Mic92/sops-nix/0.1.*.tar.gz";
    };
    tmux-cheat-sh = {
      flake = false;
      url = "github:ironman820/tmux-cheat-sh";
    };
    tmux-fzf-url = {
      flake = false;
      url = "github:wfxr/tmux-fzf-url";
    };
    tmux-session-wizard = {
      flake = false;
      url = "github:27medkamal/tmux-session-wizard";
    };
    unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz";
    yanky-nvim = {
      flake = false;
      url = "github:gbprod/yanky.nvim";
    };
  };

  outputs = inputs: let
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
  in
    lib.mkFlake {
      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = ["openssl-1.1.1w" "electron-24.8.6"];
      };

      homes.modules = with inputs; [sops-nix.homeManagerModules.sops];

      overlays = with inputs; [
        flake.overlays.default
        blockyalarm.overlays."package/blockyalarm"
      ];

      alias = {shells.default = "ironman-shell";};
    };
}
