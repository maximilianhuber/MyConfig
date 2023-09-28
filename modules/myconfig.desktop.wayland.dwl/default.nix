# Copyright 2023 Maximilian Huber <oss@maximilian-huber.de>
# SPDX-License-Identifier: MIT
{ pkgs, config, lib, ... }:
let
  cfg = config.myconfig;
  mysomebar = (pkgs.somebar.overrideAttrs (prev: {
      version = "git";
      src = pkgs.fetchFromSourcehut {
        owner = "~raphi";
        repo = "somebar";
        rev = "8c52d4704c0ac52c946e41a1a68c8292eb83d0d2";
        hash = "sha256-9KYuX2bwRKiHiRHsFthdZ+TVkJE8Cjm+f78f9qhbB90=";
      };
      # patches = [
      #   (pkgs.fetchpatch {
      #         url = "https://git.sr.ht/~raphi/somebar/blob/master/contrib/clickable-tags-using-wtype.patch";
      #         hash = "sha256-4M59rZukfyJAXG7ZwMjgzeu8wQKx6F0OBVbaNw0xZ7k=";
      #       })
      # ];
  }));
  mydwl = (pkgs.dwl.overrideAttrs (prev: {
          version = "git";
          src = pkgs.fetchFromGitHub {
            owner = "djpohly";
            repo = "dwl";
            rev = "342850487acf4fc7383429786b9cb05a6a4cdf4f";
            hash = "sha256-qvW09Ge1Qt0Yg3K6TOD1msOxuk+pGucepNiCGhfrQwI=";
          };
          enableXWayland = true;
          # conf = ./config.h;
          patches = [
            (pkgs.fetchpatch {
              url = "https://github.com/djpohly/dwl/compare/main...sevz17:vanitygaps.patch";
              hash = "sha256-vLbdlLtBRUvvbccSpANEzgoPpwb5kxwGV0sZp9aZfvg=";
            })
            (pkgs.fetchpatch {
              url = "https://github.com/djpohly/dwl/compare/main...sevz17:autostart.patch";
              hash = "sha256-/vbVW9BJWmbrqajWpY/mUdYRze7yHOeh4CrBuBGpB0I=";
            })
            (pkgs.fetchpatch {
              url = "https://github.com/djpohly/dwl/compare/main...korei999:rotatetags.patch";
              hash = "sha256-SbtOIWodRrL+pnzaJfa3JMolLZpW5pXy2FXoxjMZC7U=";
            })
            (pkgs.fetchpatch {
              url = "https://github.com/djpohly/dwl/compare/main...NikitaIvanovV:centeredmaster.patch";
              hash = "sha256-k3pHs5E+MyagqvDGXi+HZYiKTG/WJlgqJqes7PN3uNs=";
            })
            # (pkgs.fetchpatch {
            #   url = "https://github.com/djpohly/dwl/compare/main...juliag2:alphafocus.patch";
            #   hash = "sha256-RXkA5jdDaHPKVlWgkiedFBpVXZBkuH66qMAlC6Eb+ug=";
            # })
           # (pkgs.fetchpatch {
           #    url = "https://github.com/djpohly/dwl/compare/main...dm1tz:04-cyclelayouts.patch";
           #    hash = "sha256-Xxi5ywqhVJgg+otjzKeGVMdgygKZdQS3r9Qd/XGc2OE=";
           #  })
          ];
      })).override { conf = ./config.h; };
  mydwl-autostart = pkgs.writeShellScriptBin "mydwl-autostart" ''
set -x
${cfg.desktop.wayland.autostartCommands}

${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
'';
  overlay = (_: super: {
        inherit mydwl;
        inherit mysomebar;
        mydwl-start = pkgs.writeShellScriptBin "mydwl-start" ''
PATH="$PATH:${mydwl-autostart}/bin"
exec ${mydwl}/bin/dwl -s ${mysomebar}/bin/somebar
'';
    });
in {
  options.myconfig = with lib; {
    desktop.wayland.dwl = { enable = mkEnableOption "dwl"; };
  };
  config =
    (lib.mkIf (cfg.desktop.wayland.enable && cfg.desktop.wayland.dwl.enable) {
      nixpkgs.overlays = [ overlay ];
      home-manager.sharedModules = [{ home.packages = with pkgs; [ mydwl mysomebar mydwl-start ]; }];
      services.xserver.windowManager.session = lib.singleton {
        name = "dwl";
        start = "${pkgs.mydwl-start}/bin/mydwl-start";
      };
    });
}
