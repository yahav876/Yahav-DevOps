#!/bin/bash

# Get all namespaces
namespaces=$(kubectl get ns -o jsonpath="{.items[*].metadata.name}")

echo "Checking PodDisruptionBudgets for deployments in each namespace..."

# Iterate over each namespace
for namespace in $namespaces; do
    # Get all deployments in the current namespace
    deployments=$(kubectl get deployments -n $namespace -o jsonpath="{.items[*].metadata.name}")

    # Iterate over each deployment in the current namespace
    for deployment in $deployments; do
        # Get the replica count of the deployment
        replicaCount=$(kubectl get deployment $deployment -n $namespace --output=jsonpath={.spec.replicas})

        # Check if the deployment has a PodDisruptionBudget
        if kubectl get poddisruptionbudget -n $namespace | grep -q $deployment; then
            # Get the maxUnavailable value from the PodDisruptionBudget
            maxUnavailable=$(kubectl get poddisruptionbudget $deployment -n $namespace --output=jsonpath={.spec.maxUnavailable})

            # Check if the replica count is 1 and maxUnavailable is also 1
            if [[ $replicaCount -eq 1 ]] && [[ "$maxUnavailable" == "1" ]]; then
                echo "Deployment $deployment in namespace $namespace has 1 replica and a PDB with maxUnavailable=1"
            fi
        fi
    done
done

