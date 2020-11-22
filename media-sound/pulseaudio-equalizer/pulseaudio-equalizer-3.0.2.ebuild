# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit python-single-r1 meson

DESCRIPTION="Pulseaudio LADSPA Equalizer"
HOMEPAGE="https://github.com/pulseaudio-equalizer-ladspa/equalizer"
SRC_URI="https://github.com/pulseaudio-equalizer-ladspa/equalizer/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="GPL-3"
SLOT="0"

BDEPEND="
	sys-devel/bc
"
RDEPEND="
	app-shells/bash
	>=dev-python/pygobject-3.30
	media-plugins/swh-plugins
	media-sound/pulseaudio
	x11-libs/gtk+:3
"

src_unpack() {
	if [[ -n ${A} ]]; then
		unpack ${A}
	fi
	mv ${WORKDIR}/equalizer-${PV} ${WORKDIR}/${P}
}

src_install() {
	meson_src_install
	python_fix_shebang "${D}"/usr/bin/pulseaudio-equalizer-gtk
	python_optimize
}
