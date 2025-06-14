#!/usr/bin/python
#-*- coding: utf-8 -*-

from scapy.ansmachine import AnsweringMachine
from scapy.all import conf
import sys

conf.iface = sys.argv[1]

class WlanSniffer(AnsweringMachine):
    function_name = 'WLAN Sniffer'
    filter = ""

    def is_request(self, req):
        print(req.summary())
        return False

    def make_reply(self, req):
        return req

if __name__=='__main__':
    WlanSniffer()()
