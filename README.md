# Ceph Helm

### Quckstart

Assuming you have a Kubeadm managed Kubernetes 1.5 cluster and Helm 2.1 setup[1], you can get going straight away! [2]

From the root of this repo run:

```
helm serve &
helm repo add marina http://127.0.0.1:8879/charts

./build-all.sh

helm repo update

#Generate secrets and config for ceph deployment
#                <ns> <storagecidr> <public cidr>
#helm ceph secret ceph 10.192.0.0/10 10.192.0.0/10 # Default CIDR Range for Romana CNI Plugin
helm ceph secret ceph 192.168.0.0/16 192.168.0.0/16 # Default CIDR Range for Calico CNI Plugin

#Label the nodes that will take part in the Ceph cluster
# 'all' labels all nodes in the cluster bar the k8s controller node(s)
helm ceph labelnode all

#Deploy ceph to the namespace setup above
helm install marina/ceph --namespace ceph

#Setup client credentials for a namespace
helm ceph activate default

```


### Functional testing

Once Ceph deployment has been performed you can functionally test the environment by running the jobs in the tests directory, these will soon be incorporated into a Helm plugin, but for now you can run:

```
kubectl create -R -f tests/ceph
```


#### Notes
[1] This configuration is known to work with nodes that have 8GB of RAM and 4 Cores, your mileage may vary with lower specification clusters.

[2] The cake is a lie, you actually need to have the nodes setup to access the cluster network, and `/etc/resolv.conf` setup similar to the following:
```
search svc.cluster.local cluster.local
nameserver 10.96.0.10 # K8s DNS IP
nameserver 192.168.121.1 # External DNS IP
options ndots:5
# These options enable hostname resolution to work when the kube-dns service
# is unavailable without an absolutely atrocious performance impact.
options timeout:1
options attempts:1
```
