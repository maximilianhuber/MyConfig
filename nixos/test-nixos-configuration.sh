#!/usr/bin/env bash
# see also: https://nixos.mayflower.consulting/blog/2018/09/11/custom-images/

help() {
    cat <<EOF
  $ $0 [--no-bc] [--ci] [--hostname hostname] [--check]
EOF
}

. "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/../common.sh"

set -e
ARGS=""
IN_CI=NO
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --no-bc)
            ARGS="$args --option binary-caches ''"
            shift
            ;;
        --check)
            ARGS="$args --check"
            shift
            ;;
        --ci)
            IN_CI=YES
            ;;
        --hostname)
            nixosConfig="$myconfigDir/nixos/host-${2}.nix"
            if [[ ! -f "$nixosConfig" ]]; then
                help
                exit 2
            fi
            shift
            shift
            ;;
        *)
            help
            exit 1
            ;;
    esac
done
NIX_PATH_ARGS="-I nixpkgs=$nixpkgs -I nixos-config=$nixosConfig"

if [[ "$IN_CI" == "YES" ]]; then
    cat <<EOF > "$myconfigDir/imports/dummy-hardware-configuration.nix"
{...}: {
  fileSystems."/" = { device = "/dev/sdXX"; fsType = "ext4"; };
  fileSystems."/boot" = { device = "/dev/sdXY"; fsType = "vfat"; };
  boot.loader.grub.devices = [ "/dev/sdXY" ];
}
EOF
fi

set -x

time \
    nix-build '../nixpkgs/nixos' \
              $NIX_PATH_ARGS \
              $ARGS \
              -A system \
              --no-out-link \
              --show-trace --keep-failed \
              --arg configuration "$nixosConfig"
