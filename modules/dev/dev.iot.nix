# Copyright 2017-2019 Maximilian Huber <oss@maximilian-huber.de>
# SPDX-License-Identifier: MIT
{ pkgs, config, lib, ... }:
let
  cfg = config.myconfig.dev.iot;
  platformio-udev-rules = pkgs.writeTextFile {
    name = "platformio-udev-rules";
    # see: https://docs.platformio.org/en/latest/faq.html#platformio-udev-rules
    #   see: https://raw.githubusercontent.com/platformio/platformio-core/master/scripts/99-platformio-udev.rules
    text = ''
      # Copyright (c) 2014-present PlatformIO <contact@platformio.org>
      #
      # Licensed under the Apache License, Version 2.0 (the "License");
      # you may not use this file except in compliance with the License.
      # You may obtain a copy of the License at
      #
      #    http://www.apache.org/licenses/LICENSE-2.0
      #
      # Unless required by applicable law or agreed to in writing, software
      # distributed under the License is distributed on an "AS IS" BASIS,
      # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
      # See the License for the specific language governing permissions and
      # limitations under the License.

      #####################################################################################
      #
      # INSTALLATION
      #
      # Please visit > https://docs.platformio.org/en/latest/faq.html#platformio-udev-rules
      #
      #####################################################################################

      #
      # Boards
      #

      # CP210X USB UART
      ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", MODE:="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # FT231XS USB UART
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE:="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Prolific Technology, Inc. PL2303 Serial Port
      ATTRS{idVendor}=="067b", ATTRS{idProduct}=="2303", MODE:="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # QinHeng Electronics HL-340 USB-Serial adapter
      ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", MODE:="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Arduino boards
      ATTRS{idVendor}=="2341", ATTRS{idProduct}=="[08][02]*", MODE:="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"
      ATTRS{idVendor}=="2a03", ATTRS{idProduct}=="[08][02]*", MODE:="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Arduino SAM-BA
      ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="6124", MODE:="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{MTP_NO_PROBE}="1"

      # Digistump boards
      ATTRS{idVendor}=="16d0", ATTRS{idProduct}=="0753", MODE:="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Maple with DFU
      ATTRS{idVendor}=="1eaf", ATTRS{idProduct}=="000[34]", MODE:="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # USBtiny
      ATTRS{idProduct}=="0c9f", ATTRS{idVendor}=="1781", MODE:="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # USBasp V2.0
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05dc", MODE:="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Teensy boards
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"
      ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
      KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

      #TI Stellaris Launchpad
      ATTRS{idVendor}=="1cbe", ATTRS{idProduct}=="00fd", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      #TI MSP430 Launchpad
      ATTRS{idVendor}=="0451", ATTRS{idProduct}=="f432", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      #GD32V DFU Bootloader
      ATTRS{idVendor}=="28e9", ATTRS{idProduct}=="0189", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      #
      # Debuggers
      #

      # Black Magic Probe
      SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic GDB Server", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"
      SUBSYSTEM=="tty", ATTRS{interface}=="Black Magic UART Port", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # opendous and estick
      ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="204f", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Original FT232/FT245 VID:PID
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Original FT2232 VID:PID
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Original FT4232 VID:PID
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6011", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Original FT232H VID:PID
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # DISTORTEC JTAG-lock-pick Tiny 2
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="8220", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # TUMPA, TUMPA Lite
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="8a98", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="8a99", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # XDS100v2
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="a6d0", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Xverve Signalyzer Tool (DT-USB-ST), Signalyzer LITE (DT-USB-SLITE)
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="bca0", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="bca1", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # TI/Luminary Stellaris Evaluation Board FTDI (several)
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="bcd9", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # TI/Luminary Stellaris In-Circuit Debug Interface FTDI (ICDI) Board
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="bcda", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # egnite Turtelizer 2
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="bdc8", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Section5 ICEbear
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="c140", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="c141", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Amontec JTAGkey and JTAGkey-tiny
      ATTRS{idVendor}=="0403", ATTRS{idProduct}=="cff8", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # TI ICDI
      ATTRS{idVendor}=="0451", ATTRS{idProduct}=="c32a", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # STLink probes
      ATTRS{idVendor}=="0483", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Hilscher NXHX Boards
      ATTRS{idVendor}=="0640", ATTRS{idProduct}=="0028", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Hitex probes
      ATTRS{idVendor}=="0640", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Altera USB Blaster
      ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Amontec JTAGkey-HiSpeed
      ATTRS{idVendor}=="0fbb", ATTRS{idProduct}=="1000", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # SEGGER J-Link
      ATTRS{idVendor}=="1366", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Raisonance RLink
      ATTRS{idVendor}=="138e", ATTRS{idProduct}=="9000", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Debug Board for Neo1973
      ATTRS{idVendor}=="1457", ATTRS{idProduct}=="5118", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Olimex probes
      ATTRS{idVendor}=="15ba", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # USBprog with OpenOCD firmware
      ATTRS{idVendor}=="1781", ATTRS{idProduct}=="0c63", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # TI/Luminary Stellaris In-Circuit Debug Interface (ICDI) Board
      ATTRS{idVendor}=="1cbe", ATTRS{idProduct}=="00fd", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Marvell Sheevaplug
      ATTRS{idVendor}=="9e88", ATTRS{idProduct}=="9e8f", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # Keil Software, Inc. ULink
      ATTRS{idVendor}=="c251", ATTRS{idProduct}=="2710", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"

      # CMSIS-DAP compatible adapters
      ATTRS{product}=="*CMSIS-DAP*", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"
              '';
    destination = "/etc/udev/rules.d/99-platformio.rules";
  };
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.mhuber = { home.packages = with pkgs; [ platformio ]; };
    services.udev.packages = [ platformio-udev-rules ];
  };
}
