package: OpenSSL
version: v1.1.1m
tag: OpenSSL_1_1_1m
source: https://github.com/openssl/openssl
prefer_system: .*
prefer_system_check: |
  true
build_requires:
 - zlib
 - alibuild-recipe-tools
 - "GCC-Toolchain:(?!osx)"
---
#!/bin/bash -e

rsync -av --delete --exclude="**/.git" $SOURCEDIR/ .
case ${PKG_VERSION} in
  v1.1*) 
    OPTS=""
    OPENSSLDIRPREFIX="" ;;
  *) 
    OPTS="no-krb5"
    OPENSSLDIRPREFIX="etc/ssl"
  ;;
esac

./config --prefix="$INSTALLROOT"                   \
         --openssldir="$INSTALLROOT/$OPENSSLDIRPREFIX"       \
         --libdir=lib                              \
         zlib                                      \
         no-idea                                   \
         no-mdc2                                   \
         no-rc5                                    \
         no-ec                                     \
         no-ecdh                                   \
         no-ecdsa                                  \
         no-asm                                    \
         ${OPTS}                                   \
         shared                                    \
         -fno-strict-aliasing                      \
         -L"$INSTALLROOT/lib"                      \
         -Wa,--noexecstack
make depend
make  # don't ever try to build in multicore
make install_sw # no not install man pages

# Remove static libraries and pkgconfig
rm -rf $INSTALLROOT/lib/pkgconfig \
       $INSTALLROOT/lib/*.a

# Modulefile
MODULEDIR="$INSTALLROOT/etc/modulefiles"
MODULEFILE="$MODULEDIR/$PKGNAME"

mkdir -p "$MODULEDIR"
alibuild-generate-module --lib --bin > "$MODULEFILE"
cat << EOF >> "$MODULEFILE"
prepend-path ROOT_INCLUDE_PATH \$PKG_ROOT/include
EOF
mkdir -p $INSTALLROOT/etc/modulefiles && rsync -a --delete  "$MODULEDIR"/ $INSTALLROOT/etc/modulefiles
