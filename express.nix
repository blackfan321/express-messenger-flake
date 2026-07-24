{
  lib,
  appimageTools,
  fetchurl,
  ...
}:

let
  pname = "express";
  version = "3.69.44";

  src = fetchurl {
    url = "https://updates.express.ms/desktop/eXpress-${version}.AppImage";
    hash = "sha256-OJgyIZDoQJRM5qURT2uX9Ezz1Y3AJLX0q2G3DqiJVT8=";
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
