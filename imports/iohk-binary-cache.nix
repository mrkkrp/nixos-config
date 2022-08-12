{ pkgs, ... }:

{
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://cache.iog.io"
    ];
    trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
  };
}
