#!/bin/bash
kubectl annotate service productcatalogservice skupper.io/proxy=http2
kubectl annotate service recommendationservice skupper.io/proxy=http2
