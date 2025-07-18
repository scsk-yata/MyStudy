#  Copyright (c) 1988, 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997
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
# Pathname of directory to install the binary
bindir = ${exec_prefix}/bin
# Pathname of directory to install the man page
mandir = ${datarootdir}/man

# VPATH
srcdir = .
top_srcdir = .


#
# You shouldn't need to edit anything below here.
#

CC = aarch64-linux-gnu-gcc
AR = aarch64-linux-gnu-ar
MKDEP = 
PROG = tcpdump
CCOPT = 
INCLS = -I. -I../libpcap-1.10.4 
DEFS = -DHAVE_CONFIG_H -I/home/yata/tcpdump-build/tcpdump-4.99.4 

# Standard CFLAGS
CFLAGS = -g -O2
FULL_CFLAGS = $(CCOPT) $(DEFS) $(INCLS) $(CFLAGS)

# Standard LDFLAGS
LDFLAGS = -L/home/yata/tcpdump-build/tcpdump-4.99.4

# Standard LIBS
LIBS = ../libpcap-1.10.4/libpcap.a   

INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA = ${INSTALL} -m 644
RANLIB = aarch64-linux-gnu-ranlib

DEPENDENCY_CFLAG = 

# Explicitly define compilation rule since SunOS 4's make doesn't like gcc.
# Also, gcc does not remove the .o before forking 'as', which can be a
# problem if you don't own the file but can write to the directory.
.c.o:
	@rm -f $@
	$(CC) $(FULL_CFLAGS) -c $(srcdir)/$*.c

CSRC =	fptype.c tcpdump.c

LIBNETDISSECT_SRC=\
	addrtoname.c \
	addrtostr.c \
	af.c \
	ascii_strcasecmp.c \
	checksum.c \
	cpack.c \
	gmpls.c \
	in_cksum.c \
	ipproto.c \
	l2vpn.c \
	machdep.c \
	netdissect.c \
	netdissect-alloc.c \
	nlpid.c \
	ntp.c \
	oui.c \
	parsenfsfh.c \
	print.c \
	print-802_11.c \
	print-802_15_4.c \
	print-ah.c \
	print-ahcp.c \
	print-aodv.c \
	print-aoe.c \
	print-ap1394.c \
	print-arcnet.c \
	print-arista.c \
	print-arp.c \
	print-ascii.c \
	print-atalk.c \
	print-atm.c \
	print-babel.c \
	print-bcm-li.c \
	print-beep.c \
	print-bfd.c \
	print-bgp.c \
	print-bootp.c \
	print-brcmtag.c \
	print-bt.c \
	print-calm-fast.c \
	print-carp.c \
	print-cdp.c \
	print-cfm.c \
	print-chdlc.c \
	print-cip.c \
	print-cnfp.c \
	print-dccp.c \
	print-decnet.c \
	print-dhcp6.c \
	print-domain.c \
	print-dsa.c \
	print-dtp.c \
	print-dvmrp.c \
	print-eap.c \
	print-egp.c \
	print-eigrp.c \
	print-enc.c \
	print-esp.c \
	print-ether.c \
	print-fddi.c \
	print-forces.c \
	print-fr.c \
	print-frag6.c \
	print-ftp.c \
	print-geneve.c \
	print-geonet.c \
	print-gre.c \
	print-hncp.c \
	print-hsrp.c \
	print-http.c \
	print-icmp.c \
	print-icmp6.c \
	print-igmp.c \
	print-igrp.c \
	print-ip-demux.c \
	print-ip.c \
	print-ip6.c \
	print-ip6opts.c \
	print-ipcomp.c \
	print-ipfc.c \
	print-ipnet.c \
	print-ipoib.c \
	print-ipx.c \
	print-isakmp.c \
	print-isoclns.c \
	print-juniper.c \
	print-krb.c \
	print-l2tp.c \
	print-lane.c \
	print-ldp.c \
	print-lisp.c \
	print-llc.c \
	print-lldp.c \
	print-lmp.c \
	print-loopback.c \
	print-lspping.c \
	print-lwapp.c \
	print-lwres.c \
	print-m3ua.c \
	print-macsec.c \
	print-mobile.c \
	print-mobility.c \
	print-mpcp.c \
	print-mpls.c \
	print-mptcp.c \
	print-msdp.c \
	print-msnlb.c \
	print-nflog.c \
	print-nfs.c \
	print-nsh.c \
	print-ntp.c \
	print-null.c \
	print-olsr.c \
	print-openflow-1.0.c \
	print-openflow-1.3.c \
	print-openflow.c \
	print-ospf.c \
	print-ospf6.c \
	print-otv.c \
	print-pflog.c \
	print-pgm.c \
	print-pim.c \
	print-pktap.c \
	print-ppi.c \
	print-ppp.c \
	print-pppoe.c \
	print-pptp.c \
	print-ptp.c \
	print-radius.c \
	print-raw.c \
	print-realtek.c \
	print-resp.c \
	print-rip.c \
	print-ripng.c \
	print-rpki-rtr.c \
	print-rsvp.c \
	print-rt6.c \
	print-rtsp.c \
	print-rx.c \
	print-sctp.c \
	print-sflow.c \
	print-sip.c \
	print-sl.c \
	print-sll.c \
	print-slow.c \
	print-smtp.c \
	print-snmp.c \
	print-someip.c \
	print-ssh.c \
	print-stp.c \
	print-sunatm.c \
	print-sunrpc.c \
	print-symantec.c \
	print-syslog.c \
	print-tcp.c \
	print-telnet.c \
	print-tftp.c \
	print-timed.c \
	print-tipc.c \
	print-token.c \
	print-udld.c \
	print-udp.c \
	print-unsupported.c \
	print-usb.c \
	print-vjc.c \
	print-vqp.c \
	print-vrrp.c \
	print-vsock.c \
	print-vtp.c \
	print-vxlan-gpe.c \
	print-vxlan.c \
	print-wb.c \
	print-whois.c \
	print-zep.c \
	print-zephyr.c \
	print-zeromq.c \
	signature.c \
	strtoaddr.c \
	util-print.c

