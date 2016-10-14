# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 cmake-utils toolchain-funcs versionator

XPP_ECOMMIT="58d0fe30b41c4ad4aad215868e7f265ba07b50ca"
I3IPCPP_ECOMMIT="13a8118c45eb213a67a2349d92969f85666afb3c"

DESCRIPTION="A fast and easy-to-use tool for Lemonbar"
HOMEPAGE="https://github.com/jaagr/${PN}"
SRC_URI="https://github.com/jaagr/${PN}/archive/${PV}-beta.tar.gz -> ${PF}.tar.gz
	https://github.com/jaagr/xpp/archive/${XPP_ECOMMIT}.tar.gz -> xpp-${XPP_ECOMMIT}.tar.gz
	https://github.com/jaagr/i3ipcpp/archive/${I3IPCPP_ECOMMIT}.tar.gz -> i3ipcpp-${I3IPCPP_ECOMMIT}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 -arm ~x86"
IUSE="+alsa i3 mpd test network"

RESTRICT="mirror"

RDEPEND="media-libs/freetype:2
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXrandr
	x11-proto/xcb-proto
	x11-libs/libXft:0
	x11-libs/libxcb
	x11-libs/xcb-util-wm
	net-wireless/wireless-tools
	alsa? ( media-libs/alsa-lib:0 )
	i3? (
		>=dev-libs/jsoncpp-1.7.0
		dev-libs/libsigc++:2
	)
	mpd? ( media-libs/libmpdclient )"
DEPEND="dev-libs/boost[threads]"

S="${WORKDIR}/${P}-beta"

PATCHES=(
	"${FILESDIR}"/${PN}-jsoncpp.patch
)

pkg_pretend() {
	# A C++14 compliant compiler is required
	if ! version_is_at_least 5.1 $(gcc-version); then
		eerror "${PN} passes -std=c++14 to \${CXX} and requires a version"
		eerror "of gcc newer than 5.1.0"
	fi
}

src_prepare() {
	rmdir "${S}"/lib/xpp || die
	mv "${WORKDIR}"/xpp-${XPP_ECOMMIT} "${S}"/lib/xpp || die

	rmdir "${S}"/lib/i3ipcpp || die
	mv "${WORKDIR}"/i3ipcpp-${I3IPCPP_ECOMMIT} "${S}"/lib/i3ipcpp || die

	default
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_CCACHE=OFF
		-DBUILD_TESTS="$(usex test)"
		-DENABLE_ALSA="$(usex alsa)"
		-DENABLE_I3="$(usex i3)"
		-DENABLE_MPD="$(usex mpd)"
		-DENABLE_NETWORK="$(usex network)"
	)
	cmake-utils_src_configure
}
