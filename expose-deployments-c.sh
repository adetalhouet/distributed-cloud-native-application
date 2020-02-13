#!/bin/bash
kubectl annotate service emailservice skupper.io/proxy=http2
skupper expose deployment paymentservice --address paymentservice --port 50051 --protocol http2 --target-port 50051
skupper expose deployment shippingservice --address shippingservice --port 50051 --protocol http2 --target-port 50051
