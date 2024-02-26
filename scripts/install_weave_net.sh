kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml



kubectl edit daemonset weave-net -n kube-system

##agregar la parte de ipalloc_range
#  spec:
#       containers:
#       - command:
#         - /home/weave/launch.sh
#         env:
#         - name: IPALLOC_RANGE
#           value: 192.16.0.0/16
#         - name: INIT_CONTAINER
#           value: "true"
#         - name: HOSTNAME
#           valueFrom:
#             fieldRef:
#               apiVersion: v1
#               fieldPath: spec.nodeName
#         image: weaveworks/weave-kube:latest
#         imagePullPolicy: Always
#         name: weave 