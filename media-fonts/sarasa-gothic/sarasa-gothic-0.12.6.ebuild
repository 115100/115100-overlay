# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="A CJK programming font based on Iosevka and Source Han Sans"
HOMEPAGE="https://be5invis.github.io/Sarasa-Gothic/"
SRC_URI="https://github.com/be5invis/${PN}/releases/download/v${PV}/${PN}-ttc-${PV}.7z"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="app-arch/p7zip"

S=${WORKDIR}
FONT_S="${S}"
FONT_SUFFIX="ttc"
