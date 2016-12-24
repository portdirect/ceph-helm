# Ceph Helm

### Quckstart

Assuming you have a Kubeadm managed Kubernetes 1.5 cluster and Helm 2.1 setup[1], you can get going straight away! [2]

From the root of this repo run:

```
helm serve &
helm repo add marina http://127.0.0.1:8879/charts

./build-all.sh

helm repo update

#Label the nodes that will take part in the Ceph cluster
kubectl get nodes -L kubeadm.alpha.kubernetes.io/role --no-headers | awk '$NF ~ /^<none>/ { print $1}' | while read NODE ; do
  kubectl label node $NODE --overwrite ceph-storage=enabled
done

#Deploy ceph to the namespace setup above
helm install marina/ceph --namespace ceph

```


### Functional testing

Once Ceph deployment has been performed you can functionally test the environment by running the jobs in the tests directory, these will soon be incorporated into a Helm plugin, but for now you can run:

```
kubectl create --namespace ceph -R -f tests/ceph
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
