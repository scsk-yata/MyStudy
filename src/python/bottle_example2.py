#!/usr/bin/python
#-*- coding: utf-8 -*-

from bottle import route
from bottle import request
from bottle import run
from bottle import template

@route('/hello')
def index(user=''):
    username = request.query.get('user')
    return template('<h1>Hello {{ user }}</h1>', user=username)

run(host='0.0.0.0', port=8080)
