#!/bin/bash
set -e

echo "Exporting yaml files..."
kubectl get ns | gawk 'NR>1 {print $1}' | while read ns

do
    mkdir k8s_resources/${ns}
    kubectl api-resources | gawk 'NR==1 {a=index($0,"APIGROUP")} NR>1 && $1 !="events" {if(substr($0,48,1)==" ") {api="None"} else {temp=substr($0,48); temp1=index(temp," ");api=substr(temp,1,temp1)};print $1 "\t" api }'| while read resource api
    do

        mkdir  k8s_resources/${ns}/${resource} || true
        mkdir  k8s_resources/${ns}/${resource}/${api}
        kubectl get ${resource} -n ${ns} | gawk 'NR>1 {print $1}'  | while read resource_name
        do
            kubectl get ${resource} ${resource_name} -n ${ns} -o yaml > k8s_resources/${ns}/${resource}/${api}/${resource_name}.yaml

        done

    done

done