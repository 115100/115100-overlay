# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature systemd

DESCRIPTION="Policy-driven snapshot management and replication tools for ZFS."
HOMEPAGE="https://github.com/jimsalterjrs/sanoid"
SRC_URI="https://github.com/jimsalterjrs/sanoid/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-lang/perl
	sys-apps/groff
"
RDEPEND="
	dev-lang/perl
	dev-perl/Capture-Tiny
	dev-perl/Config-IniFiles
	sys-apps/pv
	sys-block/mbuffer
	sys-fs/zfs
	virtual/perl-Data-Dumper
	virtual/perl-Getopt-Long
	virtual/ssh
"

src_compile() {
	perldoc -onroff -dsanoid.1 sanoid || die "Failed to compile sanoid.1!"
	perldoc -onroff -dsyncoid.1 syncoid || die "Failed to compile syncoid.1!"
}

src_install() {
	dobin sanoid
	dobin syncoid

	doman sanoid.1 syncoid.1

	insinto /etc/sanoid
	doins "sanoid.defaults.conf"
	systemd_dounit "${FILESDIR}/${PN}".{service,timer}
}

pkg_postinst() {
	optfeature "lzop compression support" app-arch/lzop
	optfeature "pigz compression support" app-arch/pigz
	optfeature "zstd compression support" app-arch/zstd

	elog "You will need to set up your /etc/sanoid/sanoid.conf file before"
	elog "running sanoid for the first time. For details, please consult the"
	elog "documentation on https://github.com/jimsalterjrs/sanoid."
}
