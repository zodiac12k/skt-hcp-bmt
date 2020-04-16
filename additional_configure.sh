#!/bin/bash

ANCHORE_CLI_POD=$(kubectl get pod -n ns-repository -lrun=anchore-cli --no-headers=true -o=custom-columns=NAME:.metadata.name)
# Add anchore registry
kubectl exec -it ${ANCHORE_CLI_POD} -n ns-repository -- anchore-cli registry add default-route-openshift-image-registry.apps.skthcp.skcloud.io serviceaccount $(kubectl get secret -n kabanero kabanero-operator-dockercfg-2mgm6 -o=jsonpath="{.data.\.dockercfg}" | base64 --decode | jq -r '."image-registry.openshift-image-registry.svc.cluster.local:5000".password') --insecure

# Add anchore policy
kubectl cp anchore_skt_hcp_bmt.json ${ANCHORE_CLI_POD}:/home/anchore/anchore_skt_hcp_bmt.json
kubectl exec -it ${ANCHORE_CLI_POD} -n ns-repository -- anchore-cli policy add /home/anchore/anchore_skt_hcp_bmt.json

# Create jenkins home docker pvc
kubectl apply -f zcp-jenkins-docker-petshop-pvc.yaml
