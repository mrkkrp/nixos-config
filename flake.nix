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
      pad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          ./devices/pad/configuration.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
          ./imports/common.nix
          ./imports/location-paris.nix
          ./imports/nginx.nix
          ./imports/pipewire.nix
          ./imports/printer.nix
          ./imports/iohk-binary-cache.nix
          ./imports/for-client.nix
          ./imports/steam.nix
        ];
      };
    };
  };
}
