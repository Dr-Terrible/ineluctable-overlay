# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="Lightweight markup processor to produce HTML, LaTeX, and more"
HOMEPAGE="http://fletcherpenney.net/multimarkdown https://github.com/fletcher/MultiMarkdown-6"
SRC_URI="https://github.com/fletcher/MultiMarkdown-6/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="6"
KEYWORDS="amd64 arm arm64 x86"

RDEPEND="net-misc/curl"

S="${WORKDIR}/MultiMarkdown-${SLOT}-${PV}"

DOCS=(
	QuickStart/QuickStart.html
	DevelopmentNotes/DevelopmentNotes.html
	IMPORTANT
	LICENSE.txt
	README.md
)

src_install() {
	cmake_src_install

	# executable name clashes with sys-fs/mtools
	mv "${D}"/usr/bin/mmd "${D}"/usr/bin/mmd-${SLOT} || die
}
