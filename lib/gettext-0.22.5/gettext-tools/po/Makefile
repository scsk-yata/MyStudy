# Makefile for PO directory in any package using GNU gettext.
# Copyright (C) 1995-2000 Ulrich Drepper <drepper@gnu.ai.mit.edu>
# Copyright (C) 2000-2023 Free Software Foundation, Inc.
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.
#
# Origin: gettext-0.22
GETTEXT_MACRO_VERSION = 0.20

PACKAGE = gettext-tools
VERSION = 0.22.5
PACKAGE_BUGREPORT = bug-gettext@gnu.org

SED = /usr/bin/sed
SHELL = /bin/sh


srcdir = .
top_srcdir = ..


prefix = /opt/gettext-0.22.5
exec_prefix = ${prefix}
datarootdir = ${prefix}/share
datadir = ${datarootdir}
localedir = ${datarootdir}/locale
gettextsrcdir = $(datadir)/gettext/po

INSTALL = /usr/bin/install -c
INSTALL_DATA = ${INSTALL} -m 644

# We use $(mkdir_p).
# In automake <= 1.9.x, $(mkdir_p) is defined either as "mkdir -p --" or as
# "$(mkinstalldirs)" or as "$(install_sh) -d". For these automake versions,
# ${SHELL} /home/yata/gettext-0.22.5/build-aux/install-sh does not start with $(SHELL), so we add it.
# In automake >= 1.10, $(MKDIR_P) is derived from ${MKDIR_P}, which is defined
# either as "/path/to/mkdir -p" or ".../install-sh -c -d". For these automake
# versions, $(mkinstalldirs) and $(install_sh) are unused.
mkinstalldirs = $(SHELL) ${SHELL} /home/yata/gettext-0.22.5/build-aux/install-sh -d
install_sh = $(SHELL) ${SHELL} /home/yata/gettext-0.22.5/build-aux/install-sh
MKDIR_P = /usr/bin/mkdir -p
mkdir_p = $(MKDIR_P)

# When building gettext-tools, we prefer to use the built programs
# rather than installed programs.  However, we can't do that when we
# are cross compiling.
CROSS_COMPILING = no

GMSGFMT_ = /usr/bin/msgfmt
GMSGFMT_no = /usr/bin/msgfmt
GMSGFMT_yes = /usr/bin/msgfmt
GMSGFMT = $(GMSGFMT_$(USE_MSGCTXT))
XGETTEXT_ = /usr/bin/xgettext
XGETTEXT_no = /usr/bin/xgettext
XGETTEXT_yes = /usr/bin/xgettext
XGETTEXT = $(XGETTEXT_$(USE_MSGCTXT))
MSGMERGE = /usr/bin/msgmerge
MSGMERGE_UPDATE = /usr/bin/msgmerge --update
MSGMERGE_FOR_MSGFMT_OPTION = --for-msgfmt
MSGINIT = msginit
MSGCONV = msgconv
MSGFILTER = msgfilter

POFILES =  be.po bg.po ca.po cs.po da.po de.po el.po en@quot.po en@boldquot.po es.po et.po eu.po fi.po fr.po gl.po id.po hr.po it.po ja.po ka.po ko.po nb.po nl.po nn.po pa.po pl.po pt.po pt_BR.po ro.po ru.po sk.po sl.po sr.po sv.po tr.po uk.po vi.po zh_CN.po zh_TW.po
GMOFILES =  be.gmo bg.gmo ca.gmo cs.gmo da.gmo de.gmo el.gmo en@quot.gmo en@boldquot.gmo es.gmo et.gmo eu.gmo fi.gmo fr.gmo gl.gmo id.gmo hr.gmo it.gmo ja.gmo ka.gmo ko.gmo nb.gmo nl.gmo nn.gmo pa.gmo pl.gmo pt.gmo pt_BR.gmo ro.gmo ru.gmo sk.gmo sl.gmo sr.gmo sv.gmo tr.gmo uk.gmo vi.gmo zh_CN.gmo zh_TW.gmo
UPDATEPOFILES =  be.po-update bg.po-update ca.po-update cs.po-update da.po-update de.po-update el.po-update en@quot.po-update en@boldquot.po-update es.po-update et.po-update eu.po-update fi.po-update fr.po-update gl.po-update id.po-update hr.po-update it.po-update ja.po-update ka.po-update ko.po-update nb.po-update nl.po-update nn.po-update pa.po-update pl.po-update pt.po-update pt_BR.po-update ro.po-update ru.po-update sk.po-update sl.po-update sr.po-update sv.po-update tr.po-update uk.po-update vi.po-update zh_CN.po-update zh_TW.po-update
DUMMYPOFILES =  be.nop bg.nop ca.nop cs.nop da.nop de.nop el.nop en@quot.nop en@boldquot.nop es.nop et.nop eu.nop fi.nop fr.nop gl.nop id.nop hr.nop it.nop ja.nop ka.nop ko.nop nb.nop nl.nop nn.nop pa.nop pl.nop pt.nop pt_BR.nop ro.nop ru.nop sk.nop sl.nop sr.nop sv.nop tr.nop uk.nop vi.nop zh_CN.nop zh_TW.nop
DISTFILES.common = Makefile.in.in remove-potcdate.sin \
$(DISTFILES.common.extra1) $(DISTFILES.common.extra2) $(DISTFILES.common.extra3)
DISTFILES = $(DISTFILES.common) Makevars POTFILES.in \
$(POFILES) $(GMOFILES) \
$(DISTFILES.extra1) $(DISTFILES.extra2) $(DISTFILES.extra3)

