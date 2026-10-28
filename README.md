# Installing this config

Two-stage install: a quick `workmachine-lite` first, then the full `workmachine`.

## 0. Before you start

- Boot the NixOS minimal or graphical ISO in **UEFI** mode.
- Push the updated repo to GitHub (or keep it on a USB stick).
- Decide your options in `hosts/workmachine/default.nix`:

```nix
custom.nvidia = { enable = true; open = false; package = "legacy_580"; };
custom.login  = { manager = "qylock"; qylockTheme = "nier-automata"; }; # or "ly"/"gdm"
```

## 1. Network and Nix settings

```bash
sudo -i    # root shell for the whole install (env vars survive, no more sudo)

# Wi-Fi (skip if wired)
#   graphical ISO: nmcli device wifi connect "<SSID>" password "<password>"
#   minimal ISO:   wpa_cli  ->  add_network / set_network / enable_network
#                  (or: systemctl start wpa_supplicant first)

export NIX_CONFIG="experimental-features = nix-command flakes"
```

## 2. Partition and mount

Replace `/dev/nvme0n1` with your disk. This **erases it**.


```bash
cfdisk
# Chose three options: EFI system (vfat), Linux swap (swap) and Linux filesystem (ext4).

mkfs.fat -F 32 -n BOOT /dev/nvme0n1p1
mkswap -L swap /dev/nvme0n1p2
mkfs.ext4 -L nixos /dev/nvme0n1p3

mount /dev/nvme0n1p3 /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/boot
swapon /dev/nvme0n1p2
mount -t efivarfs efivarfs /sys/firmware/efi/efivars
```

## 3. Get the config

```bash
nix-shell -p git
git clone https://github.com/sora-yuka/nixos /mnt/etc/nixos
cd /mnt/etc/nixos
```

## 4. Regenerate hardware config

The committed `hardware-configuration.nix` has **UUIDs of the old machine**. On a new disk, regenerate it:

```bash
nixos-generate-config --root /mnt --show-hardware-config \
  > hosts/workmachine/hardware-configuration.nix
git add -A   # flakes only see tracked files
```

## 5. Install the lite variant

```bash
mkdir -p /mnt/tmp && export TMPDIR=/mnt/tmp   # keeps builds out of the ISO's RAM

nixos-install --flake /mnt/etc/nixos#workmachine-lite \
  --no-root-passwd \
  --option accept-flake-config true
```

`workmachine-lite` skips heavy and unfree apps (vscode, postman, browsers, ffmpeg-full, spicetify) and docs. The NVIDIA driver is still downloaded and built.

## 6. Set your user password

`--no-root-passwd` leaves root without a password, and `copa` has none yet either:

```bash
nixos-enter --root /mnt -c 'passwd copa'
```

Then `reboot` and remove the USB stick.

## 7. Switch to the full config

After logging in:

```bash
cd /etc/nixos
sudo nixos-rebuild switch --flake .#workmachine
```

Heavy apps download here. If it fails or is slow, just rerun it.

Also, you can set root password using command:
```bash
sudo passwd root
```

## Tips

- **See what will compile** before building:
  `nix build .#nixosConfigurations.workmachine-lite.config.system.build.toplevel --dry-run`
- **Don't run `nix flake update` right before installing.** A fresh `nixos-unstable` commit may not be built on Hydra yet, so you'd compile instead of download.
- **Out of memory on the ISO?** Keep `TMPDIR=/mnt/tmp` and use the swap partition (`swapon` above).
- **Switch login screen later:** change `custom.login.manager` and rebuild.
