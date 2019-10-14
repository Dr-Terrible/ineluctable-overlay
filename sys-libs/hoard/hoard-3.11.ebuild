# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic

HL_ECOMMIT="87f851165bfb570d3fb0b0a99a9bf44a03a26ae2"

DESCRIPTION="HOARD Memory Allocator"
HOMEPAGE="http://www.hoard.org"
SRC_URI="https://github.com/emeryberger/Hoard/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/emeryberger/Heap-Layers/archive/${HL_ECOMMIT}.tar.gz -> Heap-Layers-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc debug"

S="${WORKDIR}/Hoard-${PV}"

RESTRICT="mirror"

src_prepare() {
	default

	mv "${WORKDIR}"/Heap-Layers-${HL_ECOMMIT}/* "${S}"/src/Heap-Layers/ || die

	# Makefile forces hardcode cflags, so we need to substitue these values with
	# the one supplied by the user into the make.conf.
	# NOTE: this is necessary to avoid binary breakage, to fix runtime text
	# relocations, and to fix a lacking SONAME.
	sed -i \
		-e "s:-march=pentium4:-march=$(get-flag march) -fPIC:" \
		-e "s:-march=nocona:-march=$(get-flag march) -fPIC:" \
		-e "s:-shared:-shared \$\(CXXFLAGS\) \$\(LDFLAGS\) -Wl,-soname,lib${PN}.so.0.0.0:" \
		-e "s:-o libhoard.so:-o libhoard.so.0.0.0:" \
		-e "s: g++ : \$\(CXX\) :" \
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
	emake ${target} -C src/ || die "emake failed."
}

src_install() {
	# installing env.d
	cat <<EOF > "${T}"/01${PN}
LD_PRELOAD=/usr/$(get_libdir)/lib${PN}.so
EOF
	doenvd "${T}"/01${PN}

	# installing libhoard
	pushd src
		ln -sf lib${PN}.so.0.0.0 lib${PN}.so || die
	popd
	dolib.so src/lib${PN}.so*

	# installing docs
	dodoc {AUTHORS,COPYING,NEWS,README.md,THANKS}
	if use doc; then
		dohtml -r doc/*
	fi
}
