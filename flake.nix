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
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2311.*.tar.gz";
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

  outputs = {self, ...} @ inputs: let
    inherit (builtins) listToAttrs map;
    inherit (inputs.nixpkgs) lib;
    inherit (lib.lists) forEach;

    defaultImports = {
      inherit overlays;
      inherit (systemSettings) system;

      channels-config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        permittedInsecurePackages = ["openssl-1.1.1w"];
      };
    };

    hostSystems = [
      "ironman@docker"
      "ironman@friday"
      "ironman@git-home"
      "ironman@ironman-laptop"
      "ironman@pdns-home"
      "ironman@pdns-work"
      "ironman@pxe-home"
      "ironman@pxe-work"
      "ironman@qc-work"
      "ironman@rcm-work"
      "ironman@rcm2-home"
      "ironman@rcm2-work"
      "ironman@tdarr2"
      "ironman@traefik-work"
      "niceastman@e105-laptop"
      "nixos@liveiso"
      "royell@health"
      "royell@pass"
      "royell@zabbix"
    ];

    overlayList = [];

    overlays =
      [
        inputs.flake.overlays.default
        (import ./lib {})
      ]
      ++ forEach overlayList (layer:
        import ./overlays/${layer} {
          inherit inputs self;
          inherit (systemSettings) system;
        });

    packageList = [];

    pkgs = import inputs.nixpkgs defaultImports;

    systemSettings = {
      locale = "en_US.UTF-8";
      modules = with inputs; [
        sops-nix.homeManagerModules.sops
        ./modules
      ];

      system = "x86_64-linux";
      timezone = "America/Chicago";
    };

    userSettings = rec {
      wm = "hyprland";
      wmType =
        if (wm == "hyprland")
        then "wayland"
        else "x11";
      browser = "floorp";
      term = "alacritty";
      editor = "nvim";

      spawnEditor =
        if (editor == "emacsclient")
        then "emacsclient -c -a 'emacs'"
        else
          (
            if
              ((editor == "vim")
                || (
                  editor == "nvim"
                )
                || (editor == "nano"))
            then "exec " + term + " -e " + editor
            else editor
          );
      font = "FiraCode Nerd Font Retina";
      fontPkg = pkgs.nerdfonts;
    };
  in {
    inherit lib pkgs;

    # overlays = with inputs; [
    #   blockyalarm.overlays."package/blockyalarm"
    # ];

    # alias = {shells.default = "ironman-shell";};

    homeConfigurations = listToAttrs (map (sys: {
        name = sys;
        value = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          inherit (systemSettings) system;
          extraSpecialArgs = {
            inherit inputs pkgs self systemSettings userSettings;
            inherit (pkgs) lib;
          };
          modules = ["./homes/${sys}"] ++ systemSettings.modules;
        };
      })
      hostSystems);

    packages.${systemSettings.system} = listToAttrs (map (pkg: {
        name = pkg;
        value = import ./packages/${pkg} {inherit inputs pkgs;};
      })
      packageList);
  };
}
