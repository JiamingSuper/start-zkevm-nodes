#!/bin/python

import os 
import subprocess 
import sys
import time

# git clone准备好的部署仓库及初始化geth data
init_chain_commands_A = [
    "sshpass -p '220718-ai' ssh hzhx@192.168.10.21 'cd /home/hzhx/Desktop/polygonzkevm/test && export HTTPS_PROXY='http://192.168.10.2:7890' &&  export HTTP_PROXY='http://192.168.10.2:7890' && export ALL_PROXY=socks5://192.168.10.2:7890 && echo '220718-ai' | sudo -S rm -rf ./start-zkevm-nodes && git clone https://github.com/JiamingSuper/start-zkevm-nodes.git && cd start-zkevm-nodes && echo '220718-ai' | sudo -S ./start-zkevm-node.sh'"
]
init_chain_commands_B = [
    "sshpass -p 'guangdian523' ssh aengine@192.168.10.35 'cd /home/aengine/Desktop/polygonzkevm/test && export HTTPS_PROXY='http://192.168.10.2:7890' &&  export HTTP_PROXY='http://192.168.10.2:7890' && export ALL_PROXY=socks5://192.168.10.2:7890 && echo 'guangdian523' | sudo -S rm -rf ./start-zkevm-nodes && git clone https://github.com/JiamingSuper/start-zkevm-nodes.git && cd start-zkevm-nodes && echo 'guangdian523' | sudo -S ./start-zkevm-node.sh'"
]

# 进入A机器，开启L1节点和L2节点各一个
start_l1Node1_l2Node1_commands = [
    "sshpass -p '220718-ai' ssh hzhx@192.168.10.21 'cd /home/hzhx/Desktop/polygonzkevm/test/start-zkevm-nodes && export HTTPS_PROXY='http://192.168.10.2:7890' &&  export HTTP_PROXY='http://192.168.10.2:7890' && export ALL_PROXY=socks5://192.168.10.2:7890 && chmod +x start-geth1.sh && echo '220718-ai' | sudo -S sudo ./start-geth1.sh && chmod +x start-zkevm1.sh && echo '220718-ai' | sudo -S sudo ./start-zkevm1.sh'"
]

# 进入B机器，开启不可信的L2节点一个，start-zkevm2.sh脚本可带一个参数(可信L2节点的IP地址，脚本会自动所需的配置文件)
start_l2Node2_commands = [
    "sshpass -p 'guangdian523' ssh aengine@192.168.10.35 'cd /home/aengine/Desktop/polygonzkevm/test/start-zkevm-nodes && export HTTPS_PROXY='http://192.168.10.2:7890' &&  export HTTP_PROXY='http://192.168.10.2:7890' && export ALL_PROXY=socks5://192.168.10.2:7890 && chmod +x start-zkevm2.sh && echo 'guangdian523' | sudo -S sudo ./start-zkevm2.sh 192.168.10.21'"
]

# 进入B机器，开启L1节点，start-geth2.sh脚本可带一个参数(L1节点的IP地址，脚本会更新geth启动时的enode)
start_l1Node2_commands = [
    "sshpass -p 'guangdian523' ssh aengine@192.168.10.35 'cd /home/aengine/Desktop/polygonzkevm/test/start-zkevm-nodes && export HTTPS_PROXY='http://192.168.10.2:7890' &&  export HTTP_PROXY='http://192.168.10.2:7890' && export ALL_PROXY=socks5://192.168.10.2:7890 && chmod +x start-geth2.sh && echo 'guangdian523' | sudo -S sudo ./start-geth2.sh 192.168.10.21'"
]

stop_A_Node_commands = [
    "sshpass -p '220718-ai' ssh hzhx@192.168.10.21 'cd /home/hzhx/Desktop/polygonzkevm/test/start-zkevm-nodes && chmod +x stop-node.sh && echo '220718-ai' | sudo -S sudo ./stop-node.sh'"
]

stop_B_Node_commands = [
    "sshpass -p 'guangdian523' ssh aengine@192.168.10.35 'cd /home/aengine/Desktop/polygonzkevm/test/start-zkevm-nodes && chmod +x stop-node.sh && echo 'guangdian523' | sudo -S sudo ./stop-node.sh'"
]

def init_chain():
    for command in init_chain_commands_A:
        subprocess.run(command, shell=True, check=True)
    for command in init_chain_commands_B:
        subprocess.run(command, shell=True, check=True)
    stop_node()
    print("设备A、B初始化完成")

# 一台机器 => A设备:L1节点，L2节点
def model_A():
    init_chain()
    for command in start_l1Node1_l2Node1_commands:
        subprocess.run(command, shell=True, check=True)
    print("一台机器 => 开启单个L1节点, 单个L2节点")

# 两台机器 => A设备:L1节点，A/B设备：L2节点
def model_B():
    init_chain()
    for command in start_l1Node1_l2Node1_commands:
        subprocess.run(command, shell=True, check=True)
    for command in start_l2Node2_commands:
        subprocess.run(command, shell=True, check=True)
    print("两台机器 => 开启单个L1节点, 各一个L2节点")

# 两台机器 => A/B设备:L1节点，L2节点
def model_C():
    init_chain()
    for command in start_l1Node1_l2Node1_commands:
        subprocess.run(command, shell=True, check=True)
    for command in start_l2Node2_commands:
        subprocess.run(command, shell=True, check=True)
    for command in start_l1Node2_commands:
        subprocess.run(command, shell=True, check=True)
    print("两台机器 => 各一个L1节点和一个L2节点")

# 关闭机器上开启的L1，L2节点
def stop_node():
    for command in stop_A_Node_commands:
        subprocess.run(command, shell=True, check=True)
    for command in stop_B_Node_commands:
        subprocess.run(command, shell=True, check=True)
    print("关闭正在运行的全部节点")



if __name__=='__main__':
    if sys.argv[1] == 'init_chain':
        init_chain()
    elif sys.argv[1] == 'model_A':
        model_A()
    elif sys.argv[1] == 'model_B':
        model_B()
    elif sys.argv[1] == 'model_C':
        model_C()
    else:
        print("Command error")