POTFILES = \
     ../gnulib-lib/argmatch.c \
     ../gnulib-lib/clean-temp.c \
     ../gnulib-lib/clean-temp-simple.c \
     ../gnulib-lib/closeout.c \
     ../gnulib-lib/copy-file.c \
     ../gnulib-lib/csharpcomp.c \
     ../gnulib-lib/csharpexec.c \
     ../gnulib-lib/error.c \
     ../gnulib-lib/execute.c \
     ../gnulib-lib/gai_strerror.c \
     ../gnulib-lib/getaddrinfo.c \
     ../gnulib-lib/getopt.c \
     ../gnulib-lib/javacomp.c \
     ../gnulib-lib/javaexec.c \
     ../gnulib-lib/javaversion.c \
     ../gnulib-lib/obstack.c \
     ../gnulib-lib/openat-die.c \
     ../gnulib-lib/os2-spawn.c \
     ../gnulib-lib/pipe-filter-ii.c \
     ../gnulib-lib/quotearg.c \
     ../gnulib-lib/spawn-pipe.c \
     ../gnulib-lib/wait-process.c \
     ../gnulib-lib/xalloc-die.c \
     ../gnulib-lib/xsetenv.c \
     ../src/cldr-plurals.c \
     ../src/file-list.c \
     ../src/format-awk.c \
     ../src/format-boost.c \
     ../src/format.c \
     ../src/format-c++-brace.c \
     ../src/format-c.c \
     ../src/format-c-parse.h \
     ../src/format-csharp.c \
     ../src/format-elisp.c \
     ../src/format-gcc-internal.c \
     ../src/format-gfc-internal.c \
     ../src/format-invalid.h \
     ../src/format-java.c \
     ../src/format-java-printf.c \
     ../src/format-javascript.c \
     ../src/format-kde.c \
     ../src/format-kde-kuit.c \
     ../src/format-librep.c \
     ../src/format-lisp.c \
     ../src/format-lua.c \
     ../src/format-pascal.c \
     ../src/format-perl-brace.c \
     ../src/format-perl.c \
     ../src/format-php.c \
     ../src/format-python-brace.c \
     ../src/format-python.c \
     ../src/format-qt.c \
     ../src/format-qt-plural.c \
     ../src/format-ruby.c \
     ../src/format-scheme.c \
     ../src/format-sh.c \
     ../src/format-smalltalk.c \
     ../src/format-tcl.c \
     ../src/hostname.c \
     ../src/its.c \
     ../src/locating-rule.c \
     ../src/msgattrib.c \
     ../src/msgcat.c \
     ../src/msgcmp.c \
     ../src/msgcomm.c \
     ../src/msgconv.c \
     ../src/msgen.c \
     ../src/msgexec.c \
     ../src/msgfilter.c \
     ../src/msgfmt.c \
     ../src/msggrep.c \
     ../src/msginit.c \
     ../src/msgl-cat.c \
     ../src/msgl-charset.c \
     ../src/msgl-check.c \
     ../src/msgl-iconv.c \
     ../src/msgmerge.c \
     ../src/msgunfmt.c \
     ../src/msguniq.c \
     ../src/open-catalog.c \
     ../src/po-charset.c \
     ../src/po-gram-gen.y \
     ../src/po-lex.c \
     ../src/po-xerror.c \
     ../src/read-catalog.c \
     ../src/read-csharp.c \
     ../src/read-desktop.c \
     ../src/read-java.c \
     ../src/read-mo.c \
     ../src/read-properties.c \
     ../src/read-resources.c \
     ../src/read-stringtable.c \
     ../src/read-tcl.c \
     ../src/recode-sr-latin.c \
     ../src/urlget.c \
     ../src/write-catalog.c \
     ../src/write-csharp.c \
     ../src/write-desktop.c \
     ../src/write-java.c \
     ../src/write-mo.c \
     ../src/write-po.c \
     ../src/write-qt.c \
     ../src/write-resources.c \
     ../src/write-tcl.c \
     ../src/write-xml.c \
     ../src/x-awk.c \
     ../src/x-c.c \
     ../src/x-csharp.c \
     ../src/x-desktop.c \
     ../src/x-elisp.c \
     ../src/xg-arglist-parser.c \
     ../src/xg-encoding.c \
     ../src/xgettext.c \
     ../src/xg-message.c \
     ../src/xg-mixed-string.c \
     ../src/x-java.c \
     ../src/x-javascript.c \
     ../src/x-librep.c \
     ../src/x-lisp.c \
     ../src/x-lua.c \
     ../src/x-perl.c \
     ../src/x-php.c \
     ../src/x-po.c \
     ../src/x-python.c \
     ../src/x-rst.c \
     ../src/x-ruby.c \
     ../src/x-scheme.c \
     ../src/x-sh.c \
     ../src/x-smalltalk.c \
     ../src/x-tcl.c \
     ../src/x-vala.c \
     ../src/x-ycp.c \
     ../src/user-email.sh.in \
     ../libgettextpo/error.c \
     ../libgettextpo/gettext-po.c \
     ../libgettextpo/markup.c \
     ../libgettextpo/obstack.c \
     ../libgettextpo/xalloc-die.c

CATALOGS =  be.gmo bg.gmo ca.gmo cs.gmo da.gmo de.gmo el.gmo en@quot.gmo en@boldquot.gmo es.gmo et.gmo eu.gmo fi.gmo fr.gmo gl.gmo id.gmo hr.gmo it.gmo ja.gmo ka.gmo ko.gmo nb.gmo nl.gmo nn.gmo pa.gmo pl.gmo pt.gmo pt_BR.gmo ro.gmo ru.gmo sk.gmo sl.gmo sr.gmo sv.gmo tr.gmo uk.gmo vi.gmo zh_CN.gmo zh_TW.gmo

