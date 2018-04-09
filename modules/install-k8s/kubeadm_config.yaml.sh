cat <<EOF
apiVersion: kubeadm.k8s.io/v1alpha1
kind: MasterConfiguration
etcd:
  endpoints:
$(echo "${ETCD_ENDPOINTS:-https://127.0.0.1:2379}" | cut -d, -f1- --output-delimiter=$'\n' | sed 's/\(.*\)/   - \1/g')
  caFile: /opt/etcd/certs/ca.pem
  certFile: /opt/etcd/certs/cert.pem
  keyFile: /opt/etcd/certs/cert-key.pem
kubeProxy:
  config:
    mode: ${KUBEPROXY_CONFIG_MODE:-iptables}
networking:
  dnsDomain: ${NETWORKING_DNS_DOMAIN:-local}
  serviceSubnet: ${NETWORKING_SERVICE_SUBNET:-10.3.0.0/16}
  podSubnet: ${NETWORKING_POD_SUBNET:-10.2.0.0/16}
kubernetesVersion: ${KUBERNETES_VERSION:-1.9.6}
nodeName: $(hostname)
authorizationModes:
$(echo "${AUTHORIZATION_MODES:-Node,RBAC}" | cut -d, -f1- --output-delimiter=$'\n' | sed 's/\(.*\)/- \1/g')
selfHosted: false
apiServerCertSANs:
$(echo "${API_SERVER_CERT_SANS:-127.0.0.1}" | cut -d, -f1- --output-delimiter=$'\n' | sed 's/\(.*\)/- \1/g')
certificatesDir: "/etc/kubernetes/pki"
EOF
