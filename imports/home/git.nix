{ ... }:
{
  programs.git = {
    enable = true;
    signing = {
      key = "2889FF7C";
      signByDefault = true;
    };
    lfs.enable = true;
    ignores = [
      "*.sw*"
      ".DS_Store"
      ".#*"
      "\\#*#"
      "*~"
      "result"
      "result-*"
      ".flycheck_*"
    ];
    settings = {
      user = {
        name = "Mark Karpov";
        email = "markkarpov92@gmail.com";
      };
      magit.hideCampaign = true;
      rebase.autosquash = true;
      merge.conflictstyle = "diff3";
    };
  };

  # programs.git writes to ~/.config/git/config, not ~/.gitconfig. Git
  # reads both if present, with ~/.gitconfig taking precedence, so the old
  # symlink there (from the retired imports/gitconfig setup) would
  # silently shadow the settings above forever, since home-manager has no
  # other reason to touch that path. Claim it explicitly, empty.
  #
  # force = true because the existing ~/.gitconfig is a symlink left by the
  # old imports/symlinks setup: backupFileExtension only backs up plain
  # files, not symlinks, so without force this collides fatally instead of
  # being backed up.
  home.file.".gitconfig" = {
    text = "";
    force = true;
  };
}
