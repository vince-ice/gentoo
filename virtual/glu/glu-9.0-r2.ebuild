# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-build

DESCRIPTION="Virtual for OpenGL utility library"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	|| (
		>=media-libs/glu-9.0.0-r1[${MULTILIB_USEDEP}]
		dev-util/mingw64-runtime
	)"
