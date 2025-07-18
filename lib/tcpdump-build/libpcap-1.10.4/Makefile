#  Copyright (c) 1993, 1994, 1995, 1996
#	The Regents of the University of California.  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that: (1) source code distributions
#  retain the above copyright notice and this paragraph in its entirety, (2)
#  distributions including binary code include the above copyright notice and
#  this paragraph in its entirety in the documentation or other materials
#  provided with the distribution, and (3) all advertising materials mentioning
#  features or use of this software display the following acknowledgement:
#  ``This product includes software developed by the University of California,
#  Lawrence Berkeley Laboratory and its contributors.'' Neither the name of
#  the University nor the names of its contributors may be used to endorse
#  or promote products derived from this software without specific prior
#  written permission.
#  THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

#
# Various configurable paths (remember to edit Makefile.in, not Makefile)
#

# Top level hierarchy
prefix = /usr/local
exec_prefix = ${prefix}
datarootdir = ${prefix}/share
# Pathname of directory to install the configure program
bindir = ${exec_prefix}/bin
# Pathname of directory to install the rpcapd daemon
sbindir = ${exec_prefix}/sbin
# Pathname of directory to install the include files
includedir = ${prefix}/include
# Pathname of directory to install the library
libdir =  ${exec_prefix}/lib
# Pathname of directory to install the man pages
mandir = ${datarootdir}/man

# VPATH
srcdir = .
top_srcdir = .


#
# You shouldn't need to edit anything below.
#

LD = /usr/bin/ld
CC = aarch64-linux-gnu-gcc
AR = aarch64-linux-gnu-ar
LN_S = ln -s
MKDEP = 
CCOPT =  -fvisibility=hidden
SHLIB_CCOPT =  -fpic
INCLS = -I. 
DEFS = -DBUILDING_PCAP -Dpcap_EXPORTS -DHAVE_CONFIG_H 
ADDLOBJS = 
ADDLARCHIVEOBJS = 
LIBS =  
CROSSFLAGS=
CFLAGS = -g -O2   ${CROSSFLAGS}
LDFLAGS =  ${CROSSFLAGS}
DYEXT = none
RPATH = -Wl,-rpath,${libdir}
DEPENDENCY_CFLAG = 
PROG=libpcap
PTHREAD_LIBS=
BUILD_RPCAPD=
INSTALL_RPCAPD=

# Standard CFLAGS for building members of a shared library
FULL_CFLAGS = $(CCOPT)  $(SHLIB_CCOPT) $(INCLS) $(DEFS) $(CFLAGS)
CXXFLAGS = $(CCOPT)  $(SHLIB_CCOPT) $(INCLS) $(DEFS) $(CFLAGS)

INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA = ${INSTALL} -m 644
RANLIB = aarch64-linux-gnu-ranlib

LEX = flex
BISON_BYACC = bison

# Explicitly define compilation rule since SunOS 4's make doesn't like gcc.
# Also, gcc does not remove the .o before forking 'as', which can be a
# problem if you don't own the file but can write to the directory.
.c.o:
	@rm -f $@
	$(CC) $(FULL_CFLAGS) -c $(srcdir)/$*.c

PLATFORM_C_SRC =	pcap-linux.c fad-getad.c
PLATFORM_CXX_SRC =	
MODULE_C_SRC =		 pcap-usb-linux.c pcap-netfilter-linux.c
REMOTE_C_SRC =		
COMMON_C_SRC =	pcap.c gencode.c optimize.c nametoaddr.c etherent.c \
		fmtutils.c pcap-util.c \
		savefile.c sf-pcap.c sf-pcapng.c pcap-common.c \
		pcap-usb-linux-common.c bpf_image.c bpf_filter.c bpf_dump.c
GENERATED_C_SRC = scanner.c grammar.c
LIBOBJS = 

SRC =	$(PLATFORM_C_SRC) $(PLATFORM_CXX_SRC) \
	$(MODULE_C_SRC) $(REMOTE_C_SRC) $(COMMON_C_SRC) \
	$(GENERATED_C_SRC)

# We would like to say "OBJ = $(SRC:.c=.o)" but Ultrix's make cannot
# hack the extra indirection, and we have to handle PLATFORM_CXX_SRC
# differently from the defines for C source
OBJ =	$(PLATFORM_C_SRC:.c=.o) $(PLATFORM_CXX_SRC:.cpp=.o) \
	$(MODULE_C_SRC:.c=.o) $(REMOTE_C_SRC:.c=.o) $(COMMON_C_SRC:.c=.o) \
	$(GENERATED_C_SRC:.c=.o) \
	$(LIBOBJS)

PUBHDR = \
	pcap.h \
	pcap-bpf.h \
	pcap-namedb.h \
	pcap/bluetooth.h \
	pcap/bpf.h \
	pcap/can_socketcan.h \
	pcap/compiler-tests.h \
	pcap/dlt.h \
	pcap/funcattrs.h \
	pcap/ipnet.h \
	pcap/namedb.h \
	pcap/nflog.h \
	pcap/pcap-inttypes.h \
	pcap/pcap.h \
	pcap/sll.h \
	pcap/socket.h \
	pcap/usb.h \
	pcap/vlan.h

