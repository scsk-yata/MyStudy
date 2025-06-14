#!/usr/bin/python
#-*- coding: utf-8 -*-

from bottle import route
from bottle import run
from bottle import request
from bottle import redirect
import sqlite3
import html

db_name = 'tasklist.db'
conn = sqlite3.connect(db_name)
cursor = conn.cursor()

@route('/')
def hello(user=''):
    tasks = get_tasklist()
    
    html = "<h2>Persistent XSS Demo</h2>"
    html += "<form action='./' method='POST'>"
    html += "タスク名: <input type='text' name='name' /><br>"
    html += "内容: <input type='text' name='detail' /><br>"
    html += "<input type='submit' name='register' value='登録'/>"
    html += "</form>"
    html += tasks
    
    return html

@route('/', method='POST')
def register():
    name = html.escape(request.forms.get('name'))
    detail = html.escape(request.forms.get('detail'))
    
    sql_query = 'INSERT INTO tasklist values(?, ?)'
    cursor.execute(sql_query, (name, detail))
    conn.commit()
    
    return redirect('/')

def get_tasklist():
    sql_query = 'SELECT * FROM tasklist'
    result = cursor.execute(sql_query)
    
    html = '<table border="1">'
    for row in result:
        html += '<tr><td>'
        html += str(row[0])
        html += '</td><td>'
        html += str(row[1])
        html += '</td></tr>'

    html += '</table>'
    return html

run(host='0.0.0.0', port=8080, debug=True)
