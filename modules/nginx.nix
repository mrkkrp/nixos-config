# Nginx configuration to help me preview my personal sites.
{ config, pkgs, ... }:
{
  services.nginx.virtualHosts = {
    # markkarpov.com on port 5000.
    "markkarpov-com" = {
      listen = [
        {
          addr = "localhost";
          port = 5000;
        }
      ];
      locations."/" = {
        root = "/home/mark/projects/mrkkrp/markkarpov.com/result/";
        index = "posts.html index.htm";
        extraConfig = "error_page 404 = /404.html;";
      };
      locations."/static/img/" = {
        alias = "/home/mark/projects/mrkkrp/markkarpov.com/static/img/";
      };
      locations."/static/" = {
        alias = "/home/mark/projects/mrkkrp/markkarpov.com/result/static/";
      };
    };
    # markkarpov.art on port 5001.
    "markkarpov-art" = {
      listen = [
        {
          addr = "localhost";
          port = 5001;
        }
      ];
      locations."/" = {
        root = "/home/mark/projects/mrkkrp/markkarpov.art/result/";
        index = "exhibitions.html index.htm";
        extraConfig = "error_page 404 = /404.html;";
      };
      locations."/static/img/" = {
        alias = "/home/mark/projects/mrkkrp/markkarpov.art/static/img/";
      };
      locations."/static/" = {
        alias = "/home/mark/projects/mrkkrp/markkarpov.art/result/static/";
      };
    };
  };
  services.nginx.user = "mark";
  services.nginx.enable = true;
  systemd.services.nginx.serviceConfig.ProtectHome = "read-only";
}