HDR = $(PUBHDR) \
	arcnet.h \
	atmuni31.h \
	diag-control.h \
	ethertype.h \
	extract.h \
	fmtutils.h \
	ftmacros.h \
	gencode.h \
	ieee80211.h \
	llc.h \
	nametoaddr.h \
	nlpid.h \
	optimize.h \
	pcap-common.h \
	pcap-int.h \
	pcap-rpcap.h \
	pcap-types.h \
	pcap-usb-linux-common.h \
	pcap-util.h \
	pflog.h \
	portability.h \
	ppp.h \
	rpcap-protocol.h \
	sf-pcap.h \
	sf-pcapng.h \
	sunatmpos.h \
	varattrs.h

GENHDR = \
	scanner.h grammar.h

TAGFILES = \
	$(SRC) $(HDR)

CLEANFILES = $(OBJ) libpcap.a libpcap.so.`cat $(srcdir)/VERSION` \
	$(PROG)-`cat $(srcdir)/VERSION`.tar.gz $(GENERATED_C_SRC) $(GENHDR) \
	lex.yy.c pcap-config libpcap.pc

MAN1 = pcap-config.1

MAN3PCAP_EXPAND = \
	pcap.3pcap.in \
	pcap_compile.3pcap.in \
	pcap_datalink.3pcap.in \
	pcap_dump_open.3pcap.in \
	pcap_get_tstamp_precision.3pcap.in \
	pcap_list_datalinks.3pcap.in \
	pcap_list_tstamp_types.3pcap.in \
	pcap_open_dead.3pcap.in \
	pcap_open_offline.3pcap.in \
	pcap_set_immediate_mode.3pcap.in \
	pcap_set_tstamp_precision.3pcap.in \
	pcap_set_tstamp_type.3pcap.in

MAN3PCAP_NOEXPAND = \
	pcap_activate.3pcap \
	pcap_breakloop.3pcap \
	pcap_can_set_rfmon.3pcap \
	pcap_close.3pcap \
	pcap_create.3pcap \
	pcap_datalink_name_to_val.3pcap \
	pcap_datalink_val_to_name.3pcap \
	pcap_dump.3pcap \
	pcap_dump_close.3pcap \
	pcap_dump_file.3pcap \
	pcap_dump_flush.3pcap \
	pcap_dump_ftell.3pcap \
	pcap_file.3pcap \
	pcap_fileno.3pcap \
	pcap_findalldevs.3pcap \
	pcap_freecode.3pcap \
	pcap_get_required_select_timeout.3pcap \
	pcap_get_selectable_fd.3pcap \
	pcap_geterr.3pcap \
	pcap_init.3pcap \
	pcap_inject.3pcap \
	pcap_is_swapped.3pcap \
	pcap_lib_version.3pcap \
	pcap_lookupdev.3pcap \
	pcap_lookupnet.3pcap \
	pcap_loop.3pcap \
	pcap_major_version.3pcap \
	pcap_next_ex.3pcap \
	pcap_offline_filter.3pcap \
	pcap_open_live.3pcap \
	pcap_set_buffer_size.3pcap \
	pcap_set_datalink.3pcap \
	pcap_set_promisc.3pcap \
	pcap_set_protocol_linux.3pcap \
	pcap_set_rfmon.3pcap \
	pcap_set_snaplen.3pcap \
	pcap_set_timeout.3pcap \
	pcap_setdirection.3pcap \
	pcap_setfilter.3pcap \
	pcap_setnonblock.3pcap \
	pcap_snapshot.3pcap \
	pcap_stats.3pcap \
	pcap_statustostr.3pcap \
	pcap_strerror.3pcap \
	pcap_tstamp_type_name_to_val.3pcap \
	pcap_tstamp_type_val_to_name.3pcap

MAN3PCAP = $(MAN3PCAP_NOEXPAND) $(MAN3PCAP_EXPAND:.in=)

MANFILE = \
	pcap-savefile.manfile.in

MANMISC = \
	pcap-filter.manmisc.in \
	pcap-linktype.manmisc.in \
	pcap-tstamp.manmisc.in

