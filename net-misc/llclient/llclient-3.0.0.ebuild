# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9,10} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Set of Python functions for load.link's API."
HOMEPAGE="https://github.com/115100/llclient"
SRC_URI="https://github.com/115100/llclient/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/clint[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests-toolbelt[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/wand[${PYTHON_USEDEP}]
		dev-python/watchdog[${PYTHON_USEDEP}]
	')
	media-sound/alsa-utils
	gui-apps/wl-clipboard
"
