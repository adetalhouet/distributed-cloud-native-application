# Multi-cluster Cloud-Native microservices application demo

This tutorial demonstrates how to deploy the [Hipster Shop](https://github.com/GoogleCloudPlatform/microservices-demo/) microservices demo application across multiple Kubernetes clusters that are located in different public and private cloud providers. This project contains a 10-tier microservices application developed by Google to demonstrate the use of technologies like Kubernetes.

In this tutorial, you will create a Virtual Application Network that enables communications across the public and private clusters. You will then deploy a subset of the application's microservices to each cluster. You will then access the `Hipster Shop` web interface to browse items, add them to the cart and purchase them.

Top complete this tutorial, do the following:

* [Prerequisites](#prerequisites)
* [Step 1: Set up the demo](#step-1-set-up-the-demo)
* [Step 2: Deploy the Virtual Application Network](#step-2-deploy-the-virtual-application-network)
* [Step 3: Deploy the application microservices](#step-3-deploy-the-application-microservices)
* [Step 4: Annotate the microservices to access the Virtual Application Network](#step-4-annotate-the-microservices-to-access-the-virtual-application-network)
* [Step 5: Access the Hipster Shop Application](#step-5-access-the-hipster-shop-application)
* [Cleaning up](#cleaning-up)
* [Next steps](#next-steps)

## Prerequisites

* The `kubectl` command-line tool, version 1.15 or later ([installation guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/))
* The `skupper` command-line tool, the latest version ([installation guide](https://skupper.io/start/index.html#step-1-install-the-skupper-command-line-tool-in-your-environment))

The basis for this demonstration is to depict the deployment of member microservices for an application across both private and public clusters and for the ability of these microsservices to communicate across a Virtual Application Network. As an example, the cluster deployment might be comprised of:

* A "private cloud" cluster running on your local machine
* Two public cloud clusters running in public cloud providers

While the detailed steps are not included here, this demonstration can alternatively be performed with three separate namespaces on a single cluster.

## Step 1: Set up the demo

1. On your local machine, make a directory for this tutorial and clone the example repo:

   ```bash
   mkdir hipster-demo
   cd hipster-demo
   git clone git@github.com:skupperproject/skupper-example-microservices.git
   ```

3. Prepare the target clusters.

   1. On your local machine, log in to each cluster in a separate terminal session.
   2. In each cluster, create a namespace to use for the demo.
   3. In each cluster, set the kubectl config context to use the demo namespace [(see kubectl cheat sheet)](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

## Step 2: Deploy the Virtual Application Network

On each cluster, using the `skupper` tool, define the Virtual Application Network and the connectivity for the peer clusters.

1. In the terminal for the first public cluster, deploy the **public1** application router. Create two connection tokens for connections from the **public2** cluster and the **private1** cluster:

   ```bash
   skupper init --id public1
   skupper connection-token private1-to-public1-token.yaml
   skupper connection-token public2-to-public1-token.yaml
   ```
2. In the terminal for the second public cluster, deploy the **public2** application router, and connect to the **public1** cluster:

   ```bash
   skupper init --id public2
   skupper connection-token private1-to-public2-token.yaml
   skupper connect public2-to-public1-token.yaml
   ```

3. In the terminal for the private cluster, deploy the **private1** application router and define its connections to the **public1** cluster

   ```bash
   skupper init --edge --id private1
   skupper connect private1-to-public1-token.yaml
   skupper connect private1-to-public2-token.yaml
   ```

## Step 3: Deploy the application microservices

After creating the Virtual Application Nework, deploy the microservices for the `Hipster Shop` application. There are three `deploymen .yaml` files
labelled *a, b, and c*. These files (arbitrarily) define a subset of the application microservices to deploy to a cluster.

| Deployment            | Microservices
| ----------------------|------------------------------------------|
| deployment-ms-a.yaml  | frontend, productcatalog, recommendation |
| ----------------------|------------------------------------------|
| deployment-ms-b.yaml  | ad, cart, checkout, currency, redis-cart |
| ----------------------|------------------------------------------|
| deployment-ms-c.yaml  | email, payment, shipping                 |
| ----------------------|------------------------------------------|

1. In the terminal for the **private1** cluster, deploy the following:

   ```bash
   kubectl apply -f ~/hipster-demo/skupper-example-microservices/deployment-ms-a.yaml
   ```

2. In the terminal for the **public1** cluster, deploy the following:

   ```bash
   kubectl apply -f ~/hipster-demo/skupper-example-microservices/deployment-ms-b.yaml
   ```

3. In the terminal for the **public2** cluster, deploy the following:

   ```bash
   kubectl apply -f ~/hipster-demo/skupper-example-microservices/deployment-ms-c.yaml
   ```

## Step 4: Annotate the microservices to access the Virtual Application Network

There are three script files labelled *a, b, and c*. These files annotate the services created above to join them to the Virtual Application Network. Note that the frontend service is not assigned to the Virtual Application Network as it is setup for external web access.


| File                   | Service Annotations
| -----------------------|------------------------------------------|
| annotate-services-a.sh | productcatalog, recommendation           |
| -----------------------|------------------------------------------|
| annotate-services-b.sh | ad, cart, checkout, currency, redis-cart |
| -----------------------|------------------------------------------|
| annotate-services-c.sh | email, payment, shipping                 |
| -----------------------|------------------------------------------|

1. In the terminal for the **private1** cluster, execute the following annotation script:

   ```bash
   ~/hipster-demo/skupper-example-microservices/annotate-services-a.sh
   ```

2. In the terminal for the **public1** cluster, execute the following annotation script:

   ```bash
   ~/hipster-demo/skupper-example-microservices/annotate-services-b.sh
   ```

3. In the terminal for the **public2** cluster, execute the following annotation script:

   ```bash
   ~/hipster-demo/skupper-example-microservices/annotate-services-c.yaml
   ```

## Step 5:

The web frontend for the `Hipster Shop` application can be accessed via the *frontend-external* service. In the
terminal for the **private1** cluster, determine the address to access this service.

   ```bash
   echo $(kubectl get svc frontend-external -o=jsonpath='http://{.spec.externalIPs[0]}:{.spec.ports[0].port}')
   ```

Open a browser and use the url provided above to access the `Hipster Shop`.

## Cleaning Up

Restore your cluster environment by returning the resources created in the demonstration. On each cluster, delete the demo resources and the skupper network:

1. In the terminal for the **private1** cluster, delete the resources:

   ```bash
   kubectl delete -f ~/hipster-demo/skupper-example-microservices/deployment-ms-a.yaml
   skupper delete
   ```

2. In the terminal for the **public1** cluster, delete the resources:

   ```bash
   kubectl delete -f ~/hipster-demo/skupper-example-microservices/deployment-ms-b.yaml
   skupper delete
   ```

3. In the terminal for the **public1** cluster, delete the resources:

   ```bash
   kubectl delete -f ~/hipster-demo/skupper-example-microservices/deployment-ms-b.yaml
   skupper delete
   ```

## Next Steps

 - [Try the example for multi-cluster distributed web services](https://github.com/skupperproject/skupper-example-bookinfo)
 - [Find more examples](https://skupper.io/examples/)