POFILESDEPS_ = $(srcdir)/$(DOMAIN).pot
POFILESDEPS_yes = $(POFILESDEPS_)
POFILESDEPS_no =
POFILESDEPS = $(POFILESDEPS_$(PO_DEPENDS_ON_POT))

DISTFILESDEPS_ = update-po
DISTFILESDEPS_yes = $(DISTFILESDEPS_)
DISTFILESDEPS_no =
DISTFILESDEPS = $(DISTFILESDEPS_$(DIST_DEPENDS_ON_UPDATE_PO))

# Makevars gets inserted here. (Don't remove this line!)
# Makefile variables for PO directory in any package using GNU gettext.
#
# Copyright (C) 2003-2023 Free Software Foundation, Inc.
# This file, Makevars, is free software; the Free Software Foundation
# gives unlimited permission to use, copy, distribute, and modify it.

# Usually the message domain is the same as the package name.
DOMAIN = $(PACKAGE)

# These two variables depend on the location of this directory.
subdir = po
top_builddir = ..

# These options get passed to xgettext.
XGETTEXT_OPTIONS = \
  --package-name='GNU gettext' \
  --keyword=_ --flag=_:1:pass-c-format \
  --keyword=N_ --flag=N_:1:pass-c-format \
  --flag=error:3:c-format --flag=error_at_line:5:c-format \
  --flag=asprintf:2:c-format --flag=vasprintf:2:c-format \
  --flag=xasprintf:1:c-format --flag=error_logger:1:c-format \
  --flag=po_error:3:c-format --flag=po_error_at_line:5:c-format \
  --flag=po_gram_error:1:c-format --flag=po_gram_error_at_line:2:c-format

# This is the copyright holder that gets inserted into the header of the
# $(DOMAIN).pot file.  Set this to the copyright holder of the surrounding
# package.  (Note that the msgstr strings, extracted from the package's
# sources, belong to the copyright holder of the package.)  Translators are
# expected to transfer the copyright for their translations to this person
# or entity, or to disclaim their copyright.  The empty string stands for
# the public domain; in this case the translators are expected to disclaim
# their copyright.
COPYRIGHT_HOLDER = Free Software Foundation, Inc.

# This tells whether or not to prepend "GNU " prefix to the package
# name that gets inserted into the header of the $(DOMAIN).pot file.
# Possible values are "yes", "no", or empty.  If it is empty, try to
# detect it automatically by scanning the files in $(top_srcdir) for
# "GNU packagename" string.
PACKAGE_GNU =

# This is the email address or URL to which the translators shall report
# bugs in the untranslated strings:
# - Strings which are not entire sentences, see the maintainer guidelines
#   in the GNU gettext documentation, section 'Preparing Strings'.
# - Strings which use unclear terms or require additional context to be
#   understood.
# - Strings which make invalid assumptions about notation of date, time or
#   money.
# - Pluralisation problems.
# - Incorrect English spelling.
# - Incorrect formatting.
# It can be your email address, or a mailing list address where translators
# can write to without being subscribed, or the URL of a web page through
# which the translators can contact you.
MSGID_BUGS_ADDRESS = bug-gettext@gnu.org

# This is the list of locale categories, beyond LC_MESSAGES, for which the
# message catalogs shall be used.  It is usually empty.
EXTRA_LOCALE_CATEGORIES =

# This tells whether the $(DOMAIN).pot file contains messages with an 'msgctxt'
# context.  Possible values are "yes" and "no".  Set this to yes if the
# package uses functions taking also a message context, like pgettext(), or
# if in $(XGETTEXT_OPTIONS) you define keywords with a context argument.
USE_MSGCTXT = no

# These options get passed to msgmerge.
# Useful options are in particular:
#   --previous            to keep previous msgids of translated messages
MSGMERGE_OPTIONS =

# These options get passed to msginit.
# If you want to disable line wrapping when writing PO files, add
# --no-wrap to MSGMERGE_OPTIONS, XGETTEXT_OPTIONS, and
# MSGINIT_OPTIONS.
MSGINIT_OPTIONS =

# This tells whether or not to regenerate a PO file when $(DOMAIN).pot
# has changed.  Possible values are "yes" and "no".  Set this to no if
# the POT file is checked in the repository and the version control
# program ignores timestamps.
PO_DEPENDS_ON_POT = yes

# This tells whether or not to forcibly update $(DOMAIN).pot and
# regenerate PO files on "make dist".  Possible values are "yes" and
# "no".  Set this to no if the POT file and PO files are maintained
# externally.
DIST_DEPENDS_ON_UPDATE_PO = yes

all: all-yes


.SUFFIXES:
.SUFFIXES: .po .gmo .sed .sin .nop .po-create .po-update

# The .pot file, stamp-po, .po files, and .gmo files appear in release tarballs.
# The GNU Coding Standards say in
# <https://www.gnu.org/prep/standards/html_node/Makefile-Basics.html>:
#   "GNU distributions usually contain some files which are not source files
#    ... . Since these files normally appear in the source directory, they
#    should always appear in the source directory, not in the build directory.
#    So Makefile rules to update them should put the updated files in the
#    source directory."
# Therefore we put these files in the source directory, not the build directory.

