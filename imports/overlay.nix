self: super:
{
  gitconfig = self.callPackage ./gitconfig { };
  mutate = self.callPackage ./mutate { };
  nixconfig = self.callPackage ./nixconfig { };
  coder_2_9_1 = self.callPackage ./coder { };
}
