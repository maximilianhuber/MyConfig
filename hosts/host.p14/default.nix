# Copyright 2016-2017 Maximilian Huber <oss@maximilian-huber.de>
# SPDX-License-Identifier: MIT
{ config, pkgs, lib, myconfig, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../hardware/efi.nix
    ../../hardware/notebook-generic.nix
    {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.useDHCP = false;
      networking.interfaces.wlp0s20f3.useDHCP = true;
      # networking.interfaces.enp82s0u2u1u2.useDHCP = true;
    }
    ../../hardware/footswitch.nix
    ../../hardware/blink1.nix
    ../../hardware/unifying.nix
    ./hardware.hantek
    ./mykeylight
    ./role.work
    ./programs.khal.nix
    # ./a7iiiAsWebcam.nix
    {
      services.openssh = {
        listenAddresses = [{
          addr = "127.0.0.1";
          port = 22;
        }];
      };
    }
    {
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_testing;
      #       boot.kernelPatches = [{
      #         name = "i915-P14sG3-intel-fix";
      #         patch = pkgs.writeTextFile {
      #           name = "i915-P14sG3-intel-fix.patch";
      #           text = ''
      # diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
      # index 7d6eb9a..679cf36 100644
      # --- a/drivers/gpu/drm/i915/display/intel_bios.c
      # +++ b/drivers/gpu/drm/i915/display/intel_bios.c
      # @@ -2674,7 +2674,7 @@ static void parse_ddi_port(struct intel_bios_encoder_data *devdata)
      #  		drm_dbg_kms(&i915->drm,
      #  			    "More than one child device for port %c in VBT, using the first.\n",
      #  			    port_name(port));
      # -		return;
      # +		// return; // see https://gitlab.freedesktop.org/drm/intel/-/issues/5531#note_1477044
      #  	}

      #  	sanitize_device_type(devdata, port);
      # '';
      #         };
      #       }];
    }
    # fun
    ../host.workstation/gaming/games.steam
  ];

  config = {
    networking.hostName = "p14";
    networking.hostId = "1ea9689e";
    myconfig = {
      desktop = {
        enable = true;
        wayland = {
          enable = true;
          desktop = "sway";
          # river.enable = true;
          # qtile.enable = true;
        };
        imagework.enable = true;
        cad.enable = true;
      };
      email.enable = true;
      virtualisation.enable = true;
      dev = {
        compliance.enable = true;
        go.enable = true;
        haskell.enable = true;
        network.enable = true;
        nodejs.enable = true;
        # ruby.enable = true;
        rust.enable = true;
      };
    };
    virtualisation.docker.enable = true;
    virtualisation.podman.enable = true;
    # virtualisation.libvirtd.enable = true;
    # virtualisation.virtualbox.host.enable = true;
    #
    programs.sway.enable = true;

    services.xserver.wacom.enable = true;

    services.hardware.bolt.enable = true;

    services.logind.extraConfig = ''
      HandlePowerKey=suspend
      RuntimeDirectorySize=8G
    '';
    services.gnome.gnome-keyring.enable = true;

    home-manager.sharedModules = [
      {
        # home.file = {
        #   ".config/autorandr/" = {
        #     source = ./autorandr;
        #     recursive = true;
        #   };
        #   ".config/autorandr/mobile/postswitch.d/mykeylight-off".source = let
        #     script = with pkgs;
        #       writeShellScriptBin "script"
        #       "${mykeylight}/bin/mykeylight-off &disown";
        #   in "${script}/bin/script";
        #   ".config/electron-flags.conf".text = ''
        #     --enable-features=WaylandWindowDecorations
        #     --ozone-platform-hint=auto
        #   '';
        # };
        home.packages = with pkgs; [
          rdesktop
          google-chrome # for netflix and stadia
          comma
        ];
        programs.zsh.shellAliases = {
          upg-get-hostId = ''
            cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
          '';
        };
      }
      {
        services.kanshi.profiles = {
          # get list via "swaymsg -t get_outputs"
          undocked = {
            outputs = [{
              criteria = "eDP-1";
              mode = "1920x1200@60Hz";
              position = "0,0";
              scale = 1.0;
            }];
            exec = [ "${pkgs.mykeylight}/bin/mykeylight-off" ];
          };
        };
      }
    ];

    hardware.enableRedistributableFirmware = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = lib.mkForce "22.05"; # Did you read the comment?
  };
}
