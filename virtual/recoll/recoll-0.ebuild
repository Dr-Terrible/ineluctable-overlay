# Copyright 1999-2019 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for recoll"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="epub exif lzma pdf postscript rar rtf"

RDEPEND="app-misc/recoll
	app-text/antiword
	dev-libs/libxslt[python]
	dev-libs/libxml2[python]
	epub? ( dev-python/epub )
	exif? ( media-libs/exiftool )
	lzma? ( dev-python/pylzma )
	pdf? ( app-text/tesseract )
	postscript? ( app-text/pstotext )
	rar? ( dev-python/rarfile )
	rtf? ( app-text/unrtf )"
