# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/redmine/redmine-2.2.0.ebuild,v 1.1 2013/01/07 13:39:26 matsuu Exp $

EAPI="3"
# jruby: dev-ruby/rails has no jruby
# rbx: dev-ruby/rails has no rbx
#USE_RUBY="ruby18 ree18"
USE_RUBY="ruby18 ruby19"
inherit eutils user depend.apache ruby-ng

DESCRIPTION="Redmine is a flexible project management web application written using Ruby on Rails framework"
HOMEPAGE="http://www.redmine.org/"
SRC_URI="mirror://rubyforge/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"
#IUSE="bazaar cvs darcs fastcgi git imagemagick mercurial mysql openid passenger postgres sqlite3 subversion"
IUSE="fastcgi imagemagick ldap openid passenger"

#RDEPEND="$(ruby_implementation_depend ruby18 '>=' -1.8.6)[ssl]"

ruby_add_rdepend "virtual/ruby-ssl
	virtual/rubygems
	>=dev-ruby/coderay-1.0.6
	dev-ruby/i18n:0.6
	>=dev-ruby/rake-10.0.3
	>=dev-ruby/rails-3.2.11:3.2
	>=dev-ruby/jquery-rails-2.0.2
	dev-ruby/builder:3
	dev-ruby/bundler
	>=dev-ruby/rack-1.4.4
	>=dev-ruby/mocha-0.12.7
	fastcgi? ( dev-ruby/fcgi )
	imagemagick? ( >=dev-ruby/rmagick-2 )
	ldap? ( >=dev-ruby/ruby-net-ldap-0.3.1 )
	openid? ( >=dev-ruby/ruby-openid-2.1.4 )
	passenger? ( www-apache/passenger )
	"
#	ruby_targets_ruby18? (
#		>=dev-ruby/fastercsv-1.5
#		postgres? ( >=dev-ruby/pg-0.11 )
#		sqlite3? ( dev-ruby/sqlite3 )
#		mysql? ( >=dev-ruby/mysql-ruby-2.8.1 )
#	)
#	ruby_targets_ruby19? (
#		postgres? ( >=dev-ruby/pg-0.11 )
#		sqlite3? ( dev-ruby/sqlite3 )
#		mysql? ( dev-ruby/mysql2:0.3 )
#	)
#	ruby_targets_jruby? (
#		dev-ruby/jruby-openssl
#		>=dev-ruby/fastercsv-1.5
#		mysql? ( dev-ruby/activerecord-jdbcmysql-adapter )
#		postgres? ( dev-ruby/activerecord-jdbcpostgresql-adapter )
#		sqlite3? ( dev-ruby/activerecord-jdbcsqlite3-adapter )
#	)

#ruby_add_bdepend ">=dev-ruby/rdoc-2.4.2
#	yard
#	test? (
#		!ruby_targets_ruby19? (
#			>=dev-ruby/shoulda-2.11
#		)
#		ruby_targets_ruby19? (
#			dev-ruby/test-unit
#		)
#		ruby_targets_jruby? (
#			dev-ruby/test-unit
#		)
#		>=dev-ruby/mocha-0.12.3
#	)"

#RDEPEND="${RDEPEND}
#	bazaar ( dev-vcs/bazaar )
#	cvs? ( >=dev-vcs/cvs-1.12 )
#	darcs? ( dev-vcs/darcs )
#	git? ( dev-vcs/git )
#	mercurial? ( dev-vcs/mercurial )
#	subversion? ( >=dev-vcs/subversion-1.3 )"

REDMINE_DIR="/var/lib/${PN}"

pkg_setup() {
	enewgroup redmine
	# home directory is required for SCM.
	enewuser redmine -1 -1 "${REDMINE_DIR}" redmine
}

all_ruby_prepare() {
	rm -r log files/delete.me || die

	# bug #406605
	rm .gitignore .hgignore || die

	#rm Gemfile config/preinitializer.rb || die

	echo "CONFIG_PROTECT=\"${EPREFIX}${REDMINE_DIR}/config\"" > "${T}/50${PN}"
	echo "CONFIG_PROTECT_MASK=\"${EPREFIX}${REDMINE_DIR}/config/locales ${EPREFIX}${REDMINE_DIR}/config/settings.yml\"" >> "${T}/50${PN}"
}

