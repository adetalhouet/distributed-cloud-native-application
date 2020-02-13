#!/bin/bash
kubectl annotate service emailservice skupper.io/proxy-
skupper unexpose deployment paymentservice --address paymentservice
skupper unexpose deployment shippingservice --address shippingservice
