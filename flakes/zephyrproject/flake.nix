{
  description = "my project description";

  inputs = {
    platformio-core.url = "github:platformio/platformio-core";
    platformio-core.flake = false;
  };

  outputs = { self, nixpkgs,  ... }@inputs:
    let
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
      systems = [ "x86_64-linux" ];
    in
    {
      nixosModule = { config, lib, pkgs, ... }: let
        platformio-udev-rules = pkgs.writeTextFile {
          name = "platformio-udev-rules";
          text = builtins.readFile "${inputs.platformio-core}/scripts/99-platformio-udev.rules";
          destination = "/etc/udev/rules.d/99-platformio.rules";
        };
        segger-modemmanager-blacklist-udev-rules = pkgs.writeTextFile {
          name = "segger-modemmanager-blacklist-udev-rules";
          # https://docs.zephyrproject.org/2.5.0/guides/tools/nordic_segger.html#gnu-linux
          text = "ATTRS{idVendor}==\"1366\", ENV{ID_MM_DEVICE_IGNORE}=\"1\"";
          destination = "/etc/udev/rules.d/99-segger-modemmanager-blacklist.rules";
        };
      in {
        nixpkgs.overlays = [ self.overlay ];
        home-manager.sharedModules = [{
          home.packages = (with pkgs; [
            my-west
            my-west-arm
            my-west-esp32
            my-minicom-esp32
            my-west-init my-west-update
            platformio openocd
            picocom
            my-jlink
            (writeShellScriptBin "flash-nrf52840dongle" ''
set -euo pipefail
in=build/zephyr/zephyr.hex
out=build/zephyr.zip
if [[ -f "$in" ]]; then
  set -x
  ${pkgs.nrfutil}/bin/nrfutil pkg generate --hw-version 52 --sd-req=0x00 \
          --application "$in" \
          --application-version 1 "$out"
  ${pkgs.nrfutil}/bin/nrfutil dfu usb-serial -pkg "$out" -p "''${1:-/dev/ttyACM0}"
else
  echo "\$in=$in not found"
fi
'')
          ]);
          home.sessionVariables = {
            ZEPHYR_BASE = "/home/mhuber/zephyrproject/zephyr";
            IDF_PATH = "/home/mhuber/zephyrproject/modules/hal/espressif";
            IDF_TOOLS_PATH = "/home/mhuber/zephyrproject/modules/hal/espressif/tools";
          };
        }];
        services.udev.packages = [ platformio-udev-rules segger-modemmanager-blacklist-udev-rules pkgs.openocd ];
      };

      overlay = import ./flake.overlay.nix inputs;

      packages = forAllSystems (system: {
        my-west = (import nixpkgs { inherit system; overlays = [ self.overlay ]; }).my-west;
        my-platformio-zephyr = (import nixpkgs { inherit system; overlays = [ self.overlay ]; }).my-platformio-zephyr;
        my-west-arm = (import nixpkgs { inherit system; overlays = [ self.overlay ]; }).my-west-arm;
        my-west-riscv = (import nixpkgs { inherit system; overlays = [ self.overlay ]; }).my-west-riscv;
        my-west-esp32 = (import nixpkgs { inherit system; overlays = [ self.overlay ]; }).my-west-esp32;
        my-minicom-esp32 = (import nixpkgs { inherit system; overlays = [ self.overlay ]; }).my-minicom-esp32;
        my-west-init = (import nixpkgs { inherit system; overlays = [ self.overlay ]; }).my-west-init;
        my-west-update = (import nixpkgs { inherit system; overlays = [ self.overlay ]; }).my-west-update;
        my-jlink = (import nixpkgs { inherit system; overlays = [ self.overlay ]; }).my-jlink;
      });

      defaultPackage = forAllSystems (system: self.packages.${system}.my-west-arm);

      defaultApp = forAllSystems (system: {
        type = "app";
        program = "${self.defaultPackage."${system}"}/bin/mywest";
      });

      devShell = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlay ];
            config.allowUnfree = true;
          };
        in pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            my-west
            my-platformio-zephyr
            my-west-arm
            my-west-riscv
            my-west-esp32
            my-west-update
            my-west-init
            my-minicom-esp32
            my-jlink
          ];
        }
      );
    };
}
