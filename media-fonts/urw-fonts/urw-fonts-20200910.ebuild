# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_PN="urw-base35-fonts"

DESCRIPTION="Repository for (URW)++ base 35 font set"
HOMEPAGE="https://github.com/ArtifexSoftware/urw-base35-fonts"
SRC_URI="https://github.com/ArtifexSoftware/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	cd "${S}"/fontconfig
	for f in *.conf ; do
		mv "${f}" "30-${f}"
	done || die "src_prepare failed"
	cd "${S}"
	default
}

FONT_SUFFIX="otf"
FONT_S="fonts"
FONT_CONF=(
	fontconfig/30-urw-bookman.conf
	fontconfig/30-urw-c059.conf
	fontconfig/30-urw-d050000l.conf
	fontconfig/30-urw-fallback-backwards.conf
	fontconfig/30-urw-fallback-generics.conf
	fontconfig/30-urw-fallback-specifics.conf
	fontconfig/30-urw-gothic.conf
	fontconfig/30-urw-nimbus-mono-ps.conf
	fontconfig/30-urw-nimbus-roman.conf
	fontconfig/30-urw-nimbus-sans-narrow.conf
	fontconfig/30-urw-nimbus-sans.conf
	fontconfig/30-urw-p052.conf
	fontconfig/30-urw-standard-symbols-ps.conf
	fontconfig/30-urw-z003.conf
)
