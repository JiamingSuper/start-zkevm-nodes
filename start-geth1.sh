#!/bin/bash

# 启动单个L1-node1节点（部署了zkevm合约）
sudo docker compose -f  geth-node/docker-compose.geth.yml up -d geth1

# 获取节点信息，并提取 IP 地址
MANAGER_IP=$(sudo docker info | grep -w "Node Address" | awk '{print $3}')
echo "L1-node1 RPC地址: $MANAGER_IP:8545"