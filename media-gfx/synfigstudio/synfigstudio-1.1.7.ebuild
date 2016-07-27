# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_AUTORECONF=1
inherit eutils fdo-mime autotools-multilib

ECOMMIT="ac0cfb03001b33066c28a1568ad45d9387934e3e"

DESCRIPTION="Main UI of synfig: Film-Quality Vector Animation"
HOMEPAGE="http://www.synfig.org"
SRC_URI="https://github.com/synfig/synfig/archive/${ECOMMIT}.tar.gz -> ${PF}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fmod debug static-libs"

DEPEND="dev-cpp/gtkmm:2.4
	>=media-gfx/synfig-${PV}[ffmpeg,openexr,imagemagick]
	dev-libs/libsigc++:2
	fmod? ( media-libs/fmod:1 )"
RDEPEND=${DEPEND}

S="${WORKDIR}/synfig-${ECOMMIT}/${PN//stu/-stu}"
RESTRICT+=" mirror"

src_prepare() {
	sed -i -e 's/CXXFLAGS="`echo $CXXFLAGS | sed s:-g::` $debug_flags"//' \
		   -e 's/CFLAGS="`echo $CFLAGS | sed s:-g::` $debug_flags"//'     \
		m4/subs.m4

	autotools-multilib_src_prepare
}

src_configure() {
	local warnings_level="none"
	use debug && warnings_level="hardcore"
	local myeconfargs=(
		--disable-update-mimedb
		--disable-rpath
		--disable-dependency-tracking
		--without-included-ltdl
		--enable-warnings="${warnings_level}"
		--enable-branch-probabilities
		--enable-nls
		$(use_with fmod libfmod )
		$(use_enable static-libs static)
	)
	autotools-multilib_src_configure
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
