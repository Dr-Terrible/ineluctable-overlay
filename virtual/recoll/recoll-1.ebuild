# Copyright 1999-2021 Ineluctable Overlay Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for recoll"
SLOT="0"
KEYWORDS="-*"
IUSE="epub exif lzma pdf postscript rar rtf ical djvu"

RDEPEND=">=app-misc/recoll-1.28.0
	app-text/antiword
	dev-libs/libxslt
	dev-libs/libxml2[python]
	epub? ( dev-python/epub )
	exif? ( media-libs/exiftool )
	lzma? ( >=dev-python/py7zr-0.11.3 )
	pdf? (
		app-text/poppler
		app-text/tesseract
	)
	postscript? ( app-text/pstotext )
	rar? ( dev-python/rarfile )
	rtf? ( app-text/unrtf )
	ical? ( dev-python/icalendar )
	djvu? ( app-text/djvu )"
