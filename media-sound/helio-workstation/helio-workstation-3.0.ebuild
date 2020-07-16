# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xdg

JUCE_COMMIT="72f4b0d76d713d1eca4e8a851c2223be8c0bdb19"
HMAP_COMMIT="b0de25158da691e6680bb5c6c2a12ede3a4b0f70"

DESCRIPTION="One music sequencer for all major platforms, desktop and mobile"
HOMEPAGE="https://helio.fm"
SRC_URI="https://github.com/helio-fm/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/peterrudenko/JUCE/archive/${JUCE_COMMIT}.tar.gz -> juce-${JUCE_COMMIT}.tar.gz
	https://github.com/peterrudenko/hopscotch-map/archive/${HMAP_COMMIT}.tar.gz -> hmap-${HMAP_COMMIT}.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="doc"

BDEPEND="!media-sound/${PN}-bin
	virtual/pkgconfig
	doc? ( app-text/mdbook )"
RDEPEND="net-misc/curl
	media-libs/alsa-lib
	media-libs/freetype
	media-libs/mesa[libglvnd(+)]
	virtual/jack
	virtual/opengl"

RESTRICT="mirror"

src_prepare() {
	rmdir "${S}"/ThirdParty/JUCE || die
	mv "${WORKDIR}"/JUCE-$JUCE_COMMIT "${S}"/ThirdParty/JUCE || die

	rmdir "${S}"/ThirdParty/HopscotchMap || die
	mv "${WORKDIR}"/hopscotch-map-$HMAP_COMMIT "${S}"/ThirdParty/HopscotchMap || die

	default
}

src_compile() {
	pushd Projects/LinuxMakefile || die
		emake CONFIG=Release64 V=1
	popd || die
}

src_install() {
	newbin Projects/LinuxMakefile/build/Helio helio

	# install desktop file
	insinto /usr/share/applications
	doins Projects/Deployment/Linux/Debian/x64/usr/share/applications/*

	# install icons
	insinto /usr/share/icons
	doins -r Projects/Deployment/Linux/Debian/x64/usr/share/icons/*

	# build doc using mdbook
	if use doc; then
		mdbook build Docs --dest-dir "${D}"/usr/share/doc/${PF}/html || die
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
