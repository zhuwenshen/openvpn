#!/bin/sh

set -e

cd /etc/openvpn/easy-rsa/3/

#./easyrsa gen-req client nopass      #客户证书名，无密码
#cd /etc/openvpn/easy-rsa/3/
#./easyrsa import-req /etc/openvpn/client/easy-rsa/3.0.3/pki/reqs/client.req client
#./easyrsa sign client client
#./easyrsa build-client-full $1 nopass

#./easyrsa build-client-full zhuwenshen nopass

#cd /etc/openvpn/easy-rsa/3.0.3/ 
#./easyrsa gen-req zhuwenshen nopass #输入回车
#./easyrsa sign client zhuwenshen #yes
#mkdir /etc/openvpn/client/zhuwenshen
#cd /etc/openvpn/client/zhuwenshen
#cp /etc/openvpn/easy-rsa/3/pki/ca.crt .
#cp /etc/openvpn/easy-rsa/3/pki/issued/zhuwenshen.crt .
#cp /etc/openvpn/easy-rsa/3/pki/private/zhuwenshen.key .


echo |./easyrsa gen-req $1 nopass
echo 'yes'|./easyrsa sign client $1 
#./easyrsa gen-req $1 nopass #输入回车
#./easyrsa sign client $1 < echo 'yes' #yes
rm -rf /etc/openvpn/client/$1
mkdir -p /etc/openvpn/client/$1
cd /etc/openvpn/client/$1
cp /etc/openvpn/easy-rsa/3/pki/ca.crt .
cp /etc/openvpn/easy-rsa/3/pki/issued/$1.crt .
cp /etc/openvpn/easy-rsa/3/pki/private/$1.key .

echo "生成客户端完成，文档路径为：/etc/openvpn/client/$1"
exec "$@"
