#!/bin/bash
skupper expose deployment checkoutservice --address checkoutservice --port 5050 --protocol http2 --target-port 5050
skupper expose deployment cartservice --address cartservice --port 7070 --protocol http2 --target-port 7070
skupper expose deployment currencyservice --address currencyservice --port 7000 --protocol http2 --target-port 7000
skupper expose deployment adservice --address adservice --port 9555 --protocol http2 --target-port 9555
skupper expose deployment redis-cart --address redis-cart --port 6379 --protocol tcp --target-port 6379

