# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for recoll"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="epub exif postscript"

RDEPEND="app-misc/recoll
	app-text/antiword
	dev-libs/libxslt[python]
	dev-libs/libxml2[python]
	exif? ( media-libs/exiftool )
	postscript? ( app-text/pstotext )
	epub? ( dev-python/epub )"
