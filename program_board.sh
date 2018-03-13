#!/bin/bash

# From https://forum.digilentinc.com/topic/157-nexys-3-getting-started/


# Enumerate the attached devices using:

#dadutil enum

#djtgcfg enum

 

# Initialize the scan chain:

# djtgcfg -d Nexys3 init

  

#  Program the FPGA:

#  djtgcfg -d Nexys3 -i 0 prog -f myproject.bit

djtgcfg enum
djtgcfg -d Nexys3 init
djtgcfg -d Nexys3 -i 0 prog -f $1


