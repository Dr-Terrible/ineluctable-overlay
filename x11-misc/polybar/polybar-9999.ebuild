# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 cmake-utils git-r3 toolchain-funcs versionator

DESCRIPTION="A fast and easy-to-use status bar"
HOMEPAGE="https://github.com/jaagr/${PN}"
EGIT_REPO_URI="https://github.com/jaagr/${PN}.git"
EGIT_SUBMODULES=('*')


LICENSE="MIT"
SLOT="0"
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
