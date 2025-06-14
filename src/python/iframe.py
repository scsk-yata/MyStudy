#!/usr/bin/python
#-*- coding: utf-8 -*-

from bottle import route
from bottle import run

@route('/')
def hello():
    target_url = 'http://172.17.0.1:8000'
    html = '<h2>攻撃者のWebサイト</h2>'
    html += '<iframe src="'
    html += target_url
    html += '"></iframe>'
    return html

run(host='0.0.0.0', port=8080, debug=True)
