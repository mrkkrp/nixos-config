# NixOS instructions

**The current configuration is to be used with: `d96bd3394b734487d1c3bfbac0e8f17465e03afe`.**

See also: https://grahamc.com/blog/nixos-on-dell-9560

This repo describes how to install [NixOS](https://nixos.org) and configure
it.

## Intro

* Disable secure boot.
* Disable RAID mode (e.g. System Configuration -> SATA Operation -> Select
  AHCI.).
* If you have a UEFI system, you should boot in UEFI mode.
* Boot from installation medium. Use graphical installation medium,
  especially if you'll need to use WiFi for internet connection.

## Partitioning and formatting

* Use `lsblk` to see what devices/partitions you have.
* If you don't have devices at `/dev/nvme_*` you forgot to turn off RAID
  mode.
* Use `fdisk` (BIOS) or `gdisk` (UEFI) to edit partition table of device you
  want to install NixOS to.

Partition  | Size      |  Code | Purpose
:----------|:----------|:------|:-------------
1          | 500 MiB   | EF00  | EFI partition
2          | remaining | 8300  | root file system

## LUKS disk encryption

Create an encrypted root with a key you can remember:

```console
$ cryptsetup luksFormat /dev/nvme0n1p2
```

Then open it:

```console
$ cryptsetup luksOpen /dev/nvme0n1p2 cryptroot
```

## File systems

Create the file system for the root partition:

```console
$ mkfs.ext4 /dev/mapper/cryptroot
```

Rebuild the boot partition:

```console
$ mkfs.vfat /dev/nvme0n1p1
```

Check the disk mapping:

```console
$ ls -l /dev/disk/by-uuid/
```

Descrypted root partition will be the one that is linked to something like
`dm-0`. You can confirm it by running:

```console
$ ls -la /dev/mapper
```

Mount the decrypted cryptroot to `/mnt`:

```console
$ mount /dev/disk/by-uuid/<the-uuid> /mnt
```

Setup and mount the boot partition:

```console
$ mkdir /mnt/boot
$ mount /dev/disk/by-uuid/AAAA-AAAA /mnt/boot
```

## Initial configuration

Generate initial configuration:

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

Enter root password when asked.

If everything went well, reboot.

## Setting password for the normal user

It may be necessary to first login as `root` and set password for the normal
user with the `passwd` command. After that you can re-login as the normal
user.

## Copy your SSH and GPG keys

Now is the right time to do that.

## The final rebuild

Nix channels suck, so just clone the nixpkgs repo and checkout the commit
specified at the top of this page (or see [channels][channels] and
[howoldis][howoldis]):

```console
$ git clone git@github.com:nixos/nixpkgs.git nixpkgs
$ git checkout <see-top-of-the-page>
```

Clone this repo:

```console
$ mkdir -p ~/projects/mrkkrp
$ cd ~/projects/mrkkrp
$ git clone git@github.com:mrkkrp/nixos-config.git nixos-config
```

Create a proper new configuration under `devices` by copying previously
generated `/etc/nixos/hardware-configuration.nix` and re-using some of the
existing configurations.

Build the system:

```consoule
# nixos-rebuild switch \
  -I nixos-config=/home/mark/projects/mrkkrp/nixos-config/devices/<device>/configuration.nix \
  -I nixpkgs=/home/mark/nixpkgs
```

Reboot.

[channels]: https://channels.nix.gsc.io
[howoldis]: https://howoldis.herokuapp.com/
