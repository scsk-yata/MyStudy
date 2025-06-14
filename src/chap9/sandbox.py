#!/usr/bin/python
#-*- coding: utf-8 -*-

import ctypes
import struct
import os, sys

SYS_openat = 257

# /usr/include/linux/ptrace.h
PTRACE_TRACEME  = 0
PTRACE_PEEKDATA = 2
PTRACE_POKEDATA = 5
PTRACE_GETREGS  = 12
PTRACE_SYSCALL  = 24

class user_regs_struct(ctypes.Structure):
    _fields_ = [
            ('r15', ctypes.c_ulonglong),
            ('r14', ctypes.c_ulonglong),
            ('r13', ctypes.c_ulonglong),
            ('r12', ctypes.c_ulonglong),
            ('rbp', ctypes.c_ulonglong),
            ('rbx', ctypes.c_ulonglong),
            ('r11', ctypes.c_ulonglong),
            ('r10', ctypes.c_ulonglong),
            ('r9', ctypes.c_ulonglong),
            ('r8', ctypes.c_ulonglong),
            ('rax', ctypes.c_ulonglong),
            ('rcx', ctypes.c_ulonglong),
            ('rdx', ctypes.c_ulonglong),
            ('rsi', ctypes.c_ulonglong),
            ('rdi', ctypes.c_ulonglong),
            ('orig_rax', ctypes.c_ulonglong),
            ('rip', ctypes.c_ulonglong),
            ('cs', ctypes.c_ulonglong),
            ('eflags', ctypes.c_ulonglong),
            ('rsp', ctypes.c_ulonglong),
            ('ss', ctypes.c_ulonglong),
            ('fs_base', ctypes.c_ulonglong),
            ('gs_base', ctypes.c_ulonglong),
            ('ds', ctypes.c_ulonglong),
            ('es', ctypes.c_ulonglong),
            ('fs', ctypes.c_ulonglong),
            ('gs', ctypes.c_ulonglong),
            ]

libc = ctypes.CDLL(None)
ptrace = libc.ptrace

def run(cmds):
    commands = [cmds]
    for x in [';', '&', '|']:
        if len(cmds.split(x)) > 1:
            commands = cmds.split(x)

    ret = ''
    for cmd in commands:
        ret += trace(cmd).decode()

    return ret

def trace(cmd):
    print('cmd (in sandbox): ' + cmd)
    log_file = '/tmp/result.txt'
    fd = os.open(log_file, os.O_RDWR|os.O_CREAT)
    os.dup2(fd, 1)
    os.dup2(fd, 2)
    data = b''

    child = os.fork()
    if child == 0:
        ptrace(PTRACE_TRACEME, 0, 0, 0)
        os.execl('/bin/bash', 'bash', '-c', cmd)
    else:
        while 1:
            try:
                pid, status = os.wait()
            except ChildProcessError:
                data = b"Failed to traceroute"
                break
            if status != 0:
                regs = user_regs_struct()
                ptrace(PTRACE_GETREGS, pid, 0, ctypes.pointer(regs))

                if regs.orig_rax == SYS_openat:
                    hook(regs, pid)

                ptrace(PTRACE_SYSCALL, pid, 0, 0)
            else:
                break
                #os._exit(0)

    os.close(fd)
    with open(log_file, 'rb') as f:
        data = f.read()

    os.remove(log_file)

    if type(data) == str:
        data = bytes(data)
    return data


def hook(regs, pid):
    path = b''
    i = 0
    word = b''
    while not b'\x00' in word:
        addr = ctypes.c_ulonglong(regs.rsi + i)
        word = ptrace(PTRACE_PEEKDATA, pid, addr, 0)
        word = struct.pack('<l', word)
        path += word
        i += 4
    path = path[:path.find(b'\x00')].decode()

    if os.path.basename(path) == 'flag.txt':
        addr = ctypes.c_ulonglong(regs.rsi)
        data = struct.unpack('<l', b'.du\x00')[0]
        ptrace(PTRACE_POKEDATA, pid, addr, data)
