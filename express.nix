{
  lib,
  appimageTools,
  fetchurl,
  ...
}:

let
  pname = "express";
  version = "3.68.41";

  src = fetchurl {
    url = "https://updates.express.ms/desktop/eXpress-${version}.AppImage";
    hash = "sha256-hZmlbyXob2oT6XjefWLK7N8+nnteOqD5QVge1PwPF8Y=";
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
