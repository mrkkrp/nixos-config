{ config, lib, pkgs, ... }:

with lib;

let
  usersWithKeys = attrValues (flip filterAttrs config.users.users (n: u:
    u.symlinks != { }
  ));

  activationScriptForUser = user: flip mapAttrsToList user.symlinks (reltarget: src:
    "update_symlink \"${user.name}\" \"${src}\" \"${user.home}/${reltarget}\""
  );

  activationScript = ''
    ${builtins.readFile ./update-symlinks.sh}
    ${concatStringsSep "\n" (flatten (map activationScriptForUser usersWithKeys))}
  '';
in
{
  options = {

    users.users = mkOption {
      type = with types; loaOf (submodule {
        options.symlinks = mkOption {
          default = { };
          description = ''
            An attrset of relative paths and targets to symlink in to
            the user's HOME.
          '';
        };
      });
    };
  };

  config = ({
    system.activationScripts.usersymlinks = activationScript;
  });
}
