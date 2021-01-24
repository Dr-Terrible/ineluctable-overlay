# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ECOMMIT="87c54065a28f18541a00b48e1e02540591b911c2"

DESCRIPTION="Style guides for Google-originated open-source projects"
HOMEPAGE="https://google.github.io/styleguide https://github.com/google/styleguide"
SRC_URI="https://github.com/google/styleguide/archive/${ECOMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN//google-}-${ECOMMIT}"

LICENSE="CC-BY-3.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"

RESTRICT="mirror test"

src_prepare() {
	default
	rm -r cpplint || die
}

DOCS=( CODEOWNERS LICENSE README.md )

src_install() {
	einstalldocs

	rm *.vim || die
	rm *.el || die
	rm *.xml || die
	rm *.xsl || die
	rm "${DOCS[@]}" || die

	docinto html
	dodoc -r .
}
