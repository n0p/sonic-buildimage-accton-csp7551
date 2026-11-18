#!/bin/bash
# Se ejecuta DENTRO del contenedor sonic-slave-bookworm.
set -x
DEBS=/debs
P=$(ls $DEBS/libnl-3-200_3.7.0*.deb $DEBS/libnl-3-dev_3.7.0*.deb \
        $DEBS/libnl-genl-3-200_3.7.0*.deb $DEBS/libnl-genl-3-dev_3.7.0*.deb \
        $DEBS/libnl-nf-3-200_3.7.0*.deb $DEBS/libnl-nf-3-dev_3.7.0*.deb 2>/dev/null | grep -v dbgsym)
dpkg -i --force-depends $P
dpkg -i --force-depends $DEBS/libswsscommon_1.0.0_amd64.deb $DEBS/libswsscommon-dev_1.0.0_amd64.deb \
    $DEBS/bfnsdk_20221130_sai_1.11.0_deb11.deb
ls -la /usr/lib/x86_64-linux-gnu/libnl-genl-3.so /usr/lib/x86_64-linux-gnu/libnl-nf-3.so

cd /out/src/sonic-sairedis
dpkg-buildpackage -b -uc -us -j8 > /out/build_meta_official.log 2>&1
echo "RC=$?"
ls -la /out/src/libsaimetadata_1.0.0_amd64.deb /out/src/libsairedis_1.0.0_amd64.deb 2>/dev/null
