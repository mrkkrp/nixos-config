#!/usr/bin/env bash
#
# Configure XFCE4

set -e

mkdir -pv ~/.config/xfce4/terminal
cp -v files/.config/xfce4/terminal/terminalrc ~/.config/xfce4/terminal/terminalrc

cp -v files/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
cp -v files/.config/xfce4/xfconf/xfce-perchannel-xml/accessibility.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/accessibility.xml
cp -v files/.config/xfce4/xfconf/xfce-perchannel-xml/keyboards.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/keyboards.xml
cp -v files/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
