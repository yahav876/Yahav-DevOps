#!/bin/bash

# Get all namespaces
namespaces=$(kubectl get ns -o jsonpath="{.items[*].metadata.name}")

echo "Checking deployments with 1 replica and strategy maxUnavailable: 1..."

# Iterate over each namespace
for namespace in $namespaces; do
    # Get all deployments in the current namespace
    deployments=$(kubectl get deployments -n $namespace -o jsonpath="{.items[*].metadata.name}")

    # Iterate over each deployment in the current namespace
    for deployment in $deployments; do
        # Get the replica count of the deployment
        replicaCount=$(kubectl get deployment $deployment -n $namespace --output=jsonpath={.spec.replicas})

        # Get the maxUnavailable value from the deployment strategy
        maxUnavailable=$(kubectl get deployment $deployment -n $namespace --output=jsonpath={.spec.strategy.rollingUpdate.maxUnavailable})

        # Check if the replica count is 1 and maxUnavailable is 1
        if [[ "$replicaCount" == "1" ]] && [[ "$maxUnavailable" == "1" ]]; then
            echo "Deployment $deployment in namespace $namespace has 1 replica and strategy maxUnavailable=1"
        fi
    done
done

