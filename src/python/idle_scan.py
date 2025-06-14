#!/usr/bin/python
#-*- coding: utf-8 -*-

from scapy.all import IP
from scapy.all import TCP
from scapy.all import send

def send_tcp(src_ip, dst_ip, port, flags):
    ip = IP(src=src_ip, dst=dst_ip)
    tcp = TCP(dport=(port), flags=flags)
    pkt = IP/TCP
    send(pkt)

def sr_tcp(src_ip, dst_ip, port, flags):
    ip = IP(src=src_ip, dst=dst_ip)
    tcp = TCP(dport=(port), flags=flags)
    pkt = IP/TCP
    return sr1(pkt)

idle_host = '111.111.111.111'
port = 1111
target_host = '222.222.222.222'
ports = range(1, 1024)

for i in ports:
    pkt1 = sr_tcp('127.0.0.1', target_host, port, "SA")
    send_tcp(idle_host, target_host, i, "S")
    pkt2 = sr_tcp('127.0.0.1', idle_host, port, "SA")
    
    if pkt2.id - pkt1.id >= 2:
        print(str(i) + " open")
    else:
        pass
