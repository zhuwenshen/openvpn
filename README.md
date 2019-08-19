#具体请参考 https://github.com/zhuwenshen/openvpn（以下内容可能会过时）
mkdir -p /home/dockerdata
docker run -d  --rm --name openvpn --privileged=true registry.cn-hangzhou.aliyuncs.com/zhuwenshen/openvpn:1.0
docker cp openvpn:/etc/openvpn /home/dockerdata/
docker stop openvpn
docker run -d --name openvpn -e TZ="Asia/Shanghai" --privileged=true -v /home/dockerdata/openvpn:/etc/openvpn -p 21194:21194 registry.cn-hangzhou.aliyuncs.com/zhuwenshen/openvpn:1.0
#进入容器
docker exec -it openvpn /bin/bash
#生成服务端证书
sh /etc/openvpn/createServer.sh
#执行初始化防火墙脚本
sh /etc/openvpn/createFirewall.sh
#生成客户端证书
sh /etc/openvpn/createClient.sh zhuwenshen #最后一个参数为生成客户端的用户名
#退出容器
exit
#重启容器
docker restart openvpn
#端口查询
#netstat -nlp

