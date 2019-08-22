# 1.运行前准备
### 创建容器保存目录
mkdir -p /home/dockerdata
### 运行测试容器
docker run -d  --rm --name openvpn --privileged=true zhuwenshen/openvpn:1.0
### 取得相关脚本
docker cp openvpn:/etc/openvpn /home/dockerdata/
docker stop openvpn

# 2.修改配置
### 1.确定访问端口 
映射端口 21194
### 2. 运行容器
docker run -d --name openvpn -e TZ="Asia/Shanghai"  --privileged=true -v /home/dockerdata/openvpn:/etc/openvpn -p 21194:21194 zhuwenshen/openvpn:1.0
### 3.修改防火墙脚本
防火墙配置脚本在/home/dockerdata/openvpn/createFirewall.sh

修改映射端口与要映射的端口一致\
firewall-cmd --add-port=21194/udp --permanent\
firewall-cmd --add-port=21194/tcp --permanent


修改需要访问的内网网段\
firewall-cmd --add-source=10.6.2.0 --permanent\
firewall-cmd --query-source=10.6.2.0 --permanent 

### 4.修改openvpn的配置文件
openvpn的配置文件是/home/dockerdata/openvpn/server.conf

修改端口

port 21194

修改允许访问的内网网段

push "route 10.6.2.0 255.255.255.0"

# 3.运行脚本
### 1.进入容器
docker exec -it openvpn /bin/bash
### 2.生成服务端证书
sh /etc/openvpn/createServer.sh
### 3.执行初始化防火墙脚本
sh /etc/openvpn/createFirewall.sh
### 4.生成客户端证书
sh /etc/openvpn/createClient.sh zhuwenshen #最后一个参数为生成客户端的用户名
### 5.退出容器
exit
### 6.重启容器
docker restart openvpn

# 4.客户端配置
生成的客户端配置的目录 /home/dockerdata/openvpn/client/zhuwenshen 

### 1.修改配置
参考 源码给出的例子配置zhuwenshen.ovpn

创建 【用户名.ovpn】的配置文件

修改 服务器端口和访问的域名或ip

remote my.com 21194

修改认证文件\
cert zhuwenshen.crt #对应的用户名.crt\
key zhuwenshen.key #对应的用户名.key


### 2.下载客户端（windows 10）
下载OpenVPN客户端  https://www.techspot.com/downloads/5182-openvpn.html
安装客户端

### 3.配置
把服务器生成的三个配置文件
ca.crt、zhuwenshen.crt、zhuwenshen.key
加上 新建的文件 zhuwenshen.ovpn\
一共四个文件 一起放到客户度的安装目录的config的目录下

### 4.启动客户端
启动客户端，在win10的环境下，一定要用管理员运行，否则连接不上vpn。

客户端启动后会自动连接vpn





