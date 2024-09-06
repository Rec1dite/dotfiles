{ lib, python3, fetchurl, ddcutil, xrandr, libsForQt5 }:
python3.pkgs.buildPythonPackage rec {
  pname = "brightness-controller";
  version = "v2.4";

  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/7e/87/a4f007158fb7805334c92f2a4bddea776bbbc5a719d3dacb2f4d1373a51f/brightness_controller_linux-2.4-py3-none-any.whl";
    sha256 = "sha256-ozhKB2LTBrnMywFBDDR+Imy8jQfhZwBXv2HRrzPRf2s=";
  };

  build-system = with python3.pkgs; [
    poetry-core
  ];

  buildInputs = with libsForQt5; [
    qt5.qtbase
  ];
  nativeBuildInputs = with libsForQt5; [
    qt5.wrapQtAppsHook
  ];

  dependencies = [
    ddcutil
    xrandr
    python3.pkgs.qtpy
    python3.pkgs.pyqt5
  ];

  meta = with lib; {
    description = "Brightness controller for primary and external displays";
    homepage = "https://github.com/LordAmit/Brightness";
    license = licenses.gpl3Only;
    maintainers = [ "rec1dite" ];
    mainProgram = "brightness-controller";
  };
}