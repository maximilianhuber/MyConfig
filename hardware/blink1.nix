{ config, lib, pkgs, ... }:
let user = config.myconfig.user;
in {
  config = {
    nixpkgs.config.packageOverrides = pkgs: {
      blink1-udev-rules = pkgs.writeTextFile {
        name = "blink1-udev-rules";
        text = ''
          # Copy this udev with "sudo cp 51-blink1.rules /etc/udev/rules.d/"
          # Edit it to suit your type of Linux. It's currently set up for modern Ubuntu
          # When done, do "sudo udevadm control --reload"
          # and unplug and replug in the blink1 device.

          # Note the hex values for vid & pid must be lower-case
          # SYSFS{idVendor}=="27b8", SYSFS{idProduct}=="01ed", MODE="666"
          #ATTRS{idVendor}=="27b8", ATTRS{idProduct}=="01ed", SUBSYSTEMS=="usb", ACTION=="add", MODE="0666", GROUP="plugdev"

          # modern ubuntu
          #SUBSYSTEM=="input", GROUP="input", MODE="0666"
          ATTRS{idVendor}=="27b8", ATTRS{idProduct}=="01ed", MODE:="666", GROUP="plugdev"
          #KERNEL=="hidraw*", ATTRS{idVendor}=="27b8", ATTRS{idProduct}=="01ed", MODE="0666", GROUP="plugdev"
                  '';
        destination = "/etc/udev/rules.d/51-blink1.rules";
      };
    };
    services.udev.packages = with pkgs; [ blink1-udev-rules ];
    environment.systemPackages = with pkgs; [ blink1-udev-rules blink1-tool ];

    home-manager.users."${user}" = {
      home.file = {
        ".config/autorandr/postswitch.d/reset_blink1".source = let
          muteNotebookAudio = with pkgs;
            writeShellScriptBin "reset_blink1" ''
              ${blink1-tool}/bin/blink1-tool --off &disown
            '';
        in "${muteNotebookAudio}/bin/reset_blink1";
      };
    };
  };
}
