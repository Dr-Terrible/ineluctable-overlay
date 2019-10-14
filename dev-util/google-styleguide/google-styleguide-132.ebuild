# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_COMMIT="43d738ab8bb0c797f78506945729946aacbab17d"

DESCRIPTION="Style guides for Google-originated open-source projects"
HOMEPAGE="https://github.com/google/styleguide"
SRC_URI="https://github.com/google/styleguide/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN//google-}-${EGIT_COMMIT}"

LICENSE="CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

src_prepare() {
	default
	rm -r cpplint || die
}

src_install() {
	dohtml -A xml,xsl -r ./.
}
