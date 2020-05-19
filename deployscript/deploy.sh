#!/bin/bash
P_URL="https://github.com/atom/atom/releases/download/v1.47.0/atom-amd64.tar.gz"
P_NAME=$(echo $P_URL | cut -d/ -f5)
P_VERSION=$(echo $P_URL | cut -d/ -f8)
P_VERSION_NUM="${P_VERSION:1}"
P_FILENAME=$(echo $P_URL | cut -d/ -f9)
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

wget -nv $P_URL
tar xf $P_FILENAME -C "$WORKDIR/"

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

cat > "AppRun" << EOF
#!/bin/bash
HERE="\$(dirname "\$(readlink -f "\${0}")")"
#------------------------------

# Libs and deps variables
export LD_LIBRARY_PATH="\$HERE/atom-${P_VERSION_NUM}-amd64":\$LD_LIBRARY_PATH

# from .desktop
#export ATOM_DISABLE_SHELLING_OUT_FOR_ENVIRONMENT=false

#------------------------------
MAIN="\$HERE/atom-${P_VERSION_NUM}-amd64/atom"

export PATH=\$HERE/atom-${P_VERSION_NUM}-amd64:\$PATH
"\$MAIN" "\$@" | cat

EOF
chmod +x AppRun

cp AppRun $WORKDIR
cp resource/* $WORKDIR

./appimagetool.AppImage --appimage-extract

export ARCH=x86_64; squashfs-root/AppRun -v $WORKDIR -u 'gh-releases-zsync|ferion11|${P_NAME}_Appimage|continuous|${P_NAME}-${P_VERSION}-*arch*.AppImage.zsync' ${P_NAME}-${P_VERSION}-${ARCH}.AppImage

echo "All files at the end of script: $(ls)"
