# Copyright 2019 Maximilian Huber <oss@maximilian-huber.de>
# SPDX-License-Identifier: MIT
{ pkgs, ... }:
{
  imports = [
    # hardware:
    ./hardware/x1extremeG2.nix
    ./hardware/efi.nix
    ./hardware/exfat.nix
    # configuration
    ../modules/desktop
    ../modules/mail
    ../modules/dev
    ../modules/work
    ../modules/misc/service.openssh.nix
    ## fun
    ../modules/imagework
    ../modules/misc/smarthome.nix
    ../modules/gaming
  ];

  config = {
    boot.kernelPackages = pkgs.unstable.linuxPackages_latest;
    boot.initrd.supportedFilesystems = [ "luks" ];
    boot.initrd.luks.devices = [{
      device = "/dev/disk/by-uuid/2118a468-c2c3-4304-b7d3-32f8e19da49f";
      name = "crypted";
      preLVM = true;
      allowDiscards = true;
    }];

    # option definitions
    boot.kernel.sysctl = {
      "vm.swappiness" = 1;
    };
  };
}
