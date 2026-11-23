obj-m += x86-64-accton-csp7551-sfp.o accton_i2c_cpld.o fpga_driver.o bf_si5383.o
$(info $$KVERSION is [${KVERSION}])
# at24_csp7551: EEPROM del chasis en 0x57. Antes solo se construia para el
# kernel 4.19 del vendor; con 6.12 (SONiC 202511) tambien hace falta.
obj-m += at24_csp7551.o