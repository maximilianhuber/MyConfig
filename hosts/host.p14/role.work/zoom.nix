# Copyright 2022 Maximilian Huber <oss@maximilian-huber.de>
# SPDX-License-Identifier: MIT
{ config, lib, pkgs, ... }:
let
  zoom-auto = (pkgs.writeShellScriptBin "zoom-auto"
''
set -euo pipefail

function convert_zoom_link_to_zoommtg() {
    local zoom_link="$1"
    local confno=$(echo "$zoom_link" | sed -n 's/.*\/j\/\([0-9]*\).*/\1/p')
    if [[ "$zoom_link" =~ .*pwd=.* ]]; then
        local pwd=$(echo "$zoom_link" | sed -n 's/.*pwd=\(.*\)/\1/p')
        echo "zoommtg://zoom.us/join?action=join&confno=$confno&pwd=$pwd"
    else
        echo "zoommtg://zoom.us/join?action=join&confno=$confno"
    fi
}

function open_zoom_link_in_zoom() {
    local zoom_link="$1"
    local zoommtg_link=$(convert_zoom_link_to_zoommtg "$zoom_link")
    echo "... opening zoom link in zoom ..."
    exec zoom-us "$zoommtg_link"
    exit 0
}

function test_for_zoom_link() {
    local args="$@"
    # bash check that args has no whitespace
    if [[ "$args" =~ ^https://.*zoom.us.*$ && ! "$args" =~ .*[[:space:]].* ]]; then
        echo "... starting zoom ..."
        open_zoom_link_in_zoom "$args"
    else
        echo "... no zoom link found"
    fi
}

echo "testing for secondary clipboard ..."
test_for_zoom_link "$(${pkgs.wl-clipboard}/bin/wl-paste || true)"
echo "testing for primary clipboard ..."
test_for_zoom_link "$(${pkgs.wl-clipboard}/bin/wl-paste -p || true)"
'');
in {
  config = {
    # nixpkgs.overlays = [
    #   # (self: super: {
    #   #   my-zoom-us = pkgs.master.zoom-us.overrideAttrs (old: {
    #   #     postFixup = let
    #   #       os-release = super.writeText "os-release" ''
    #   #         PRETTY_NAME="Debian GNU/Linux 10 (buster)"
    #   #         NAME="Debian GNU/Linux"
    #   #         VERSION_ID="10"
    #   #         ID=debian
    #   #       '';
    #   #     in old.postFixup + ''
    #   #       wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE
    #   #       wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE
    #   #       echo "${super.bubblewrap}/bin/bwrap --dev-bind / / --ro-bind ${os-release} /etc/os-release $out/bin/.zoom-us-wrapped" > $out/bin/bw-zoom-us
    #   #       chmod +x $out/bin/bw-zoom-us
    #   #     '';
    #   #   });
    #   # })
    # ];
    home-manager.sharedModules = [{
      home.packages = with pkgs; [ zoom-us zoom-auto ];
      xdg.mimeApps = {
        defaultApplications."x-scheme-handler/zoommtg" =
          [ "us.zoom.Zoom.desktop" ];
      };
    }];
  };
}
