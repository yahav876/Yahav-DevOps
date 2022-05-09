#! /usr/bin/python3

import json
import time
import requests
import pymysql

CMDB_CONFIG = {
    "host":"ip",
    "user":"user",
    "password":"passs",
    "database":"dbanme",
    "port":3306,
    "autocommit":True
}

TYPE_CONFIG = {
    "host":"localhost",
    "user":"root",
    "password":"pass",
    "database":"dbname",
    "autocommit":True
}


type_suggested = []

db_cmdb = pymysql.connect(**CMDB_CONFIG)
db_type = pymysql.connect(**TYPE_CONFIG)
cursor = db_cmdb.cursor()
type_cursor = db_type.cursor()
cursor.execute('SELECT lan_ip, hostname, instance_type, vcpu, MEMORY, ops_id, owner_id FROM aws_server WHERE STATUS = 0 AND hostname != "";')
instance_info = cursor.fetchall()
i = 1
for info in instance_info:
    ip = info[0]
    hostname = info[1]
    instance_type = info[2]
    vcpu = info[3]
    mem = info[4]
    ops_id = info[5]
    owner_id = info[6]
    query_cpu = ("http://ip:4242/api/query?start=168h-ago&m=sum:cpu.idle{endpoint=%s_*}" %ip)
    query_mem = ("http://ip:4242/api/query?start=168h-ago&m=sum:mem.memfree.percent{endpoint=%s_*}" %ip)
    try:
        cpu_data = requests.get(query_cpu)
        mem_data = requests.get(query_mem)
    except:
        print("no monitor on ip: {}".format(ip))
    try:
        idle_cpu = min(cpu_data.json()[0]['dps'].values())
        idle_mem = min(mem_data.json()[0]['dps'].values())
    except:
        print("problem IP is: {}".format(ip))
        pass
    peak_cpu = 100 - idle_cpu
    peak_mem = 100 - idle_mem
    if peak_cpu < 30 and peak_mem < 30:
        need_reduce = 1
    else:
        need_reduce = 0
    suggested_cpu = vcpu * peak_cpu / 100 / 0.5
    suggested_mem = mem  * peak_mem / 100 / 0.5
    type_cursor.execute('SELECT * FROM instance_type_new WHERE vCPU >={} AND mem >= {} ORDER BY price'.format(suggested_cpu, suggested_mem))
    type_suggested = type_cursor.fetchmany(3)
    type_cursor.execute('INSERT INTO type_suggested_new (IP, hostname, type_curr, vCPU_curr, mem_curr, peak_cpu, peak_mem, need_reduce, type_suggested, ops_id, owner_id) VALUES ("{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}", "{}");'.format(ip, hostname, instance_type, vcpu, mem, peak_cpu, peak_mem, need_reduce, type_suggested, ops_id, owner_id))
    print("IP: {} info generated.".format(ip))
    print("{} IPs processed".format(i))
    i = i + 1
db_type.commit()
cursor.close()
type_cursor.close()
db_cmdb.close()
db_type.close()

# def gen_suggest():
#     db = pymysql.connect(**TYPE_CONFIG)
#     cursor = db.cursor()
#     cursor.execute('select * from instance_type order by price')
#     type_suggested.append(cursor.fetchmany(3))
#     print(type_suggested)
#     ttt = cursor.fetchmany(3)
#     print(ttt, type(ttt))
#     print(list(ttt))
#     one = cursor.fetchone()
#     print(one, type(one))


