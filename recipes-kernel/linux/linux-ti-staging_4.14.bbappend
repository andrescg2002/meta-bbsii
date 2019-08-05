MACHINE_KERNEL_PR_append = "_syrus"

# Add the .dtb for your dts to the KERNEL_DEVICETREE variable
COMPATIBLE_MACHINE_syrusrouter = "syrusrouter"

KERNEL_DEVICETREE ?= " \
    am335x-boneblack.dtb \
    nohdmi.dtb \    
"

#KERNEL_DEVICETREE += "nohdmi.dtb syrus-cape.dtb"

# This insures the version of defconfig in this layer is used instead of the
# version in meta-ti

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-4.14:"

SRC_URI += "file://0001-Add-Quectel-EC25-USB-Serial-Driver-Support.patch \
file://0002-Revoke-i2c2-cape-definitions.patch \
file://0003-Add-syrus-BB-dts-emmc.patch \  
file://0004-Edit-am335x-dts-file.patch \
file://syrus_kernel.cfg \  
"

# meta-ti uses KERNEL_CONFIG_FRAGMENTS to add kernel configurations to the base 
# configuration. Don’t forget to put yourconfig.cfg under the ${WORKDIR} 

KERNEL_CONFIG_FRAGMENTS += "${WORKDIR}/syrus_kernel.cfg"
