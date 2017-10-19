# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 cmake-utils toolchain-funcs versionator

XPP_ECOMMIT="9d410a963e7e2673a87b200b7560a3d83747e900"
I3IPCPP_ECOMMIT="8ed783100bbc8053fd7d8e19cef58cd097ff23f7"

DESCRIPTION="A fast and easy-to-use status bar"
HOMEPAGE="https://github.com/jaagr/${PN}"
SRC_URI="https://github.com/jaagr/${PN}/archive/${PV}.tar.gz -> ${PF}.tar.gz
	https://github.com/jaagr/xpp/archive/${XPP_ECOMMIT}.tar.gz -> xpp-${XPP_ECOMMIT}.tar.gz
	https://github.com/jaagr/i3ipcpp/archive/${I3IPCPP_ECOMMIT}.tar.gz -> i3ipcpp-${I3IPCPP_ECOMMIT}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 -arm ~x86"
IUSE="+alsa curl i3 mpd test wifi +xkb debug"

RESTRICT="mirror"

# We need jsoncpp-1.8.0 to avoid: https://github.com/jaagr/polybar/issues/236
# see also https://bugs.gentoo.org/show_bug.cgi?id=601204
RDEPEND="media-libs/freetype:2
	media-libs/fontconfig
	x11-libs/libX11
	x11-proto/xcb-proto
	x11-libs/libXft:0
	x11-libs/libxcb[xkb?]
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-image
	alsa? ( media-libs/alsa-lib:0 )
	curl? ( net-misc/curl )
	i3? (
		>=dev-libs/jsoncpp-1.8.0
		dev-libs/libsigc++:2
	)
	mpd? ( media-libs/libmpdclient )
	wifi? ( net-wireless/wireless-tools )"
DEPEND="dev-libs/boost[threads]"

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

	# remove bundled libs
	rm -r lib/i3ipcpp/libs/jsoncpp-1.7.7 || die
	rm -r lib/jsoncpp-1.7.7.tar.gz || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_CCACHE=OFF
		-DBUILD_TESTS="$(usex test)"
		-DENABLE_ALSA="$(usex alsa)"
		-DENABLE_CURL="$(usex curl)"
		-DENABLE_I3="$(usex i3)"
		-DENABLE_MPD="$(usex mpd)"
		-DENABLE_NETWORK="$(usex wifi)"

		-DWITH_XRANDR="ON"
		-DWITH_XRENDER="OFF"
		-DWITH_XDAMAGE="OFF"
		-DWITH_XSYNC="OFF"
		-DWITH_XCOMPOSITE="OFF"
		-DWITH_XKB="$(usex xkb)"

		-DDEBUG_LOGGER="$(usex debug)"
		-DDEBUG_HINTS="$(usex debug)"
	)
	cmake-utils_src_configure
}
