# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 cmake-utils toolchain-funcs versionator

XPP_ECOMMIT="c73db50f3020b7abe294631b25a2d302fcd9e1cb"
I3IPCPP_ECOMMIT="a6aa7a19786bdf7b96a02900510b3b3c325c8bdf"

DESCRIPTION="A fast and easy-to-use status bar"
HOMEPAGE="https://github.com/jaagr/${PN}"
SRC_URI="https://github.com/jaagr/${PN}/archive/${PV}.tar.gz -> ${PF}.tar.gz
	https://github.com/jaagr/xpp/archive/${XPP_ECOMMIT}.tar.gz -> xpp-${XPP_ECOMMIT}.tar.gz
	https://github.com/jaagr/i3ipcpp/archive/${I3IPCPP_ECOMMIT}.tar.gz -> i3ipcpp-${I3IPCPP_ECOMMIT}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="+alsa curl i3 mpd network test xcomposite xrender debug verbose-debug"

RESTRICT="mirror"

# We need jsoncpp-1.8.0 to avoid: https://github.com/jaagr/polybar/issues/236
# see also https://bugs.gentoo.org/show_bug.cgi?id=601204
RDEPEND="media-libs/fontconfig
	x11-libs/cairo[X,xcb]
	x11-libs/xcb-util-image
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-xrm
	alsa? ( media-libs/alsa-lib )
	curl? ( net-misc/curl )
	i3? (
		x11-wm/i3
		>=dev-libs/jsoncpp-1.8.0
	)
	mpd? ( media-libs/libmpdclient )
	network? ( net-wireless/wireless-tools )"
DEPEND="${RDEPEND}
	>=x11-base/xcb-proto-1.12-r2"

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

	# remove bundled libs
	rm -r lib/i3ipcpp/libs/jsoncpp-1.7.7 || die
	rm -r lib/jsoncpp-1.7.7.tar.gz || die

	default
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_IPC_MSG="ON"
		-DBUILD_TESTS="$(usex test)"

		-DENABLE_CCACHE="OFF"
		-DENABLE_ALSA="$(usex alsa)"
		-DENABLE_CURL="$(usex curl)"
		-DENABLE_I3="$(usex i3)"
		-DENABLE_MPD="$(usex mpd)"
		-DENABLE_NETWORK="$(usex network)"
		-DENABLE_XKEYBOARD="ON"

		-DWITH_XRANDR="ON"
		-DWITH_XRANDR_MONITORS="ON"
		-DWITH_XRENDER="$(usex xrender)"
		-DWITH_XDAMAGE="OFF"
		-DWITH_XSYNC="OFF"
		-DWITH_XCOMPOSITE="$(usex xcomposite)"
		-DWITH_XKB="ON"
		-DWITH_XRM="ON"
		-DWITH_XCURSOR="ON"

		-DDEBUG_LOGGER="$(usex debug)"
		-DDEBUG_LOGGER_VERBOSE="$(usex verbose-debug)"
		-DDEBUG_HINTS="$(usex debug)"
		-DDEBUG_WHITESPACE="$(usex debug)"
		-DDEBUG_FONTCONFIG="$(usex debug)"
	)
	use debug && CMAKE_BUILD_TYPE=Debug
	cmake-utils_src_configure
}
