#!/bin/bash
skupper expose deployment productcatalogservice --address productcatalogservice --port 3550 --protocol http2 --target-port 3550
skupper expose deployment recommendationservice --address recommendationservice --port 8080 --protocol http2 --target-port 8080
