kubeadm join 10.0.0.37:6443 --token 6nyaco.jbsvxbtm8c1eehow \
	--discovery-token-ca-cert-hash sha256:a6688ab3fe219d2d4a1fc76946185a970aebf6f47d553a3cc97eaa0f15ee96da --cri-socket=unix:///var/run/cri-dockerd.sock



kubectl label node cb2.4xyz.couchbase.com node-role.kubernetes.io/worker=worker