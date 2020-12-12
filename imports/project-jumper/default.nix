pkgs:

let source = pkgs.fetchFromGitHub {
      owner = "mrkkrp";
      repo = "project-jumper";
      rev = "cf98d0e0f37b8b456ef0e73c30214e8566fc64ce";
      sha256 = "sha256-BnLXip3QjBI//BLeEbI0CVA7v+UhS1DKZNmZYQ0CN7E=";
    };
in pkgs.haskellPackages.callCabal2nix "project-jumper" source {}