EXTRA_DIST = \
	CHANGES \
	ChmodBPF/ChmodBPF \
	ChmodBPF/StartupParameters.plist \
	CREDITS \
	CMakeLists.txt \
	INSTALL.md \
	LICENSE \
	Makefile.in \
	Makefile-devel-adds \
	README.md \
	doc/README.Win32.md \
	doc/README.aix \
	doc/README.dag \
	doc/README.hpux \
	doc/README.linux \
	doc/README.macos \
	doc/README.septel \
	doc/README.sita \
	doc/README.solaris.md \
	CONTRIBUTING.md \
	TODO \
	VERSION \
	aclocal.m4 \
	charconv.c \
	charconv.h \
	chmod_bpf \
	cmake_uninstall.cmake.in \
	cmakeconfig.h.in \
	cmake/Modules/FindAirPcap.cmake \
	cmake/Modules/FindDAG.cmake \
	cmake/Modules/Finddpdk.cmake \
	cmake/Modules/FindFseeko.cmake \
	cmake/Modules/FindLFS.cmake \
	cmake/Modules/FindPacket.cmake \
	cmake/Modules/FindSNF.cmake \
	cmake/Modules/FindTC.cmake \
	cmake/have_siocglifconf.c \
	config.guess \
	config.h.in \
	config.sub \
	configure \
	configure.ac \
	dlpisubs.c \
	dlpisubs.h \
	fad-getad.c \
	fad-gifc.c \
	fad-glifc.c \
	grammar.y.in \
	install-sh \
	lbl/os-aix4.h \
	lbl/os-aix7.h \
	lbl/os-hpux11.h \
	lbl/os-osf4.h \
	lbl/os-osf5.h \
	lbl/os-solaris2.h \
	lbl/os-sunos4.h \
	lbl/os-ultrix4.h \
	libpcap.pc.in \
	missing/asprintf.c \
	missing/getopt.c \
	missing/getopt.h \
	missing/strlcat.c \
	missing/strlcpy.c \
	missing/strtok_r.c \
	missing/win_asprintf.c \
	mkdep \
	msdos/bin2c.c \
	msdos/makefile \
	msdos/makefile.dj \
	msdos/makefile.wc \
	msdos/pkt_rx0.asm \
	msdos/pkt_rx1.s \
	msdos/pktdrvr.c \
	msdos/pktdrvr.h \
	msdos/readme.dos \
	nomkdep \
	org.tcpdump.chmod_bpf.plist \
	pcap-airpcap.c \
	pcap-airpcap.h \
	pcap-bpf.c \
	pcap-bt-linux.c \
	pcap-bt-linux.h \
	pcap-bt-monitor-linux.c \
	pcap-bt-monitor-linux.h \
	pcap-config.in \
	pcap-dag.c \
	pcap-dag.h \
	pcap-dbus.c \
	pcap-dbus.h \
	pcap-dll.rc \
	pcap-dlpi.c \
	pcap-dos.c \
	pcap-dos.h \
	pcap-dpdk.c \
	pcap-dpdk.h \
	pcap-enet.c \
	pcap-haiku.cpp \
	pcap-int.h \
	pcap-libdlpi.c \
	pcap-linux.c \
	pcap-namedb.h \
	pcap-new.c \
	pcap-netfilter-linux.c \
	pcap-netfilter-linux.h \
	pcap-netmap.c \
	pcap-netmap.h \
	pcap-nit.c \
	pcap-npf.c \
	pcap-null.c \
	pcap-pf.c \
	pcap-rdmasniff.c \
	pcap-rdmasniff.h \
	pcap-rpcap.c \
	pcap-rpcap-int.h \
	pcap-septel.c \
	pcap-septel.h \
	pcap-sita.h \
	pcap-sita.c \
	pcap-sita.html \
	pcap-snf.c \
	pcap-snf.h \
	pcap-snit.c \
	pcap-snoop.c \
	pcap-tc.c \
	pcap-tc.h \
	pcap-usb-linux.c \
	pcap-usb-linux.h \
	rpcap-protocol.c \
	rpcapd/CMakeLists.txt \
	rpcapd/Makefile.in \
	rpcapd/config_params.h \
	rpcapd/daemon.h \
	rpcapd/daemon.c \
	rpcapd/fileconf.c \
	rpcapd/fileconf.h \
	rpcapd/log.h \
	rpcapd/log.c \
	rpcapd/org.tcpdump.rpcapd.plist \
	rpcapd/rpcapd.c \
	rpcapd/rpcapd.h \
	rpcapd/rpcapd.inetd.conf \
	rpcapd/rpcapd.manadmin.in \
	rpcapd/rpcapd-config.manfile.in \
	rpcapd/rpcapd.rc \
	rpcapd/rpcapd.socket \
	rpcapd/rpcapd.xinetd.conf \
	rpcapd/rpcapd@.service \
	rpcapd/win32-svc.c \
	rpcapd/win32-svc.h \
	sockutils.c \
	sockutils.h \
	sslutils.c \
	sslutils.h \
	scanner.l \
	testprogs/CMakeLists.txt \
	testprogs/Makefile.in \
	testprogs/can_set_rfmon_test.c \
	testprogs/capturetest.c \
	testprogs/filtertest.c \
	testprogs/findalldevstest.c \
	testprogs/findalldevstest-perf.c \
	testprogs/fuzz/CMakeLists.txt \
	testprogs/fuzz/fuzz_both.c \
	testprogs/fuzz/fuzz_both.options \
	testprogs/fuzz/fuzz_filter.c \
	testprogs/fuzz/fuzz_filter.options \
	testprogs/fuzz/fuzz_pcap.c \
	testprogs/fuzz/fuzz_pcap.options \
	testprogs/fuzz/onefile.c \
	testprogs/nonblocktest.c \
	testprogs/opentest.c \
	testprogs/reactivatetest.c \
	testprogs/selpolltest.c \
	testprogs/threadsignaltest.c \
	testprogs/unix.h \
	testprogs/valgrindtest.c \
	testprogs/visopts.py \
	testprogs/writecaptest.c

