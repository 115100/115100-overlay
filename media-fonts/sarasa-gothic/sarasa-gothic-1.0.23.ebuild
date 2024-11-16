# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font unpacker

DESCRIPTION="A CJK programming font based on Iosevka and Source Han Sans"
HOMEPAGE="https://be5invis.github.io/Sarasa-Gothic/"
SRC_URI="https://github.com/be5invis/${PN}/releases/download/v${PV}/Sarasa-TTC-${PV}.7z -> ${P}.7z"

S=${WORKDIR}
LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="app-arch/p7zip"

FONT_S="${S}"
FONT_SUFFIX="ttc"

src_unpack() {
	unpack_7z ${P}.7z
}
