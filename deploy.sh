#!/bin/bash

P_URL="https://github.com/atom/atom/releases/download/v1.63.0/atom-amd64.tar.gz"
P_NAME=$(echo $P_URL | cut -d/ -f5)
P_VERSION=$(echo $P_URL | cut -d/ -f8)
P_VERSION_NUM="${P_VERSION:1}"
P_FILENAME=$(echo $P_URL | cut -d/ -f9)
P_ARCH=x86_64
WORKDIR="workdir"

sudo apt update
sudo apt install -y aptitude wget file bzip2

mkdir "$WORKDIR"

# Download and extract the archive file
wget -nv "$P_URL"
tar xf "$P_FILENAME" -C "$WORKDIR/"

# AppRun file supposes main directory to be named 'atom'
mv "$WORKDIR/atom-${P_VERSION_NUM}-amd64" "$WORKDIR/atom"

wget -nv -c "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" -O appimagetool.AppImage
chmod +x appimagetool.AppImage

chmod +x AppRun

cp AppRun "$WORKDIR"
cp resource/* "$WORKDIR"

ARCH="${P_ARCH}" ./appimagetool.AppImage -v "$WORKDIR" -u "gh-releases-zsync|ferion11|atom_Appimage|continuous-master|${P_NAME}-*-${P_ARCH}.AppImage.zsync" "${P_NAME}-${P_VERSION}-${P_ARCH}.AppImage"

rm appimagetool.AppImage

echo "All files at the end of script: $(ls)"
