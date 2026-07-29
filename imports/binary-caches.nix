{ pkgs, ... }:

{
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://cache.iog.io"
      "https://ormolu.cachix.org"
    ];
    trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "ormolu.cachix.org-1:0L9Y4A+6dGpvfGtaeaq5w44pgX0AVRivKMfi2fiOzYE="
      "markkarpov-sites.cachix.org-1:tzrAG4NHl/VkbtjotbuQJ7kCSaq/dkzj2IaSUgxo4Gs="
    ];
  };
}
