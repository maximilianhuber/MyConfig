# Copyright 2017-2018 Maximilian Huber <oss@maximilian-huber.de>
# SPDX-License-Identifier: MIT
{ config, lib, pkgs, ... }:

{
  options = {
    myconfig.roles.work = {
      enable = lib.mkEnableOption "Work role";
    };
  };

  config = lib.mkIf config.myconfig.roles.work.enable {
    environment.systemPackages = with pkgs; [
      thunderbird
      openvpn networkmanager_openvpn
      # rdesktop
      unstable.openjdk unstable.maven unstable.gradle
      libreoffice
      unstable.zoom-us rambox # franz hipchat
      p7zip
      thrift93
      idea-ultimate
      dia
    ];
    # services.nfs.server.enable = true;
    # services.nfs.server.exports = "";
  };
}
