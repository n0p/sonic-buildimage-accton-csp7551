# Parches de plataforma para SONiC 202511 (kernel 6.12)

Aplicados en caliente sobre la imagen desplegada; aquí quedan versionados.

## csp7551-i2c-init.sh + .service
El arranque de 202511 no instancia los clientes i2c que necesita la plataforma:
- 32 x `csp7551_portN` en 0x50 sobre los buses `Accton_FPGA_SMBus_*` (1..32)
- `cpld_csp7551` en 0x62 (bus 33) y 0x64 (bus 34)

Sin ellos xcvrd no ve las ópticas (`sfp_is_present` devuelve EPERM porque el CPLD
no está bindeado) y los puertos 100G no levantan. Ojo con los nombres: el
`i2c_device_id` del driver es **cpld_csp7551** (no `accton_i2c_cpld`), y el del
SFP es `csp7551_portN`. Instalar en `/usr/local/bin/` y `/etc/systemd/system/`,
`systemctl enable csp7551-i2c-init`.

## fixsfp.py
Normaliza `Sfp.get_transceiver_info()` para que devuelva todas las claves de
`info_dict_keys` (vendor_rev, vendor_date...): algunas ramas del EEPROM no las
rellenan.

## fixxcvrd.py
En `xcvrd.py`, `post_port_sfp_info_to_db()` indexa `port_info_dict[vendor_rev]`
y compañía sin comprobar. Se normalizan con `setdefault(N/A)` antes de usarlas.

## Pendiente
`psud`, `syseepromd` y `thermalctld` siguen cayendo: el EEPROM del chasis en
`0-0057` queda bindeado a `ee1004` y falla (`Failed to select page 0`, -ENXIO);
hace falta compilar `at24_csp7551.ko` contra el kernel 6.12 e incluirlo en la
imagen, o forzar el binding al driver de Accton.

## at24_csp7551.ko (EEPROM del chasis)

El Makefile de los modulos solo construia `at24_csp7551.o` cuando
`KVERSION == 4.19.0-12-2-amd64`, asi que con 6.12 nunca se generaba y el
EEPROM en `0-0057` se quedaba sin driver (`syseepromd`, `psud` y `thermalctld`
morian con `Failed to read eeprom: [Errno 6]`). Ya esta corregido en el arbol.

Compilacion contra los headers del propio SONiC:

```sh
dpkg -i target/debs/trixie/linux-headers-6.12.41+deb13-common-sonic_*.deb \
        target/debs/trixie/linux-headers-6.12.41+deb13-sonic-amd64_*.deb
make -C /usr/src/linux-headers-6.12.41+deb13-sonic-amd64 M=<dir modules> modules
```

**Ojo al instalar**: en la imagen de 202511 los modulos viven en
`/usr/lib/modules/<uname -r>/extra/`, y `/lib` es un directorio real. Crear
`/lib/modules/...` a mano deja un arbol paralelo que oculta el bueno y rompe
`modprobe` (incluso `bridge`, y con el, `dockerd`). Instalar siempre en
`/usr/lib/modules/...` y ejecutar `depmod -a` despues.
