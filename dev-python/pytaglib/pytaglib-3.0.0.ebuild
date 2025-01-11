# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..13} )
inherit distutils-r1

DESCRIPTION="Python wrapper for taglib library"
HOMEPAGE="https://pypi.org/project/pytaglib/"
SRC_URI="https://github.com/supermihi/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-python/cython"
RDEPEND=">=media-libs/taglib-2.0"
DEPEND="${RDEPEND}"
RESTRICT="test"
