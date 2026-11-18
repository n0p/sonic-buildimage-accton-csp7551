#!/bin/bash
# GNU/sonic CSP-7551: instancia los clientes i2c de CPLD y SFP que el arranque
# de 202511 no crea (kernel 6.12). Sin esto xcvrd no ve las opticas y los
# puertos 100G no levantan.
modprobe i2c-i801 2>/dev/null
modprobe fpga_driver 2>/dev/null
modprobe accton_i2c_cpld 2>/dev/null
modprobe x86_64_accton_csp7551_sfp 2>/dev/null

# esperar a los adaptadores de la FPGA
for i in $(seq 1 30); do
    [ -e /sys/bus/i2c/devices/i2c-32 ] && break
    sleep 1
done

for b in $(seq 1 32); do
    [ -e /sys/bus/i2c/devices/i2c-$b ] || continue
    [ -e /sys/bus/i2c/devices/$b-0050 ] || echo csp7551_port$b 0x50 > /sys/bus/i2c/devices/i2c-$b/new_device 2>/dev/null
done

for pair in "33 0x62" "34 0x64"; do
    set -- $pair
    [ -e /sys/bus/i2c/devices/i2c-$1 ] || continue
    [ -e /sys/bus/i2c/devices/$1-00${2#0x} ] || echo cpld_csp7551 $2 > /sys/bus/i2c/devices/i2c-$1/new_device 2>/dev/null
done
exit 0
