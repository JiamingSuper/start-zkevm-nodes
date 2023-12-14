#!/bin/bash

# 检查参数
if [ $# -eq 0 ]; then
  echo "使用本机8545端口作为L1节点地址"
else
  echo "使用$1:8545端口作为enode地址"
  sed -i "s#URL = \"http://[^:]*:8545\"#URL = \"http://$1:8545\"#" zkevm-node/test/config/test.node.config.toml
fi

# 启动单个L2-node1节点（可信定序器），依次启动服务
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-state-db
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-pool-db
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-event-db
sleep 5
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-prover
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-approve
sleep 10
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-sync
sleep 10
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-eth-tx-manager
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-sequencer
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-sequence-sender
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-l2gaspricer
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-aggregator
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-json-rpc

# 获取节点信息，并提取 IP 地址
MANAGER_IP=$(sudo docker info | grep -w "Node Address" | awk '{print $3}')
echo "L2-node1 RPC地址: $MANAGER_IP:8123"