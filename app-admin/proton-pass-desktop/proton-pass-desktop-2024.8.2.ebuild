# Copyright 2011-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop pax-utils rpm unpacker xdg

DESCRIPTION="Proton Pass Password Manager"
HOMEPAGE="https://proton.me/en/pass"
MY_PN="proton-pass"
MY_P="proton-pass"

SRC_URI="
https://proton.me/download/PassDesktop/linux/x64/ProtonPass.rpm
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
QA_DESKTOP_FILE="usr/share/applications/proton-pass.desktop"
PASS_HOME="usr/lib/proton-pass/"
OUTPUT_HOME="opt/proton-pass"

pkg_pretend() {
	# Protect against people using autounmask overzealously
	use amd64 || die "protonpass only works on amd64"
}

pkg_setup() {
	:
}

src_unpack() {
	:	
}

src_install() {
	dodir /
	cd "${ED}" || die
	rpm_src_unpack ${A}

	# Move all to opt
	mkdir -p $OUTPUT_HOME
	mv usr/lib/proton-pass/* $OUTPUT_HOME
	rm -rf usr/lib/proton-pass/
	ln -sf "/opt/proton-pass/Proton Pass" usr/bin/proton-pass

	mv usr/share/doc/proton-pass usr/share/doc/${PF} || die
	pax-mark m "${PASS_HOME}/proton-pass"
}
