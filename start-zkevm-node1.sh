#!/bin/bash

# # 准备相关文件
# sudo rm -rf geth-node/gethData/geth_date1
# sudo cp -r geth-node/gethData/geth_date/* geth-node/gethData/geth_date1/

# 开启单个L1节点
sudo docker compose -f  geth-node/docker-compose.geth.yml up -d geth1

# TODO 读取本机IP并设置给其他服务

# # 构建zkNode
# cd zkevm-node
# sudo docker build -t zkevm-node -f ./Dockerfile .
# cd ..

# 开启单个L2，依次启动服务
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

# 开启第二个L2
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
