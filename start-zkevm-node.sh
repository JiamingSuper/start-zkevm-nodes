#!/bin/bash

# 准备L1节点1所需的 geth data
sudo rm -rf geth-node/gethData/geth_data1
sudo rm -rf geth-node/gethData/geth_data2
mkdir geth-node/gethData/geth_data1/
cp -r geth-node/gethData/geth_data/* geth-node/gethData/geth_data1/

# 准备L1节点2所需的 geth data
chmod +x geth
./geth init --datadir geth-node/gethData/geth_data2 geth-node/genesis.json
cp -r geth-node/gethData/geth_data/keystore/* geth-node/gethData/geth_data2/keystore/
cp geth-node/gethData/geth_data/node1Password.txt geth-node/gethData/geth_data2/node1Password.txt

# 构建zkNode
cd zkevm-node
sudo docker build -t zkevm-node -f ./Dockerfile .
cd ..

# 获取节点信息，并提取 IP 地址（L1部署在管理节点）
MANAGER_IP=$(sudo docker info | grep -w "Node Address" | awk '{print $3}')
echo "Swarm管理节点IP地址为: $MANAGER_IP"

# 替换文件中的内容
sed -i "s/enode:\/\/[a-f0-9]*@[^:]*:/enode:\/\/1f44b33387802039704acfa424e716a821a7f22b3c057c5c17d63fee3d6b6c0001af4a839e2e049ec13524f0ffc45e6d6ba4864a816d6fd24e83cc188901aac8@$MANAGER_IP:/" geth-node/docker-compose.geth2.yml
sed -i "s#URL = \"http://[^:]*:8545\"#URL = \"http://$MANAGER_IP:8545\"#" zkevm-node/test/config/test.node.config.toml
sed -i "s#URL = \"http://[^:]*:8545\"#URL = \"http://$MANAGER_IP:8545\"#" zkevm-node/test/config/test.node2.config.toml