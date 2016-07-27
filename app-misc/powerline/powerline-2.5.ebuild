# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit font systemd readme.gentoo-r1 distutils-r1

ECOMMIT="6e2e0b2f9221fbff117be3d190f9293b40ba64cd"

DESCRIPTION="Python-based statusline/prompt utility"
HOMEPAGE="https://pypi.python.org/pypi/powerline-status"
SRC_URI="https://github.com/${PN}/${PN}/archive/${ECOMMIT}.tar.gz -> ${PF}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="awesome busybox +bash dash doc +extra fish +man mksh rc qtile tmux +zsh"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Some optional dependencies are only available for a limited subset of
# architectures supported by this ebuild. For example, "app-shells/rc" is only
# available for amd64 and x86 architectures. Such dependencies are explicitly
# masked in the corresponding "profiles/arch/${ARCH}/package.use.mask" file for
# this overlay.
CDEPEND="extra? (
	dev-python/netifaces[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
)"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	man? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
RDEPEND="${CDEPEND}
	!media-fonts/powerline-symbols
	awesome? ( >=x11-wm/awesome-3.5.1 )
	bash? ( app-shells/bash )
	busybox? ( sys-apps/busybox )
	dash? ( app-shells/dash )
	fish? ( >=app-shells/fish-2.1 )
	mksh? ( app-shells/mksh )
	qtile? ( >=x11-wm/qtile-0.6 )
	rc? ( app-shells/rc )
	zsh? ( app-shells/zsh )"

S="${WORKDIR}/${PN}-${ECOMMIT}"

# OpenType Unicode font with symbols for Powerline/Airline
FONT_S="${S}/font"
FONT_SUFFIX="otf"
FONT_CONF=( ${FONT_S}/10-powerline-symbols.conf )

# Source directory containing application-specific Powerline bindings, from
# which all non-Python files will be removed. See python_prepare_all().
POWERLINE_SRC_BINDINGS_PYTHON_DIR="${S}"/powerline/bindings

# Temporary directory housing application-specific Powerline bindings, from
# which all Python files will be removed. See python_prepare_all().
POWERLINE_TMP_BINDINGS_NONPYTHON_DIR="${T}"/bindings

# Temporary directory housing application-specific Powerline bindings, from
# which all *NO* files will be removed. See python_prepare_all().
POWERLINE_TMP_BINDINGS_DIR="${T}"/bindings-full

# Final target directory to which all applicable files will be installed.
POWERLINE_HOME=/usr/share/powerline
POWERLINE_HOME_EROOTED="${EROOT}"usr/share/powerline/

# Powerline's Travis-specific continuous integration repository.
TEST_EGIT_REPO_URI="https://github.com/powerline/bot-ci"
TEST_EGIT_BRANCH="master"

