#!/usr/bin/python
#-*- coding: utf-8 -*-

from bottle import route
from bottle import run
from bottle import request
from bottle import response

@route('/')
def hello(user=''):
    username = request.query.get('user')
    username = '' if username is None else username
    
    html = "<h2> Hello </h2>"
    script = "<script>"
    script += "document.write(unescape('URL: ' + document.baseURI));"
    script += "</script>"
    
    response.set_header('X-XSS-Protection', '1; mode=block')
    response.set_header('Content-Security-Policy', "default-src 'self'")
    
    return html + script

run(host='0.0.0.0', port=8080, debug=True)
