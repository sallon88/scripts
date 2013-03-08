#!/bin/bash
# run as root!
# 添加至外网的路由表, 首先删除错误路由表

if [ `whoami` != "root" ]; then
	echo 'only root allowed'
	exit 1
fi

bad=$(route -n | grep '192.0.0.0')
if [ "$bad" ]
then
	route del -net 192.0.0.0/7
fi

# 添加虚拟机至外网的转发
#echo 1 > /proc/sys/net/ipv4/ip_forward

#获取当前网关所在端口
out=$(route -n | grep UG | awk '{print $8}')

iptables -t nat -F
iptables -t nat -A POSTROUTING -o $out -s 192.168.56.0/24 -j MASQUERADE

#iptables -t nat -A PREROUTING -s 192.168.50.110 -p tcp -d 192.168.50.19 --dport 80 -j DNAT --to 192.168.56.101:80

#所有来自192.168.50.11的请求全部转发给192.168.56.101
#iptables -t nat -A PREROUTING -s 192.168.50.11 -d 192.168.50.19 -j DNAT --to 192.168.56.101
#iptables -t nat -A PREROUTING  -d 192.168.90.19 -j DNAT --to 192.168.56.101
