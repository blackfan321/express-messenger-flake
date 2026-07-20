{
  lib,
  appimageTools,
  fetchurl,
  ...
}:

let
  pname = "express";
  version = "3.68.44";

  src = fetchurl {
    url = "https://updates.express.ms/desktop/eXpress-${version}.AppImage";
    hash = "sha256-z/aG5M7/3RezH7/XSJF8yor79ChzYb+MqXOAO71mFnc=";
  };

  appimageContents = appimageTools.extractType1 { inherit pname version src; };
  mkDesktop = import ./desktop-helper.nix;
in appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = mkDesktop {inherit pname; inherit appimageContents;};

  meta = with lib; {
    description = "eXpress client";
    longDescription = ''
      Desktop client for eXpress Messenger
    '';

    mainProgram = pname;
    homepage = "https://express.ms/";
    downloadPage = "https://express.ms/download/#web-desktop";
    license = licenses.unfree;
    maintainers = with maintainers; [ blackfan321 ];
    platforms = [ "x86_64-linux" ];
  };
}
