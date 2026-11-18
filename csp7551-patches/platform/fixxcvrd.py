p = "/usr/local/lib/python3.11/dist-packages/xcvrd/xcvrd.py"
s = open(p).read()

anchor = """            if port_info_dict is not None:
                is_replaceable = _wrapper_is_replaceable(physical_port)"""

new = """            if port_info_dict is not None:
                # CSP-7550: el API de plataforma no siempre rellena todas las claves
                # (vendor_rev, vendor_date, ...) y aqui se indexan directamente.
                for _k in ('type', 'vendor_rev', 'serial', 'manufacturer', 'model',
                           'vendor_oui', 'vendor_date', 'connector', 'encoding',
                           'ext_identifier', 'ext_rateselect_compliance', 'cable_type',
                           'cable_length', 'specification_compliance', 'nominal_bit_rate'):
                    port_info_dict.setdefault(_k, 'N/A')
                is_replaceable = _wrapper_is_replaceable(physical_port)"""

if "CSP-7550: el API de plataforma no siempre rellena" in s:
    print("ya estaba")
else:
    assert anchor in s, "ancla no encontrada"
    s = s.replace(anchor, new, 1)
    open(p, "w").write(s)
    print("xcvrd.py parcheado")
