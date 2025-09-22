SUMMARY = "One-time first-boot SSH bootstrap for Raspberry Pi"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://firstboot-ssh.sh file://firstboot-ssh.service"
S = "${WORKDIR}"

inherit systemd
RDEPENDS:${PN} = "openssh openssh-sshd iproute2 busybox"

do_install() {
    install -d ${D}/usr/local/sbin
    install -m 0755 ${WORKDIR}/firstboot-ssh.sh ${D}/usr/local/sbin/firstboot-ssh.sh

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/firstboot-ssh.service ${D}${systemd_unitdir}/system/firstboot-ssh.service
}

SYSTEMD_SERVICE:${PN} = "firstboot-ssh.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"
FILES:${PN} += "${systemd_unitdir}/system/firstboot-ssh.service /usr/local/sbin/firstboot-ssh.sh"

