# 1.运行前准备
### 创建容器保存目录
mkdir -p /home/dockerdata
### 运行测试容器
docker run -d  --rm --name openvpn --privileged=true registry.cn-hangzhou.aliyuncs.com/zhuwenshen/openvpn:1.0
### 取得相关脚本
docker cp openvpn:/etc/openvpn /home/dockerdata/
docker stop openvpn

# 2.修改配置
### 1.确定访问端口 
映射端口 21194
### 2. 运行容器
docker run -d --name openvpn -e TZ="Asia/Shanghai"  --privileged=true \
-v /home/dockerdata/openvpn:/etc/openvpn \
-p 21194:21194 registry.cn-hangzhou.aliyuncs.com/zhuwenshen/openvpn:1.0
### 3.修改防火墙脚本
防火墙配置脚本在/home/dockerdata/openvpn/createFirewall.sh

修改映射端口与要映射的端口一致

firewall-cmd --add-port=21194/udp --permanent

firewall-cmd --add-port=21194/tcp --permanent


修改需要访问的内网网段

firewall-cmd --add-source=10.6.2.0 --permanent

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


