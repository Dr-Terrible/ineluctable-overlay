# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit linux-info cmake-utils
#git-2

#EGIT_REPO_URI="git://github.com/facebook/hhvm.git"
#EGIT_BRANCH="HHVM-2.2"
#EGIT_HAS_SUBMODULES=1

DESCRIPTION="HipHop Virtual Machine, Runtime and JIT for PHP"
HOMEPAGE="http://www.hhvm.com"
SRC_URI="https://github.com/facebook/${PN}/archive/HHVM-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+jemalloc +inotify debug doc"

S="${WORKDIR}/${PN}-HHVM-${PV}"

DEPEND=">=sys-devel/gcc-4.8.1:4.8[cxx]
	dev-cpp/glog
	amd64? ( dev-cpp/glog[unwind] )
	dev-libs/boost
	virtual/mysql
	dev-libs/libpcre
	media-libs/gd[zlib,png,jpeg]
	dev-libs/libxml2
	dev-libs/expat
	>=dev-libs/icu-52.1
	dev-cpp/tbb
	dev-libs/libmcrypt
	dev-libs/openssl
	app-arch/bzip2
	>=dev-libs/oniguruma-5.9.5
	net-nds/openldap
	sys-libs/readline
	dev-libs/libedit
	dev-libs/elfutils
	=dev-libs/libdwarf-20120410
	>=dev-libs/libmemcached-0.39
	=dev-libs/hhvm-libevent-1.4.14b
	inotify? ( x11-libs/libnotify )
	jemalloc? ( dev-libs/jemalloc[stats] )"
RDEPEND="${DEPEND}"

CMAKE_IN_SOURCE_BUILD="true"

pkg_pretend() {
	if use inotify; then
		CONFIG_CHECK="~INOTIFY_USER"
		check_extra_config
	fi
}

pkg_setup() {
	ebegin "Creating hhvm user and group"
		enewgroup hhvm
		enewuser hhvm -1 -1 "/usr/lib/hhvm" hhvm
	eend $?
}

src_prepare() {
	# FIX: avoid symbols collision with dev-libs/icu
	epatch "${FILESDIR}/cmake.patch"
}
src_configure() {
	CMAKE_BUILD_TYPE="Release"
	use debug && CMAKE_BUILD_TYPE="Debug"

#	export HPHP_HOME="${S}"

	# FIX: avoid linking to the system-wide dev-libs/libevent
	local mycmakeargs=(
		"-DLIBEVENT_LIB=/opt/hhvm/lib64/libevent.so"
		"-DLIBEVENT_INCLUDE_DIR=/opt/hhvm/include/"
		"-DHPHP_HOME=${S}"
	)

	cmake-utils_src_configure
}
