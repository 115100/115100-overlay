# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit python-r1 meson

DESCRIPTION="A GTK front-end to ratbagd"
HOMEPAGE="https://github.com/libratbag/piper"
SRC_URI="https://github.com/libratbag/piper/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~amd64"

SLOT="0"

DEPEND="
	>=dev-util/meson-0.40.0
"

RDEPEND="
	>=x11-libs/gtk+-3.22
	dev-libs/libratbag
	dev-python/pygobject:3
	dev-python/python-evdev
"

src_prepare() {
	default
	python_setup
}

src_install() {
	meson_src_install
	python_fix_shebang "${D}"/usr/bin/piper
	python_optimize
}
