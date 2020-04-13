# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="HOARD Memory Allocator"
HOMEPAGE="http://www.hoard.org"
SRC_URI="https://github.com/emeryberger/Hoard/releases/download/${PV}/${PN}-release.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc debug"

S="${WORKDIR}/Hoard"

RESTRICT="mirror"

src_compile() {
	local target
	case ${ARCH} in
	x86*)
		target="Linux-gcc-x86"
		;;
	amd64)
		target="Linux-gcc-x86_64"
		;;
	arm)
		target="Linux-gcc-arm"
		;;
	*)
		target="generic-gcc"
		;;
	esac

	use debug && target="${target}-debug"
	emake ${target} -C src/ || die "emake failed."
}

src_install() {
	# installing env.d
	cat <<EOF > "${T}"/01${PN}
LD_PRELOAD=/usr/$(get_libdir)/lib${PN}.so
EOF
	doenvd "${T}"/01${PN}

	# installing libhoard
	dolib.so src/lib${PN}.so*

	# installing docs
	dodoc {AUTHORS,COPYING,NEWS,README.md,THANKS}
	if use doc; then
		dodoc -r doc/*
	fi
}
