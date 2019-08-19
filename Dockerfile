FROM centos:7.2.1511
MAINTAINER zhuwenshen <1204621904@qq.com>

#允许数据转发
#RUN sed -i '$a net.ipv4.ip_forward = 1' /etc/sysctl.conf

RUN yum -y install epel-release 
RUN yum -y install openvpn easy-rsa firewalld firewall-config 

COPY server.conf /etc/openvpn/server.conf

COPY createFirewall.sh /etc/openvpn/createFirewall.sh
RUN chmod 0700 /etc/openvpn/createFirewall.sh

COPY createServer.sh /etc/openvpn/createServer.sh
RUN chmod 0700 /etc/openvpn/createServer.sh

COPY createClient.sh /etc/openvpn/createClient.sh
RUN chmod 0700 /etc/openvpn/createClient.sh

#RUN sh /etc/openvpn/createFirewall.sh

#CMD ["systemctl start openvpn@server"]
CMD /usr/sbin/init

#bulid
#docker build -t openvpn:1.0 .
#启动命令
#docker run -d --name openvpn --privileged=true -p 8080:8080 -p 21194:1194 -v /dockerdata/chrome/app:/app selnium:chrome2.73
#docker run -d --name openvpn --net=host --privileged=true  -p 21194:1194 openvpn:1.0 /usr/sbin/init
#进入容器
#docker exec -it openvpn /bin/bash
#执行初始化脚本
#sh /etc/openvpn/createFirewall.sh
#生成服务端证书
#sh /etc/openvpn/createServer.sh
#生成客户端证书
#sh /etc/openvpn/createClient.sh zhuwenshen


#push
#docker tag 3b0405928776 registry.cn-hangzhou.aliyuncs.com/zhuwenshen/openvpn:1.0
#docker push registry.cn-hangzhou.aliyuncs.com/zhuwenshen/openvpn:1.0
