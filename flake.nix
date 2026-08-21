{
  description = "Mark Karpov's NixOS configurations";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixpkgs-unstable";
    };
    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
    };
    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      type = "github";
      owner = "nix-community";
      repo = "plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, plasma-manager }@attrs: {
    nixosConfigurations = {
      pad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          ./devices/pad/configuration.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
          ./modules/common.nix
          ./modules/location-paris.nix
          ./modules/nginx.nix
          ./modules/steam.nix
        ];
      };
      frame = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          ./devices/frame/configuration.nix
          nixos-hardware.nixosModules.framework-16-amd-ai-300-series
          ./modules/common.nix
          ./modules/location-paris.nix
          ./modules/nginx.nix
        ];
      };
    };
  };
}
