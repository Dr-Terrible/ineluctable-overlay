# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit linux-info eutils autotools

DESCRIPTION="AMD CodeAnalyst Performance Analyzer is an open source front-end to OProfile."
HOMEPAGE="http://developer.amd.com/cpu/CodeAnalyst"
SRC_URI="http://developer.amd.com/Downloads/CodeAnalyst3_3_18_0361Public.tar.gz"
RESTRICT="fetch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="X static-libs debug java"

COMMON_DEPEND="x11-libs/qt:3
	dev-util/oprofile
	dev-libs/elfutils
	dev-libs/popt"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/CodeAnalyst-gui-${PV}"

CA_DIR="/opt/CodeAnalyst"

pkg_nofetch() {
	elog "Please visit ${HOME}/codeanalystlinux/Pages/default.aspx"
	elog "and place ${A} in ${DISTDIR}"
}

pkg_setup() {
	linux-info_pkg_setup
	if ! linux_config_exists \
		|| ! linux_chkconfig_present OPROFILE; then
		echo
		eerror "Please enable OProfile support in your kernel,"
		eerror "under the 'General Setup' section."
		die 'missing CONFIG_OPROFILE'
	fi
}
src_prepare() {
	# FIX: DS bugs
	epatch "${FILESDIR}"/${PN}-${PV}-ds-iterator.patch
#	epatch "${FILESDIR}"/CodeAnalyst-Linux-2.8.29-ds-counter_detection.patch

	# FIX: add support for oprofile 0.9.6
	epatch "${FILESDIR}"/${PN}-${PV}-oprofile.patch

	# FIX: add Intel support
#	epatch "${FILESDIR}"/CodeAnalyst-Linux-2.8.29-ds-intel.patch
#	epatch "${FILESDIR}"/CodeAnalyst-Linux-2.8.29-ds-oprofile.patch

	# some files aren't installed in DESTDIR
#	sed -i -e "s/\$(CA_DATA_DIR)\/Configs/\$(DESTDIR)\/\$(CA_DATA_DIR)\/Configs/" src/ca/gui/Makefile.am || die "failed to adjust project files"
#	sed -i -e "s/\$(bindir)\/killdaemon/\$(DESTDIR)\/\$(bindir)\/killdaemon/" src/ca/gui/Makefile.am || die "failed to adjust project files"

	# We copy those files ourselves
	#sed -i -e "s/\${prefix}/\${DESTDIR}\/\${prefix}/" Makefile.am || die "failed to adjust project files"
#	sed -i -e s/install-data-hook/NOTHING/ Makefile.am

	# nasty Setup, we should do this ourselves
#	rm src/ca/Setup.sh
	AT_M4DIR="m4" eautoreconf
#	./autogen.sh || die "autogen failed"
}

src_configure() {
#	econf --prefix=${CA_DIR}
	# use --with-oprofile to use another oprofile version than the one included
	#econf --with-oprofile=
	econf \
		$(use_with X x) \
		$(use_enable static-libs static) \
		$(use_enable debug) \
		--with-oprofile=${ROOT}/usr \
		--disable-oprofile-lib \
		--disable-dwarf \
		${EXTRA_ECONF}
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc README ChangeLog AUTHORS INSTALL NEWS || die

	# Removing oprofile
	rm -f "${D}"/${CA_DIR}/lib/libopagent* "${D}"/${CA_DIR}/lib64/libopagent* 
	rm -f "${D}"/${CA_DIR}/lib/*.*a "${D}"/${CA_DIR}/lib64/*.*a
	rm -rf "${D}"/${CA_DIR}/include/oprofile
	rm -rf "${D}"/${CA_DIR}/share/oprofile
	rm -rf "${D}"/${CA_DIR}/share/doc/oprofile
	rm -f "${D}"/${CA_DIR}/share/man/man1/op*

	# Setting links
	rm "${D}"/${CA_DIR}/bin/op*.sh
	for opfile in "${D}"/${CA_DIR}/bin/op*; do
		name=`basename $opfile`
		rm "${D}/${CA_DIR}/bin/$name"
		ln -s /usr/bin/${name} "${D}"/${CA_DIR}/bin/$name
	done
    
    # Install additional collectors and views
    cp -r "${FILESDIR}/Configs" "${D}"/${CA_DIR}/share/codeanalyst || die
    
    # Fixing owners and permissions
    fowners root.amdca ${CA_DIR}/bin/killdaemon
    chmod ug+s "${D}"/${CA_DIR}/bin/killdaemon
    
    # Install missing things
    dodir /etc/init.d
    insopts -m0755
    insinto /etc/init.d
    newins "${FILESDIR}"/codeanalyst_init /etc/init.d/codeanalyst

    insopts -m0755
    insinto ${CA_DIR}/bin
    doins src/ca/group.pl
    doins src/ca/ca_setuser
    doins src/ca/capackage.sh
    doins src/ca/util/oprofiled_monitor.sh
    doins src/ca/util/oprofile_drv_monitor.sh 
    doins src/ca/gui/oprofiled.sh
#    ln -s family10h "${D}"/${CA_DIR}/share/oprofile/x86-64/family10
    
	cat <<EOF > ${D}/${CA_DIR}/bin/ca_setuser.sh
#!/bin/bash 

CA_DIR=${CA_DIR}
\$CA_DIR/bin/group.pl "$1" \$CA_DIR
EOF


    dodir /etc/env.d
    CA_LIB_DIR=`dirname ${D}/${CA_DIR}/lib*/libCA.so`
    CA_LIB=`basename $CA_LIB_DIR`
    echo "LDPATH=/${CA_DIR}/$CA_LIB" > "${D}"/etc/env.d/99codeanalyst

	# Setting link /usr/bin
	dodir /usr/bin
	ln -s ${CA_DIR}/bin/CodeAnalyst "${D}"/usr/bin/CodeAnalyst

	# remove useless .la files
	find "${D}" -name '*.la' -delete \
		|| die "removal of libarchive files	failed"
}

pkg_setup() {
	enewgroup amdca
}

pkg_postinst() {
	einfo ""
	einfo "You need to setup users allowed to execute CodeAnalyst"
	einfo "1. You can do it manually: add users to amdca group and allow to execute"
	einfo "   opcontrol in sudo environment. Add to /etc/sudoers:"
	einfo "       user ALL=NOPASSWD: ${CA_DIR}/bin/opcontrol"
	einfo "2. Or use a script:"
	einfo "       ${CA_DIR}/bin/ca_setuser.sh <coma separated users list>"
	einfo ""
	einfo "Add system service to autostart"
	einfo "   rc-update add codeanalyst default"
	einfo "   /etc/init.d/codeanalyst start"
	einfo ""
	einfo "Finally type CodeAnalyst to start profiling"
}
