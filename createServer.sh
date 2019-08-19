#!/bin/sh
set -e

#清空旧数据
rm -rf /etc/openvpn/easy-rsa \
	&& cp -r /usr/share/easy-rsa/ /etc/openvpn/easy-rsa \
	&& cd /etc/openvpn/easy-rsa/ \
	&& \rm 3 3.0 \
	&& mv 3.0.3 3 
#	&& cd 3/ \
#	&& find / -type f -name "vars.example" | xargs -i cp {} . && mv vars.example vars

#生成服务器证书
cd /etc/openvpn/easy-rsa/3
./easyrsa init-pki
echo |./easyrsa build-ca nopass #要输入回车
echo |./easyrsa gen-req server nopass #要输入回车
echo 'yes'|./easyrsa sign server server #要输入yes
./easyrsa gen-dh

exec "$@"
