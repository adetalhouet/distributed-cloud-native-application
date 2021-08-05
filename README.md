# Multi-cluster Cloud-Native grpc (microservices) application demo

This tutorial demonstrates how to deploy the [Online Boutique](https://github.com/GoogleCloudPlatform/microservices-demo/) microservices demo application across multiple Kubernetes clusters that are located in different public and private cloud providers. This project contains a 10-tier microservices application developed by Google to demonstrate the use of technologies like Kubernetes.

In this tutorial, you will create a Virtual Application Network that enables communications across the public and private clusters. You will then deploy a subset of the application's grpc based microservices to each cluster. You will then access the `Online Boutique` web interface to browse items, add them to the cart and purchase them.

Top complete this tutorial, do the following:

* [Prerequisites](#prerequisites)
* [Step 1: Set up the demo](#step-1-set-up-the-demo)
* [Step 2: Deploy the Virtual Application Network](#step-2-deploy-the-virtual-application-network)
* [Step 3: Deploy the application microservices](#step-3-deploy-the-application-microservices)
* [Step 4: Expose the microservices to the Virtual Application Network](#step-4-expose-the-microservices-to-the-virtual-application-network)
* [Step 5: Access the Online Boutique Application](#step-5-access-the-boutique-shop-application)
* [Cleaning up](#cleaning-up)
* [Next steps](#next-steps)

## Prerequisites

* The `kubectl` command-line tool, version 1.15 or later ([installation guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/))
* The `skupper` command-line tool, the latest version ([installation guide](https://skupper.io/start/index.html#step-1-install-the-skupper-command-line-tool-in-your-environment))

The basis for this demonstration is to depict the deployment of member microservices for an application across both private and public clusters and for the ability of these microsservices to communicate across a Virtual Application Network. As an example, the cluster deployment might be comprised of:

* A private cloud cluster running on your local machine
* Two public cloud clusters running in public cloud providers

While the detailed steps are not included here, this demonstration can alternatively be performed with three separate namespaces on a single cluster.

## Step 1: Set up the demo

1. On your local machine, make a directory for this tutorial and clone the example repo:

   ```bash
   mkdir boutique-demo
   cd boutique-demo
   git clone https://github.com/skupperproject/skupper-example-grpc.git
   ```

3. Prepare the target clusters.

   1. On your local machine, log in to each cluster in a separate terminal session.
   2. In each cluster, create a namespace to use for the demo.
   3. In each cluster, set the kubectl config context to use the demo namespace [(see kubectl cheat sheet for more information)](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
   ```bash
   kubectl config set-context --current --namespace <namespace>
   ```

## Step 2: Deploy the Virtual Application Network

On each cluster, using the `skupper` tool, define the Virtual Application Network and the connectivity for the peer clusters.

1. In the terminal for the first public cluster, deploy the **public1** application router. Create a connection token for connections from the **public2** cluster and the **private1** cluster:

   ```bash
   skupper init --site-name public1
   skupper token create public1-token.yaml --uses 2
   ```
2. In the terminal for the second public cluster, deploy the **public2** application router, create a connection token for connections from the **private1** cluser and connect to the **public1** cluster:

   ```bash
   skupper init --site-name public2
   skupper token create public2-token.yaml
   skupper link create public1-token.yaml
   ```

3. In the terminal for the private cluster, deploy the **private1** application router and define its connections to the **public1** and **public2** cluster

   ```bash
   skupper init --site-name private1
   skupper link create public1-token.yaml
   skupper link create public2-token.yaml
   ```

4. In each of the cluster terminals, verify connectivity has been established

   ```bash
   skupper link status
   ```

## Step 3: Deploy the application microservices

After creating the Virtual Application Network, deploy the grpc based microservices for the `Online Boutique` application. There are three `deployment .yaml` files
labelled *a, b, and c*. These files (arbitrarily) define a subset of the application microservices to deploy to a cluster.

| Deployment           | Microservices
| -------------------- | ---------------------------------------- |
| deployment-ms-a.yaml | frontend, productcatalog, recommendation |
| deployment-ms-b.yaml | ad, cart, checkout, currency, redis-cart |
| deployment-ms-c.yaml | email, payment, shipping                 |


1. In the terminal for the **private1** cluster, deploy the following:

   ```bash
   kubectl apply -f skupper-example-grpc/deployment-ms-a.yaml
   ```

2. In the terminal for the **public1** cluster, deploy the following:

   ```bash
   kubectl apply -f skupper-example-grpc/deployment-ms-b.yaml
   ```

3. In the terminal for the **public2** cluster, deploy the following:

   ```bash
   kubectl apply -f skupper-example-grpc/deployment-ms-c.yaml
   ```

## Step 4: Expose the microservices to the Virtual Application Network

There are three script files labelled *-a, -b, and -c*. These files expose the services created above to join the Virtual Application Network. Note that the frontend service is not assigned to the Virtual Application Network as it is setup for external web access.


| File                    | Deployments
| ----------------------- | ---------------------------------------- |
| expose-deployments-a.sh | productcatalog, recommendation           |
| expose-deployments-b.sh | ad, cart, checkout, currency, redis-cart |
| expose-deployments-c.sh | email, payment, shipping                 |


1. In the terminal for the **private1** cluster, execute the following annotation script:

   ```bash
   skupper-example-grpc/expose-deployments-a.sh
   ```

2. In the terminal for the **public1** cluster, execute the following annotation script:

   ```bash
   skupper-example-grpc/expose-deployments-b.sh
   ```

3. In the terminal for the **public2** cluster, execute the following annotation script:

   ```bash
   skupper-example-grpc/expose-deployments-c.sh
   ```

## Step 5: Access The Boutique Shop Application

The web frontend for the `Online Boutique` application can be accessed via the *frontend-external* service. In the
terminal for the **private1** cluster, start a firefox browser and access the shop UI.

   ```bash
   /usr/bin/firefox --new-window  "http://$(kubectl get service frontend-external -o=jsonpath='{.spec.clusterIP}')/"
   ```

Open a browser and use the url provided above to access the `Online Boutique`.

## Cleaning Up

Restore your cluster environment by returning the resources created in the demonstration. On each cluster, delete the demo resources and the skupper network:

1. In the terminal for the **private1** cluster, delete the resources:

   ```bash
   skupper-example-grpc/unexpose-deployments-a.sh
   kubectl delete -f ~/boutique-demo/skupper-example-grpc/deployment-ms-a.yaml
   skupper delete
   ```

2. In the terminal for the **public1** cluster, delete the resources:

   ```bash
   skupper-example-grpc/unexpose-deployments-b.sh
   kubectl delete -f ~/boutique-demo/skupper-example-grpc/deployment-ms-b.yaml
   skupper delete
   ```

3. In the terminal for the **public2** cluster, delete the resources:

   ```bash
   skupper-example-grpc/unexpose-deployments-c.sh
   kubectl delete -f ~/boutique-demo/skupper-example-grpc/deployment-ms-c.yaml
   skupper delete
   ```

## Next Steps

 - [Try the example for multi-cluster distributed web services](https://github.com/skupperproject/skupper-example-bookinfo)
 - [Find more examples](https://skupper.io/examples/)
