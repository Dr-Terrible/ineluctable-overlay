# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit multilib flag-o-matic

HL_ECOMMIT="87f851165bfb570d3fb0b0a99a9bf44a03a26ae2"

DESCRIPTION="HOARD Memory Allocator"
HOMEPAGE="http://www.hoard.org"
SRC_URI="https://github.com/emeryberger/Hoard/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/emeryberger/Heap-Layers/archive/${HL_ECOMMIT}.tar.gz -> Heap-Layers-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc debug"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/Hoard-${PV}"

RESTRICT="mirror"

src_prepare() {
	mv "${WORKDIR}"/Heap-Layers-${HL_ECOMMIT}/* "${S}"/src/Heap-Layers/ || die

	# Makefile forces hardcode -march cflags (pentium4 and nocona), so we
	# need to substitue these values with the one supplied by the user into
	# the make.conf.
	# NOTE: this is necessary to avoid binary breakage and to fix runtime text
	# relocations too
	sed -i \
		-e "s:-march=pentium4:-march=$(get-flag march) -fPIC:" \
		-e "s:-march=nocona:-march=$(get-flag march) -fPIC:" \
		src/Makefile || die "seding src/Makefile failed."
}

src_compile() {
	local target
	case ${ARCH} in
	x86*)
		target="linux-gcc-x86"
		;;
	amd64)
		target="linux-gcc-x86-64"
		;;
	*)
		target="generic-gcc"
		;;
	esac

	use debug && target="${target}-debug"
	pushd src/
	emake ${target} || die "emake failed."
	popd
}

src_install() {
	# installing env.d
	cat <<EOF > "${T}"/01hoard
LD_PRELOAD=/usr/$(get_libdir)/libhoard.so
EOF
	doenvd "${T}"/01hoard

	# installing libhoard
	dolib.so src/libhoard.so

	# installing docs
	dodoc {AUTHORS,COPYING,NEWS,README.md,THANKS}
	if use doc; then
		dohtml -r doc/*
	fi
}
