# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils linux-info versionator flag-o-matic autotools

DESCRIPTION="LinuX Containers userspace utilities"
HOMEPAGE="http://linuxcontainers.org"
SRC_URI="http://linuxcontainers.org/downloads/${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~x86"

LICENSE="LGPL-3"
SLOT="0"
IUSE="examples lua"

RDEPEND="sys-libs/libcap"

DEPEND="${RDEPEND}
	app-text/docbook-sgml-utils
	>=sys-kernel/linux-headers-3.2"

RDEPEND="${RDEPEND}
	sys-apps/util-linux
	app-misc/pax-utils
	>=sys-apps/openrc-0.9.9.1
	sys-libs/libseccomp
	virtual/awk
	lua? ( dev-lang/lua )"

CONFIG_CHECK="~CGROUPS ~CGROUP_DEVICE
	~CPUSETS ~CGROUP_CPUACCT
	~RESOURCE_COUNTERS
	~CGROUP_SCHED

	~SECCOMP

	~NAMESPACES
	~IPC_NS ~USER_NS ~PID_NS

	~DEVPTS_MULTIPLE_INSTANCES
	~CGROUP_FREEZER
	~UTS_NS ~NET_NS
	~VETH ~MACVLAN

	~POSIX_MQUEUE
	~!NETPRIO_CGROUP

	~!GRKERNSEC_CHROOT_MOUNT
	~!GRKERNSEC_CHROOT_DOUBLE
	~!GRKERNSEC_CHROOT_PIVOT
	~!GRKERNSEC_CHROOT_CHMOD
	~!GRKERNSEC_CHROOT_CAPS
"

ERROR_DEVPTS_MULTIPLE_INSTANCES="CONFIG_DEVPTS_MULTIPLE_INSTANCES:	needed for pts inside container"

ERROR_CGROUP_FREEZER="CONFIG_CGROUP_FREEZER:	needed to freeze containers"

ERROR_UTS_NS="CONFIG_UTS_NS:	needed to unshare hostnames and uname info"
ERROR_NET_NS="CONFIG_NET_NS:	needed for unshared network"

ERROR_VETH="CONFIG_VETH:	needed for internal (host-to-container) networking"
ERROR_MACVLAN="CONFIG_MACVLAN:	needed for internal (inter-container) networking"

ERROR_POSIX_MQUEUE="CONFIG_POSIX_MQUEUE:	needed for lxc-execute command"

ERROR_NETPRIO_CGROUP="CONFIG_NETPRIO_CGROUP:	as of kernel 3.3 and lxc 0.8.0_rc1 this causes LXCs to fail booting."

ERROR_GRKERNSEC_CHROOT_MOUNT=":CONFIG_GRKERNSEC_CHROOT_MOUNT	some GRSEC features make LXC unusable see postinst notes"
ERROR_GRKERNSEC_CHROOT_DOUBLE=":CONFIG_GRKERNSEC_CHROOT_DOUBLE	some GRSEC features make LXC unusable see postinst notes"
ERROR_GRKERNSEC_CHROOT_PIVOT=":CONFIG_GRKERNSEC_CHROOT_PIVOT	some GRSEC features make LXC unusable see postinst notes"
ERROR_GRKERNSEC_CHROOT_CHMOD=":CONFIG_GRKERNSEC_CHROOT_CHMOD	some GRSEC features make LXC unusable see postinst notes"
ERROR_GRKERNSEC_CHROOT_CAPS=":CONFIG_GRKERNSEC_CHROOT_CAPS	some GRSEC features make LXC unusable see postinst notes"

DOCS=(AUTHORS CONTRIBUTING MAINTAINERS TODO README doc/FAQ.txt)

src_prepare() {
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac || die
	epatch "${FILESDIR}"/lxc-docbook2x-man.patch
	eautoreconf
}

src_configure() {
	append-flags -fno-strict-aliasing

	econf \
		--localstatedir=/var \
		--bindir=/usr/sbin \
		--docdir=/usr/share/doc/${PF} \
		--with-config-path=/etc/lxc	\
		--with-rootfs-path=/usr/lib/lxc/rootfs \
		--enable-doc \
		--disable-apparmor \
		--enable-seccomp \
		--with-distro=gentoo \
		$(use_enable lua) \
		$(use_enable examples)
}

src_install() {
	default

	keepdir /etc/lxc /usr/lib/lxc/rootfs

	prune_libtool_files --modules

	# Gentoo-specific additions!
	newinitd "${FILESDIR}/${PN}.initd.2" ${PN}
	keepdir /var/log/lxc
}

pkg_postinst() {
	elog "There is an init script provided with the package now; no documentation"
	elog "is currently available though, so please check out /etc/init.d/lxc ."
	elog "You _should_ only need to symlink it to /etc/init.d/lxc.configname"
	elog "to start the container defined into /etc/lxc/configname.conf ."
	elog "For further information about LXC development see"
	elog "http://blog.flameeyes.eu/tag/lxc" # remove once proper doc is available
	elog ""
	ewarn "With version 0.7.4, the mountpoint syntax came back to the one used by 0.7.2"
	ewarn "and previous versions. This means you'll have to use syntax like the following"
	ewarn ""
	ewarn "    lxc.rootfs = /container"
	ewarn "    lxc.mount.entry = /usr/portage /container/usr/portage none bind 0 0"
	ewarn ""
	ewarn "To use the Fedora, Debian and (various) Ubuntu auto-configuration scripts, you"
	ewarn "will need sys-apps/yum or dev-util/debootstrap."
	ewarn ""
	ewarn "Some GrSecurity settings in relation to chroot security will cause LXC not to"
	ewarn "work, while others will actually make it much more secure. Please refer to"
	ewarn "Diego Elio Pettenò's weblog at http://blog.flameeyes.eu/tag/lxc for further"
	ewarn "details."
}