all_ruby_install() {
	dodoc doc/{CHANGELOG,INSTALL,README_FOR_APP,RUNNING_TESTS,UPGRADING} || die
	rm -fr doc || die
	dodoc README.rdoc || die
	rm README.rdoc || die

	keepdir /var/log/${PN} || die
	dosym /var/log/${PN}/ "${REDMINE_DIR}/log" || die

	insinto "${REDMINE_DIR}"
	doins -r . || die
	keepdir "${REDMINE_DIR}/files" || die
	keepdir "${REDMINE_DIR}/public/plugin_assets" || die

	fowners -R redmine:redmine \
		"${REDMINE_DIR}/config" \
		"${REDMINE_DIR}/files" \
		"${REDMINE_DIR}/public/plugin_assets" \
		"${REDMINE_DIR}/tmp" \
		/var/log/${PN} || die
	# for SCM
	fowners redmine:redmine "${REDMINE_DIR}" || die
	# bug #406605
	fperms -R go-rwx \
		"${REDMINE_DIR}/config" \
		"${REDMINE_DIR}/files" \
		"${REDMINE_DIR}/tmp" \
		/var/log/${PN} || die

	if use passenger ; then
		has_apache
		insinto "${APACHE_VHOSTS_CONFDIR}"
		doins "${FILESDIR}/10_redmine_vhost.conf" || die
	else
		newconfd "${FILESDIR}/${PN}.confd" ${PN} || die
		newinitd "${FILESDIR}/${PN}-2.initd" ${PN} || die
		keepdir /var/run/${PN} || die
		fowners -R redmine:redmine /var/run/${PN} || die
		dosym /var/run/${PN}/ "${REDMINE_DIR}/tmp/pids" || die
	fi
	doenvd "${T}/50${PN}" || die
}

pkg_postinst() {
	einfo
	if [ -e "${EPREFIX}${REDMINE_DIR}/config/initializers/session_store.rb" -o -e "${EPREFIX}${REDMINE_DIR}/config/initializers/secret_token.rb" ] ; then
		elog "Execute the following command to upgrade environment:"
		elog
		elog "# emerge --config \"=${CATEGORY}/${PF}\""
		elog
		elog "For upgrade instructions take a look at:"
		elog "http://www.redmine.org/wiki/redmine/RedmineUpgrade"
	else
		elog "Execute the following command to initlize environment:"
		elog
		elog "# cd ${EPREFIX}${REDMINE_DIR}"
		elog "# cp config/database.yml.example config/database.yml"
		elog "# \${EDITOR} config/database.yml"
		elog "# chown redmine:redmine config/database.yml"
		elog "# emerge --config \"=${CATEGORY}/${PF}\""
		elog
		elog "Installation notes are at official site"
		elog "http://www.redmine.org/wiki/redmine/RedmineInstall"
	fi
	einfo
}

pkg_config() {
	if [ ! -e "${EPREFIX}${REDMINE_DIR}/config/database.yml" ] ; then
		eerror "Copy ${EPREFIX}${REDMINE_DIR}/config/database.yml.example to ${EPREFIX}${REDMINE_DIR}/config/database.yml and edit this file in order to configure your database settings for \"production\" environment."
		die
	fi

	local RAILS_ENV=${RAILS_ENV:-production}
	local RUBY=${RUBY:-ruby18}

	cd "${EPREFIX}${REDMINE_DIR}"
	if [ -e "${EPREFIX}${REDMINE_DIR}/config/initializers/session_store.rb" ] ; then
		einfo
		einfo "Generate secret token."
		einfo
		rm config/initializers/session_store.rb || die
		RAILS_ENV="${RAILS_ENV}" ${RUBY} -S rake generate_secret_token || die
	fi
	if [ -e "${EPREFIX}${REDMINE_DIR}/config/initializers/secret_token.rb" ] ; then
		einfo
		einfo "Upgrade database."
		einfo

		einfo "Migrate database."
		RAILS_ENV="${RAILS_ENV}" ${RUBY} -S rake db:migrate || die
		einfo "Upgrade the plugin migrations."
		RAILS_ENV="${RAILS_ENV}" ${RUBY} -S rake redmine:plugins:migrate || die
		einfo "Clear the cache and the existing sessions."
		${RUBY} -S rake tmp:cache:clear || die
		${RUBY} -S rake tmp:sessions:clear || die
	else
		einfo
		einfo "Initialize database."
		einfo

		einfo "Generate a session store secret."
		${RUBY} -S rake generate_secret_token || die
		einfo "Create the database structure."
		RAILS_ENV="${RAILS_ENV}" ${RUBY} -S rake db:migrate || die
		einfo "Insert default configuration data in database."
		RAILS_ENV="${RAILS_ENV}" ${RUBY} -S rake redmine:load_default_data || die
		einfo
		einfo "If you use sqlite3. please do not forget to change the ownership of the sqlite files."
		einfo
		einfo "# cd \"${EPREFIX}${REDMINE_DIR}\""
		einfo "# chown redmine:redmine db/ db/*.sqlite3"
		einfo
	fi
}
