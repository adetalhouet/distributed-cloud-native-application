#!/bin/bash
kubectl annotate service adservice skupper.io/proxy=http2
kubectl annotate service cartservice skupper.io/proxy=http2
kubectl annotate service checkoutservice skupper.io/proxy=http2
kubectl annotate service currencyservice skupper.io/proxy=http2
kubectl annotate service redis-cart skupper.io/proxy=tcp

