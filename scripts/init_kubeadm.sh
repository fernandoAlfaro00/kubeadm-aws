# apiserver-advertise-address=ips de nodo master

kubeadm init --pod-network-cidr=172.17.0.1/16 --apiserver-advertise-address=10.0.0.37 --cri-socket=unix:///var/run/cri-dockerd.sock --ignore-preflight-errors=NumCPU,Mem