# During .po -> .gmo conversion, take into account the most recent changes to
# the .pot file. This eliminates the need to update the .po files when the
# .pot file has changed, which would be troublesome if the .po files are put
# under version control.
$(GMOFILES): $(srcdir)/$(DOMAIN).pot
.po.gmo:
	@lang=`echo $* | sed -e 's,.*/,,'`; \
	test "$(srcdir)" = . && cdcmd="" || cdcmd="cd $(srcdir) && "; \
	echo "$${cdcmd}rm -f $${lang}.gmo && $(MSGMERGE) $(MSGMERGE_FOR_MSGFMT_OPTION) -o $${lang}.1po $${lang}.po $(DOMAIN).pot && $(GMSGFMT) -c --statistics --verbose -o $${lang}.gmo $${lang}.1po && rm -f $${lang}.1po"; \
	cd $(srcdir) && \
	rm -f $${lang}.gmo && \
	$(MSGMERGE) $(MSGMERGE_FOR_MSGFMT_OPTION) -o $${lang}.1po $${lang}.po $(DOMAIN).pot && \
	$(GMSGFMT) -c --statistics --verbose -o t-$${lang}.gmo $${lang}.1po && \
	mv t-$${lang}.gmo $${lang}.gmo && \
	rm -f $${lang}.1po

.sin.sed:
	sed -e '/^#/d' $< > t-$@
	mv t-$@ $@


all-yes: $(srcdir)/stamp-po
all-no:

# Ensure that the gettext macros and this Makefile.in.in are in sync.
CHECK_MACRO_VERSION = \
	test "$(GETTEXT_MACRO_VERSION)" = "0.20" \
	  || { echo "*** error: gettext infrastructure mismatch: using a Makefile.in.in from gettext version $(GETTEXT_MACRO_VERSION) but the autoconf macros are from gettext version 0.20" 1>&2; \
	       exit 1; \
	     }

# $(srcdir)/$(DOMAIN).pot is only created when needed. When xgettext finds no
# internationalized messages, no $(srcdir)/$(DOMAIN).pot is created (because
# we don't want to bother translators with empty POT files). We assume that
# LINGUAS is empty in this case, i.e. $(POFILES) and $(GMOFILES) are empty.
# In this case, $(srcdir)/stamp-po is a nop (i.e. a phony target).

# $(srcdir)/stamp-po is a timestamp denoting the last time at which the CATALOGS
# have been loosely updated. Its purpose is that when a developer or translator
# checks out the package from a version control system, and the $(DOMAIN).pot
# file is not under version control, "make" will update the $(DOMAIN).pot and
# the $(CATALOGS), but subsequent invocations of "make" will do nothing. This
# timestamp would not be necessary if updating the $(CATALOGS) would always
# touch them; however, the rule for $(POFILES) has been designed to not touch
# files that don't need to be changed.
$(srcdir)/stamp-po: $(srcdir)/$(DOMAIN).pot
	@$(CHECK_MACRO_VERSION)
	test ! -f $(srcdir)/$(DOMAIN).pot || \
	  test -z "$(GMOFILES)" || $(MAKE) $(GMOFILES)
	@test ! -f $(srcdir)/$(DOMAIN).pot || { \
	  echo "touch $(srcdir)/stamp-po" && \
	  echo timestamp > $(srcdir)/stamp-poT && \
	  mv $(srcdir)/stamp-poT $(srcdir)/stamp-po; \
	}

# Note: Target 'all' must not depend on target '$(DOMAIN).pot-update',
# otherwise packages like GCC can not be built if only parts of the source
# have been downloaded.