TEST_DIST = `git ls-files tests | grep -v 'tests/\..*'`

RELEASE_FILES = $(COMMON_C_SRC) $(HDR) $(MAN1) $(MAN3PCAP_EXPAND) \
	$(MAN3PCAP_NOEXPAND) $(MANFILE) $(MANMISC) $(EXTRA_DIST) \
	$(TEST_DIST)

all: libpcap.a shared $(BUILD_RPCAPD) libpcap.pc pcap-config

libpcap.a: $(OBJ)
	@rm -f $@
	$(AR) rc $@ $(OBJ) $(ADDLARCHIVEOBJS)
	$(RANLIB) $@

shared: libpcap.$(DYEXT)

libpcap.so: $(OBJ)
	@rm -f $@
	VER=`cat $(srcdir)/VERSION`; \
	MAJOR_VER=`sed 's/\([0-9][0-9]*\)\..*/\1/' $(srcdir)/VERSION`; \
	$(CC) $(LDFLAGS) -shared -Wl,-soname,$@.$$MAJOR_VER \
	    -o $@.$$VER $(OBJ) $(ADDLOBJS) $(LIBS)

#
# The following rule succeeds, but the result is untested.
#
# In macOS, the libpcap dylib has the name "libpcap.A.dylib", with its
# full path as the install_name, and with the compatibility and current
# version both set to 1.  The compatibility version is set to 1 so that
# programs built with a newer version of the library will run against
# older versions if they don't use APIs available in the newer version
# but not in the older version.
#
# We also use "A" as the major version, and 1 as the compatibility version,
# but set the current version to the value in VERSION, with any non-numeric
# stuff stripped off (the compatibility and current version must be of the
# form X[.Y[.Z]], with Y and Z possibly absent, and with all components
# numeric).
#
libpcap.dylib: $(OBJ)
	rm -f libpcap*.dylib
	VER=`cat $(srcdir)/VERSION`; \
	MAJOR_VER=A; \
	COMPAT_VER=1; \
	CURRENT_VER=`sed 's/[^0-9.].*$$//' $(srcdir)/VERSION`; \
	$(CC) -dynamiclib -undefined error $(LDFLAGS)  \
	    -o libpcap.$$VER.dylib $(OBJ) $(ADDLOBJS) $(LIBS) \
	    -install_name $(libdir)/libpcap.$$MAJOR_VER.dylib \
	    -compatibility_version $$COMPAT_VER \
	    -current_version $$CURRENT_VER

#
# The HP-UX linker manual says that the convention for a versioned library
# is libXXX.{number}, not libXXX.sl.{number}.  That appears to be the case
# on at least one HP-UX 11.00 system; libXXX.sl is a symlink to
# libXXX.{number}.
#
# The manual also says "library-level versioning" (think "sonames") was
# added in HP-UX 10.0.
#
# XXX - this assumes we're using the HP linker, rather than the GNU
# linker, even with GCC.
#
libpcap.sl: $(OBJ)
	@MAJOR_VER=`sed 's/\([0-9][0-9]*\)\..*/\1/' $(srcdir)/VERSION`; \
	rm -f libpcap.$$MAJOR_VER
	MAJOR_VER=`sed 's/\([0-9][0-9]*\)\..*/\1/' $(srcdir)/VERSION`; \
	ld -b $(LDFLAGS) -o libpcap.$$MAJOR_VER +h libpcap.$$MAJOR_VER \
	    $(OBJ) $(ADDLOBJS) $(LIBS)

#
# AIX is different from everybody else.  A shared library is an archive
# library with one or more shared-object components.  We still build a
# normal static archive library on AIX, for the benefit of the traditional
# scheme of building libpcap and tcpdump in subdirectories of the
# same directory, with tcpdump statically linked with the libpcap
# in question, but we also build a shared library as "libpcap.shareda"
# and install *it*, rather than the static library, as "libpcap.a".
#
libpcap.shareda: $(OBJ)
	@rm -f $@ shr.o
	$(CC) $(LDFLAGS) -shared -o shr.o $(OBJ) $(ADDLOBJS) $(LIBS)
	$(AR) rc $@ shr.o

#
# For platforms that don't support shared libraries (or on which we
# don't support shared libraries).
#
libpcap.none:

scanner.c: $(srcdir)/scanner.l
	$(LEX) -P pcap_ --header-file=scanner.h --nounput -o scanner.c $<
