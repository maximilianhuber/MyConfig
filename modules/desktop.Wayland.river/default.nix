# Copyright 2017 Maximilian Huber <oss@maximilian-huber.de>
# SPDX-License-Identifier: MIT
{ pkgs, config, lib, ... }: 
let cfg = config.myconfig;
    riverPackage = pkgs.callPackage ./wrapper.nix {
      river-unwrapped = pkgs.river;
      withBaseWrapper = true;
      extraPaths= with pkgs; [
        foot
        # https://github.com/riverwm/river/wiki/Recommended-Software
        ## Output configuration
        wlopm wlr-randr kanshi way-displays
        ## statusbar
        waybar
        ## Program Launchers
        bemenu fuzzel
        ## Other
        ristate
        wayshot
      ];
      extraSessionCommands = ''
        export XKB_DEFAULT_LAYOUT=de
        export XKB_DEFAULT_VARIANT=neo
      '';
      withGtkWrapper = true;
      extraOptions = [];
    };
in {
  options.myconfig = with lib; { river.enable = mkEnableOption "river"; };
  config = (lib.mkIf cfg.river.enable {
    home-manager.sharedModules = [{
      home.file = {
        ".config/river/init".source = ./river/init;
        ".config/waybar/config".source = ./waybar/config;
      };
      home.packages = with pkgs; [
        riverPackage
      ];
    }];
    services= {
      xserver.displayManager.sddm = {
        settings = {
          General.DefaultSession = "river.desktop";
        };
      };
    };
    services.xserver.displayManager.sessionPackages = [ riverPackage ];
    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${riverPackage}/bin/river";
          user = "mhuber";
        };
        default_session = initial_session;
      };
    };
  });
}
