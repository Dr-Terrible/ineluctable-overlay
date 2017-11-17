# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit user python-r1 linux-info

MY_P="${PN}2-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="A virtual distributed ethernet emulator for qemu, bochs, and uml"
SRC_URI="mirror://sourceforge/vde/${MY_P}.tar.bz2"
HOMEPAGE="http://vde.sourceforge.net"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="pcap ssl static-libs python experimental debug tuntap kernel-switch"

RDEPEND="pcap? ( net-libs/libpcap )
	ssl? ( dev-libs/openssl:0 )"
DEPEND="${RDEPEND}"

pkg_pretend() {
	# checks for kernel options
	use tuntap && CONFIG_CHECK="~TUN"
	use kernel-switch && CONFIG_CHECK="${CONFIG_CHECK} ~OPENVSWITCH"

	if use tuntap || use kernel-switch; then
		check_extra_config
	fi
}
pkg_setup() {
	# default group already used in qemu-kvm
	enewgroup kvm
}
src_configure() {
	econf \
		$(use_enable debug profile) \
		$(use_enable pcap) \
		$(use_enable ssl cryptcab) \
		$(use_enable static-libs static) \
		$(use_enable python) \
		$(use_enable experimental) \
		$(use_enable tuntap) \
		$(use_enable kernel-switch)
}

src_install() {
	default
	use static-libs || prune_libtool_files

	newinitd "${FILESDIR}"/vde.init vde
	newconfd "${FILESDIR}"/vde.conf vde

	newinitd "${FILESDIR}"/slirpvde.init slirpvde
	newconfd "${FILESDIR}"/slirpvde.conf slirpvde
}

pkg_postinst() {
	einfo "To start vde automatically add it to the default runlevel:"
	einfo "# rc-update add vde default"
	einfo "You need to setup tap0 in /etc/conf.d/net"
	einfo "To use it as an user be sure to set a group in /etc/conf.d/vde"
}
