# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

ECOMMIT="17e882f50009ea5839cba20255515b2de1770406"

DESCRIPTION="Fatal is a library for fast prototyping software in modern C++"
HOMEPAGE="https://facebook.com/groups/lib${PN}"
SRC_URI="https://github.com/facebook/${PN}/archive/${ECOMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

S="${WORKDIR}/${PN}-${ECOMMIT}"

RESTRICT="mirror"

DOCS=(README.md CONTRIBUTING.md PATENTS)

src_install() {
	doheader -r fatal

	# Install documentation
	einstalldocs
	if use doc; then
		dodoc -r docs

		docinto docs
		dodoc -r lesson
	fi

	# Install examples
	if use examples; then
		docinto examples
		dodoc -r demo/*
	fi
}
