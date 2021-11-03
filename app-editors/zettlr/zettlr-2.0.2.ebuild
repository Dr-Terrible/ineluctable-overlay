# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit unpacker xdg

DESCRIPTION="A Markdown Editor for the 21st century."
HOMEPAGE="https://zettlr.com"
SRC_URI="amd64? ( https://github.com/Zettlr/Zettlr/releases/download/v${PV}/Zettlr-${PV}-amd64.deb )
	arm64? ( https://github.com/Zettlr/Zettlr/releases/download/v${PV}/Zettlr-${PV}-arm64.deb )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm64"
IUSE="latex"

RDEPEND="
	latex? ( dev-texlive/texlive-xetex )
	app-text/pandoc-bin
"

S="${WORKDIR}"

RESTRICT="strip mirror"

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	default

	# QA: fix non compliant .desktop files
	sed -i \
		-e "s|text/markdown;text/markdown;text/markdown;|text/markdown;|g" \
		"${WORKDIR}"/usr/share/applications/Zettlr.desktop || die

	# QA: fix pre-compressed files
	gunzip "${WORKDIR}"/usr/share/doc/${PN}/changelog.gz || die

	# QA: fix doc path
	mv "${WORKDIR}"/usr/share/doc/${PN} "${WORKDIR}"/usr/share/doc/${PF} || die
}

src_install() {
	mv "${S}"/* "${D}" || die
	dosym /opt/Zettlr/Zettlr /opt/bin/${PN}
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
