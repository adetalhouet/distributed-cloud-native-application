When importing non-OCP clusters in RHACM, their server API URL isn't getting populated, see this [bugzilla](https://bugzilla.redhat.com/show_bug.cgi?id=2073493) for reference.
To workaround this issue, you need to apply the `infrastructures.config.openshift.io` CRD in the managed clusters, and then create their `Infrastructure` CR instance providing the server API URL. This is where the RHACM appmgr addon is getting the information.

Note: the CRD was taken from an OCP 4.9.23 cluster, and I'm using RHACM 2.4.2

In my environment I had to do the following

**ca-toronto**
```
kubectl apply -f infrastructures.config.openshift.io-crd.yaml
kubectl apply -f infrastructure-us-philly.yaml
```

**ca-toronto**
```
kubectl apply -f infrastructures.config.openshift.io-crd.yaml
kubectl apply -f infrastructure-ca-toronto.yaml
```