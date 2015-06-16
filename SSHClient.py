#!/usr/bin/env python
# coding=utf-8
import paramiko
hostname = '188.188.22.225'
port = 22
username = 'root'
password = 'mychebao'

if __name__ == "__main__":
    paramiko.util.log_to_file('paramiko.log')
    s = paramiko.SSHClient()
    s.load_system_host_keys()
    s.connect ( hostname, port, username, password )
    stdin,stdout,stderr = s.exec_command('free -m ')
    print stdout.read()
    s.close()