LOCALSRC = 
LIBOBJS = 

LIBNETDISSECT_OBJ=$(LIBNETDISSECT_SRC:.c=.o) ${LOCALSRC:.c=.o} ${LIBOBJS}
LIBNETDISSECT=libnetdissect.a


SRC =	$(CSRC) $(LOCALSRC)

# We would like to say "OBJ = $(SRC:.c=.o)" but Ultrix's make cannot
# hack the extra indirection
OBJ =	$(CSRC:.c=.o)
HDR = \
	addrtoname.h \
	addrtostr.h \
	af.h \
	ah.h \
	appletalk.h \
	ascii_strcasecmp.h \
	atm.h \
	chdlc.h \
	compiler-tests.h \
	cpack.h \
	diag-control.h \
	ethertype.h \
	extract.h \
	fptype.h \
	ftmacros.h \
	funcattrs.h \
	getservent.h \
	gmpls.h \
	interface.h \
	ip.h \
	ip6.h \
	ipproto.h \
	l2vpn.h \
	llc.h \
	machdep.h \
	mib.h \
	mpls.h \
	nameser.h \
	netdissect.h \
	netdissect-alloc.h \
	netdissect-ctype.h \
	netdissect-stdinc.h \
	nfs.h \
	nfsfh.h \
	nlpid.h \
	ntp.h \
	openflow.h \
	ospf.h \
	oui.h \
	pcap-missing.h \
	pflog.h \
	ppp.h \
	print.h \
	rpc_auth.h \
	rpc_msg.h \
	signature.h \
	slcompress.h \
	smb.h \
	status-exit-codes.h \
	strtoaddr.h \
	tcp.h \
	timeval-operations.h \
	udp.h \
	varattrs.h

TAGHDR = \
	/usr/include/netinet/if_ether.h \
	/usr/include/netinet/in.h

TAGFILES = $(SRC) $(HDR) $(TAGHDR) $(LIBNETDISSECT_SRC) \
	print-smb.c smbutil.c

CLEANFILES = $(PROG) $(OBJ) $(LIBNETDISSECT_OBJ) print-smb.o smbutil.o

