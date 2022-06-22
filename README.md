# NixOS instructions

This document describes how to install [NixOS](https://nixos.org) and
configure it.

## Intro

* Disable the secure boot.
* Disable the RAID mode (e.g. System Configuration -> SATA Operation ->
  Select AHCI.).
* If you have a UEFI system, you should boot in the UEFI mode.
* Boot from your installation medium. Use the graphical installation medium,
  because it provides an easier interface for turning on WiFi.

## Partitioning and formatting

* Use `lsblk` to see what devices/partitions you have.
* If you don't have devices at `/dev/nvme_*` you forgot to turn off the RAID
  mode.
* Use `fdisk` (BIOS) or `gdisk` (UEFI) to edit the partition table.

Partition  | Size      |  Code | Purpose
:----------|:----------|:------|:-------------
1          | 500 MiB   | EF00  | EFI partition
2          | remaining | 8300  | root file system

## LUKS disk encryption

Create an encrypted root with a key you can remember:

```console
# cryptsetup luksFormat /dev/nvme0n1p2
```

Then open it:

```console
# cryptsetup luksOpen /dev/nvme0n1p2 cryptroot
```

## File systems

Create the file system for the root partition:

```console
# mkfs.ext4 /dev/mapper/cryptroot
```

Rebuild the boot partition:

```console
# mkfs.vfat /dev/nvme0n1p1
```

Check the disk mapping:

```console
$ ls -l /dev/disk/by-uuid/
```

Decrypted root partition will be the one that is linked to something like
`dm-0`. You can confirm it by running:

```console
$ ls -la /dev/mapper
```

Mount the decrypted cryptroot to `/mnt`:

```console
# mount /dev/disk/by-uuid/<the-uuid> /mnt
```

Setup and mount the boot partition:

```console
# mkdir /mnt/boot
# mount /dev/disk/by-uuid/AAAA-AAAA /mnt/boot
```

## Initial configuration

Generate an initial configuration:

```console
# nixos-generate-config --root /mnt
```

Hardware configuration should already be OK. Edit the
`/mnt/etc/nixos/configuration.nix` as needed to create a minimal system for
bootstrapping:

* Make sure that the system has `git` and a normal user.
* Make sure to set `networking.networkmanager.enable = true`, otherwise you
  won't have WiFi when you boot into your new system.
* Make sure to enable SDDM and Plasma (just uncomment the relevant lines in
  the template).

## Installation

Do the installation:

```console
# nixos-install
```

Enter the root password when asked. Reboot.

## Setting password for the normal user

It may be necessary to first login as `root` and set password for the normal
user with the `passwd` command. After that you can re-login as the normal
user.

## Copy your SSH and GPG keys

Now is the right time to do that. Be sure to set `600` mode for
`~/.ssh/id_rsa`:

```console
$ chmod 600 ~/.ssh/id_rsa
```

## The final rebuild

Clone this repo:

```console
$ mkdir -p ~/projects/mrkkrp
$ cd ~/projects/mrkkrp
$ git clone git@github.com:mrkkrp/nixos-config.git nixos-config
```

Create a new configuration under `devices` by copying the previously
generated `etc/nixos/configuration.nix` and
`/etc/nixos/hardware-configuration.nix`. Add a new entry in `flake.nix`
following the existing examples.

Build the system (execute from `~/projects/mrkkrp/nixos-config`):

```consoule
$ nixos-rebuild --use-remote-sudo switch --flake .#<hostname>
```

Reboot.

## Update

To update the system do:

```console
$ nixos-switch
```
