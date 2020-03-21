# NixOS instructions

**The current configuration is to be used with: `d96bd3394b734487d1c3bfbac0e8f17465e03afe`.**

See also: https://grahamc.com/blog/nixos-on-dell-9560

This document describes how to install [NixOS](https://nixos.org) and
configure it how I like it.

## Intro

Boot from installation medium. Use graphical installation medium, especially
if you'll need to use WiFi for internet connection. If you have UEFI system,
you should boot in UEFI mode. To use Dvorak keyboard layout in terminal,
execute:

```console
# loadkeys dvorak
```

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

```console
# mount /dev/nixos /mnt
```

Also mount the boot partition now to `/mnt/boot`:

```console
# mount /dev/boot /mnt/boot
```

Activate swap devices now:

```console
# spawon /dev/swapfile
```

## NixOS configuration

Generate initial configuration:

```console
# nixos-generate-config --root /mnt
# nano /mnt/etc/nixos/configuration.nix
```

Edit the `configuration.nix` as needed to create a minimal system for
bootstrapping. Make sure that the system will have `git` and a normal user.

Set `boot.loader.grub.device` to specify on which disk GRUB boot loader is
to be installed. Without it, NixOS cannot boot. This is only for BIOS
systems it seems.

If you have additional file systems (additional SSD/HDD drives) you want to
be mounted by default, add them to `fileSystems` (example is given in the
configuration). Add swap devices to `swapDevices`.

## Installation

Do the installation:

```console
# nixos-install
```

Enter root password when asked.

If everything went well, reboot:

```console
# reboot
```

## Clone nixpkgs repo

Nix channels suck, so just clone the nixpkgs repo and checkout some good
commit (see [channels][channels] and [howoldis][howoldis]):

```console
$ git clone git@github.com:nixos/nixpkgs.git nixpkgs
```

## Clone this repo

```console
$ mkdir -p ~/projects/mrkkrp
$ cd projects/mrkkrp
$ git clone git@github.com:mrkkrp/nixos-config.git nixos-config
```

Create a proper new configuration under `devices` using previously generated
`/etc/nixos/hardware-configuration.nix` and some of the existing
configurations for inspiration.

Build the system:

```consoule
# nixos-rebuild switch -I nixos-config=/home/mark/projects/mrkkrp/nixos-config/devices/<device>/configuration.nix
```

## Copy your SSH and GPG keys

Now is the right time to do that.

## Misc setup for normal user

This is done by running several bash scripts.

```console
$ cd nixos-config
$ ./emacs.sh
$ ./kde.sh
```

[channels]: https://channels.nix.gsc.io
[howoldis]: https://howoldis.herokuapp.com/