# This target rebuilds $(DOMAIN).pot; it is an expensive operation.
# Note that $(DOMAIN).pot is not touched if it doesn't need to be changed.
# The determination of whether the package xyz is a GNU one is based on the
# heuristic whether some file in the top level directory mentions "GNU xyz".
# If GNU 'find' is available, we avoid grepping through monster files.
$(DOMAIN).pot-update: $(POTFILES) $(srcdir)/POTFILES.in remove-potcdate.sed
	package_gnu="$(PACKAGE_GNU)"; \
	test -n "$$package_gnu" || { \
	  if { if (LC_ALL=C find --version) 2>/dev/null | grep GNU >/dev/null; then \
	         LC_ALL=C find -L $(top_srcdir) -maxdepth 1 -type f -size -10000000c -exec grep -i 'GNU gettext-tools' /dev/null '{}' ';' 2>/dev/null; \
	       else \
	         LC_ALL=C grep -i 'GNU gettext-tools' $(top_srcdir)/* 2>/dev/null; \
	       fi; \
	     } | grep -v 'libtool:' >/dev/null; then \
	     package_gnu=yes; \
	   else \
	     package_gnu=no; \
	   fi; \
	}; \
	if test "$$package_gnu" = "yes"; then \
	  package_prefix='GNU '; \
	else \
	  package_prefix=''; \
	fi; \
	if test -n '$(MSGID_BUGS_ADDRESS)' || test '$(PACKAGE_BUGREPORT)' = '@'PACKAGE_BUGREPORT'@'; then \
	  msgid_bugs_address='$(MSGID_BUGS_ADDRESS)'; \
	else \
	  msgid_bugs_address='$(PACKAGE_BUGREPORT)'; \
	fi; \
	case `$(XGETTEXT) --version | sed 1q | sed -e 's,^[^0-9]*,,'` in \
	  '' | 0.[0-9] | 0.[0-9].* | 0.1[0-5] | 0.1[0-5].* | 0.16 | 0.16.[0-1]*) \
	    $(XGETTEXT) --default-domain=$(DOMAIN) --directory=$(top_srcdir) \
	      --add-comments=TRANSLATORS: \
	      --files-from=$(srcdir)/POTFILES.in \
	      --copyright-holder='$(COPYRIGHT_HOLDER)' \
	      --msgid-bugs-address="$$msgid_bugs_address" \
	      $(XGETTEXT_OPTIONS)  --flag=error:3:c-format --flag=error_at_line:5:c-format --keyword='proper_name:1,"This is a proper name. See the gettext manual, section Names."' --keyword='proper_name_utf8:1,"This is a proper name. See the gettext manual, section Names."' --flag=asprintf:2:c-format --flag=vasprintf:2:c-format --flag=xasprintf:1:c-format --flag=error:3:c-format --flag=error_at_line:5:c-format --flag=asprintf:2:c-format --flag=vasprintf:2:c-format --flag=xasprintf:1:c-format \
	    ;; \
	  *) \
	    $(XGETTEXT) --default-domain=$(DOMAIN) --directory=$(top_srcdir) \
	      --add-comments=TRANSLATORS: \
	      --files-from=$(srcdir)/POTFILES.in \
	      --copyright-holder='$(COPYRIGHT_HOLDER)' \
	      --package-name="$${package_prefix}gettext-tools" \
	      --package-version='0.22.5' \
	      --msgid-bugs-address="$$msgid_bugs_address" \
	      $(XGETTEXT_OPTIONS)  --flag=error:3:c-format --flag=error_at_line:5:c-format --keyword='proper_name:1,"This is a proper name. See the gettext manual, section Names."' --keyword='proper_name_utf8:1,"This is a proper name. See the gettext manual, section Names."' --flag=asprintf:2:c-format --flag=vasprintf:2:c-format --flag=xasprintf:1:c-format --flag=error:3:c-format --flag=error_at_line:5:c-format --flag=asprintf:2:c-format --flag=vasprintf:2:c-format --flag=xasprintf:1:c-format \
	    ;; \
	esac
	test ! -f $(DOMAIN).po || { \
	  if test -f $(srcdir)/$(DOMAIN).pot-header; then \
	    sed -e '1,/^#$$/d' < $(DOMAIN).po > $(DOMAIN).1po && \
	    cat $(srcdir)/$(DOMAIN).pot-header $(DOMAIN).1po > $(DOMAIN).po && \
	    rm -f $(DOMAIN).1po \
	    || exit 1; \
	  fi; \
	  if test -f $(srcdir)/$(DOMAIN).pot; then \
	    sed -f remove-potcdate.sed < $(srcdir)/$(DOMAIN).pot > $(DOMAIN).1po && \
	    sed -f remove-potcdate.sed < $(DOMAIN).po > $(DOMAIN).2po && \
	    if cmp $(DOMAIN).1po $(DOMAIN).2po >/dev/null 2>&1; then \
	      rm -f $(DOMAIN).1po $(DOMAIN).2po $(DOMAIN).po; \
	    else \
	      rm -f $(DOMAIN).1po $(DOMAIN).2po $(srcdir)/$(DOMAIN).pot && \
	      mv $(DOMAIN).po $(srcdir)/$(DOMAIN).pot; \
	    fi; \
	  else \
	    mv $(DOMAIN).po $(srcdir)/$(DOMAIN).pot; \
	  fi; \
	}

# This rule has no dependencies: we don't need to update $(DOMAIN).pot at
# every "make" invocation, only create it when it is missing.
# Only "make $(DOMAIN).pot-update" or "make dist" will force an update.
$(srcdir)/$(DOMAIN).pot:
	$(MAKE) $(DOMAIN).pot-update

# This target rebuilds a PO file if $(DOMAIN).pot has changed.
# Note that a PO file is not touched if it doesn't need to be changed.
$(POFILES): $(POFILESDEPS)
	@test -f $(srcdir)/$(DOMAIN).pot || $(MAKE) $(srcdir)/$(DOMAIN).pot
	@lang=`echo $@ | sed -e 's,.*/,,' -e 's/\.po$$//'`; \
	if test -f "$(srcdir)/$${lang}.po"; then \
	  test "$(srcdir)" = . && cdcmd="" || cdcmd="cd $(srcdir) && "; \
	  echo "$${cdcmd}$(MSGMERGE_UPDATE) --quiet $(MSGMERGE_OPTIONS) --lang=$${lang} --previous $${lang}.po $(DOMAIN).pot"; \
	  cd $(srcdir) \
	    && { case `$(MSGMERGE_UPDATE) --version | sed 1q | sed -e 's,^[^0-9]*,,'` in \
	           '' | 0.[0-9] | 0.[0-9].* | 0.10 | 0.10.*) \
	             $(MSGMERGE_UPDATE) $(MSGMERGE_OPTIONS) $${lang}.po $(DOMAIN).pot;; \
	           0.1[1-5] | 0.1[1-5].*) \
	             $(MSGMERGE_UPDATE) --quiet $(MSGMERGE_OPTIONS) $${lang}.po $(DOMAIN).pot;; \
	           0.1[6-7] | 0.1[6-7].*) \
	             $(MSGMERGE_UPDATE) --quiet $(MSGMERGE_OPTIONS) --previous $${lang}.po $(DOMAIN).pot;; \
	           *) \
	             $(MSGMERGE_UPDATE) --quiet $(MSGMERGE_OPTIONS) --lang=$${lang} --previous $${lang}.po $(DOMAIN).pot;; \
	         esac; \
	       }; \
	else \
	  $(MAKE) $${lang}.po-create; \
	fi


