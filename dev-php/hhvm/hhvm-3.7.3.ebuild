# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CMAKE_IN_SOURCE_BUILD=1
inherit elisp-common eutils user systemd versionator linux-info cmake-utils git-r3

EGIT_REPO_URI="git://github.com/${PN}/${PN}-third-party"
EGIT_BRANCH="HHVM-$(get_version_component_range 1-2)"
EGIT_COMMIT="a7d0e6834a"
EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-HHVM-${PV}/third-party/"

DESCRIPTION="Virtual Machine, Runtime, and JIT for PHP"
HOMEPAGE="https://github.com/facebook/hhvm"
SRC_URI="https://github.com/facebook/${PN}/archive/HHVM-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug hack hack-tools +jemalloc +jsonc xen +zend-compat cpu_flags_x86_avx kernel_linux elibc_uclibc test systemd emacs"

RESTRICT="mirror"

RDEPEND="
	dev-db/unixODBC
	dev-libs/libedit
	dev-libs/gmp[cxx]
	dev-libs/fribidi
	dev-libs/glib:2
	dev-libs/libyaml
	>=media-libs/libvpx-1.4.0
	app-arch/bzip2
	dev-libs/re2
	dev-cpp/glog
	amd64? ( dev-cpp/glog[unwind] )
	dev-cpp/tbb
	dev-db/sqlite:3
	hack? ( >=dev-lang/ocaml-4.02.2[ocamlopt] )
	hack-tools? ( >=dev-ml/findlib-1.5.5-r1[ocamlopt] )
	>=dev-libs/boost-1.49[threads]
	!elibc_uclibc? ( >=dev-libs/boost-1.49[context] )
	dev-libs/cloog
	dev-libs/expat
	dev-libs/icu
	jemalloc? ( >=dev-libs/jemalloc-3.0.0[stats] )
	jsonc? ( dev-libs/json-c )
	dev-libs/libdwarf
	>=dev-libs/libevent-2.0.9[threads]
	dev-libs/libmcrypt
	>=dev-libs/libmemcached-1.0.8-r2[libevent]
	dev-libs/libpcre[jit,cxx]
	dev-libs/libxml2
	dev-libs/libxslt
	>=dev-libs/libzip-0.11.0
	dev-libs/oniguruma
	dev-libs/openssl:0
	media-gfx/imagemagick[cxx]
	media-libs/freetype
	media-libs/gd[zlib,png,jpeg]
	net-libs/c-client[kerberos]
	>=net-misc/curl-7.28.0
	net-nds/openldap
	sys-libs/libcap
	sys-libs/ncurses:0
	sys-libs/readline:0
	sys-libs/zlib
	app-arch/lz4
	dev-libs/double-conversion
	virtual/libiconv
	virtual/mysql
	emacs? ( virtual/emacs )"
#	vim? ( || ( app-editors/vim app-editors/gvim ) )"

DEPEND="${RDEPEND}
	|| (
		dev-libs/elfutils
		dev-libs/libelf
	)
	>=dev-util/cmake-3.0.2
	sys-devel/binutils[static-libs]
	sys-devel/bison
	sys-devel/flex"

S="${WORKDIR}/${PN}-HHVM-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-3.7.1-libvpx.patch"
)

pkg_pretend() {
	# checks for kernel options
	if use kernel_linux; then
		CONFIG_CHECK="~INOTIFY_USER"
		check_extra_config
	fi

	# checks for Xen environment
	if ! use xen && [[ ${RC_SYS} == XENU ]]; then
		error "Under xenU, 'xen' USE flag is required."
		die
	fi

	# checks for gcc version
	if [[ $(gcc-major-version) -lt 4 ]] || \
			( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 9 ]] ) \
			; then
		eerror "${PN} needs to be built with gcc-4.9."
		eerror "Please use gcc-config to switch to gcc-4.9 version."
		die
	fi
}

