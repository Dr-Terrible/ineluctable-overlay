# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}_${PV}"
DESCRIPTION="Interconverts between various bibliography formats using common XML intermediate"
HOMEPAGE="https://sourceforge.net/p/bibutils/home/Bibutils/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}_src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"
IUSE="+static test"

S="${WORKDIR}/${MY_P}"

# NOTE: configure script relies on these deps to detect the system
BDEPEND="virtual/awk
	sys-apps/coreutils"

DOCS=( ChangeLog readme.txt )

src_configure() {
	sh ./configure \
		--install-dir "${D}${EPREFIX}/usr/bin" \
		--install-lib "${D}${EPREFIX}/usr/$(get_libdir)" \
		--$(usex static static dynamic) \
	|| die "Failed to execute configure"
}

src_compile() {
	emake DISTRO_CFLAGS="${CFLAGS}" LDFLAGSIN="${LDFLAGS}"
}

src_test() {
	emake DISTRO_CFLAGS="${CFLAGS}" LDFLAGSIN="${LDFLAGS}" test
}
