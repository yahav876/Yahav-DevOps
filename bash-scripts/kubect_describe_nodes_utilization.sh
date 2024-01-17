#!/bin/bash 

cmd='kubectl describe nodes'

echo "account-node-1875c64fb89e6c58
account-node-f92e5f7aa46c08a9
accountapigateway-49dfc345332da393
accountapigateway-86bb074c79e7c9eb
accountapigateway-91274f237223577f
accountnode-f9248c5ba9c53b4b
apigateway-5e0f188275df403a
apigateway-84aa71b77c6a5ec5
apigateway-9d2ea79a75378309
apigateway-b02d320a50fcb46d
apigateway-f9f7e409fe14a560
bigdata-nginx-12436d3baee861f3
bigdata-nginx-5c30457a217fc39d
cluster001
cluster002
cluster003
filesever-tenant-0f7debd079cb54be
filesever-tenant-cbe8a3ef363e859b
hiupgrade-apigateway-f92db2f5d5e286a6
hiupgradenginx-0fb5113e366297a2
hiupgradenginx-ae9150a44a8e6ffc
k8snode-04201aafc019f25b
k8snode-0d05a3ae44e14bd6
k8snode-0d8cf2bd0b6b096f
k8snode-1a41dd56c59664ad
k8snode-20fdfb3184f87a97
k8snode-22e9d1a74c3f75c6
k8snode-2532c7ac6379b348
k8snode-2c5984520bc25a41
k8snode-36a593ab3a2042bb
k8snode-4133059c6ca1ba63
k8snode-4599db3d63b66d0b
k8snode-691f7690dd34c699
k8snode-72cf326d841481be
k8snode-7c0339806a171ba6
k8snode-8b5069908927d43b
k8snode-8eaee46ad01e6183
k8snode-9996a256a810ff67
k8snode-b0413b45b16ff41c
k8snode-b7214e1b6ab6541b
k8snode-bb75f71a3825231e
k8snode-bc81c05cb6683831
k8snode-c4293a5cde782ea7
k8snode-c674007cbf5d7955
k8snode-e245178ce4b56c47
k8snode-f04a7b55e422039d
k8snode-f5221b6c757caed8
k8snode-f81fcad6773d195e
message-apigateway-1bc5312b4cdf06f8
message-apigateway-520b76ae7790eb4d
message-apigateway-b35ef8da4a4a1d0f
message-nginx-26b4edc4356741d2
message-nginx-33a7f3001741fd70
monitor-12378de8d7da689b
monitor-221484bc78699e36
monitor-851aa6b2441df8be
msghub-0ce5f27e091172a4
msghub-3f78fd30799d8013
msghub-672418ba0c9d57ca
msghub-6ee49262aefda39c
msghub-941d97201510acad
msghub-c1e7d15c129dc2dd
msghub-cba3f219d810a213
msghub-f148447b73540223
nginx-63d58a77be9f4303
nginx-for-op-nodeport-6d440ff30013722c
nginx-for-op-nodeport-a09b44d86b367358
nginx-for-op-nodeport-ee741fe35cb77826
nginx20220818-097cae6640470f4a
njbp-apigateway-150a317ce005144c
njbp-apigateway-394bc4d9b2509c5b
njbp-apigateway-5fba06548a536937
njbp-apigateway-c10054e362eac202
playground-3ddd4584969acc05
thirdparty-gateway-966a3366996a85ef
thirdparty-gateway-b40a7a98b4c158ca
thirdparty-gateway-d22d151fa9cc8995
vidaavoice-42aa2302b9893199
vidaavoice-5a620d905859448c
vidaavoicegateway-a4a2169e2ae267a6
vidaavoicegateway-b0ec90c8fa7045e5
worker-af6e3dbdc60ad325
worker-c2581ad0ec660608
worker-f479e3e2a0053c84
worker-f63265503404dba3" |


while read worker

do 
    echo "K8s nodes utilization CPU/Memory"
    kubectl describe node ${worker} | awk 'NR==1; /Allocated resources:/ { for (i = 1; i <= 6; ++i)  {print $0; getline}} '
    # kubectl describe node ${worker} | awk 'NR==1 || (NR>=79 && NR<=83)'
done

### commnad to put it in excel 
# cat k8s_compute.txt | awk '/Name/ {line=$NF} /cpu/ {line=line "|" $2 " " $3 "|" $4 " " $5} /memory/ {line=line "|" $2 " " $3 "|" $4 " " $5; print line}' > k8s_new.txt