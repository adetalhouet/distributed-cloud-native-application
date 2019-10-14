#!/bin/bash
kubectl annotate service emailservice skupper.io/proxy=http2
kubectl annotate service paymentservice skupper.io/proxy=http2
kubectl annotate service shippingservice skupper.io/proxy=http2
