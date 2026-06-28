self: super:
{
  gitconfig = self.callPackage ./gitconfig { };
  mutate = self.callPackage ./mutate { };
  nixconfig = self.callPackage ./nixconfig { };
}
