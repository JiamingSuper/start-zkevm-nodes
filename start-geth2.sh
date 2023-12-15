#!/bin/bash

# 检查参数
if [ $# -eq 0 ]; then
  echo "使用本机的30303端口作为enode地址"
else
  echo "使用$1:30303端口作为enode地址"
  sed -i "s/enode:\/\/[a-f0-9]*@[^:]*:/enode:\/\/1f44b33387802039704acfa424e716a821a7f22b3c057c5c17d63fee3d6b6c0001af4a839e2e049ec13524f0ffc45e6d6ba4864a816d6fd24e83cc188901aac8@$1:/" geth-node/docker-compose.geth.yml
fi

# 启动单个L1-node2节点
sudo docker compose -f  geth-node/docker-compose.geth.yml up -d geth2

# 获取节点信息，并提取 IP 地址
MANAGER_IP=$(sudo docker info | grep -w "Node Address" | awk '{print $3}')
echo "L1-node2 RPC地址: $MANAGER_IP:8145"