pkgs:

pkgs.stdenv.mkDerivation {
  pname = "project-jumper";
  version = "0.0.1.0";
  src = ./.;
  buildPhase = ''
    runHook preBuild
    $CC -O2 -Wall -Wextra -Werror -o project-jumper main.c
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    install -Dm755 project-jumper $out/bin/project-jumper
    runHook postInstall
  '';
  meta = with pkgs.lib; {
    description = "A utility for jumping to local project directories";
    homepage = "https://github.com/mrkkrp/nixos-config";
    license = licenses.bsd3;
    mainProgram = "project-jumper";
    platforms = platforms.unix;
  };
}
