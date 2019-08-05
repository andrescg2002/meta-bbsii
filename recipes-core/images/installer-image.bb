SUMMARY = "The image for provisioning the emmc"
HOMEPAGE = "http://www.digitalcomtech.com"
LICENSE = "MIT"

IMAGE_FEATURES += "package-management"
IMAGE_LINGUAS = "en-us"

inherit core-image

IMAGE_INSTALL += " \
    emmc-installer \
    tar \
    xz \
 "
export IMAGE_BASENAME = "installer-image"
