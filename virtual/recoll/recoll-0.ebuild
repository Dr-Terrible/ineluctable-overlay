# Copyright 1999-2020 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for recoll"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="epub exif lzma pdf postscript rar rtf ical djvu"

RDEPEND="app-misc/recoll
	app-text/antiword
	dev-libs/libxslt[python]
	dev-libs/libxml2[python]
	epub? ( dev-python/epub )
	exif? ( media-libs/exiftool )
	lzma? ( >=dev-python/pylzma-0.5.0 )
	pdf? (
		app-text/poppler
		app-text/tesseract
	)
	postscript? ( app-text/pstotext )
	rar? ( dev-python/rarfile )
	rtf? ( app-text/unrtf )
	ical? ( dev-python/icalendar )
	djvu? ( app-text/djvu )"
