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
      ".claude/"
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
}
