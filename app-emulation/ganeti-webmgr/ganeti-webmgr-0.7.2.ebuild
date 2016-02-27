# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils distutils-r1

DESCRIPTION="Ganeti Web Manager is an application for Ganeti clusters
administration"
HOMEPAGE="http://code.osuosl.org/projects/ganeti-webmgr"
SRC_URI="http://code.osuosl.org/attachments/download/2457/${PN}.${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="vnc mysql postgres +sqlite test +webserver"
REQUIRED_USE="|| ( mysql postgres sqlite )"

RDEPEND="dev-python/django[${PYTHON_USEDEP},sqlite?]
	dev-python/django-registration
	>=dev-python/django-haystack-1.2.3
	dev-python/django-muddle-users
	dev-python/django-fields
	dev-python/south
	dev-python/whoosh
	dev-python/pycurl
	dev-python/pyopenssl
	dev-python/simplejson
	>=dev-python/ganeti-webmgr-layout-0.8
	postgres? ( dev-python/psycopg:0 )
	vnc? ( dev-python/twisted-web )"
DEPEND="${RDEPEND}
	test? ( dev-python/unittest2 )"

PYTHON_MODNAME="${PN/-/_}"

S="${WORKDIR}/${PYTHON_MODNAME}"
DOCS="AUTHORS CHANGELOG COPYING LICENSE README UPGRADING"

GWM_DIR="/var/lib/${PYTHON_MODNAME}"

pkg_setup() {
	# checking python setup
	python_set_active_version 2
	python_pkg_setup

	# show a warning about not well supported backends from south
	if use postgres || use mysql; then
		einfo
		ewarn "Postgres and MySQL are not officially supported at the moment."
		ewarn "Use these backends at your own risk."
		einfo
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-settings.patch
}

src_compile() { :; }
src_install() {
	# cleaning unused 'fab' and 'sip' utilities
	# (we use portage to install deps)
	rm fabfile.py || die

	# installing docs
	dodoc ${DOCS}
	rm ${DOCS} || die

	# installing app
	insinto "${GWM_DIR}"
	doins -r "${S}"/*
	fperms 0550 "${GWM_DIR}/manage.py"

	# installing init.d files
	if use webserver; then
		doinitd "${FILESDIR}/${PN}"
	#	doinitd "${FILESDIR}/${PN}-cache"
	#	doinitd "${FILESDIR}/${PN}-flashpolicy"
	#	use vnc && doinitd "${FILESDIR}/${PN}-vncproxy"
		newconfd "${FILESDIR}/${PN}-confd" "${PN}"
		dodir /var/run/"${PYTHON_MODNAME}"
	fi
}

src_test() {
	cp "${FILESDIR}/settings-test.py" settings.py || die
	"$(PYTHON)" manage.py test -v 2 --failfast || die
	rm settings.py *.pyc || die
}

pkg_postinst() {
	einfo
	elog "Before initializing the Haystack database, you MUST edit"
	elog "your configuration options:"
	elog "# cd ${EPREFIX}${GWM_DIR}"
	elog "# cp settings.py.dist settings.py"
	elog "# ${EDITOR} settings.py"
	elog
	elog "Then, execute the following command to setup the initial"
	elog "database environment:"
	elog "# emerge --config =${CATEGORY}/${PF}"
	elog

	if use webserver; then
		elog ""
		elog ""
	fi

	elog "Usage notes are on-line on the official web-site:"
	elog "http://code.osuosl.org/projects/ganeti-webmgr/wiki"
	einfo
}
pkg_postrm() { :; }

pkg_config() {
	einfo "Moving into: ${GWM_DIR}"
	cd ${GWM_DIR} || die
	einfo "Initializing the database ..."
	"$(PYTHON)" /var/lib/"${PYTHON_MODNAME}"/manage.py syncdb --migrate || die
}
