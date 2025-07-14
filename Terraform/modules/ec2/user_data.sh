#!/bin/bash
###############################################################################
# Gros-Michel EKS Bastion – Amazon Linux 전용 user-data (EC2 부트스트랩)
###############################################################################

set -e

CLUSTER_NAME="grosmichel-cluster"
REGION="ap-northeast-2"

echo "🛠️  [1] 시스템 업데이트 및 필수 패키지 설치"
yum update -y
yum install -y java-17-amazon-corretto awscli wget tar gzip unzip shadow-utils sudo jq

echo "🧰 [2] kubectl 설치 (EKS v1.32.0 호환)"
sudo -u ec2-user mkdir -p /home/ec2-user/bin
curl -o /home/ec2-user/bin/kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl
chmod +x /home/ec2-user/bin/kubectl
chown ec2-user:ec2-user /home/ec2-user/bin/kubectl
ln -s /home/ec2-user/bin/kubectl /usr/local/bin/kubectl || true
ln -s /home/ec2-user/bin/kubectl /usr/bin/kubectl || true

echo "📡 [3] EKS 연결"
for i in {1..60}; do
  STATUS=$(aws eks describe-cluster --region "$REGION" --name "$CLUSTER_NAME" --query "cluster.status" --output text)
  echo "⏳ 현재 클러스터 상태: $STATUS"
  if [ "$STATUS" == "ACTIVE" ]; then
    echo "✅ 클러스터가 ACTIVE 상태입니다."
    break
  fi
  sleep 10
done

mkdir -p /home/ec2-user/.kube
aws eks --region "$REGION" update-kubeconfig --name "$CLUSTER_NAME" --kubeconfig /home/ec2-user/.kube/config
chown -R ec2-user:ec2-user /home/ec2-user/.kube

echo "export KUBECONFIG=/home/ec2-user/.kube/config" >> /etc/profile.d/kubeconfig.sh
echo "export KUBECONFIG=/home/ec2-user/.kube/config" >> /home/ec2-user/.bashrc
export KUBECONFIG=/home/ec2-user/.kube/config

echo "📦 [4] Helm 설치"
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "⌛ [4.9] EKS 노드 Ready 상태 확인"
for i in {1..60}; do
  READY_NODE_COUNT=$(kubectl get nodes --no-headers 2>/dev/null | grep -c " Ready")
  echo "⏳ 현재 Ready 노드 수: $READY_NODE_COUNT"
  if [ "$READY_NODE_COUNT" -gt 0 ]; then
    echo "✅ 노드가 준비되었습니다."
    break
  fi
  sleep 10
done

echo "🌐 [5] Ingress NGINX 설치"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.publishService.enabled=true || true

echo "🚀 [6] Argo CD 설치"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
for i in {1..5}; do
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml && break
  echo "[WARN] ArgoCD install attempt ($i/5) failed. Retrying in 10 sec..."
  sleep 10
done
for i in {1..10}; do
  kubectl get crd applications.argoproj.io &>/dev/null && echo '✅ ArgoCD CRD ready' && break
  echo "[WAIT] Still waiting for ArgoCD CRD... ($i/10)"
  sleep 5
done
kubectl wait --for=condition=Established crd/applications.argoproj.io --timeout=60s || true

echo "📁 [7] ArgoCD 앱 배포"
wget -qO /home/ec2-user/app-helm.yaml https://raw.githubusercontent.com/hose0504/Gros_Michel_gcp/main/gcp/helm/static-site/templates/app-helm.yaml
kubectl apply -f /home/ec2-user/app-helm.yaml || true

echo "🌍 [8] ExternalDNS 설치"
cd /home/ec2-user
wget -q https://grosmichel-terraform-state.s3.ap-northeast-2.amazonaws.com/global/external-dns.tar.gz
tar -xzf external-dns.tar.gz
helm upgrade --install external-dns ./external-dns \
  --namespace external-dns --create-namespace

echo "🎉  EKS 자동화 완료!"
