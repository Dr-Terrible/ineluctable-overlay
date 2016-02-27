# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
AUTOTOOLS_AUTORECONF=1
inherit user linux-info python-single-r1 autotools-utils

DESCRIPTION="A linux trace/probe tool"
HOMEPAGE="http://sourceware.org/${PN}"
SRC_URI="http://sourceware.org/${PN}/ftp/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="crash +sqlite nls pie hardened +server libvirt selinux java examples test doc"

CDEPEND="dev-libs/nspr:0
	|| (
		>=dev-libs/elfutils-0.162:=
		dev-libs/libelf
	)
	libvirt? (
		app-emulation/libvirt
		dev-libs/libxml2:2
	)
	server? (
		dev-libs/nss
		net-dns/avahi
	)
	java? ( >=virtual/jre-1.6:* )
	sqlite? ( dev-db/sqlite:3 )"
RDEPEND="${CDEPEND}
	crash? ( dev-util/crash )"
DEPEND="${CDEPEND}
	dev-libs/boost
	doc? (
		virtual/latex-base
		dev-texlive/texlive-latexextra
		dev-tex/latex2html
		dev-texlive/texlive-fontsrecommended
		app-text/xmlto
	)
	nls? ( >=sys-devel/gettext-0.18.2 )
	test? (
		${PYTHON_DEPS}
		dev-tcltk/expect
		dev-util/dejagnu
	)"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="mirror"

DOCS=(AUTHORS HACKING NEWS README)

pkg_setup() {
	# Check for UTrace
	local K_MAJOR=3 K_MINOR=5
	if kernel_is lt $K_MAJOR $K_MINOR; then
		ewarn
		ewarn "Using ${PN} with kernels older than $K_MAJOR.$K_MINOR is unstable and unsupported."
		ewarn " - https://sourceware.org/${PN}/wiki/utrace"
		CONFIG_CHECK+=" ~UTRACE"
		ERROR_UTRACE="${PN} requires support for User Trace Interface (UTRACE)."
	fi

	# Check for KProbe
	if kernel_is gt $K_MAJOR $K_MINOR; then
		CONFIG_CHECK+=" ~KPROBES"
		ERROR_KPROBES="${PN} requires support for KProbes Instrumentation (KPROBES) - this can be enabled in 'Instrumentation Support -> Kprobes'."
	fi

	CONFIG_CHECK+=" ~RELAY ~UPROBES ~DEBUG_FS ~DEBUG_INFO ~MODULES ~MODULE_UNLOAD"
	ERROR_RELAY="${PN} requires support for user space relay support (RELAY) - this can be enabled in 'General setup -> Kernel -> user space relay support (formerly relayfs)'."
	ERROR_DEBUG_FS="${PN} works best with support for Debug Filesystem (DEBUG_FS) - this can be enabled in 'Kernel hacking -> Compile-time checks and compiler options'."
	ERROR_DEBUG_INFO="${PN} works best with support for Debug Info (DEBUG_INFO) - this can be enabled in 'Kernel hacking -> Compile-time checks and compiler options'."
	ERROR_MODULES="${PN} works best with support for Kernel Modules (MODULES) - this can be enabled in 'Enable loadable module support'."
	ERROR_MODULE_UNLOAD="${PN} works best with support for Module Unloading (MODULE_UNLOAD) - this can be enabled in 'Enable loadable module support -> Module unloading'"

	linux-info_pkg_setup
	use test && python-single-r1_pkg_setup

	ebegin "Creating stapdev and stapsr groups"
		enewgroup stapdev
		enewgroup stapusr
	eend $?
}

src_prepare() {
	# NOTE: avoid to filter -Werror from buildrun.cxx
	#       see https://bugs.gentoo.org/522908#c4
	sed -i \
		-e 's:-Werror::g' \
		configure.ac \
		Makefile.am \
		staprun/Makefile.am \
		stapdyn/Makefile.am \
		testsuite/${PN}.unprivileged/unprivileged_probes.exp \
		testsuite/${PN}.unprivileged/unprivileged_myproc.exp \
		testsuite/${PN}.base/stmt_rel_user.exp \
		testsuite/${PN}.base/sdt_va_args.exp \
		testsuite/${PN}.base/sdt_misc.exp \
		testsuite/${PN}.base/sdt.exp \
		scripts/kprobes_test/gen_code.py \
		|| die "Failed to clean up sources"

	# FIX: install path for reference documentation
	sed -i \
		-e "s:^DOC_INSTALL_DIR =.*:DOC_INSTALL_DIR = \$(DESTDIR)\$(datadir)/doc/${PF}:" \
		-e "s:^HTML_INSTALL_DIR =.*:HTML_INSTALL_DIR = \$(DESTDIR)\$(datadir)/doc/${PF}/html/reference:" \
		doc/Makefile.am \
		doc/beginners/Makefile.am \
		doc/SystemTap_Tapset_Reference/Makefile.am \
		|| die

	autotools-utils_src_prepare
	use test && python_fix_shebang .
}

src_configure() {
	local myeconfargs=(
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		--without-rpm
		--without-dyninst
		--disable-publican
		--disable-grapher
		--disable-prologues
		$(use_enable crash)
		$(use_enable doc docs)
		$(use_enable doc refdocs)
		$(use_enable nls)
		$(use_enable pie)
		$(use_enable hardened ssp)
		$(use_enable server)
		$(use_with   server nss)
		$(use_with   server avahi)
		$(use_enable libvirt virt)
		$(use_enable sqlite)
		$(use_with   selinux)
		$(use_with   java)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	fowners root:stapusr /usr/bin/staprun
	fperms 04110 /usr/bin/staprun

	# Install examples
	use examples && dohtml \
		-A meta,stp,stpm,txt,wav,tcl,py,xml,8,README \
		-f README,kmalloc-top,socktop,syscalltimes \
		-r "${ED}"/usr/share/doc/${PF}/examples
	rm -r "${ED}"/usr/share/doc/${PF}/examples || die
}