scanner.h: scanner.c
## Recover from the removal of $@
	@if test -f $@; then :; else \
		rm -f scanner.c; \
		$(MAKE) $(MAKEFLAGS) scanner.c; \
	fi

scanner.o: scanner.c grammar.h
	$(CC) $(FULL_CFLAGS) -c scanner.c

#
# Generate the grammar.y file.
#
# Some Makes, e.g. AIX Make and Solaris Make, can't handle "--file=$@.tmp:$<";
# for example, the Solaris 9 make man page says
#
#	Because make assigns $< and $* as it would for implicit rules
#	(according to the suffixes list and the directory contents),
#	they may be unreliable when used within explicit target entries.
#
# and this is an explicit target entry.
#
# Therefore, instead of using $<, we explicitly put in $(srcdir)/libpcap.pc.in.
#
grammar.y: $(srcdir)/grammar.y.in ./config.status
	@rm -f $@ $@.tmp
	./config.status --file=$@.tmp:$(srcdir)/grammar.y.in
	mv $@.tmp $@

grammar.c: grammar.y
	$(BISON_BYACC) -p pcap_ -o grammar.c -d $<
grammar.h: grammar.c
## Recover from the removal of $@
	@if test -f $@; then :; else \
		rm -f grammar.c; \
		$(MAKE) $(MAKEFLAGS) grammar.c; \
	fi

grammar.o: grammar.c scanner.h
	$(CC) $(FULL_CFLAGS) -c grammar.c

gencode.o: $(srcdir)/gencode.c grammar.h scanner.h
	$(CC) $(FULL_CFLAGS) -c $(srcdir)/gencode.c

asprintf.o: $(srcdir)/missing/asprintf.c
	$(CC) $(FULL_CFLAGS) -o $@ -c $(srcdir)/missing/asprintf.c

snprintf.o: $(srcdir)/missing/snprintf.c
	$(CC) $(FULL_CFLAGS) -o $@ -c $(srcdir)/missing/snprintf.c

strlcat.o: $(srcdir)/missing/strlcat.c
	$(CC) $(FULL_CFLAGS) -o $@ -c $(srcdir)/missing/strlcat.c

strlcpy.o: $(srcdir)/missing/strlcpy.c
	$(CC) $(FULL_CFLAGS) -o $@ -c $(srcdir)/missing/strlcpy.c

strtok_r.o: $(srcdir)/missing/strtok_r.c
	$(CC) $(FULL_CFLAGS) -o $@ -c $(srcdir)/missing/strtok_r.c

#
# Generate the libpcap.pc file.
#
# Some Makes, e.g. AIX Make and Solaris Make, can't handle "--file=$@.tmp:$<";
# for example, the Solaris 9 make man page says
#
#	Because make assigns $< and $* as it would for implicit rules
#	(according to the suffixes list and the directory contents),
#	they may be unreliable when used within explicit target entries.
#
# and this is an explicit target entry.
#
# Therefore, instead of using $<, we explicitly put in $(srcdir)/libpcap.pc.in.
#
libpcap.pc: $(srcdir)/libpcap.pc.in ./config.status
	@rm -f $@ $@.tmp
	./config.status --file=$@.tmp:$(srcdir)/libpcap.pc.in
	mv $@.tmp $@

#
# Generate the pcap-config script.  See above.
#
pcap-config: $(srcdir)/pcap-config.in ./config.status
	@rm -f $@ $@.tmp
	./config.status --file=$@.tmp:$(srcdir)/pcap-config.in
	mv $@.tmp $@
	chmod a+x $@

#
# Remote pcap daemon.
#
build-rpcapd: libpcap.a
	(cd rpcapd; $(MAKE))

#
# Test programs - not built by default, and not installed.
#
testprogs: FORCE
	(cd testprogs; $(MAKE))

FORCE:

