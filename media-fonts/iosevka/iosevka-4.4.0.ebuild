# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Slender typeface for code, from code"
HOMEPAGE="https://be5invis.github.io/Iosevka/"
SRC_URI="https://github.com/be5invis/${PN}/releases/download/v${PV}/ttc-${P}.zip
slab? (
	https://github.com/be5invis/${PN}/releases/download/v${PV}/ttc-${PN}-slab-${PV}.zip
)
"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="+slab"

DEPEND="app-arch/unzip"

S=${WORKDIR}
FONT_SUFFIX="ttc"
