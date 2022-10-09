parted /dev/vda -- mklabel msdos
parted /dev/vda -- mkpart primary 1MB -8GB
parted /dev/vda -- mkpart primary linux-swap -8GB 100%
mkfs.ext4 -L nixos /dev/vda1
mkswap -L swap /dev/vda2
mount /dev/disk/by-label/nixos /mnt
swapon /dev/vda2
nixos-generate-config --root /mnt
nix-env -iA nixos.git
git clone https://github.com/spebern/nixos-config /mnt/etc/nixos/nixos-config
cd /mnt/etc/nixos/nixos-config
git checkout bold
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/nixos-config/hosts/vm/.
nixos-install --flake .#vm
