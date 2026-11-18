#!/bin/bash
set -x
DEBS=/debs
P=$(ls $DEBS/libnl-3-200_3.7.0*.deb $DEBS/libnl-3-dev_3.7.0*.deb $DEBS/libnl-genl-3-200_3.7.0*.deb $DEBS/libnl-genl-3-dev_3.7.0*.deb $DEBS/libnl-nf-3-200_3.7.0*.deb $DEBS/libnl-nf-3-dev_3.7.0*.deb $DEBS/libnl-route-3-200_3.7.0*.deb $DEBS/libnl-route-3-dev_3.7.0*.deb $DEBS/libyang_1.0.73*.deb $DEBS/libyang-dev_1.0.73*.deb $DEBS/libyang-cpp_1.0.73*.deb 2>/dev/null | grep -v dbgsym)
dpkg -i --force-depends $P >/dev/null 2>&1
cd /out/src/sonic-swss-common
dpkg-buildpackage -b -uc -us -j8 > /out/build_swsscommon.log 2>&1
echo "RC=$?"
ls -la /out/src/libswsscommon_1.0.0_amd64.deb 2>/dev/null
