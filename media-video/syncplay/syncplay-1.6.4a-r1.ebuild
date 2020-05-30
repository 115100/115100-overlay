# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit python-single-r1

DESCRIPTION="Client/server to synchronize media playback"
HOMEPAGE="https://syncplay.pl"
SRC_URI="https://github.com/Syncplay/syncplay/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 x86"
IUSE="+client +server gui vlc"
REQUIRED_USE="vlc? ( client )
	gui? ( client )
	${PYTHON_REQUIRED_USE}"

DEPEND=""
# TODO: investigate the possibility of enabling PyQt5 gui
# possible licensing concerns
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/certifi-2018.11.29[${PYTHON_USEDEP}]
		>=dev-python/twisted-16.4.0[crypt,${PYTHON_USEDEP}]
		gui? ( >=dev-python/pyside2-5.12.0[${PYTHON_USEDEP}] )
	')

	vlc? ( media-video/vlc[lua] )
"

src_prepare() {
	default
	if ! use gui; then
		sed -i 's/"noGui": False,/"noGui": True,/' \
			syncplay/ui/ConfigurationGetter.py \
		|| die "Failed to patch ConfigurationGetter.py"
	fi
}

src_compile() {
	:
}

src_install() {
	local MY_MAKEOPTS=( DESTDIR="${D}" PREFIX=/usr )
	use client && \
		emake "${MY_MAKEOPTS[@]}" VLC_SUPPORT=$(usex vlc true false) install-client
	use server && \
		emake "${MY_MAKEOPTS[@]}" install-server
	python_fix_shebang "${ED}"/usr/bin
}

pkg_postinst() {
	if use client; then
		einfo "Syncplay supports the following players:"
		einfo "media-video/mpv, media-video/mplayer2, media-video/vlc"
	fi
}
