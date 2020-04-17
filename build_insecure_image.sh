#!/bin/bash

sudo docker login -u serviceaccount -p $(kubectl get secret -n kabanero kabanero-operator-dockercfg-2mgm6 -o=jsonpath="{.data.\.dockercfg}" | base64 --decode | jq -r '."image-registry.openshift-image-registry.svc.cluster.local:5000".password') default-route-openshift-image-registry.apps.skthcp.skcloud.io
sudo docker build -t default-route-openshift-image-registry.apps.skthcp.skcloud.io/az-cicd-dev/petshop:insecure .
sudo docker push default-route-openshift-image-registry.apps.skthcp.skcloud.io/az-cicd-dev/petshop:insecure
sudo docker logout
