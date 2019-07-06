self: super:
{
  gitconfig = self.callPackage ./gitconfig { };
  i3config = self.callPackage ./i3config { };
  mutate = self.callPackage ./mutate { };
  nixconfig = self.callPackage ./nixconfig { };
}
