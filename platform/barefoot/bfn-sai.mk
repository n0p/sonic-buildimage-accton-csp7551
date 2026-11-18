BFN_SAI = bfnsdk_20221130_sai_1.11.0_deb11.deb
$(BFN_SAI)_URL = "https://github.com/barefootnetworks/sonic-release-pkgs/raw/dev/$(BFN_SAI)"

$(BFN_SAI)_DEPENDS += $(LIBNL_GENL3_DEV)
$(eval $(call add_conflict_package,$(BFN_SAI),$(LIBSAIVS_DEV)))
$(BFN_SAI)_RDEPENDS += $(LIBNL_GENL3)

SONIC_ONLINE_DEBS += $(BFN_SAI)
$(BFN_SAI_DEV)_DEPENDS += $(BFN_SAI)

# bfnsdk es un blob de Debian 11: su libthrift-0.14.1.so enlaza contra
# libssl.so.1.1/libcrypto.so.1.1 y su _ctypes contra libffi.so.7.
# Ninguno existe en bookworm/trixie: empaquetamos las libs de bullseye.
BFN_SSL_COMPAT = libssl1.1_1.1.1w-0+deb11u1_amd64.deb
$(BFN_SSL_COMPAT)_URL = "https://deb.debian.org/debian/pool/main/o/openssl/$(BFN_SSL_COMPAT)"
SONIC_ONLINE_DEBS += $(BFN_SSL_COMPAT)

BFN_FFI_COMPAT = libffi7_3.3-6_amd64.deb
$(BFN_FFI_COMPAT)_URL = "https://deb.debian.org/debian/pool/main/libf/libffi/$(BFN_FFI_COMPAT)"
SONIC_ONLINE_DEBS += $(BFN_FFI_COMPAT)

$(BFN_SAI)_DEPENDS += $(BFN_SSL_COMPAT) $(BFN_FFI_COMPAT)
$(BFN_SAI)_RDEPENDS += $(BFN_SSL_COMPAT) $(BFN_FFI_COMPAT)
