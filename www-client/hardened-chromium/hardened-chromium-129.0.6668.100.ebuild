# Copyright 2011-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="af am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk ur vi zh-CN zh-TW"

inherit chromium-2 desktop pax-utils rpm unpacker xdg

DESCRIPTION="Secureblue Hardened Chromium"
HOMEPAGE="https://github.com/secureblue/hardened-chromium"
MY_PN="chromium-browser"
MY_P="chromium-browser"

SRC_URI="https://download.copr.fedorainfracloud.org/results/secureblue/hardened-chromium/fedora-40-x86_64/08121290-hardened-chromium/hardened-chromium-129.0.6668.100-2.fc40.x86_64.rpm
https://download.copr.fedorainfracloud.org/results/secureblue/hardened-chromium/fedora-40-x86_64/08121290-hardened-chromium/hardened-chromium-common-129.0.6668.100-2.fc40.x86_64.rpm
https://kojipkgs.fedoraproject.org//packages/libXNVCtrl/560.35.03/3.fc40/x86_64/libXNVCtrl-560.35.03-3.fc40.x86_64.rpm
"
S=${WORKDIR}

LICENSE="GPL-COMPATIBLE"
SLOT="0"
KEYWORDS="-* amd64"

IUSE="qt5 qt6 selinux"

RESTRICT="bindist mirror strip"

RDEPEND="
	media-libs/openh264
	dev-libs/libevent
	media-libs/dav1d
	dev-libs/crc32c
	media-video/ffmpeg
	net-print/cups
	>=app-accessibility/at-spi2-core-2.46.0:2
	app-misc/ca-certificates
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	>=dev-libs/nss-3.26
	media-fonts/liberation-fonts
	media-libs/alsa-lib
	media-libs/mesa[gbm(+)]
	net-misc/curl
	sys-apps/dbus
	sys-libs/glibc
	sys-libs/libcap
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	|| (
		x11-libs/gtk+:3[X]
		gui-libs/gtk:4[X]
	)
	x11-libs/libdrm
	>=x11-libs/libX11-1.5.0
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libxshmfence
	x11-libs/pango
	x11-misc/xdg-utils
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5[X]
		dev-qt/qtwidgets:5
	)
	qt6? ( dev-qt/qtbase:6[gui,widgets] )
	selinux? ( sec-policy/selinux-chromium )
"

BDEPEND="
app-arch/rpm2targz
"

QA_PREBUILT="*"
QA_DESKTOP_FILE="usr/share/applications/chromium-browser.desktop"
CHROMIUM_HOME="usr/lib64/chromium-browser"

OUTPUT_HOME="opt/chromium-browser"

pkg_nofetch() {
	eerror "Please wait 24 hours and sync your tree before reporting a bug for chromium fetch failures."
}

pkg_pretend() {
	# Protect against people using autounmask overzealously
	use amd64 || die "chromium only works on amd64"
}

pkg_setup() {
	chromium_suid_sandbox_check_kernel_config
}

src_unpack() {
	:	
}

src_install() {
	dodir /
	cd "${ED}" || die
	rpm_src_unpack ${A}

	#ls ${ED}

	rm -r etc || die
	mv usr/share/doc/hardened-chromium usr/share/doc/${PF} || die

	#gzip -d usr/share/doc/${PF}/changelog.gz || die
	gzip -d usr/share/man/man1/chromium-browser.1.gz || die
	if [[ -L usr/share/man/man1/chromium-browser.1.gz ]]; then
		rm usr/share/man/man1/chromium-browser.1.gz || die
		dosym hardened-chromium.1 usr/share/man/man1/chromium-browser.1.gz
	fi

	pushd "${CHROMIUM_HOME}/locales" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	# Move all to opt
	mkdir -p $OUTPUT_HOME
	mv usr/lib64/chromium-browser/* $OUTPUT_HOME
	rm -rf usr/lib64/chromium-browser
	ln -sf /opt/chromium-browser/chromium-browser.sh usr/bin/chromium-browser

	pax-mark m "${OUTPUT_HOME}/chromium-browser"
}
