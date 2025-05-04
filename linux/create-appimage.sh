#!/bin/sh
rm -rf AppDir
cp -r build/linux/x64/release/bundle AppDir
echo "
[Desktop Entry]
Name=UpdaterClient
Exec=updater_client
Type=Application
Icon=myicon
Categories=Utility;
" >> AppDir/updater_client.desktop
mv AppDir/updater_client AppDir/AppRun
touch AppDir/myicon.svg

appimagetool AppDir
