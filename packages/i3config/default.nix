{ mutate, sakura, i3status, dmenu, lib }:
mutate ./config {
  inherit sakura i3status dmenu;
  i3status_conf = ./i3status;
}
