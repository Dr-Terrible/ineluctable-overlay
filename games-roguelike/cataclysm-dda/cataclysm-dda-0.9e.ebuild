# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Roguelike set in a post-apocalyptic world"
HOMEPAGE="https://cataclysmdda.org"

# Post-0.9 versions of C:DDA employ capitalized alphabetic letters rather
# than numbers (e.g., "0.A" rather than "1.0"). Since Portage permits
# version specifiers to contain only a single suffixing letter prefixed by
# one or more digits, we:
#
# * Encode such versions as "0.9${lowercase_letter}" in ebuild filenames.
# * In the ebuilds themselves (i.e., here), we:
#   * Manually strip the "9" in such filenames.
#   * Uppercase the lowercase letter in such filenames.
REV="-2"
MY_PV="${PV/.9/.}"
MY_PV="${MY_PV^^}${REV}"
SRC_URI="https://github.com/CleverRaven/Cataclysm-DDA/archive/${MY_PV}.tar.gz -> ${P}${REV}.tar.gz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="clang debug lto lua luajit ncurses nls +sdl +sound test"

REQUIRED_USE="
	lua? ( sdl )
	luajit? ( lua )
	sound? ( sdl )
	^^ ( ncurses sdl )
"

RDEPEND="
	app-arch/bzip2
	sys-libs/zlib
	dev-util/astyle
	lua? ( dev-lang/lua:0 )
	luajit? ( dev-lang/luajit:2 )
	ncurses? ( sys-libs/ncurses:0 )
	nls? ( sys-devel/gettext:0[nls] )
	sdl? (
		media-libs/sdl2-image:0[jpeg,png]
		media-libs/sdl2-ttf:0
	)
	sound? ( media-libs/sdl2-mixer:0[vorbis] )
"

# Note that, while GCC also supports LTO via the gold linker, Portage appears
# to provide no means of validating the current GCC to link with gold. *shrug*
BDEPEND="${RDEPEND}
	virtual/pkgconfig
	clang? (
		sys-devel/clang
		debug? ( sys-devel/clang-runtime[sanitize] )
		lto?   ( sys-devel/llvm[gold] )
	)
	!clang? (
		sys-devel/gcc[cxx]
		debug? ( sys-devel/gcc[sanitize] )
	)
"

S="${WORKDIR}/Cataclysm-DDA-${MY_PV}"

src_prepare() {
	# If "doc/JSON_LOADING_ORDER.md" is still a symbolic link, replace this
	# link by a copy of its transitive target to avoid "QA Notice" complaints.
	if [[ -L doc/JSON_LOADING_ORDER.md ]]; then
		rm doc/JSON_LOADING_ORDER.md || die
		cp data/json/LOADING_ORDER.md doc/JSON_LOADING_ORDER.md || die
	fi

	# Strip the following from all makefiles:
	#
	# * Hardcoded optimization (e.g., "-O3", "-Os") and stripping (e.g., "-s").
	# * g++ option "-Werror", converting compiler warnings to errors and hence
	#   failing on the first (inevitable) warning.
	# * The makefile-specific ${BUILD_PREFIX} variable, conflicting with the
	#   Portage-specific variable of the same name. For disambiguity, this
	#   variable is renamed to a makefile-specific variable name.
 	sed -i \
		-e '/\bOPTLEVEL = /s~-O.\b~~' \
		-e '/LDFLAGS += /s~-s\b~~' \
		-e '/RELEASE_FLAGS = /s~-Werror\b~~' \
		-e 's~\bBUILD_PREFIX\b~CATACLYSM_BUILD_PREFIX~' \
		-e 's:-Wall:-w:' \
		-e 's:-Wextra:-w:' \
		Makefile tests/Makefile || die

	default
}

src_compile() {

	# Detect the current machine architecture and operating system.
	local cataclysm_arch
	use amd64 && cataclysm_arch=linux64
	use x86 && cataclysm_arch=linux32

	declare -ga myemakeargs=(
		# Unlike all other paths defined below, ${PREFIX} is compiled into
		# installed binaries and therefore *MUST* refer to a runtime rather
		# than installation-time directory (i.e., relative to ${ESYSROOT}
		# rather than ${ED}).
		PREFIX="${ESYSROOT}"/usr

		# Install-time directories. Since ${PREFIX} does *NOT* refer to an
		# install-time directory, all variables defined by the makefile
		# relative to ${PREFIX} *MUST* be redefined here relative to ${ED}.
		BIN_PREFIX="${ED}"/usr/bin
		DATA_PREFIX="${ED}/usr/share/${PN}"
		LOCALE_DIR="${ED}"/usr/share/locale

		RELEASE=$(usex debug 0 1)
		NATIVE="${cataclysm_arch}"
		WARNINGS="-w"

		# Enable backtrace and debug symbols support when USE 'debug' is enabled.
		BACKTRACE=$(usex debug 1 0)
		DEBUG_SYMBOLS=$(usex debug 1 0)
		SANITIZE=$(usex debug address '')

		# Link against system shared libraries.
		DYNAMIC_LINKING=1

		# Enable tests if requested.
		RUNTESTS=$(usex test 1 0)

		# Store saves and settings in XDG-compliant base directories.
		USE_HOME_DIR=0
		USE_XDG_DIR=1

		# Enable LuaJIT support.
		LUA=$(usex lua 1 0)
		LUA_BINARY=$(usex luajit luajit '')

		# Enable internationalization.
		# NOTE: Gentoo's ${L10N} USE_EXPAND flag conflicts with
		# Makefile's flag of the same name.
		LOCALIZE=$(usex nls 1 0)
		LANGUAGES='all'
		L10N=

		# Force enable code style and JSON linting.
		ASTYLE=1
		LINTJSON=1
	)

	# Enable backtrace and debug symbols support when USE 'debug' is enabled.
#	if use debug; then
#		myemakeargs+=(
#			BACKTRACE=1
#			DEBUG_SYMBOLS=1
#			SANITIZE="address"
#		)
#	fi

	# Enable Clang and Lto support.
	use clang && myemakeargs+=( CLANG=1 )
	use lto && myemakeargs+=( LTO=1 )

	# Compile the ncurses frontend.
	if use ncurses; then
		einfo "Compiling ncurses frontend"
		emake ${myemakeargs[@]}
	fi

	# Compile the SDL frontend.
	if use sdl; then
		# Enable tiles and sound output (SDL is mandatory)
		myemakeargs+=(
			TILES=1
			SOUND=$(usex sound 1 0)
		)

		einfo "Compiling SDL frontend"
		emake ${myemakeargs[@]}
	fi
}

src_test() {
	emake tests || die 'Tests failed.'
}

src_install() {
	# Install the ncurses-based binary.
	use ncurses && emake install ${myemakeargs[@]}

	# Install the SDL-based binary.
	use sdl && emake install ${myemakeargs[@]}

	# Replace a symbolic link in the documentation directory to be installed
	# below with the physical target file of that link. These operations are
	# non-essential to the execution of installed binaries and are thus
	# intentionally *NOT* suffixed by "|| die 'cp failed.'"-driven protection.
	#rm doc/LOADING_ORDER.md
	#cp data/json/LOADING_ORDER.md doc/

	# Recursively install all available documentation.
	dodoc -r README.md doc/*
}
