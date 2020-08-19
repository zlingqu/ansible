#/bin/bash
source ~/.bash_profile

namespace=`kubectl get ns |awk '{print $1}'|grep -v NAME`
for i in $namespace;do


kubectl apply -f - <<EOF
kind: Secret
apiVersion: v1
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: eyJhdXRocyI6eyJodHRwczovL2RvY2tlci5kbS1haS5jbiI6eyJ1c2VybmFtZSI6ImRvY2tlciIsInBhc3N3b3JkIjoiM2VEYzMzZjViOTQ1TFVYYThiNTkwODc5M0tiNmUiLCJhdXRoIjoiWkc5amEyVnlPak5sUkdNek0yWTFZamswTlV4VldHRTRZalU1TURnM09UTkxZalpsIn19fQ==
metadata:
  name: regsecret
  namespace: $i
EOF

done
