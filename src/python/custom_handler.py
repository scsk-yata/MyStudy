#!/usr/bin/python
#-*- coding: utf-8 -*-

from http.server import HTTPServer
from http.server import SimpleHTTPRequestHandler

class CustomHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        html = open('index.html').read()
        html = bytes(html, encoding='utf-8')
        
        self.wfile.write(html)

ip = '127.0.0.1'
port = 8000

handler = CustomHandler
server = HTTPServer((ip, port), handler)

server.serve_forever()
