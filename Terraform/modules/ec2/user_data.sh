#!/bin/bash
###############################################################################
# Gros-Michel bastion – Amazon Linux + EKS 전용 user-data (ec2-user 버전, curl 설치 생략)
###############################################################################

set -e

echo "🛠️  [1] 시스템 업데이트 및 필수 패키지 설치"
yum update -y
yum install -y java-17-amazon-corretto awscli wget tar gzip unzip shadow-utils sudo

echo "🧰 [2] kubectl 설치 (v1.29.2)"
curl -LO "https://dl.k8s.io/release/v1.29.2/bin/linux/amd64/kubectl"
chmod +x kubectl && mv kubectl /usr/local/bin/
ln -s /usr/local/bin/kubectl /usr/bin/kubectl

echo "📡 [3] EKS 연결"
CLUSTER_NAME="grosmichel-cluster"
REGION="ap-northeast-2"

# EKS 클러스터가 ACTIVE 될 때까지 최대 10분 대기
for i in {1..60}; do
  STATUS=$(aws eks describe-cluster --region "$REGION" --name "$CLUSTER_NAME" --query "cluster.status" --output text)
  echo "⏳ 현재 클러스터 상태: $STATUS"
  if [ "$STATUS" == "ACTIVE" ]; then
    echo "✅ 클러스터가 ACTIVE 상태입니다. 계속 진행합니다."
    break
  fi
  sleep 10
done

# kubeconfig 설정
aws eks --region "$REGION" update-kubeconfig --name "$CLUSTER_NAME"

echo "📦 [4] Helm 설치"
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

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

echo "📁 [7] ArgoCD 앱 배포 (앱 정의 YAML 적용)"
wget -qO /home/ec2-user/app-helm.yaml https://raw.githubusercontent.com/hose0504/Gros_Michel_gcp/main/gcp/helm/static-site/templates/app-helm.yaml
kubectl apply -f /home/ec2-user/app-helm.yaml || true

echo "🌍 [8] ExternalDNS 설치 (IRSA 연결된 Helm 차트)"
cd /home/ec2-user
wget -q https://grosmichel-terraform-state.s3.ap-northeast-2.amazonaws.com/global/external-dns.tar.gz
tar -xzf external-dns.tar.gz
helm upgrade --install external-dns ./external-dns \
  --namespace external-dns --create-namespace

echo "🎉  EKS 자동화 user-data 완료!"
