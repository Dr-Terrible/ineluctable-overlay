# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sweetest login theme available for the SDDM display manager"
HOMEPAGE="https://framagit.org/MarianArlt/${PN}"
SRC_URI="https://github.com/Kangie/sddm-sugar-candy/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
IUSE="+jpeg +svg"

KEYWORDS="amd64"

# Require at least one kind of image support. Kind of useless otherwise.
REQUIRED_USE="|| ( jpeg svg )"

RDEPEND=">=dev-qt/qtquickcontrols2-5.11
	svg? ( >=dev-qt/qtsvg-5.11 )
	>=dev-qt/qtgraphicaleffects-5.11
	>=dev-qt/qtdeclarative-5.11
	>=dev-qt/qtgui-5.11[jpeg?]
	>=x11-misc/sddm-0.18"

S="${WORKDIR}/sddm-sugar-candy-${PV}"

DOCS=( AUTHORS COPYING CHANGELOG.md README.md )

src_install() {
	einstalldocs

	local target="${ROOT}usr/share/sddm/themes/${PN}"
	insinto ${target}
	doins -r *
}

pkg_postinst () {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "This theme can be customised by editing"
		elog "${ROOT}/usr/share/sddm/themes/sugar-candy/theme.conf"
		elog "You will need to configure your ${ROOT}/etc/sddm.conf before"
		elog "this theme will be applied. If the file does not exist"
		elog "it is safe to create it with the following configuration:"
		elog "[Theme]"
		elog "Current=sugar-candy"
	fi
}
