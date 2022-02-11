# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Encode and organise your music collection"
HOMEPAGE="https://github.com/115100/untz_manager"
SRC_URI="https://github.com/115100/untz_manager/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
IUSE="+cue +opus vorbis"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	cue? (
		app-cdr/cuetools
		media-sound/shntool
	)
	opus? (
		media-sound/opus-tools
	)
	vorbis? (
		media-sound/vorbis-tools
	)
	$(python_gen_cond_dep 'dev-python/pytaglib[${PYTHON_USEDEP}]')
	media-sound/loudgain
	media-libs/flac
"
