# Multi-cluster Cloud-Native grpc (microservices) application demo

This tutorial demonstrates how to deploy the [Online Boutique](https://github.com/GoogleCloudPlatform/microservices-demo/) microservices demo application across multiple Kubernetes clusters that are located in different public and private cloud providers. This project contains a 10-tier microservices application developed by Google to demonstrate the use of technologies like Kubernetes.

In this tutorial, you will create a Virtual Application Network that enables communications across the public and private clusters. You will then deploy a subset of the application's grpc based microservices to each cluster. You will then access the `Online Boutique` web interface to browse items, add them to the cart and purchase them.

Top complete this tutorial, do the following:

```
oc apply -f managed-cluster-set.yaml
oc apply -f skupper/appset-skupper.yaml
oc apply -f online-boutique/appset-online-boutique.yaml
```