# void powerline_set_config_var_to_value(
#     string variable_name, string variable_value)
#
# Globally replace each string assigned to the passed Python variable in
# Powerline's Python configuration with the passed string.
powerline_set_config_var_to_value() {
	(( ${#} == 2 )) || die 'Expected one variable name and one variable value.'
	sed -i -e 's~^\('${1}' = \).*~\1'"'"${2}"'~" "${S}"/powerline/config.py ||
		die '"sed" failed.'
}

python_prepare_all() {
	# Replace nonstandard system paths in Powerline's Python configuration.
	powerline_set_config_var_to_value\
		DEFAULT_SYSTEM_CONFIG_DIR "${EROOT}"etc/xdg
	powerline_set_config_var_to_value\
		BINDINGS_DIRECTORY "${POWERLINE_HOME_EROOTED}"

	# Copy application-specific Powerline bindings to a temporary directory.
	# Since such bindings comprise both Python and non-Python files, failing to
	# remove the latter causes distutils to install non-Python files into the
	# Powerline Python module directory. To safely remove such files *AND*
	# permit their installation after the main distutils-based installation,
	# copy them to such directory and then remove them from the original
	# directory that distutils operates on.
	cp -R "${POWERLINE_SRC_BINDINGS_PYTHON_DIR}" "${POWERLINE_TMP_BINDINGS_NONPYTHON_DIR}" ||
		die '"cp" failed.'

	# Remove all non-Python files from the original tree.
	find "${POWERLINE_SRC_BINDINGS_PYTHON_DIR}"\
		-type f\
		-not -name '*.py'\
		-delete

	# Remove all Python files from the copied tree, for safety. Most such files
	# relate to Powerline's distutils-based install process. Exclude the
	# following unrelated Python files:
	#
	# * "powerline-awesome.py", an awesome-specific integration script.
	find "${POWERLINE_TMP_BINDINGS_NONPYTHON_DIR}"\
		-type f\
		-name '*.py'\
		-not -name 'powerline-awesome.py'\
		-delete

	# Continue with the default behaviour.
	distutils-r1_python_prepare_all
}

python_compile_all() {
	# Build documentation, if both available *AND* requested by the user.
	if use doc && [[ -d "${S}"/docs ]]; then
		einfo 'Generating documentation'
		sphinx-build -b html "${S}"/docs/source docs_output ||
			die 'HTML documentation compilation failed.'
		HTML_DOCS=( docs_output/. )
	fi

	# Build man pages.
	if use man; then
		einfo 'Generating man pages'
		sphinx-build -b man "${S}"/docs/source man_pages ||
			die 'Manpage compilation failed.'
	fi
}

python_install_all() {
	# Install man pages.
	use man && doman man_pages/*.1

	# Install init scripts
	#systemd_dounit "${FILESDIR}/systemd/${PN}.service"
	einfo "${S}/powerline/powerline/dist/systemd/powerline-daemon.service"
	systemd_douserunit "${S}"/powerline/dist/systemd/powerline-daemon.service || die

	# Contents of the "/usr/share/doc/${P}/README.gentoo" file to be installed.
	DOC_CONTENTS=""

	# Install application-specific libraries and documentation.
	if use awesome; then
		local AWESOME_LIB_DIR='/usr/share/awesome/lib/powerline'
		insinto "${AWESOME_LIB_DIR}"
		newins "${POWERLINE_TMP_BINDINGS_NONPYTHON_DIR}"/awesome/powerline.lua init.lua
		exeinto "${AWESOME_LIB_DIR}"
		doexe  "${POWERLINE_TMP_BINDINGS_NONPYTHON_DIR}"/awesome/powerline-awesome.py

		DOC_CONTENTS+="
	To enable Powerline under awesome, add the following lines to \"~/.config/awesome/rc.lua\" (assuming you originally copied such file from \"/etc/xdg/awesome/rc.lua\"):\\n
	\\trequire(\"powerline\")\\n
	\\tright_layout:add(powerline_widget)\\n\\n"
	fi

	if use bash; then
		insinto "${POWERLINE_HOME}"/bash
		doins   "${POWERLINE_TMP_BINDINGS_NONPYTHON_DIR}"/bash/powerline.sh

		DOC_CONTENTS+="
	To enable Powerline under bash, add the following line to either \"~/.bashrc\" or \"~/.profile\":\\n
	\\tsource ${POWERLINE_HOME_EROOTED}bash/powerline.sh\\n\\n"
	fi

	if use busybox; then
		insinto "${POWERLINE_HOME}"/busybox
		doins   "${POWERLINE_TMP_BINDINGS_NONPYTHON_DIR}"/shell/powerline.sh

		DOC_CONTENTS+="
	To enable Powerline under interactive sessions of BusyBox's ash shell, interactively run the following command:\\n
	\\t. ${POWERLINE_HOME_EROOTED}busybox/powerline.sh\\n\\n"
	fi

	if use dash; then
		insinto "${POWERLINE_HOME}"/dash
		doins   "${POWERLINE_TMP_BINDINGS_NONPYTHON_DIR}"/shell/powerline.sh

		DOC_CONTENTS+="
	To enable Powerline under dash, add the following line to the file referenced by environment variable \${ENV}:\\n
	\\t. ${POWERLINE_HOME_EROOTED}dash/powerline.sh\\n
	If such variable does not exist, you may need to manually create such file.\\n\\n"
	fi

	if use fish; then
		insinto /usr/share/fish/functions
		doins "${POWERLINE_TMP_BINDINGS_NONPYTHON_DIR}"/fish/powerline-setup.fish

		DOC_CONTENTS+="
	To enable Powerline under fish, add the following line to \"~/.config/fish/config.fish\":\\n
	\\tpowerline-setup\\n\\n"
	fi

	if use mksh; then
		insinto "${POWERLINE_HOME}"/mksh
		doins   "${POWERLINE_TMP_BINDINGS_NONPYTHON_DIR}"/shell/powerline.sh

		DOC_CONTENTS+="
	To enable Powerline under mksh, add the following line to \"~/.mkshrc\":\\n
	\\t. ${POWERLINE_HOME_EROOTED}mksh/powerline.sh\\n\\n"
	fi

	if use qtile; then
		DOC_CONTENTS+="
	To enable powerline under qtile, add the following to \"~/.config/qtile/config.py\":\\n
	\\tfrom libqtile.bar import Bar\\n
	\\tfrom libqtile.config import Screen\\n
	\\tfrom libqtile.widget import Spacer\\n
	\\t\\n
	\\tfrom powerline.bindings.qtile.widget import PowerlineTextBox\\n
	\\t\\n
	\\tscreens = [\\n
	\\t   Screen(\\n
	\\t       top=Bar([\\n
	\\t               PowerlineTextBox(timeout=2, side='left'),\\n
	\\t               Spacer(),\\n
	\\t               PowerlineTextBox(timeout=2, side='right'),\\n
	\\t           ],\\n
	\\t           35\\n
	\\t       ),\\n
	\\t   ),\\n
	\\t]\\n\\n"
	fi

	if use rc; then
		insinto "${POWERLINE_HOME}"/rc
		doins   "${POWERLINE_TMP_BINDINGS_NONPYTHON_DIR}"/rc/powerline.rc

		DOC_CONTENTS+="
	To enable Powerline under rc shell, add the following line to \"~/.rcrc\":\\n
	\\t. ${POWERLINE_HOME_EROOTED}rc/powerline.rc\\n\\n"
	fi

	if use tmux; then
		insinto "${POWERLINE_HOME}"/tmux
		doins   "${POWERLINE_TMP_BINDINGS_NONPYTHON_DIR}"/tmux/powerline*.conf

		DOC_CONTENTS+="
	To enable Powerline under tmux, add the following line to \"~/.tmux.conf\":\\n
	\\tsource ${POWERLINE_HOME_EROOTED}tmux/powerline.conf\\n\\n"
	fi

	if use zsh; then
		insinto /usr/share/zsh/site-contrib
		doins "${POWERLINE_TMP_BINDINGS_NONPYTHON_DIR}"/zsh/powerline.zsh

		DOC_CONTENTS+="
	To enable Powerline under zsh, add the following line to \"~/.zshrc\":\\n
	\\tsource ${EROOT}usr/share/zsh/site-contrib/powerline.zsh\\n\\n"
	fi

	# Install Powerline configuration files.
	insinto /etc/xdg/powerline
	doins -r "${S}"/powerline/config_files/*

	# If no USE flags were enabled, ${DOC_CONTENTS} will be empty, in which case
	# calling readme.gentoo_create_doc() throws the following fatal error:
	#
	#     "You are not specifying README.gentoo contents!"
	#
	# Avoid this by defaulting ${DOC_CONTENTS} to a non-empty string if empty.
	DOC_CONTENTS=${DOC_CONTENTS:-All Powerline USE flags were disabled.}

	# Install Gentoo-specific documentation.
	readme.gentoo_create_doc

	# Install Powerline python modules.
	distutils-r1_python_install_all
}

pkg_setup() {
	font_pkg_setup
}

src_install() {
	distutils-r1_src_install

	# Install Powerline fontset
	font_src_install
}

pkg_postinst() {
	font_pkg_postinst
	readme.gentoo_print_elog
}

pkg_postrm() {
	font_pkg_postrm
}
