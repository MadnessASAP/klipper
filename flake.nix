{
  description = "MakerBot - Replicator 2x Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    flake-utils.url = "flake-utils";
  };

  outputs = { nixpkgs, self, flake-utils, ...}:
  flake-utils.lib.eachDefaultSystem (system: 
    let pkgs = import nixpkgs {
      inherit system;
    }; in {
      packages = {
        mcu = pkgs.callPackage self {
          mcu = "linux-process";
          firmwareConfig = ''
            # CONFIG_LOW_LEVEL_OPTIONS is not set
            # CONFIG_MACH_AVR is not set
            # CONFIG_MACH_ATSAM is not set
            # CONFIG_MACH_ATSAMD is not set
            # CONFIG_MACH_LPC176X is not set
            # CONFIG_MACH_STM32 is not set
            # CONFIG_MACH_HC32F460 is not set
            # CONFIG_MACH_RP2040 is not set
            # CONFIG_MACH_PRU is not set
            # CONFIG_MACH_AR100 is not set
            CONFIG_MACH_LINUX=y
            # CONFIG_MACH_SIMU is not set
            CONFIG_BOARD_DIRECTORY="linux"
            CONFIG_CLOCK_FREQ=50000000
            CONFIG_LINUX_SELECT=y
            CONFIG_USB_VENDOR_ID=0x1d50
            CONFIG_USB_DEVICE_ID=0x614e
            CONFIG_USB_SERIAL_NUMBER="12345"
            CONFIG_WANT_GPIO_BITBANGING=y
            CONFIG_WANT_DISPLAYS=y
            CONFIG_WANT_SENSORS=y
            CONFIG_WANT_LIS2DW=y
            CONFIG_WANT_ADS1118=y
            CONFIG_WANT_SOFTWARE_I2C=y
            CONFIG_WANT_SOFTWARE_SPI=y
            CONFIG_NEED_SENSOR_BULK=y
            CONFIG_CANBUS_FREQUENCY=1000000
            CONFIG_HAVE_GPIO=y
            CONFIG_HAVE_GPIO_ADC=y
            CONFIG_HAVE_GPIO_SPI=y
            CONFIG_HAVE_GPIO_I2C=y
            CONFIG_HAVE_GPIO_HARD_PWM=y
            CONFIG_INLINE_STEPPER_HACK=y
          '';
        };

        atmega1280 = pkgs.callPackage self {
          mcu = "atmega1280";
          gcc = pkgs.pkgsCross.avr.buildPackages.gcc;
          firmwareConfig = ''
            # CONFIG_LOW_LEVEL_OPTIONS is not set
            CONFIG_MACH_AVR=y
            # CONFIG_MACH_ATSAM is not set
            # CONFIG_MACH_ATSAMD is not set
            # CONFIG_MACH_LPC176X is not set
            # CONFIG_MACH_STM32 is not set
            # CONFIG_MACH_HC32F460 is not set
            # CONFIG_MACH_RP2040 is not set
            # CONFIG_MACH_PRU is not set
            # CONFIG_MACH_AR100 is not set
            # CONFIG_MACH_LINUX is not set
            # CONFIG_MACH_SIMU is not set
            CONFIG_AVR_SELECT=y
            CONFIG_BOARD_DIRECTORY="avr"
            # CONFIG_MACH_atmega2560 is not set
            CONFIG_MACH_atmega1280=y
            # CONFIG_MACH_at90usb1286 is not set
            # CONFIG_MACH_at90usb646 is not set
            # CONFIG_MACH_atmega32u4 is not set
            # CONFIG_MACH_atmega1284p is not set
            # CONFIG_MACH_atmega644p is not set
            # CONFIG_MACH_atmega328p is not set
            # CONFIG_MACH_atmega328 is not set
            # CONFIG_MACH_atmega168 is not set
            CONFIG_MCU="atmega1280"
            CONFIG_AVRDUDE_PROTOCOL="arduino"
            CONFIG_CLOCK_FREQ=16000000
            CONFIG_AVR_CLKPR=-1
            CONFIG_AVR_STACK_SIZE=256
            CONFIG_AVR_WATCHDOG=y
            CONFIG_SERIAL=y
            CONFIG_SERIAL_BAUD_U2X=y
            CONFIG_SERIAL_PORT=0
            CONFIG_SERIAL_BAUD=250000
            CONFIG_USB_VENDOR_ID=0x1d50
            CONFIG_USB_DEVICE_ID=0x614e
            CONFIG_USB_SERIAL_NUMBER="12345"
            CONFIG_WANT_GPIO_BITBANGING=y
            CONFIG_WANT_DISPLAYS=y
            CONFIG_WANT_SENSORS=y
            CONFIG_WANT_LIS2DW=y
            CONFIG_WANT_ADS1118=y
            CONFIG_WANT_SOFTWARE_I2C=y
            CONFIG_WANT_SOFTWARE_SPI=y
            CONFIG_NEED_SENSOR_BULK=y
            CONFIG_CANBUS_FREQUENCY=1000000
            CONFIG_HAVE_GPIO=y
            CONFIG_HAVE_GPIO_ADC=y
            CONFIG_HAVE_GPIO_SPI=y
            CONFIG_HAVE_GPIO_I2C=y
            CONFIG_HAVE_GPIO_HARD_PWM=y
            CONFIG_HAVE_STRICT_TIMING=y
            CONFIG_INLINE_STEPPER_HACK=y
          '';
        };
      };

      apps.mcu = {
        type = "app";
        program = "${self.packages.${system}.mcu}/klipper";
      };

      devShells.default = with pkgs; mkShell {
        packages = [
          gnumake
          python3
          pkgsCross.avr.buildPackages.gcc
          avrdude
        ];
      };
    }
  );
}