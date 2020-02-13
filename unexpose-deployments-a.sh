#!/bin/bash
skupper unexpose deployment productcatalogservice --address productcatalogservice
skupper unexpose deployment recommendationservice --address recommendationservice
