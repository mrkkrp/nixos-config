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
2          | 3 MiB     | 8300  | cryptsetup luks key
4          | remaining | 8300  | root file system

8300 is because the partitions are encrypted. The cryptsetup luks key
partition is 3 MiB so that it can fit the default 2 MiB LUKS header as well
as the key.

## LUKS disk encryption

Create an encrypted disk to hold our key, the key to this drive is what
you'll type in to unlock the rest of your drives. Remember it:

```console
$ cryptsetup luksFormat /dev/nvme0n1p2
$ cryptsetup luksOpen /dev/nvme0n1p2 cryptkey
```

Fill our key disk with random data, which will be our key:

```console
$ dd if=/dev/urandom of=/dev/mapper/cryptkey bs=1024 count=14000
```

Create an encrypted root with a key you can remember:

```console
$ cryptsetup luksFormat /dev/nvme0n1p4
```

Now add the cryptkey as a decryption key to the root partition, this way you
can only decrypt the cryptkey on startup, and use the cryptkey to decrypt
the root.

```console
$ cryptsetup luksAddKey /dev/nvme0n1p4 /dev/mapper/cryptkey
```

## File systems

Now we open the swap and the root and make some filesystems.

```console
$ cryptsetup luksOpen --key-file=/dev/mapper/cryptkey /dev/nvme0n1p3 cryptroot
$ mkfs.ext4 /dev/mapper/cryptroot
```

Rebuild the boot partition:

```console
$ mkfs.vfat /dev/nvme0n1p1
```

NOT CLEAR Then for a not fun bit, matching entries in `/dev/disk/by-uuid/`
to the partitions we want to mount where. Running `ls -l /dev/disk/by-uuid/`
shows which devices have which UUIDs. To determine what `dm-1` and `dm-2`, I
ran `ls -la /dev/mapper`.

Mount the decrypted cryptroot to `/mnt`:

```console
$ mount /dev/disk/by-uuid/FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF /mnt
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
# nano /mnt/etc/nixos/hardware-configuration.nix
# nano /mnt/etc/nixos/configuration.nix
```

Edit `hardware-configuration.nix` to setup the LUKS configuration:

```nix
{
  # cryptkey must be done first, and the list seems to be
  # alphabetically sorted, so take care that cryptroot / cryptswap,
  # whatever you name them, come after cryptkey.
  boot.initrd.luks.devices = {
    cryptkey = {
      device = "/dev/disk/by-uuid/BBBBBBBB-BBBB-BBBB-BBBB-BBBBBBBBBBBB";
    };
    cryptroot = {
      device = "/dev/disk/by-uuid/DDDDDDDD-DDDD-DDDD-DDDD-DDDDDDDDDDDD";
      keyFile = "/dev/mapper/cryptkey";
    };
  };
}
```

Edit the `configuration.nix` as needed to create a minimal system for
bootstrapping. Make sure that the system has `git` and a normal user.

It should already be correct, but check that:

* `fileSystems."/boot".device` refers to `/dev/disk/by-uuid/AAAA-AAAA`
* `fileSystems."/".device` refers to `/dev/disk/by-uuid/FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF`

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

Nix channels suck, so just clone the nixpkgs repo and checkout the commit
specified at the top of this page (or see [channels][channels] and
[howoldis][howoldis]):

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

[channels]: https://channels.nix.gsc.io
[howoldis]: https://howoldis.herokuapp.com/
