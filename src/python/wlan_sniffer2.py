#!/usr/bin/python
#-*- coding: utf-8 -*-

from scapy.ansmachine import AnsweringMachine
from scapy.all import conf
import socket
import sys

conf.iface = sys.argv[1]

class WlanSniffer(AnsweringMachine):
    function_name = 'WLAN Sniffer'
    filter = "tcp dst port 443"

    def is_request(self, req):
        domain = ''
        try:
            domain = socket.gethostbyaddr(req['IP'].dst)[0]
        except socket.herror:
            domain = 'Unknown Host'

        summary = domain + ': ' + req.summary()
        print(summary)

        return False

    def make_reply(self, req):
        return req

if __name__=='__main__':
    WlanSniffer()()
