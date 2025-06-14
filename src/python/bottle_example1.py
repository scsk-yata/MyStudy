#!/usr/bin/python
#-*- coding: utf-8 -*-

from bottle import route
from bottle import run

@route('/hello')
def index():
    return '<h1>Hello</h1>'

run(host='0.0.0.0', port=8080)
