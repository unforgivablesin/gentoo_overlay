EAPI="7"

MODS="atspibus"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for the GNOME spi bus"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi
