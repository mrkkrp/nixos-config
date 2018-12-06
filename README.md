# NixOS instructions

This document describes how to install [NixOS](https://nixos.org) and
configure it how I like it.

## Intro

Boot from installation medium. If you have UEFI system, you should boot in
UEFI mode. To use Dvorak keyboard layout in terminal, execute:

```
# loadkeys dvorak
```

## Internet connection

Internet connection is necessary for the installation process. If you have
ethernet, that's good: internet should be already available, check it:

```
# ping 8.8.8.8
```

Otherwise, you'll probably want to use Wi-Fi. For that create
`/etc/wpa_supplicant.conf` with the following contents:

```
network={
  ssid="network-name"
  psk="password"
}
```

Then start `wpa_supplicant.service`:

```
# systemctl start wpa_supplicant.service
```

Strangely, if you try `ping 8.8.8.8` now it may still tell you that the
network is unreachable, but if you try e.g. `curl` you should find that it's
quite reachable (after that `ping` also starts working).

## Partitioning and formatting

* Use `lsblk` to see what devices/partitions you have.
* Use `fdisk` (BIOS) or `gdisk` (UEFI) to edit partition table of device you
  want to install NixOS to.
* Use `mkfs.ext4` and such to create file systems. It's a good idea to
  assign labels using the `-L` flag to make file system configuration
  independent from device changes. Let's assign `nixos` to the partition for
  NixOS and `boot` to boot partition.
* Use `mkswap` if you want to use swap, again let's use `-L` to assign label
  `swapfile`.

If you have UEFI system, you'll need a separate partition with partition
code EF00 (EFI system?) and it should be formatted as `vfat` file system
(use `mkfs.vfat`).

Mount the target file system on which NixOS shoud be installed on `/mnt`,
e.g.:

```
# mount /dev/nixos /mnt
```

Also mount the boot partition now to `/mnt/boot`:

```
# mount /dev/boot /mnt/boot
```

Activate swap devices now:

```
# spawon /dev/swapfile
```

## NixOS configuration

Generate initial configuration:

```
# nixos-generate-config --root /mnt
```

Use `configuration.nix` from this repo and edit it as needed:

```
# curl https://raw.githubusercontent.com/mrkkrp/nix-workstation/master/configuration.nix --output /mnt/etc/nixos/configuration.nix
# nano /mnt/etc/nixos/configuration.nix
```

Set `boot.loader.grub.device` to specify on which disk GRUB boot loader is
to be installed. Without it, NixOS cannot boot. This is only for BIOS
systems it seems.

If you have additional file systems (additional SSD/HDD drives) you want to
be mounted by default, add them to `fileSystems` (example is given in the
configuration). Add swap devices to `swapDevices`.

## Installation

Do the installation:

```
# nixos-install
```

Enter root password when asked.

If everything went well, reboot:

```
# reboot
```

## Add root channel

I use `nixos-unstable` usually (although lately it has become rather…
unstable):

```
# nix-channel --add https://nixos.org/channels/nixos-unstable nixos
```

## Copy your SSH and GPG keys

Now is the right time to do that.

## Misc setup for normal user

This is done by running several bash scripts.

```
$ git clone git@github.com:mrkkrp/nix-workstation.git ~/nix-workstation
$ cd nix-workstation
$ ./misc.sh
$ ./kde.sh
$ ./git.sh
$ ./emacs.sh
$ ./stack.sh
$ ./agda.sh
$ ./projects.sh
```

I usually create a hard link to `/etc/nixos/configuration.nix` so the file
in the repo is always up to date:

```
$ sudo ln /etc/nixos/configuration.nix configuration.nix
```
