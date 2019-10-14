# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils xdg-utils autotools multilib-minimal

DESCRIPTION="Main UI of synfig: Film-Quality Vector Animation"
HOMEPAGE="http://www.synfig.org"
SRC_URI="https://github.com/synfig/synfig/archive/v${PV}.tar.gz -> synfig-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug static-libs nls jack"

DEPEND="dev-cpp/gtkmm:2.4
	>=media-gfx/synfig-${PV}[ffmpeg,openexr,imagemagick]
	dev-libs/libsigc++:2
	jack? ( media-sound/jack-audio-connection-kit )"
RDEPEND=${DEPEND}

RESTRICT+=" mirror"

S="${WORKDIR}/synfig-${PV}/synfig-studio"

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	local warnings_level="none"
	use debug && warnings_level="hardcore"

	local myconf=(
		--without-included-ltdl
		--disable-rpath
		--disable-option-checking
		--disable-dependency-tracking
		--disable-update-mimedb
		--disable-libfmod
		--enable-branch-probabilities
		--enable-warnings="${warnings_level}"

		$(use_enable jack)
		$(use_enable static-libs static)
		$(use_enable nls)
		$(use_enable debug)
	)
	econf "${myconf[@]}"
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
