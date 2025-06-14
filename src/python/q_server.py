#!/usr/bin/python
#-*- coding: utf-8 -*-

from bottle import template
from bottle import request
from bottle import route
from bottle import run
import sandbox
import socket

@route('/')
def index():
    return template('index', output='')

@route('/exec', method='POST')
def execute():
    ip = request.forms.get('ip')
    if len(ip) > 40:
        return template('index', output='IP address is too long.')

    cmd_type = int(request.params['cmdtype'])

    output_text = ''
    if cmd_type == 0:
        try:
            for x in ip.split('.'):
                output_text += bin(int(x))[2:] + '.'
            output_text = output_text[:-1]
        except Exception:
            output_text = 'Invalid ip address'
    if cmd_type == 1:
        try:
            output_text = socket.gethostbyname(ip)
        except socket.gaierror as e:
            output_text = e.args[1]
    elif cmd_type == 2:
        cmd = 'traceroute ' + ip
        print('cmd: ' + cmd)
        output_text = sandbox.run(cmd)
        print('output_text: ' + output_text)

    return template('index', output=output_text)

run(host='0.0.0.0', port=80, debug=True)
