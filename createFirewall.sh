#!/bin/sh

echo "开始执行构建防火墙脚本"
set -e

#firewall-cmd --list-all
systemctl start firewalld.service
#firewall-cmd --state
#firewall-cmd --zone=public --list-all
firewall-cmd --add-service=openvpn --permanent
#firewall-cmd --add-port=1194/udp --permanent
#firewall-cmd --add-port=1194/tcp --permanent
firewall-cmd --add-port=21194/udp --permanent
firewall-cmd --add-port=21194/tcp --permanent #保存映射端口与docker的出端口一致
#firewall-cmd --add-port=22/tcp --permanent
firewall-cmd --add-source=10.6.2.0 --permanent
firewall-cmd --query-source=10.6.2.0 --permanent
firewall-cmd --add-masquerade --permanent
firewall-cmd --query-masquerade --permanent
firewall-cmd --reload
systemctl enable firewalld #开机启动
systemctl enable openvpn@server.service #开机启动

#允许数据转发
echo 'net.ipv4.ip_forward = 1' >>/etc/sysctl.conf
sysctl -p

echo "执行构建防火墙脚本完成"
exec "$@"
