EAPI=7

inherit cargo

CRATES="
bitflags-1.1.0
cc-1.0.41
cfg-if-0.1.9
libc-0.2.62
nix-0.15.0
void-1.0.2
"

SRC_URI="https://github.com/115100/dracut-ssh-unlock/archive/v${PV}.zip -> ${P}.zip
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
	make DESTDIR=${D} install
}
