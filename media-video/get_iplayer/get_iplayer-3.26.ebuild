# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A utility for downloading TV and radio programmes from BBC iPlayer and BBC Sounds."
HOMEPAGE="https://github.com/get-iplayer/get_iplayer"
SRC_URI="https://github.com/get-iplayer/get_iplayer/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="3"

RDEPEND="
	dev-lang/perl
	dev-perl/LWP-Protocol-https
	dev-perl/Mojolicious
	dev-perl/XML-LibXML
	dev-perl/libwww-perl
	media-video/atomicparsley
	virtual/ffmpeg
"

src_install() {
	dobin get_iplayer
	doman get_iplayer.1
}
