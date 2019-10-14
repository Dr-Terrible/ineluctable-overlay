# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit systemd cmake-utils

#ECOMMIT="1beed44f7e4b2d953075dd96cdb432123b29b4da"

DESCRIPTION="Experimental, scalable, high performance HTTP server"
HOMEPAGE="http://lwan.ws"
SRC_URI="https://github.com/lpereira/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="asan ubsan"

RESTRICT="mirror"

#S="${WORKDIR}/${PN}-${ECOMMIT}"

DEPEND="sys-libs/zlib
	dev-util/google-perftools:0
	dev-libs/jemalloc
	dev-lang/luajit:2
	dev-db/sqlite:3
	dev-util/valgrind
	virtual/mysql"

src_prepare() {
	sed -i \
		-e "s:./wwwroot:/usr/share/${PN}/htdocs:" \
		${PN}.conf || die

	# fix multi-strict error
	sed -i \
		-e "s:DESTINATION \"lib\":DESTINATION $(get_libdir):" \
		common/CMakeLists.txt || die

	default
}

src_configure() {
	local mycmakeargs=(
		-DASAN="$(usex asan)"
		-DUBSAN="$(usex ubsan)"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	rm "${ED}"/usr/$( get_libdir )/lib${PN}.a || die

	# Install configuration file
	insinto /etc/${PN}
	doins ${PN}.conf

	# Install htdocs
	insinto /usr/share/${PN}/htdocs
	doins -r wwwroot/*
}
