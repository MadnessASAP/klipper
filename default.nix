{
  stdenv,
  writeText,
  python3,
  gcc,
  mcu,
  firmwareConfig,
}: stdenv.mkDerivation rec {
  name = "klipper-firmware-${mcu}";
  src = ./.;

  nativeBuildInputs = [ python3 gcc ];

  KCONFIG_CONFIG = writeText "${name}-config" firmwareConfig;

  makeFlags = [
    "V=1"
  ];

  installPhase = ''
    mkdir -p $out
    find out -name 'klipper.bin' -or -name 'klipper.elf' -exec cp \{\} $out \;
  '';
}