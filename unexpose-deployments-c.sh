#!/bin/bash
skupper unexpose deployment emailservice --address emailservice
skupper unexpose deployment paymentservice --address paymentservice
skupper unexpose deployment shippingservice --address shippingservice