pkg_setup() {
	ebegin "Creating ${PN} user and group"
		enewgroup ${PN}
		enewuser ${PN} -1 -1 "/var/lib/${PN}" ${PN}
	eend $?
}

src_unpack() {
	unpack ${A}

	# third-party dependencies
	git-r3_src_unpack
}

src_configure() {
	local mycmakeargs=(
		-Wno-dev
		-DALWAYS_ASSERT=OFF
		-DDEBUG_MEMORY_LEAK=OFF
		-DDEBUG_APC_LEAK=OFF
		-DENABLE_SSP=OFF
		-DSTATIC_CXX_LIB=OFF
		-DEXECUTION_PROFILER=OFF
		-DENABLE_FULL_SETLINE=OFF
		-DUSE_TCMALLOC=ON
		-DUSE_GOOGLE_HEAP_PROFILER=OFF
		-DUSE_GOOGLE_CPU_PROFILER=OFF
		-DENABLE_TRACE=OFF
		-DCPACK_GENERATOR=OFF
		-DENABLE_COTIRE=OFF
		-DENABLE_ASYNC_MYSQL=ON
		-DMYSQL_UNIX_SOCK_ADDR=/var/run/mysqld/mysqld.sock
		-DENABLE_MCROUTER=ON
		-DENABLE_PROXYGEN_SERVER=ON
		$(cmake-utils_use_use jsonc)
		$(cmake-utils_use_use jemalloc)
		$(cmake-utils_use_no xen HARDWARE_COUNTERS)
		$(cmake-utils_use_enable zend-compat ZEND_COMPAT)
		$(cmake-utils_use_enable cpu_flags_x86_avx AVX2)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use hack-tools; then
		einfo "Building HACK tools ..."

		for tool in hackificator remove_soft_types; do
			cd "${S}"/hphp/hack/tools/${tool} || die
			emake depend || die
			emake || die
		done
	fi
}

src_install() {
	cmake-utils_src_install

	# Install man pages
	doman hphp/doc/man/*.1

	# Install Hack
	if use hack; then

		# Install man pages
		doman hphp/hack/man/*.1

		# Install HACK binaries
		local HACK_DIR="${S}/hphp/hack/bin"
		for BIN in ${HACK_DIR}/hh_* ; do
			dobin ${BIN}
		done

		# Install HACK tools
		if use hack-tools; then
			for BIN in ${HACK_DIR}/tools/* ; do
				dobin ${BIN}
			done
		fi

		# Install emacs plugins
		if use emacs; then
			elisp-compile "${S}"/hphp/hack/editor-plugins/emacs/*.el || die
			elisp-install ${PN} \
				"${S}"/hphp/hack/editor-plugins/emacs/*.{el,elc} || die
			#cp -a "${S}"/hphp/hack/editor-plugins/emacs \
			#	"${D}"/usr/share/${PN}/hack/ \
			#	|| die
		fi
		#if use vim; then
		#	insinto /usr/share/${PN}/hack/
		#	doins "${S}"/hphp/hack/editor-plugins/vim
		#	#cp -a "${S}"/hphp/hack/editor-plugins/vim \
		#	#	"${D}"/usr/share/${PN}/hack/ \
		#	#	|| die
		#fi

	fi

	# Install init scripts
	newinitd "${FILESDIR}"/openrc/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/openrc/${PN}.confd ${PN}
	if use systemd; then
		systemd_newunit "${FILESDIR}"/systemd/${PN}.service ${PN}.service
		systemd_newunit "${FILESDIR}"/systemd/${PN}@.service ${PN}@.service
		systemd_dotmpfilesd "${FILESDIR}/systemd/${PN}.conf"
	fi

	# Install configuration files
	insinto /etc/${PN}
	doins  "${FILESDIR}"/php.ini
	newins "${FILESDIR}"/php.ini php.ini.dist
	doins  "${FILESDIR}"/server.ini
	newins "${FILESDIR}"/server.ini server.ini.dist

	keepdir /etc/${PN} /var/log/${PN} /run/${PN} /var/lib/${PN}
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
