#!/bin/bash
skupper expose deployment emailservice --address emailservice --port 5000 --protocol http2 --target-port 8080
skupper expose deployment paymentservice --address paymentservice --port 50051 --protocol http2 --target-port 50051
skupper expose deployment shippingservice --address shippingservice --port 50051 --protocol http2 --target-port 50051