install: install-exec install-data
install-exec:
install-data: install-data-yes
	if test "$(PACKAGE)" = "gettext-tools"; then \
	  $(mkdir_p) $(DESTDIR)$(gettextsrcdir); \
	  for file in $(DISTFILES.common) Makevars.template; do \
	    $(INSTALL_DATA) $(srcdir)/$$file \
			    $(DESTDIR)$(gettextsrcdir)/$$file; \
	  done; \
	  for file in Makevars; do \
	    rm -f $(DESTDIR)$(gettextsrcdir)/$$file; \
	  done; \
	else \
	  : ; \
	fi
install-data-no: all
install-data-yes: all
	@catalogs='$(CATALOGS)'; \
	for cat in $$catalogs; do \
	  cat=`basename $$cat`; \
	  lang=`echo $$cat | sed -e 's/\.gmo$$//'`; \
	  dir=$(localedir)/$$lang/LC_MESSAGES; \
	  $(mkdir_p) $(DESTDIR)$$dir; \
	  if test -r $$cat; then realcat=$$cat; else realcat=$(srcdir)/$$cat; fi; \
	  $(INSTALL_DATA) $$realcat $(DESTDIR)$$dir/$(DOMAIN).mo; \
	  echo "installing $$realcat as $(DESTDIR)$$dir/$(DOMAIN).mo"; \
	  for lc in '' $(EXTRA_LOCALE_CATEGORIES); do \
	    if test -n "$$lc"; then \
	      if (cd $(DESTDIR)$(localedir)/$$lang && LC_ALL=C ls -l -d $$lc 2>/dev/null) | grep ' -> ' >/dev/null; then \
	        link=`cd $(DESTDIR)$(localedir)/$$lang && LC_ALL=C ls -l -d $$lc | sed -e 's/^.* -> //'`; \
	        mv $(DESTDIR)$(localedir)/$$lang/$$lc $(DESTDIR)$(localedir)/$$lang/$$lc.old; \
	        mkdir $(DESTDIR)$(localedir)/$$lang/$$lc; \
	        (cd $(DESTDIR)$(localedir)/$$lang/$$lc.old && \
	         for file in *; do \
	           if test -f $$file; then \
	             ln -s ../$$link/$$file $(DESTDIR)$(localedir)/$$lang/$$lc/$$file; \
	           fi; \
	         done); \
	        rm -f $(DESTDIR)$(localedir)/$$lang/$$lc.old; \
	      else \
	        if test -d $(DESTDIR)$(localedir)/$$lang/$$lc; then \
	          :; \
	        else \
	          rm -f $(DESTDIR)$(localedir)/$$lang/$$lc; \
	          mkdir $(DESTDIR)$(localedir)/$$lang/$$lc; \
	        fi; \
	      fi; \
	      rm -f $(DESTDIR)$(localedir)/$$lang/$$lc/$(DOMAIN).mo; \
	      ln -s ../LC_MESSAGES/$(DOMAIN).mo $(DESTDIR)$(localedir)/$$lang/$$lc/$(DOMAIN).mo 2>/dev/null || \
	      ln $(DESTDIR)$(localedir)/$$lang/LC_MESSAGES/$(DOMAIN).mo $(DESTDIR)$(localedir)/$$lang/$$lc/$(DOMAIN).mo 2>/dev/null || \
	      cp -p $(DESTDIR)$(localedir)/$$lang/LC_MESSAGES/$(DOMAIN).mo $(DESTDIR)$(localedir)/$$lang/$$lc/$(DOMAIN).mo; \
	      echo "installing $$realcat link as $(DESTDIR)$(localedir)/$$lang/$$lc/$(DOMAIN).mo"; \
	    fi; \
	  done; \
	done

install-strip: install

installdirs: installdirs-exec installdirs-data
installdirs-exec:
installdirs-data: installdirs-data-yes
	if test "$(PACKAGE)" = "gettext-tools"; then \
	  $(mkdir_p) $(DESTDIR)$(gettextsrcdir); \
	else \
	  : ; \
	fi
installdirs-data-no:
installdirs-data-yes:
	@catalogs='$(CATALOGS)'; \
	for cat in $$catalogs; do \
	  cat=`basename $$cat`; \
	  lang=`echo $$cat | sed -e 's/\.gmo$$//'`; \
	  dir=$(localedir)/$$lang/LC_MESSAGES; \
	  $(mkdir_p) $(DESTDIR)$$dir; \
	  for lc in '' $(EXTRA_LOCALE_CATEGORIES); do \
	    if test -n "$$lc"; then \
	      if (cd $(DESTDIR)$(localedir)/$$lang && LC_ALL=C ls -l -d $$lc 2>/dev/null) | grep ' -> ' >/dev/null; then \
	        link=`cd $(DESTDIR)$(localedir)/$$lang && LC_ALL=C ls -l -d $$lc | sed -e 's/^.* -> //'`; \
	        mv $(DESTDIR)$(localedir)/$$lang/$$lc $(DESTDIR)$(localedir)/$$lang/$$lc.old; \
	        mkdir $(DESTDIR)$(localedir)/$$lang/$$lc; \
	        (cd $(DESTDIR)$(localedir)/$$lang/$$lc.old && \
	         for file in *; do \
	           if test -f $$file; then \
	             ln -s ../$$link/$$file $(DESTDIR)$(localedir)/$$lang/$$lc/$$file; \
	           fi; \
	         done); \
	        rm -f $(DESTDIR)$(localedir)/$$lang/$$lc.old; \
	      else \
	        if test -d $(DESTDIR)$(localedir)/$$lang/$$lc; then \
	          :; \
	        else \
	          rm -f $(DESTDIR)$(localedir)/$$lang/$$lc; \
	          mkdir $(DESTDIR)$(localedir)/$$lang/$$lc; \
	        fi; \
	      fi; \
	    fi; \
	  done; \
	done

