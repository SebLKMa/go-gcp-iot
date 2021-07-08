#!/bin/sh
PROJECT=savvy-girder-314608 
REGION=asia-east1
REGISTRY=seb-registry
DEVICE=seb-device

./gcpmqttpub-arm \
--device=${DEVICE} \
--project=${PROJECT} \
--registry=${REGISTRY} \
--region=${REGION} \
--ca_certs=./roots.pem \
--private_key=./${DEVICE}.key.pem
#--private_key=${WORK_DIR}/certs/${DEVICE}.key.pem