EXTRA_DIST = \
	CHANGES \
	CMakeLists.txt \
	CONTRIBUTING.md \
	CREDITS \
	INSTALL.md \
	LICENSE \
	Makefile-devel-adds \
	Makefile.in \
	README.md \
	VERSION \
	aclocal.m4 \
	atime.awk \
	bpf_dump.c \
	cmake/Modules/FindCRYPTO.cmake \
	cmake/Modules/FindPCAP.cmake \
	cmake/Modules/FindSMI.cmake \
	cmake_uninstall.cmake.in \
	cmakeconfig.h.in \
	config.guess \
	config.h.in \
	config.sub \
	configure \
	configure.ac \
	doc/README.aix.md \
	doc/README.NetBSD.md \
	doc/README.solaris.md \
	doc/README.Win32.md \
	install-sh \
	lbl/os-osf4.h \
	lbl/os-solaris2.h \
	lbl/os-sunos4.h \
	lbl/os-ultrix4.h \
	makemib \
	missing/datalinks.c \
	missing/dlnames.c \
	missing/getopt_long.c \
	missing/getopt_long.h \
	missing/getservent.c \
	missing/pcap_dump_ftell.c \
	missing/snprintf.c \
	missing/strdup.c \
	missing/strlcat.c \
	missing/strlcpy.c \
	missing/strsep.c \
	mkdep \
	packetdat.awk \
	print-smb.c \
	send-ack.awk \
	smbutil.c \
	stime.awk \
	tcpdump.1.in

TEST_DIST= `git ls-files tests | grep -v 'tests/\..*'`

RELEASE_FILES = $(CSRC) $(HDR) $(LIBNETDISSECT_SRC) $(EXTRA_DIST) $(TEST_DIST)

all: $(PROG)

$(PROG): $(OBJ) ../libpcap-1.10.4/libpcap.a $(LIBNETDISSECT)
	@rm -f $@
	$(CC) $(FULL_CFLAGS) $(LDFLAGS) -o $@ $(OBJ) $(LIBNETDISSECT) $(LIBS)

$(LIBNETDISSECT): $(LIBNETDISSECT_OBJ)
	@rm -f $@
	$(AR) cr $@ $(LIBNETDISSECT_OBJ)
	$(RANLIB) $@

datalinks.o: $(srcdir)/missing/datalinks.c
	$(CC) $(FULL_CFLAGS) -o $@ -c $(srcdir)/missing/datalinks.c
dlnames.o: $(srcdir)/missing/dlnames.c
	$(CC) $(FULL_CFLAGS) -o $@ -c $(srcdir)/missing/dlnames.c
getservent.o: $(srcdir)/missing/getservent.c
	$(CC) $(FULL_CFLAGS) -o $@ -c $(srcdir)/missing/getservent.c
getopt_long.o: $(srcdir)/missing/getopt_long.c
	$(CC) $(FULL_CFLAGS) -o $@ -c $(srcdir)/missing/getopt_long.c
snprintf.o: $(srcdir)/missing/snprintf.c
	$(CC) $(FULL_CFLAGS) -o $@ -c $(srcdir)/missing/snprintf.c
strdup.o: $(srcdir)/missing/strdup.c
	$(CC) $(FULL_CFLAGS) -o $@ -c $(srcdir)/missing/strdup.c
strlcat.o: $(srcdir)/missing/strlcat.c
	$(CC) $(FULL_CFLAGS) -o $@ -c $(srcdir)/missing/strlcat.c
strlcpy.o: $(srcdir)/missing/strlcpy.c
	$(CC) $(FULL_CFLAGS) -o $@ -c $(srcdir)/missing/strlcpy.c
strsep.o: $(srcdir)/missing/strsep.c
	$(CC) $(FULL_CFLAGS) -o $@ -c $(srcdir)/missing/strsep.c
pcap_dump_ftell.o: $(srcdir)/missing/pcap_dump_ftell.c
	$(CC) $(FULL_CFLAGS) -o $@ -c $(srcdir)/missing/pcap_dump_ftell.c

install: all
	[ -d $(DESTDIR)$(bindir) ] || \
	    (mkdir -p $(DESTDIR)$(bindir); chmod 755 $(DESTDIR)$(bindir))
	$(INSTALL_PROGRAM) $(PROG) $(DESTDIR)$(bindir)/$(PROG)
	$(INSTALL_PROGRAM) $(PROG) $(DESTDIR)$(bindir)/$(PROG).`cat ${srcdir}/VERSION`
	[ -d $(DESTDIR)$(mandir)/man1 ] || \
	    (mkdir -p $(DESTDIR)$(mandir)/man1; chmod 755 $(DESTDIR)$(mandir)/man1)
	$(INSTALL_DATA) $(PROG).1 $(DESTDIR)$(mandir)/man1/$(PROG).1

