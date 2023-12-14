#!/bin/bash

# 检查参数
if [ $# -eq 0 ]; then
  echo "使用本机8545端口作为L1节点地址"
else
  echo "使用$1:8545端口作为enode地址"
  sed -i "s#URL = \"http://[^:]*:8545\"#URL = \"http://$1:8545\"#" zkevm-node/test/config/test.node2.config.toml
fi

# 启动单个L2-node2节点（非可信定序器），依次启动服务
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-state-db-node2
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-pool-db-node2
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-event-db-node2
sleep 5
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-prover-node2
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-approve-node2
sleep 10
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-sync-node2
sleep 10
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-eth-tx-manager-node2
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-sequencer-node2
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-sequence-sender-node2
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-l2gaspricer-node2
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-aggregator-node2
sudo docker compose -f  zkevm-node/test/docker-compose.zkevm.yml up -d zkevm-json-rpc-node2

# 获取节点信息，并提取 IP 地址
MANAGER_IP=$(sudo docker info | grep -w "Node Address" | awk '{print $3}')
echo "L2-node2 RPC地址: $MANAGER_IP:1114"