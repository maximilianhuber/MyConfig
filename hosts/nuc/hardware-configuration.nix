# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/84fdea54-ba8f-4b5f-afc6-fac522e8e971";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/84fdea54-ba8f-4b5f-afc6-fac522e8e971";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/.snapshots" =
    { device = "/dev/disk/by-uuid/84fdea54-ba8f-4b5f-afc6-fac522e8e971";
      fsType = "btrfs";
      options = [ "subvol=@snapshots" ];
    };

  fileSystems."/.swapfile" =
    { device = "/dev/disk/by-uuid/84fdea54-ba8f-4b5f-afc6-fac522e8e971";
      fsType = "btrfs";
      options = [ "subvol=@swapfile" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8AC3-EFB4";
      fsType = "vfat";
    };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
