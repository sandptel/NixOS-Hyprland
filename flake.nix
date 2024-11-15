{
  description = "KooL's NixOS-Hyprland";

  inputs = {
    elanmoc2.url= github:sandptel/elanmoc2;
    nixpkgs.url = "github:NixOS/nixpkgs/24f0d4acd634792badd6470134c387a3b039dace";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    #catppuccin.url = "github:catppuccin/nix";
    #wallust.url = "git+https://codeberg.org/explosion-mental/wallust?ref=dev";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland/940ed3d525d838bc255070bd8cfc2f75df04229a"; # hyprland development
#    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";
    nixos-grub-themes.url = "github:jeslie0/nixos-grub-themes";
     grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
    };
    #hypr-contrib.url = "github:hyprwm/contrib";
    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  #  home-manager.url = "github:nix-community/home-manager/master";
  #  home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    wezterm.url = "github:wez/wezterm?dir=nix";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
   };
    nixos-boot.url = "github:Melkor333/nixos-boot";
    #zen-browser.url = "github:MarceColl/zen-browser-flake";
#    nvf = {
#        url = "github:notashelf/nvf";
#        inputs.nixpkgs.follows = "nixpkgs";
#    };
};
  outputs =
    inputs @ { self
    , nixpkgs
    , ...
    }:
    let
      system = "x86_64-linux";
      host = "default";
      username = "roronoa";
      #defaultPackage.x86_64-linux = wezterm.packages.x86_64-linux.default;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit inputs;
            inherit username;
            inherit host;
          };
          modules = [
            ./hosts/${host}/config.nix
            inputs.nixos-boot.nixosModules.default
 #           inputs.distro-grub-themes.nixosModules.${system}.default
            inputs.grub2-themes.nixosModules.default
            inputs.spicetify-nix.nixosModules.default
            inputs.chaotic.nixosModules.default
            inputs.elanmoc2.nixosModules.elanmoc2
            #inputs.zen-browser.packages."${system}".default
            #inputs.stylix.nixosModules.default
            #inputs.catppuccin.homeManagerModules.catppuccin
            { nixpkgs.overlays = [ inputs.hyprpanel.overlay ]; }
          ];
        };
      };
    };
}