install: install-shared install-archive libpcap.pc pcap-config 
	[ -d $(DESTDIR)$(libdir) ] || \
	    (mkdir -p $(DESTDIR)$(libdir); chmod 755 $(DESTDIR)$(libdir))
	[ -d $(DESTDIR)$(includedir) ] || \
	    (mkdir -p $(DESTDIR)$(includedir); chmod 755 $(DESTDIR)$(includedir))
	[ -d $(DESTDIR)$(includedir)/pcap ] || \
	    (mkdir -p $(DESTDIR)$(includedir)/pcap; chmod 755 $(DESTDIR)$(includedir)/pcap)
	[ -d $(DESTDIR)$(mandir)/man1 ] || \
	    (mkdir -p $(DESTDIR)$(mandir)/man1; chmod 755 $(DESTDIR)$(mandir)/man1)
	[ -d $(DESTDIR)$(mandir)/man3 ] || \
	    (mkdir -p $(DESTDIR)$(mandir)/man3; chmod 755 $(DESTDIR)$(mandir)/man3)
	[ -d $(DESTDIR)$(mandir)/man5 ] || \
	    (mkdir -p $(DESTDIR)$(mandir)/man5; chmod 755 $(DESTDIR)$(mandir)/man5)
	[ -d $(DESTDIR)$(mandir)/man7 ] || \
	    (mkdir -p $(DESTDIR)$(mandir)/man7; chmod 755 $(DESTDIR)$(mandir)/man7)
	for i in $(PUBHDR); do \
		$(INSTALL_DATA) $(srcdir)/$$i \
		    $(DESTDIR)$(includedir)/$$i; done
	[ -d $(DESTDIR)$(bindir) ] || \
	    (mkdir -p $(DESTDIR)$(bindir); chmod 755 $(DESTDIR)$(bindir))
	$(INSTALL_PROGRAM) pcap-config $(DESTDIR)$(bindir)/pcap-config
	[ -d $(DESTDIR)$(libdir)/pkgconfig ] || \
	    (mkdir -p $(DESTDIR)$(libdir)/pkgconfig; chmod 755 $(DESTDIR)$(libdir)/pkgconfig)
	$(INSTALL_DATA) libpcap.pc $(DESTDIR)$(libdir)/pkgconfig/libpcap.pc
	for i in $(MAN1); do \
		$(INSTALL_DATA) $(srcdir)/$$i \
		    $(DESTDIR)$(mandir)/man1/$$i; done
	for i in $(MAN3PCAP_NOEXPAND); do \
		$(INSTALL_DATA) $(srcdir)/$$i \
		    $(DESTDIR)$(mandir)/man3/$$i; done
	for i in $(MAN3PCAP_EXPAND:.in=); do \
		$(INSTALL_DATA) $$i \
		    $(DESTDIR)$(mandir)/man3/$$i; done
	(cd $(DESTDIR)$(mandir)/man3 && \
	rm -f pcap_datalink_val_to_description.3pcap && \
	$(LN_S) pcap_datalink_val_to_name.3pcap \
		 pcap_datalink_val_to_description.3pcap && \
	rm -f pcap_datalink_val_to_description_or_dlt.3pcap && \
	$(LN_S) pcap_datalink_val_to_name.3pcap \
		 pcap_datalink_val_to_description_or_dlt.3pcap && \
	rm -f pcap_dump_fopen.3pcap && \
	$(LN_S) pcap_dump_open.3pcap pcap_dump_fopen.3pcap && \
	rm -f pcap_freealldevs.3pcap && \
	$(LN_S) pcap_findalldevs.3pcap pcap_freealldevs.3pcap && \
	rm -f pcap_perror.3pcap && \
	$(LN_S) pcap_geterr.3pcap pcap_perror.3pcap && \
	rm -f pcap_sendpacket.3pcap && \
	$(LN_S) pcap_inject.3pcap pcap_sendpacket.3pcap && \
	rm -f pcap_free_datalinks.3pcap && \
	$(LN_S) pcap_list_datalinks.3pcap pcap_free_datalinks.3pcap && \
	rm -f pcap_free_tstamp_types.3pcap && \
	$(LN_S) pcap_list_tstamp_types.3pcap pcap_free_tstamp_types.3pcap && \
	rm -f pcap_dispatch.3pcap && \
	$(LN_S) pcap_loop.3pcap pcap_dispatch.3pcap && \
	rm -f pcap_minor_version.3pcap && \
	$(LN_S) pcap_major_version.3pcap pcap_minor_version.3pcap && \
	rm -f pcap_next.3pcap && \
	$(LN_S) pcap_next_ex.3pcap pcap_next.3pcap && \
	rm -f pcap_open_dead_with_tstamp_precision.3pcap && \
	$(LN_S) pcap_open_dead.3pcap \
		 pcap_open_dead_with_tstamp_precision.3pcap && \
	rm -f pcap_open_offline_with_tstamp_precision.3pcap && \
	$(LN_S) pcap_open_offline.3pcap pcap_open_offline_with_tstamp_precision.3pcap && \
	rm -f pcap_fopen_offline.3pcap && \
	$(LN_S) pcap_open_offline.3pcap pcap_fopen_offline.3pcap && \
	rm -f pcap_fopen_offline_with_tstamp_precision.3pcap && \
	$(LN_S) pcap_open_offline.3pcap pcap_fopen_offline_with_tstamp_precision.3pcap && \
	rm -f pcap_tstamp_type_val_to_description.3pcap && \
	$(LN_S) pcap_tstamp_type_val_to_name.3pcap pcap_tstamp_type_val_to_description.3pcap && \
	rm -f pcap_getnonblock.3pcap && \
	$(LN_S) pcap_setnonblock.3pcap pcap_getnonblock.3pcap)
	for i in $(MANFILE); do \
		$(INSTALL_DATA) `echo $$i | sed 's/.manfile.in/.manfile/'` \
		    $(DESTDIR)$(mandir)/man5/`echo $$i | sed 's/.manfile.in/.5/'`; done
	for i in $(MANMISC); do \
		$(INSTALL_DATA) `echo $$i | sed 's/.manmisc.in/.manmisc/'` \
		    $(DESTDIR)$(mandir)/man7/`echo $$i | sed 's/.manmisc.in/.7/'`; done