# Define this as empty until I found a useful application.
installcheck:

uninstall: uninstall-exec uninstall-data
uninstall-exec:
uninstall-data: uninstall-data-yes
	if test "$(PACKAGE)" = "gettext-tools"; then \
	  for file in $(DISTFILES.common) Makevars.template; do \
	    rm -f $(DESTDIR)$(gettextsrcdir)/$$file; \
	  done; \
	else \
	  : ; \
	fi
uninstall-data-no:
uninstall-data-yes:
	catalogs='$(CATALOGS)'; \
	for cat in $$catalogs; do \
	  cat=`basename $$cat`; \
	  lang=`echo $$cat | sed -e 's/\.gmo$$//'`; \
	  for lc in LC_MESSAGES $(EXTRA_LOCALE_CATEGORIES); do \
	    rm -f $(DESTDIR)$(localedir)/$$lang/$$lc/$(DOMAIN).mo; \
	  done; \
	done

check: all

info dvi ps pdf html tags TAGS ctags CTAGS ID:

install-dvi install-ps install-pdf install-html:

mostlyclean:
	rm -f remove-potcdate.sed
	rm -f $(srcdir)/stamp-poT
	rm -f core core.* $(DOMAIN).po $(DOMAIN).1po $(DOMAIN).2po *.new.po
	rm -fr *.o

clean: mostlyclean

distclean: clean
	rm -f Makefile Makefile.in POTFILES

maintainer-clean: distclean
	@echo "This command is intended for maintainers to use;"
	@echo "it deletes files that may require special tools to rebuild."
	rm -f $(srcdir)/$(DOMAIN).pot $(srcdir)/stamp-po $(GMOFILES)

distdir = $(top_builddir)/$(PACKAGE)-$(VERSION)/$(subdir)
dist distdir:
	test -z "$(DISTFILESDEPS)" || $(MAKE) $(DISTFILESDEPS)
	@$(MAKE) dist2
# This is a separate target because 'update-po' must be executed before.
dist2: $(srcdir)/stamp-po $(DISTFILES)
	@dists="$(DISTFILES)"; \
	if test "$(PACKAGE)" = "gettext-tools"; then \
	  dists="$$dists Makevars.template"; \
	fi; \
	if test -f $(srcdir)/$(DOMAIN).pot; then \
	  dists="$$dists $(DOMAIN).pot stamp-po"; \
	else \
	  case $(XGETTEXT) in \
	    :) echo "Warning: Creating a tarball without '$(DOMAIN).pot', because a suitable 'xgettext' program was not found in PATH." 1>&2;; \
	    *) echo "Warning: Creating a tarball without '$(DOMAIN).pot', because 'xgettext' found no strings to extract. Check the contents of the POTFILES.in file and the XGETTEXT_OPTIONS in the Makevars file." 1>&2;; \
	  esac; \
	fi; \
	if test -f $(srcdir)/ChangeLog; then \
	  dists="$$dists ChangeLog"; \
	fi; \
	for i in 0 1 2 3 4 5 6 7 8 9; do \
	  if test -f $(srcdir)/ChangeLog.$$i; then \
	    dists="$$dists ChangeLog.$$i"; \
	  fi; \
	done; \
	if test -f $(srcdir)/LINGUAS; then dists="$$dists LINGUAS"; fi; \
	for file in $$dists; do \
	  if test -f $$file; then \
	    cp -p $$file $(distdir) || exit 1; \
	  else \
	    cp -p $(srcdir)/$$file $(distdir) || exit 1; \
	  fi; \
	done

update-po: Makefile
	$(MAKE) $(DOMAIN).pot-update
	test -z "$(UPDATEPOFILES)" || $(MAKE) $(UPDATEPOFILES)
	$(MAKE) update-gmo

# General rule for creating PO files.

.nop.po-create:
	@lang=`echo $@ | sed -e 's/\.po-create$$//'`; \
	echo "File $$lang.po does not exist. If you are a translator, you can create it through 'msginit'." 1>&2; \
	exit 1

# General rule for updating PO files.

