{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools, ki18n, makeWrapper,
  akonadi-contacts, gnupg, karchive, kcodecs, kcontacts, kcoreaddons,
  kcrash, kdbusaddons, kiconthemes, kjobwidgets, kio, knotifications, kservice,
  ktextwidgets, kxmlgui, kwidgetsaddons, kwindowsystem, qgpgme,
}:

mkDerivation {
  name = "kgpg";
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeWrapper ];
  buildInputs = [
    akonadi-contacts gnupg karchive kcodecs kcontacts kcoreaddons kcrash
    kdbusaddons ki18n kiconthemes kjobwidgets kio knotifications kservice
    ktextwidgets kxmlgui kwidgetsaddons kwindowsystem qgpgme
  ];
  postFixup = ''
    wrapProgram "$out/bin/kgpg" --prefix PATH : "${lib.makeBinPath [ gnupg ]}"
  '';
  meta = {
    license = [ lib.licenses.gpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
