# Copyright 2016-2017 Maximilian Huber <oss@maximilian-huber.de>
# SPDX-License-Identifier: MIT
{ config, pkgs, lib, myconfig, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../hardware/efi.nix
    ../../hardware/nixos-hardware/common/pc/ssd
    # (myconfig.metadatalib.fixIp "enp39s0")
    # (myconfig.metadatalib.setupAsBuildMachine [
    #   myconfig.metadatalib.get.hosts.x1extremeG2.pubkeys."id_ed25519.pub"
    #   myconfig.metadatalib.get.hosts.x1extremeG2.pubkeys."id_rsa.pub"
    # ])
    ({
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;
  networking.interfaces.wwp0s20f0u5c2.useDHCP = true;

     })
  ];

  config = {
    networking.hostName = "spare";
    networking.hostId = "13942153";
    myconfig = {
      # desktop.enable = true;
      headless.enable = true;
      # virtualisation.enable = true;
    };
    # virtualisation.docker.enable = true;

    services.logind.extraConfig = ''
      HandlePowerKey=suspend
    '';

    boot.initrd.supportedFilesystems = [ "luks" ];
    boot.initrd.luks.devices.crypted = {
      device = "/dev/disk/by-uuid/2118a468-c2c3-4304-b7d3-32f8e19da49f";
      preLVM = true;
      allowDiscards = true;
    };

    hardware.enableRedistributableFirmware = true;

    boot.initrd.supportedFilesystems = [ "luks" "btrfs" ];

    # services.snapper = {
    #   snapshotInterval = "hourly";
    #   cleanupInterval = "1d";
    #   filters = null;
    #   configs = {
    #     home = {
    #       subvolume = "/home";
    #       extraConfig = ''
    #         ALLOW_USERS="${myconfig.user}"
    #       '';
    #     };
    #   };
    # };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = lib.mkForce "21.05"; # Did you read the comment?
  };
}
