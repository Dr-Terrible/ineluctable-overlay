# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECOMMIT="2b72ef6c6f720fe0ffde5ea5c7c48152e02f6c4f"

DESCRIPTION="Sweetest login theme available for the SDDM display manager"
HOMEPAGE="https://framagit.org/MarianArlt/${PN}"
SRC_URI="https://framagit.org/MarianArlt/${PN}/-/archive/${ECOMMIT}/${PN}-${ECOMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="dev-qt/qtgraphicaleffects
	dev-qt/qtquickcontrols2
	dev-qt/qtsvg
	>=x11-misc/sddm-0.18"

S="${WORKDIR}/${PN}-${ECOMMIT}"

src_install() {
	insinto /usr/share/sddm/themes/sugar-candy
	doins -r .
}
