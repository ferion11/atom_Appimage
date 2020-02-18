#!/bin/bash
WORKDIR="workdir"

#=========================
die() { echo >&2 "$*"; exit 1; };
#=========================

#add-apt-repository ppa:webupd8team/atom -y

#-----------------------------
#dpkg --add-architecture i386
apt update
#apt install -y aptitude wget file bzip2 gcc-multilib
apt install -y aptitude wget file bzip2
#===========================================================================================
# Get inex
# using the package
mkdir "$WORKDIR"

wget -nv https://github.com/atom/atom/releases/download/v1.44.0/atom-amd64.tar.gz
tar xf atom-amd64.tar.gz -C "$WORKDIR/"

cd "$WORKDIR" || die "ERROR: Directory don't exist: $WORKDIR"

pkgcachedir='/tmp/.pkgdeploycache'
mkdir -p $pkgcachedir

#aptitude -y -d -o dir::cache::archives="$pkgcachedir" install atom

#extras
#wget -nv -c http://ftp.osuosl.org/pub/ubuntu/pool/main/libf/libffi/libffi6_3.2.1-4_amd64.deb -P $pkgcachedir

#find $pkgcachedir -name '*deb' ! -name 'mesa*' -exec dpkg -x {} . \;
#echo "All files in $pkgcachedir: $(ls $pkgcachedir)"
#---------------------------------

##clean some packages to use natives ones:
#rm -rf $pkgcachedir ; rm -rf share/man ; rm -rf usr/share/doc ; rm -rf usr/share/lintian ; rm -rf var ; rm -rf sbin ; rm -rf usr/share/man
#rm -rf usr/share/mime ; rm -rf usr/share/pkgconfig; rm -rf lib; rm -rf etc;
#---------------------------------
#===========================================================================================

##fix something here:

#===========================================================================================
# appimage
cd ..

#wget -nv -c "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" -O  appimagetool.AppImage
chmod +x appimagetool.AppImage

chmod +x AppRun

cp AppRun $WORKDIR
cp resource/* $WORKDIR

./appimagetool.AppImage --appimage-extract

export ARCH=x86_64; squashfs-root/AppRun -v $WORKDIR -u 'gh-releases-zsync|ferion11|atom_Appimage|continuous|atom-*arch*.AppImage.zsync' atom-${ARCH}.AppImage

echo "All files at the end of script: $(ls)"
