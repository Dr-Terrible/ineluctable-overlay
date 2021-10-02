# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit unpacker xdg

DESCRIPTION="gopass CLI + UI = visual cross-platform password manager for teams"
HOMEPAGE="https://github.com/codecentric/${PN}"
SRC_URI="https://github.com/codecentric/${PN}/releases/download/v${PV}/${PN}_${PV}_amd64.deb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

RDEPEND="app-admin/gopass"

RESTRICT="bindist mirror"

QA_PREBUILT="*"

S="${WORKDIR}"

src_prepare() {
	default

	# normalize "Gopass UI" as gopass-ui
	mv "${WORKDIR}/opt/Gopass UI" "${WORKDIR}"/opt/${PN} || die
	sed "s/Gopass UI/${PN}/" -i "${WORKDIR}"/usr/share/applications/${PN}.desktop || die "sed failed"

	# QA: fix pre-compressed files
	gunzip "${WORKDIR}"/usr/share/doc/${PN}/changelog.gz || die
}

src_install() {
	mv "${S}"/* "${ED}" || die
	mv "${ED}/usr/share/doc/${PN//-bin}" "${ED}/usr/share/doc/${PF}" || die
}
