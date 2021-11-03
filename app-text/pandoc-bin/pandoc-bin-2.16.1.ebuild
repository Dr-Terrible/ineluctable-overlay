# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit unpacker

DESCRIPTION="Conversion between markup formats"
HOMEPAGE="https://pandoc.org"
SRC_URI="amd64? ( https://github.com/jgm/pandoc/releases/download/${PV}/pandoc-${PV}-1-amd64.deb )
	arm64? ( https://github.com/jgm/pandoc/releases/download/${PV}/pandoc-${PV}-1-arm64.deb )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64"

S="${WORKDIR}"

RESTRICT="strip mirror"

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	default

	# QA: use correct FHS/Gentoo policy paths
	mv "${S}/usr/share/doc/${PN//-bin}" "${S}/usr/share/doc/${PF}" || die

	# QA: fix pre-compressed files
	gunzip "${WORKDIR}"/usr/share/man/man1/${PN//-bin}.1.gz || die
}

src_install() {
	mv "${S}"/* "${D}" || die
}
