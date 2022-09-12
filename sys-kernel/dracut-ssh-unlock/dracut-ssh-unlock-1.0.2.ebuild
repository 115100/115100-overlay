# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
bitflags-1.1.0
cc-1.0.41
cfg-if-0.1.9
libc-0.2.62
nix-0.15.0
void-1.0.2
"

inherit cargo

DESCRIPTION="A dracut module for unlocking an encrypted drive remotely over SSH."
HOMEPAGE="https://github.com/115100/dracut-ssh-unlock"
SRC_URI="https://github.com/115100/dracut-ssh-unlock/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
$(cargo_crate_uris ${CRATES})"

LICENSE="BSD-2"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="
	net-misc/openssh
	sys-kernel/dracut
"

BDEPEND="
	virtual/rust
"

src_install() {
	make DESTDIR="${D}" install
}
