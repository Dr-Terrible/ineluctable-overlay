# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit eutils distutils-r1 fdo-mime

DESCRIPTION="Bittorrent client that does not require a website to discover content"
HOMEPAGE="http://www.tribler.org"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/Tribler-v${PV}.tar.xz -> ${PF}.tar.xz"

LICENSE="GPL-2 LGPL-2.1+ PSF-2.4 openssl wxWinLL-3.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vlc"

RDEPEND="dev-python/pyasn1[${PYTHON_USEDEP}]
	dev-python/netifaces[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/apsw[${PYTHON_USEDEP}]
	dev-python/plyvel[${PYTHON_USEDEP}]
	dev-python/feedparser[${PYTHON_USEDEP}]
	dev-python/cherrypy[${PYTHON_USEDEP}]
	dev-python/twisted-core[crypt,${PYTHON_USEDEP}]
	dev-python/twisted-web[${PYTHON_USEDEP}]
	dev-python/wxpython:2.8[${PYTHON_USEDEP}]
	net-libs/rb_libtorrent:0/8[dht,python,${PYTHON_USEDEP}]
	vlc? (
		media-video/vlc
	)"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}/${PN}-xdg.patch"
	"${FILESDIR}/${PN}-fix-desktop.patch"
)

src_prepare() {
	distutils-r1_src_prepare
	python_fix_shebang .
}

src_install() {
	distutils-r1_src_install

	# Install exec wrapper
	dobin debian/bin/${PN}

	# Install man pages
	doman Tribler/Main/Build/Ubuntu/tribler.1

	# Install desktop menu+icons
	doicon Tribler/Main/Build/Ubuntu/tribler.xpm
	doicon Tribler/Main/Build/Ubuntu/tribler_big.xpm
	domenu Tribler/Main/Build/Ubuntu/tribler.desktop

	# Remove un-necessary files
	rm -r Tribler/Main/Build/ || die
	rm -r Tribler/Test || die
	rm Tribler/*.txt || die

	# Install /usr/share files
	insinto /usr/share/${PN}
	doins logger.conf
	doins -r Tribler
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
