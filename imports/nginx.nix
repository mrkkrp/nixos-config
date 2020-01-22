# Nginx configuration to help me preview my personal site.
{ config, pkgs, ... }:
{
  services.nginx.virtualHosts = {
    "localhost" = {
       listen = [
         {
           addr = "localhost";
           port = 5000;
         }
       ];
       locations."/" = {
         root = "/home/mark/projects/mrkkrp/markkarpov.com/_build/";
         index = "posts.html index.htm";
         extraConfig = "error_page 404 = /404.html;";
       };
    };
  };
  services.nginx.user = "mark";
  services.nginx.enable = true;
}
