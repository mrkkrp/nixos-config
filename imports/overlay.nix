self: super:
{
  gitconfig = self.callPackage ./gitconfig { };
  mutate = self.callPackage ./mutate { };
  nixconfig = self.callPackage ./nixconfig { };
  coder_2_14_3 = self.callPackage ./coder { };
}
