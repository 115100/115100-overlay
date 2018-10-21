EAPI=7

DESCRIPTION="Policy-driven snapshot management and replication tools. Currently using ZFS for underlying next-gen storage, with explicit plans to support btrfs when btrfs becomes more reliable. Primarily intended for Linux, but BSD use is supported and reasonably frequently tested. http://www.openoid.net/products/"
HOMEPAGE="https://github.com/jimsalterjrs/sanoid"
SRC_URI="https://github.com/jimsalterjrs/sanoid/archive/v${PV}.zip"

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"

DEPEND=""
RDEPEND="
	dev-lang/perl
	dev-perl/Config-IniFiles
	sys-fs/zfs
"

src_install() {
	dobin sanoid

	insinto /etc/sanoid
	doins "sanoid.defaults.conf"

	elog "You will need to set up your /etc/sanoid/sanoid.conf file before"
	elog "running sanoid for the first time. For details, please consult the"
	elog "documentation on https://github.com/jimsalterjrs/sanoid."
}
