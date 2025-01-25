# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="A session manager for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/xfce/xfce4-session/start
	https://gitlab.xfce.org/xfce/xfce4-session
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="X nls policykit wayland +xscreensaver"
REQUIRED_USE="|| ( X wayland )"

DEPEND="
	>=dev-libs/glib-2.72.0
	>=x11-libs/gtk+-3.24.0:3[X?,wayland?]
	>=xfce-base/libxfce4util-4.19.2:=
	>=xfce-base/libxfce4ui-4.18.4:=
	>=xfce-base/libxfce4windowing-4.19.2:=
	>=xfce-base/xfconf-4.12.0:=
	policykit? ( >=sys-auth/polkit-0.102 )
	wayland? (
		>=gui-libs/gtk-layer-shell-0.7.0
	)
	X? (
		>=x11-libs/libICE-1.0.10
		>=x11-libs/libSM-1.2.3
		>=x11-libs/libX11-1.6.7
		>=x11-libs/libwnck-3.10.0:3
	)
"
RDEPEND="
	${DEPEND}
	x11-apps/xrdb
	nls? ( x11-misc/xdg-user-dirs )
	X? (
		x11-apps/iceauth
	)
	xscreensaver? (
		|| (
			xfce-extra/xfce4-screensaver
			>=x11-misc/xscreensaver-5.26
			x11-misc/light-locker
		)
	)
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		$(use_enable X x11)
		$(use_enable policykit polkit)
		$(use_enable wayland)
		$(use_enable wayland gtk-layer-shell)
		--with-xsession-prefix="${EPREFIX}"/usr
		ICEAUTH="${EPREFIX}"/usr/bin/iceauth
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	exeinto /etc/X11/Sessions
	newexe - Xfce4 <<-EOF
		startxfce4
	EOF
	dosym Xfce4 /etc/X11/Sessions/Xfce
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
