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
    ormolu = {
      type = "github";
      owner = "tweag";
      repo = "ormolu";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, ormolu }@attrs: {
    nixosConfigurations = {
      old = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          ./devices/old/configuration.nix
          ./imports/common.nix
          ./imports/location-paris.nix
          ./imports/nginx.nix
          ./imports/pulseaudio.nix
          ./imports/iohk-binary-cache.nix
        ];
      };

      pad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          ./devices/pad/configuration.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
          ./imports/common.nix
          ./imports/location-paris.nix
          ./imports/nginx.nix
          ./imports/pulseaudio.nix
          ./imports/iohk-binary-cache.nix
          ./imports/for-client.nix
        ];
      };
    };
  };
}
