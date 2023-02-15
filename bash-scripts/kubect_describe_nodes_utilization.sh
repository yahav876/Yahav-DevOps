#!/bin/bash 

cmd='kubectl describe nodes'

echo "account-node--i-01875c64fb89e6c58
account-node--i-0f92e5f7aa46c08a9
accountapigateway--i-049dfc345332da393
accountapigateway--i-086bb074c79e7c9eb
accountapigateway--i-091274f237223577f
accountnode--i-0f9248c5ba9c53b4b
apigateway--i-05e0f188275df403a
apigateway--i-084aa71b77c6a5ec5
apigateway--i-09d2ea79a75378309
apigateway--i-0b02d320a50fcb46d
apigateway--i-0f9f7e409fe14a560
bigdata-nginx--i-012436d3baee861f3
bigdata-nginx--i-05c30457a217fc39d
cluster001
cluster002
cluster003
filesever-tenant--i-00f7debd079cb54be
filesever-tenant--i-0cbe8a3ef363e859b
hiupgrade-apigateway--i-0f92db2f5d5e286a6
hiupgradenginx--i-00fb5113e366297a2
hiupgradenginx--i-0ae9150a44a8e6ffc
k8snode--i-004201aafc019f25b
k8snode--i-00d05a3ae44e14bd6
k8snode--i-00d8cf2bd0b6b096f
k8snode--i-01a41dd56c59664ad
k8snode--i-020fdfb3184f87a97
k8snode--i-022e9d1a74c3f75c6
k8snode--i-02532c7ac6379b348
k8snode--i-02c5984520bc25a41
k8snode--i-036a593ab3a2042bb
k8snode--i-04133059c6ca1ba63
k8snode--i-04599db3d63b66d0b
k8snode--i-0691f7690dd34c699
k8snode--i-072cf326d841481be
k8snode--i-07c0339806a171ba6
k8snode--i-08b5069908927d43b
k8snode--i-08eaee46ad01e6183
k8snode--i-09996a256a810ff67
k8snode--i-0b0413b45b16ff41c
k8snode--i-0b7214e1b6ab6541b
k8snode--i-0bb75f71a3825231e
k8snode--i-0bc81c05cb6683831
k8snode--i-0c4293a5cde782ea7
k8snode--i-0c674007cbf5d7955
k8snode--i-0e245178ce4b56c47
k8snode--i-0f04a7b55e422039d
k8snode--i-0f5221b6c757caed8
k8snode--i-0f81fcad6773d195e
message-apigateway--i-01bc5312b4cdf06f8
message-apigateway--i-0520b76ae7790eb4d
message-apigateway--i-0b35ef8da4a4a1d0f
message-nginx--i-026b4edc4356741d2
message-nginx--i-033a7f3001741fd70
monitor--i-012378de8d7da689b
monitor--i-0221484bc78699e36
monitor--i-0851aa6b2441df8be
msghub--i-00ce5f27e091172a4
msghub--i-03f78fd30799d8013
msghub--i-0672418ba0c9d57ca
msghub--i-06ee49262aefda39c
msghub--i-0941d97201510acad
msghub--i-0c1e7d15c129dc2dd
msghub--i-0cba3f219d810a213
msghub--i-0f148447b73540223
nginx--i-063d58a77be9f4303
nginx-for-op-nodeport--i-06d440ff30013722c
nginx-for-op-nodeport--i-0a09b44d86b367358
nginx-for-op-nodeport--i-0ee741fe35cb77826
nginx20220818--i-0097cae6640470f4a
njbp-apigateway--i-0150a317ce005144c
njbp-apigateway--i-0394bc4d9b2509c5b
njbp-apigateway--i-05fba06548a536937
njbp-apigateway--i-0c10054e362eac202
playground--i-03ddd4584969acc05
thirdparty-gateway--i-0966a3366996a85ef
thirdparty-gateway--i-0b40a7a98b4c158ca
thirdparty-gateway--i-0d22d151fa9cc8995
vidaavoice--i-042aa2302b9893199
vidaavoice--i-05a620d905859448c
vidaavoicegateway--i-0a4a2169e2ae267a6
vidaavoicegateway--i-0b0ec90c8fa7045e5
worker--i-0af6e3dbdc60ad325
worker--i-0c2581ad0ec660608
worker--i-0f479e3e2a0053c84
worker--i-0f63265503404dba3" |


while read worker

do 
    echo "K8s nodes utilization CPU/Memory"
    kubectl describe node ${worker} | awk 'NR==1; /Allocated resources:/ { for (i = 1; i <= 6; ++i)  {print $0; getline}} '
    # kubectl describe node ${worker} | awk 'NR==1 || (NR>=79 && NR<=83)'
done

### commnad to put it in excel 
# cat k8s_compute.txt | awk '/Name/ {line=$NF} /cpu/ {line=line "|" $2 " " $3 "|" $4 " " $5} /memory/ {line=line "|" $2 " " $3 "|" $4 " " $5; print line}' > k8s_new.txt