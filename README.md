### Polygon zkEvm启动脚本

#### 目录结构

geth-node：L1节点相关准备文件，gethData/geth_data包含部署了zkEvm所需合约的区块链数据。每次初始化将会复制一份该文件，作为L1节点的初始数据。

zkevm-node：来自于官方的[zkevm-node仓库](https://github.com/0xPolygonHermez/zkevm-node)，使用了zkevm-node/test目录下准备好的部署方式作为基础进行多节点部署。

#### sh脚本

##### init-chains.sh

初始化L1节点所需数据。

##### start-geth1.sh

在本机启动单个L1节点  `本机IP:8545`

##### start-geth2.sh

在本机启动单个L1节点，可通过参数指定需要连接的L1节点IP，如：`start-geth2.sh 192.168.X.X`，将会把这个节点的enode指向指定的IP，若没有传递参数则enode将使用本机IP地址。

##### start-geth1.sh

在本机启动单个L2节点(可信定序器)，可通过参数指定需要连接的L1节点IP(端口为8545)，如：`start-geth1.sh 192.168.X.X`，将会把配置文件中指向的L1节点地址改为：`http://192.168.X.X:8545`，若没有传递参数则将使用本机IP地址。

##### start-geth2.sh

在本机启动单个L2节点(非可信定序器)，可通过参数指定需要连接的L1节点IP(端口为8545)，若没有传递参数则将使用本机IP地址。

##### stop-node.sh

关闭本机上运行的L2，L2节点。