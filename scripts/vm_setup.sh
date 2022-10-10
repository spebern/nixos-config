parted /dev/sda -- mklabel msdos
parted /dev/sda -- mkpart primary 1MB -8GB
parted /dev/sda -- mkpart primary linux-swap -8GB 100%

mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2

mount /dev/disk/by-label/nixos /mnt
swapon /dev/sda2

nixos-generate-config --root /mnt

nix-env -iA nixos.git

git clone https://github.com/spebern/nixos-config /mnt/etc/nixos/nixos-config
cd /mnt/etc/nixos/nixos-config
git checkout bold

cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/nixos-config/hosts/vm/

nixos-install --flake .#vm
