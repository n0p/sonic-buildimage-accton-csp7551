path = "/usr/lib/python3/dist-packages/sonic_platform/sfp.py"
s = open(path).read()

patch = '''

# CSP-7550: SONiC 202511 espera todas las claves de info_dict_keys (vendor_rev,
# vendor_date, ...). Algunas ramas de lectura de EEPROM no las rellenan y xcvrd
# moria con KeyError. Normalizamos el diccionario devuelto.
_csp7551_orig_get_transceiver_info = Sfp.get_transceiver_info


def _csp7551_get_transceiver_info(self, *args, **kwargs):
    info = _csp7551_orig_get_transceiver_info(self, *args, **kwargs)
    if isinstance(info, dict):
        for key in getattr(self, "info_dict_keys", []) or []:
            info.setdefault(key, "N/A")
    return info


Sfp.get_transceiver_info = _csp7551_get_transceiver_info
'''

if "_csp7551_get_transceiver_info" not in s:
    open(path, "a").write(patch)
    print("sfp.py parcheado")
else:
    print("ya estaba")
