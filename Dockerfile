FROM centos:7.4.1708
MAINTAINER zhuwenshen <1204621904@qq.com>

#设置编码
ENV LANG en_US.UTF-8
#设置时区
#RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
#	&&  echo "Asia/Shanghai" > /etc/timezone; 

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
#docker run -d --name openvpn --privileged=true -e TZ="Asia/Shanghai" -p 21194:21194 openvpn:1.0
#进入容器
#docker exec -it openvpn /bin/bash
#执行初始化脚本
#sh /etc/openvpn/createFirewall.sh
#生成服务端证书
#sh /etc/openvpn/createServer.sh
#生成客户端证书
#sh /etc/openvpn/createClient.sh zhuwenshen


#push
#docker tag ebd3aa19fb92 registry.cn-hangzhou.aliyuncs.com/zhuwenshen/openvpn:1.0
#docker push registry.cn-hangzhou.aliyuncs.com/zhuwenshen/openvpn:1.0
