#!/usr/bin/python
#-*- coding: utf-8 -*-

from scapy.all import Ether
from scapy.all import ARP
from scapy.all import srp
import ipaddress

myip = '172.17.0.1'
netmask = '255.255.0.0'
hwaddr = 'ff:ff:ff:ff:ff:ff'

def gen_cidr(ip, netmask):
    ipv4 = ipaddress.ip_address(ip)
    netmask = ipaddress.ip_address(netmask)
    netaddr = ipaddress.ip_address(int(ipv4) & int(netmask))
    netaddr = str(netaddr).split('/')[0]
    
    cidr = bin(int(netmask)).count('1')
    return str(netaddr) + '/' + str(cidr)

cidr = gen_cidr(myip, netmask)

print('Scanning on : ' + cidr + '\n')

pkt = Ether(dst=hwaddr)/ARP(op=1, pdst=cidr)
ans, uans = srp(pkt, timeout=2)

print('')
for send, recv in ans:
    print(recv.sprintf('%ARP.psrc% is up.'))