install-shared: install-shared-$(DYEXT)
install-shared-so: libpcap.so
	[ -d $(DESTDIR)$(libdir) ] || \
	    (mkdir -p $(DESTDIR)$(libdir); chmod 755 $(DESTDIR)$(libdir))
	VER=`cat $(srcdir)/VERSION`; \
	MAJOR_VER=`sed 's/\([0-9][0-9]*\)\..*/\1/' $(srcdir)/VERSION`; \
	$(INSTALL_PROGRAM) libpcap.so.$$VER $(DESTDIR)$(libdir)/libpcap.so.$$VER; \
	ln -sf libpcap.so.$$VER $(DESTDIR)$(libdir)/libpcap.so.$$MAJOR_VER; \
	ln -sf libpcap.so.$$MAJOR_VER $(DESTDIR)$(libdir)/libpcap.so
install-shared-dylib: libpcap.dylib
	[ -d $(DESTDIR)$(libdir) ] || \
	    (mkdir -p $(DESTDIR)$(libdir); chmod 755 $(DESTDIR)$(libdir))
	VER=`cat $(srcdir)/VERSION`; \
	MAJOR_VER=A; \
	$(INSTALL_PROGRAM) libpcap.$$VER.dylib $(DESTDIR)$(libdir)/libpcap.$$VER.dylib; \
	ln -sf libpcap.$$VER.dylib $(DESTDIR)$(libdir)/libpcap.$$MAJOR_VER.dylib; \
	ln -sf libpcap.$$MAJOR_VER.dylib $(DESTDIR)$(libdir)/libpcap.dylib
install-shared-sl: libpcap.sl
	[ -d $(DESTDIR)$(libdir) ] || \
	    (mkdir -p $(DESTDIR)$(libdir); chmod 755 $(DESTDIR)$(libdir))
	MAJOR_VER=`sed 's/\([0-9][0-9]*\)\..*/\1/' $(srcdir)/VERSION`; \
	$(INSTALL_PROGRAM) libpcap.$$MAJOR_VER $(DESTDIR)$(libdir)
	ln -sf libpcap.$$MAJOR_VER $(DESTDIR)$(libdir)/libpcap.sl
install-shared-shareda: libpcap.shareda
	#
	# AIX shared libraries are weird.  They're archive libraries
	# with one or more shared object components.
	#
	[ -d $(DESTDIR)$(libdir) ] || \
	    (mkdir -p $(DESTDIR)$(libdir); chmod 755 $(DESTDIR)$(libdir))
	$(INSTALL_PROGRAM) libpcap.shareda $(DESTDIR)$(libdir)/libpcap.a
install-shared-none:

install-archive: install-archive-$(DYEXT)
install-archive-so install-archive-dylib install-archive-sl install-archive-none: libpcap.a
	#
	# Most platforms have separate suffixes for shared and
	# archive libraries, so we install both.
	#
	[ -d $(DESTDIR)$(libdir) ] || \
	    (mkdir -p $(DESTDIR)$(libdir); chmod 755 $(DESTDIR)$(libdir))
	$(INSTALL_DATA) libpcap.a $(DESTDIR)$(libdir)/libpcap.a
	$(RANLIB) $(DESTDIR)$(libdir)/libpcap.a
install-archive-shareda:
	#
	# AIX, however, doesn't, so we don't install the archive
	# library on AIX.
	#

install-rpcapd:
	(cd rpcapd; $(MAKE) DESTDIR=$(DESTDIR) install)

