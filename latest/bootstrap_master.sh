#!/bin/bash

echo "[TASK 1] Pull required containers"
kubeadm config images pull >/dev/null 2>&1

echo "[TASK 2] Initialize Kubernetes Cluster"
#kubeadm init --apiserver-advertise-address=172.16.16.100 --pod-network-cidr=192.168.0.0/16 >> /root/kubeinit.log 2>/dev/null
kubeadm init --apiserver-advertise-address=192.168.56.10 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

echo "[TASK 3] Deploy Calico network"
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.16/manifests/calico.yaml >/dev/null 2>&1

echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh 2>/dev/null

# FIXME - the command below return error and the script stops.
# echo "[TASK 5] Remove taint from control-plane node"
# kubectl taint nodes --all node-role.kubernetes.io/master-
