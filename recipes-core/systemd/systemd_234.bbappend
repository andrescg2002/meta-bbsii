FILESEXTRAPATHS_prepend := "${THISDIR}/systemd:"

SRC_URI += " \
    file://usb0.network \
    file://eth0.network \
"

do_install_append() {
    # The network files need to be in /usr/lib/systemd, not ${systemd_unitdir}...
    install -d ${D}${prefix}/lib/systemd/network/
    install -m 0644 ${WORKDIR}/usb0.network ${D}${prefix}/lib/systemd/network/
    install -m 0644 ${WORKDIR}/eth0.network ${D}${prefix}/lib/systemd/network/
}

FILES_${PN} += " \
    ${nonarch_base_libdir}/systemd/network \
"
