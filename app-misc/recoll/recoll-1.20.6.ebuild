# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
AUTOTOOLS_IN_SOURCE_BUILD=1
AUTOTOOLS_AUTORECONF=1
inherit toolchain-funcs qmake-utils linux-info python-r1 readme.gentoo autotools-utils

DESCRIPTION="A personal full text search package"
HOMEPAGE="http://www.recoll.org"
SRC_URI="http://www.lesbonscomptes.com/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

INDEX_HELPERS="audio chm djvu dvi exif postscript ics info lyx msdoc msppt msxls pdf rtf tex wordperfect xml"
IUSE="+spell inotify +qt5 +session camelcase xattr webkit fam threads ${INDEX_HELPERS}"

RESTRICT+=" mirror"

DEPEND="virtual/libiconv
	>=dev-libs/xapian-1.0.12
	sys-libs/zlib
	spell? ( app-text/aspell )
	!inotify? ( fam? ( virtual/fam ) )
	qt5? (
		dev-qt/qtcore:5
		webkit? ( dev-qt/qtwebkit:5 )
	)
	session? (
		inotify? ( x11-libs/libX11 x11-libs/libSM x11-libs/libICE )
		!inotify? ( fam? ( x11-libs/libX11 x11-libs/libSM x11-libs/libICE ) )
	)"

RDEPEND="${DEPEND}
	app-arch/unzip
	sys-apps/sed
	virtual/awk
	pdf? ( app-text/poppler )
	postscript? ( app-text/pstotext )
	msdoc? ( app-text/antiword )
	msxls? ( app-text/catdoc )
	msppt? ( app-text/catdoc )
	wordperfect? ( app-text/libwpd:0.9 )
	rtf? ( app-text/unrtf )
	tex? ( dev-tex/detex )
	dvi? ( virtual/tex-base )
	djvu? ( >=app-text/djvu-3.5.15 )
	exif? ( media-libs/exiftool )
	chm? ( dev-python/pychm )
	ics? ( dev-python/icalendar )
	lyx? ( app-office/lyx )
	audio? ( media-libs/mutagen )
	xml? ( dev-libs/libxslt )
	info? ( sys-apps/texinfo )"

REQUIRED_USE="session? ( || ( fam inotify ) )"

DOCS=(ChangeLog README)

PATCHES=(
	"${FILESDIR}/${PN}-cflags.patch"
)

pkg_pretend() {
	if use inotify; then
		CONFIG_CHECK="~INOTIFY_USER"
		check_extra_config
	fi
}

pkg_setup() {
	local i at_least_one_helper

	at_least_one_helper=0
	for i in $INDEX_HELPERS; do
		if use $i; then
			at_least_one_helper=1
			break
		fi
	done
	if [[ $at_least_one_helper -eq 0 ]]; then
		ewarn
		ewarn "You did not enable any of the optional file format flags."
		ewarn "Recoll can read some file formats natively, but many of them"
		ewarn "are optional since they require external helpers."
		ewarn
	fi
}

src_prepare() {
	use xattr && has_version "${CATEGORY}/${PN}:${SLOT}[-xattr]" && FORCE_PRINT_ELOG="yes"
	! use xattr && has_version "${CATEGORY}/${PN}:${SLOT}[xattr]" && FORCE_PRINT_ELOG="yes"

	DOC_CONTENTS="Default configuration files located at
		/usr/share/${PN}/examples. Either edit these files to match
		your needs or copy them to ~/.${PN}/ and edit these files
		instead."

	use xattr && DOC_CONTENTS+="
		Use flag 'xattr' enables support for fetching field values from extended
		file attributes. You will also need to set up a map from the attributes
		names to the Recoll field names (see comment at the end of the fields
		configuration file)."

	# don't strip binaries
	sed -i -e "/STRIP/d" "${S}"/${PN}install.in || die

	# FIX: force makefiles to honor LDFLAGS
	sed -i -e "s:ar ru:$(tc-getAR) ru:" lib/mkMake.in || die
	sed -i -e "/QMAKE/d" Makefile.in || die
	for FILE in $( find "${S}" -name Makefile -type f ); do
		sed -i -e "s:\$(ALL_CXXFLAGS):\$(ALL_CXXFLAGS) \$(LDFLAGS):" \
			${FILE} || die
	done

	autotools-utils_src_prepare
}

src_configure() {
	local qtconf

	if use qt5 || use webkit; then
		qtconf="QMAKEPATH=/usr/bin/qmake"
	fi

	local myeconfargs=(
		$(use_with spell aspell)
		$(use_with inotify)
		$(use_with fam)
		$(use_with qt5 x)
		$(use_enable xattr)
		$(use_enable qt5 qtgui)
		$(use_enable webkit)
		$(use_enable camelcase)
		$(use_enable threads idxthreads)
		$(use_enable session x11mon)
		${qtconf}
	)
	autotools-utils_src_configure

	if use qt5 || use webkit; then
		cd qtgui || die
		eqmake4 ${PN}.pro
	fi
}

src_install() {
	autotools-utils_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	if [[ -n ${REPLACING_VERSIONS} ]]; then
		elog
		elog "Recoll ${PV} introduces significant index formats changes, and it"
		elog "will be advisable to reset the index in most cases."
		elog
		elog "The best method is to quit all Recoll programs and entirely"
		elog "delete the index directory:"
		elog "  $ rm -rf ~/.${PN}/xapiandb"
		elog "then start /usr/bin/recoll or /usr/bin/recollindex."
		elog
		elog "Always reset the index if you do not know by which Recoll version"
		elog "it was created."
	fi
}