uninstall:
	rm -f $(DESTDIR)$(bindir)/$(PROG)
	rm -f $(DESTDIR)$(bindir)/$(PROG).`cat ${srcdir}/VERSION`
	rm -f $(DESTDIR)$(mandir)/man1/$(PROG).1

lint:
	lint -hbxn $(SRC) $(LIBNETDISSECT_SRC) | \
	    grep -v 'struct/union .* never defined' | \
	    grep -v 'possible pointer alignment problem'

clean:
	rm -f $(CLEANFILES) $(PROG)-`cat ${srcdir}/VERSION`.tar.gz

distclean:
	rm -f $(CLEANFILES) Makefile config.cache config.log config.status \
	    config.h os-proto.h stamp-h stamp-h.in $(PROG).1 \
	    libnetdissect.a tests/.failed tests/.passed \
	    tests/failure-outputs.txt
	rm -rf autom4te.cache tests/DIFF tests/NEW

check: tcpdump
	$(srcdir)/tests/TESTrun

extags: $(TAGFILES)
	ctags $(TAGFILES)

tags: $(TAGFILES)
	ctags -wtd $(TAGFILES)

TAGS: $(TAGFILES)
	etags $(TAGFILES)

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

releasecheck: releasetar
	@TAG=$(PROG)-`cat VERSION` && \
	INSTALL_DIR=/tmp/install_"$$TAG"_$$$$ && \
	DIR=`pwd` && \
	cd /tmp && \
	rm -rf "$$TAG" && \
	rm -rf "$$INSTALL_DIR" && \
	tar xf "$$DIR"/"$$TAG".tar.gz && \
	cd "$$TAG" && \
	echo "[$@] $$ ./configure --enable-smb --quiet --prefix=$$INSTALL_DIR" && \
	./configure --enable-smb --quiet --prefix="$$INSTALL_DIR" && \
	echo '[$@] $$ make -s all check' && \
	make -s all check >/dev/null && \
	echo '[$@] $$ make -s install' && \
	make -s install && \
	cd .. && \
	rm -rf "$$TAG" && \
	rm -rf "$$INSTALL_DIR" && \
	tar xf "$$DIR"/"$$TAG".tar.gz && \
	cd "$$TAG" && \
	mkdir build && \
	cd build && \
	echo '[$@] $$ cmake -DENABLE_SMB=yes [...] ..' && \
	cmake -DENABLE_SMB=yes \
	    -DCMAKE_INSTALL_PREFIX="$$INSTALL_DIR" \
	    -DCMAKE_MESSAGE_LOG_LEVEL=NOTICE \
	    -DCMAKE_RULE_MESSAGES=OFF \
	    -DCMAKE_INSTALL_MESSAGE=NEVER \
	    .. && \
	echo '[$@] $$ make -s all check' && \
	make -s all check >/dev/null && \
	echo '[$@] $$ make -s install' && \
	make -s install && \
	cd ../.. && \
	rm -rf "$$TAG" && \
	rm -rf "$$INSTALL_DIR" && \
	echo '[$@] Done.'

whitespacecheck:
	@# trailing space(s)?
	@if git grep -I -n ' $$' $$(git ls-files|grep -v '^tests/'); then \
	    echo 'Error: Trailing space(s).'; \
	    exit 1; \
	fi
	@# trailing tab(s)?
	@# install-sh has a tab at the end of one line
	@if git grep -I -n '	$$' $$(git ls-files|grep -vE '^(tests/|install-sh$$)'); then \
	    echo 'Error: Trailing tabs(s).'; \
	    exit 1; \
	fi
	@# space(s) before tab(s)?
	@if git grep -I -n '[ ][	]' $$(git ls-files|grep -v '^tests/'); then \
	    echo 'Error: space(s) before tab(s).'; \
	    exit 1; \
	fi

testlist:
	echo $(TEST_DIST)

depend:
	$(MKDEP) -c "$(CC)" -m "$(DEPENDENCY_CFLAG)" -s "$(srcdir)" $(DEFS) $(INCLS) $(SRC) $(LIBNETDISSECT_SRC)

shellcheck:
	shellcheck -f gcc -e SC2006 build.sh build_matrix.sh build_common.sh
