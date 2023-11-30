# Copyright 2017 Maximilian nuber <oss@maximilian-huber.de>
# SPDX-License-Identifier: MIT
{ config, lib, pkgs, ... }:

let cfg = config.myconfig;
in {
  imports = [
    ./modules/services.pipewire.nix
    ./modules/hardware.pulseaudio.nix
    ./modules/services.pipewire.wireplumber.nix
  ];
  options.myconfig = with lib; {
    desktop.audio.enable = mkEnableOption "myconfig.desktop.audio" // {
      default = true;
      example = false;
    };
  };
  config = lib.mkIf (cfg.desktop.enable && cfg.desktop.audio.enable) {
    home-manager.sharedModules =
      [({config, ...}: {
        home.packages = with pkgs; [ pavucontrol pamix ];
        programs.cava = {
          enable = true;
        };
      })];

    # hardware.pulseaudio.enable = true;
    services.pipewire.enable = true;
  };
}