.nop.po-update:
	@lang=`echo $@ | sed -e 's/\.po-update$$//'`; \
	if test "$(PACKAGE)" = "gettext-tools" && test "$(CROSS_COMPILING)" != "yes"; then PATH=`pwd`/../src:$$PATH; fi; \
	tmpdir=`pwd`; \
	echo "$$lang:"; \
	test "$(srcdir)" = . && cdcmd="" || cdcmd="cd $(srcdir) && "; \
	echo "$${cdcmd}$(MSGMERGE) --quiet $(MSGMERGE_OPTIONS) --lang=$$lang --previous $$lang.po $(DOMAIN).pot -o $$lang.new.po"; \
	cd $(srcdir); \
	if { case `$(MSGMERGE) --version | sed 1q | sed -e 's,^[^0-9]*,,'` in \
	       '' | 0.[0-9] | 0.[0-9].* | 0.10 | 0.10.*) \
	         $(MSGMERGE) $(MSGMERGE_OPTIONS) -o $$tmpdir/$$lang.new.po $$lang.po $(DOMAIN).pot;; \
	       0.1[1-5] | 0.1[1-5].*) \
	         $(MSGMERGE) --quiet $(MSGMERGE_OPTIONS) -o $$tmpdir/$$lang.new.po $$lang.po $(DOMAIN).pot;; \
	       0.1[6-7] | 0.1[6-7].*) \
	         $(MSGMERGE) --quiet $(MSGMERGE_OPTIONS) --previous -o $$tmpdir/$$lang.new.po $$lang.po $(DOMAIN).pot;; \
	       *) \
	         $(MSGMERGE) --quiet $(MSGMERGE_OPTIONS) --lang=$$lang --previous -o $$tmpdir/$$lang.new.po $$lang.po $(DOMAIN).pot;; \
	     esac; \
	   }; then \
	  if cmp $$lang.po $$tmpdir/$$lang.new.po >/dev/null 2>&1; then \
	    rm -f $$tmpdir/$$lang.new.po; \
	  else \
	    if mv -f $$tmpdir/$$lang.new.po $$lang.po; then \
	      :; \
	    else \
	      echo "msgmerge for $$lang.po failed: cannot move $$tmpdir/$$lang.new.po to $$lang.po" 1>&2; \
	      exit 1; \
	    fi; \
	  fi; \
	else \
	  echo "msgmerge for $$lang.po failed!" 1>&2; \
	  rm -f $$tmpdir/$$lang.new.po; \
	fi

$(DUMMYPOFILES):

update-gmo: Makefile $(GMOFILES)
	@:

# Recreate Makefile by invoking config.status. Explicitly invoke the shell,
# because execution permission bits may not work on the current file system.
# Use /bin/bash, which is the shell determined by autoconf for the use by its
# scripts, not $(SHELL) which is hardwired to /bin/sh and may be deficient.
Makefile: Makefile.in.in Makevars $(top_builddir)/config.status POTFILES.in LINGUAS
	cd $(top_builddir) \
	  && /bin/bash ./config.status $(subdir)/$@.in po-directories

force:

# Tell versions [3.59,3.63) of GNU make not to export all variables.
# Otherwise a system limit (for SysV at least) may be exceeded.
.NOEXPORT:
# Special Makefile rules for English message catalogs with quotation marks.
#
# Copyright (C) 2001-2017 Free Software Foundation, Inc.
# This file, Rules-quot, and its auxiliary files (listed under
# DISTFILES.common.extra1) are free software; the Free Software Foundation
# gives unlimited permission to use, copy, distribute, and modify them.

DISTFILES.common.extra1 = quot.sed boldquot.sed en@quot.header en@boldquot.header insert-header.sin Rules-quot

.SUFFIXES: .insert-header .po-update-en

en@quot.po-create:
	$(MAKE) en@quot.po-update
en@boldquot.po-create:
	$(MAKE) en@boldquot.po-update

en@quot.po-update: en@quot.po-update-en
en@boldquot.po-update: en@boldquot.po-update-en

.insert-header.po-update-en:
	@lang=`echo $@ | sed -e 's/\.po-update-en$$//'`; \
	if test "$(PACKAGE)" = "gettext-tools" && test "$(CROSS_COMPILING)" != "yes"; then PATH=`pwd`/../src:$$PATH; GETTEXTLIBDIR=`cd $(top_srcdir)/src && pwd`; export GETTEXTLIBDIR; fi; \
	tmpdir=`pwd`; \
	echo "$$lang:"; \
	ll=`echo $$lang | sed -e 's/@.*//'`; \
	LC_ALL=C; export LC_ALL; \
	cd $(srcdir); \
	if $(MSGINIT) $(MSGINIT_OPTIONS) -i $(DOMAIN).pot --no-translator -l $$lang -o - 2>/dev/null \
	   | $(SED) -f $$tmpdir/$$lang.insert-header | $(MSGCONV) -t UTF-8 | \
	   { case `$(MSGFILTER) --version | sed 1q | sed -e 's,^[^0-9]*,,'` in \
	     '' | 0.[0-9] | 0.[0-9].* | 0.1[0-8] | 0.1[0-8].*) \
	       $(MSGFILTER) $(SED) -f `echo $$lang | sed -e 's/.*@//'`.sed \
	       ;; \
	     *) \
	       $(MSGFILTER) `echo $$lang | sed -e 's/.*@//'` \
	       ;; \
	     esac } 2>/dev/null > $$tmpdir/$$lang.new.po \
	     ; then \
	  if cmp $$lang.po $$tmpdir/$$lang.new.po >/dev/null 2>&1; then \
	    rm -f $$tmpdir/$$lang.new.po; \
	  else \
	    if mv -f $$tmpdir/$$lang.new.po $$lang.po; then \
	      :; \
	    else \
	      echo "creation of $$lang.po failed: cannot move $$tmpdir/$$lang.new.po to $$lang.po" 1>&2; \
	      exit 1; \
	    fi; \
	  fi; \
	else \
	  echo "creation of $$lang.po failed!" 1>&2; \
	  rm -f $$tmpdir/$$lang.new.po; \
	fi

en@quot.insert-header: insert-header.sin
	sed -e '/^#/d' -e 's/HEADER/en@quot.header/g' $(srcdir)/insert-header.sin > en@quot.insert-header

en@boldquot.insert-header: insert-header.sin
	sed -e '/^#/d' -e 's/HEADER/en@boldquot.header/g' $(srcdir)/insert-header.sin > en@boldquot.insert-header

mostlyclean: mostlyclean-quot
mostlyclean-quot:
	rm -f *.insert-header
