#! /bin/sh
#
# Copyright (C) 2022 Free Software Foundation, Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; either version 2.1 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

# This script makes it possible to build this package in a sibling directory
# of a package such as GCC, gdb, or binutils, and use the binaries in the
# build tree without doing 'make install'.
#
# Use from within a Bourne-compatible shell:
#     relative_builddir='${top_builddir}/../gettext-runtime'
#     . ${top_builddir}/../gettext-runtime/uninstalled-config.sh

# Note: Another option for the same use-case would be a Makefile target
# 'install-lib', such that the sibling package could do
#     cd ${top_builddir}/../gettext-runtime \
#     && $(MAKE) all \
#     && $(MAKE) install-lib libdir=... includedir=...
# This is how it's done in GNU libiconv. However, the 'uninstalled-config.sh'
# approach has two advantages:
#   - it does not copy artifacts around,
#   - it even allows for Makefile rules to depend on the uninstalled binaries.
# It has also a drawback:
#   - On platforms with weird shared library mechanisms (e.g. AIX, HP-UX,
#     native Windows) it works only with '--disable-shared'.

# ================= Configuration variables for using libintl =================

# INCINTL is a set of compiler options, to use when preprocessing or compiling,
# that ensures that the uninstalled <libintl.h> gets found.
# Attention! This variable needs to be used _after_ the -I options that ensure
# access to config.h (because INCINTL may contain a -I option that would allow
# access to libintl's private config.h, which you should not use).
if test no = yes; then
  # The intl/ subdirectory contains the <libintl.h> that "make install" would
  # install.
  INCINTL="-I ${relative_builddir}/intl"
else
  # No <libintl.h> file is needed, as it is provided by libc.
  INCINTL=
fi

# LIBINTL is a set of compiler options, to use when linking without libtool,
# that ensures that the library that contains the *gettext() family of functions
# gets found.
if test no = yes; then
  if test 'yes' = yes; then
    # NB: This case is not supported on AIX and HP-UX.
    LIBINTL="${relative_builddir}/intl/.libs/libintl.so -Wl,-rpath,${relative_builddir}/intl/.libs  "
  else
    LIBINTL="${relative_builddir}/intl/.libs/libintl.a  "
  fi
else
  # The functionality is provided by libc.
  LIBINTL=
fi

# LTLIBINTL is a set of compiler options, to use when linking with libtool,
# that ensures that the library that contains the *gettext() family of functions
# gets found.
if test no = yes; then
  LTLIBINTL="${relative_builddir}/intl/libintl.la  "
else
  # The functionality is provided by libc.
  LTLIBINTL=
fi

# LIBINTL_DEP is a list of files, that can be used in Makefile dependency lists,
# that indicate that binaries linked with LIBINTL or LTLIBINTL need to be
# rebuilt.
if test no = yes; then
  LIBINTL_DEP="${relative_builddir}/intl/libintl.la"
else
  LIBINTL_DEP=
fi

# ============== Configuration variables for compiling PO files ==============

# USE_NLS is 'yes' if the build is NLS enabled and therefore .po files should
# be compiled and .mo files should be installed. It is 'no' otherwise.
USE_NLS='yes'

# POSUB is 'po' if the build is NLS enabled and therefore the build needs to
# recurse into the 'po' directory. It is empty otherwise.
POSUB='po'

# XGETTEXT is a GNU xgettext version ≥ 0.12, if found in $PATH, or ':' if
# not found.
XGETTEXT='/usr/bin/xgettext'

# XGETTEXT_015 is a GNU xgettext version ≥ 0.15, if found in $PATH, or ':' if
# not found.
XGETTEXT_015='/usr/bin/xgettext'

# GMSGFMT is a GNU msgfmt, if found in $PATH, or ':' if not found.
GMSGFMT='/usr/bin/msgfmt'

# GMSGFMT_015 is a GNU msgfmt version ≥ 0.15, if found in $PATH, or ':' if
# not found.
GMSGFMT_015='/usr/bin/msgfmt'
