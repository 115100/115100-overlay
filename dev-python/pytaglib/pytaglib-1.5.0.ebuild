# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9,10} )
inherit distutils-r1

DESCRIPTION="Python wrapper for taglib library"
HOMEPAGE="https://pypi.org/project/pytaglib/"
SRC_URI="https://github.com/supermihi/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="media-libs/taglib"
DEPEND="${RDEPEND}"
