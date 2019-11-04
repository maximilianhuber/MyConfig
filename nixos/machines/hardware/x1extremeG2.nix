# Copyright 2017 Maximilian Huber <oss@maximilian-huber.de>
# SPDX-License-Identifier: MIT
{ config, lib, pkgs, ... }:

#
#
# Hardware:
#   Thinkpad X1 Extreme Generation 2
#
#

let
  ##############################################################################
  # Graphics:
  # See also:
  # - https://nixos.wiki/wiki/Nvidia
  # - https://nixos.org/nixos/manual/#sec-x11-graphics-cards-nvidia
  ##############################################################################
  # Only nvidia
  rawNvidiaConf = {
    services.xserver = {
      videoDrivers = [ "nvidia" ];
      # # screenSection = ''
      # #   Identifier     "Screen1"
      # #   Device         "Device1"
      # #   Monitor        "Monitor1"
      # #   DefaultDepth    24
      # #   Option         "Stereo" "0"
      # #   Option         "nvidiaXineramaInfoOrder" "DFP-2"
      # #   Option         "metamodes" "HDMI-0: nvidia-auto-select +0+0, DP-0: nvidia-auto-select +2560+0"
      # #   Option         "SLI" "Off"
      # #   Option         "MultiGPU" "Off"
      # #   Option         "BaseMosaic" "off"
      # # '';
      # # extraDisplaySettings = ''
      # #   Depth       24
      # # '';
      # # # monitorSection = ''
      # # # '';
      # deviceSection = ''
      #   Identifier     "Device1"
      #   Driver         "nvidia"
      #   VendorName     "NVIDIA Corporation"
      #   BoardName      "GeForce GTX 1650"
      # '';
    };
  };
  ##############################################################################
  # Bumblebee
  bumblebeeConf = {
    hardware.bumblebee.enable = true;
    environment.systemPackages = with pkgs; [ bumblebee xorg.xf86videointel ];
  };
  ##############################################################################
  # Optimus Prime
  optimusPrimeConf = {
    services.xserver.videoDrivers = [ "intel" "nvidia" ];
    hardware.nvidia = {
      optimus_prime = {
        enable = true;
        # sync.enable = true;
        # offload.enable = true; # see: https://github.com/NixOS/nixpkgs/pull/66601

        # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
        nvidiaBusId = "PCI:1:0:0";
        # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
        intelBusId = "PCI:0:2:0";
      };
      modesetting.enable = true;
    };
  };
  ##############################################################################
in {
  imports = [
    ./notebook-generic.nix
    ./ssd.nix
    ./lowres.nix
    ./nixos-hardware/lenovo/thinkpad/x1-extreme/gen2/default.nix

    { # config for libinput
      config = lib.mkIf (config.services.xserver.libinput.enable) {
        services.xserver.libinput.accelSpeed = "0.15";
      };
    }
    {
      # Blacklist nouveau
      boot.extraModprobeConfig = "install nouveau /run/current-system/sw/bin/false";
      boot.blacklistedKernelModules = ["nouveau"];
    }

    ############################################################################
    # chosen graphics driver setup:
    # bumblebeeConf
    optimusPrimeConf
    # rawNvidiaConf
  ];

  nix.buildCores = 8;

  boot.extraModprobeConfig = ''
    options snd slots=snd-hda-intel
  '';
}
