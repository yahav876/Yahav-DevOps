#!/bin/bash

# Set the namespace if needed, else it will use the default namespace
NAMESPACE="kube-system"

# Get the list of all pods and filter out those in Terminating state
terminating_pods=$(kubectl get pods -n "$NAMESPACE" | grep fluentd | grep Terminating | awk '{print $1}')

# Check if there are any terminating pods
if [ -z "$terminating_pods" ]; then
    echo "No terminating pods found in the $NAMESPACE namespace."
    exit 0
fi

# Loop over each terminating pod and delete it
for pod in $terminating_pods; do
    echo "Deleting pod $pod..."
    kubectl delete pod "$pod" -n "$NAMESPACE" --force --grace-period=0
done

echo "Terminating pods deletion process completed."