uninstall: uninstall-shared uninstall-rpcapd
	rm -f $(DESTDIR)$(libdir)/libpcap.a
	for i in $(PUBHDR); do \
		rm -f $(DESTDIR)$(includedir)/$$i; done
	-rmdir $(DESTDIR)$(includedir)/pcap
	rm -f $(DESTDIR)/$(libdir)/pkgconfig/libpcap.pc
	rm -f $(DESTDIR)/$(bindir)/pcap-config
	for i in $(MAN1); do \
		rm -f $(DESTDIR)$(mandir)/man1/$$i; done
	for i in $(MAN3PCAP); do \
		rm -f $(DESTDIR)$(mandir)/man3/$$i; done
	rm -f $(DESTDIR)$(mandir)/man3/pcap_datalink_val_to_description.3pcap
	rm -f $(DESTDIR)$(mandir)/man3/pcap_datalink_val_to_description_or_dlt.3pcap
	rm -f $(DESTDIR)$(mandir)/man3/pcap_dump_fopen.3pcap
	rm -f $(DESTDIR)$(mandir)/man3/pcap_freealldevs.3pcap
	rm -f $(DESTDIR)$(mandir)/man3/pcap_perror.3pcap
	rm -f $(DESTDIR)$(mandir)/man3/pcap_sendpacket.3pcap
	rm -f $(DESTDIR)$(mandir)/man3/pcap_free_datalinks.3pcap
	rm -f $(DESTDIR)$(mandir)/man3/pcap_free_tstamp_types.3pcap
	rm -f $(DESTDIR)$(mandir)/man3/pcap_dispatch.3pcap
	rm -f $(DESTDIR)$(mandir)/man3/pcap_minor_version.3pcap
	rm -f $(DESTDIR)$(mandir)/man3/pcap_next.3pcap
	rm -f $(DESTDIR)$(mandir)/man3/pcap_open_dead_with_tstamp_precision.3pcap
	rm -f $(DESTDIR)$(mandir)/man3/pcap_open_offline_with_tstamp_precision.3pcap
	rm -f $(DESTDIR)$(mandir)/man3/pcap_fopen_offline.3pcap
	rm -f $(DESTDIR)$(mandir)/man3/pcap_fopen_offline_with_tstamp_precision.3pcap
	rm -f $(DESTDIR)$(mandir)/man3/pcap_getnonblock.3pcap
	rm -f $(DESTDIR)$(mandir)/man3/pcap_tstamp_type_val_to_description.3pcap
	for i in $(MANFILE); do \
		rm -f $(DESTDIR)$(mandir)/man5/`echo $$i | sed 's/.manfile.in/.5/'`; done
	for i in $(MANMISC); do \
		rm -f $(DESTDIR)$(mandir)/man7/`echo $$i | sed 's/.manmisc.in/.7/'`; done

uninstall-shared: uninstall-shared-$(DYEXT)
uninstall-shared-so:
	VER=`cat $(srcdir)/VERSION`; \
	MAJOR_VER=`sed 's/\([0-9][0-9]*\)\..*/\1/' $(srcdir)/VERSION`; \
	rm -f $(DESTDIR)$(libdir)/libpcap.so.$$VER; \
	rm -f $(DESTDIR)$(libdir)/libpcap.so.$$MAJOR_VER; \
	rm -f $(DESTDIR)$(libdir)/libpcap.so
uninstall-shared-dylib:
	VER=`cat $(srcdir)/VERSION`; \
	MAJOR_VER=A; \
	rm -f $(DESTDIR)$(libdir)/libpcap.$$VER.dylib; \
	rm -f $(DESTDIR)$(libdir)/libpcap.$$MAJOR_VER.dylib; \
	rm -f $(DESTDIR)$(libdir)/libpcap.dylib
uninstall-shared-sl:
	MAJOR_VER=`sed 's/\([0-9][0-9]*\)\..*/\1/' $(srcdir)/VERSION`; \
	rm -f $(DESTDIR)$(libdir)/libpcap.$$MAJOR_VER; \
	rm -f $(DESTDIR)$(libdir)/libpcap.sl
uninstall-shared-shareda:
	rm -f $(DESTDIR)$(libdir)/libpcap.a
uninstall-shared-none:

uninstall-rpcapd:
	(cd rpcapd; $(MAKE) DESTDIR=$(DESTDIR) uninstall)

clean:
	rm -f $(CLEANFILES)
	(cd rpcapd; $(MAKE) clean)
	(cd testprogs; $(MAKE) clean)

distclean: clean
	rm -f Makefile grammar.y config.cache config.log config.status \
	    config.h config.h.in~ configure~ configure.ac~ \
	    net os-proto.h libpcap.pc pcap-config stamp-h stamp-h.in
	rm -f $(MAN3PCAP_EXPAND:.in=) $(MANFILE:.in=) $(MANMISC:.in=)
	rm -rf autom4te.cache
	(cd rpcapd; $(MAKE) distclean)
	(cd testprogs; $(MAKE) distclean)

extags: $(TAGFILES)
	ctags $(TAGFILES)

tags: $(TAGFILES)
	ctags -wtd $(TAGFILES)

releasetar:
	@TAG=$(PROG)-`cat VERSION` && \
	if git show-ref --tags --quiet --verify -- "refs/tags/$$TAG"; then \
	    git archive --prefix="$$TAG"/ -o "$$TAG".tar.gz "$$TAG" \
	    $(RELEASE_FILES) && \
	    echo "Archive build from tag $$TAG."; \
	else \
	    git archive --prefix="$$TAG"/ -o "$$TAG".tar.gz HEAD \
	    $(RELEASE_FILES) && \
	    echo "No $$TAG tag. Archive build from HEAD."; \
	fi

depend:	$(GENERATED_C_SRC) $(GENHDR)
	$(MKDEP) -c "$(CC)" -m "$(DEPENDENCY_CFLAG)" -s "$(srcdir)" $(CFLAGS) $(DEFS) $(INCLS) $(SRC)
	(cd rpcapd; $(MAKE) depend)
	(cd testprogs; $(MAKE) depend)

shellcheck:
	shellcheck -f gcc -e SC2006 build.sh build_matrix.sh build_common.sh
