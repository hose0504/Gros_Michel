#!/bin/bash

ACCESS_KEY="${ACCESS_KEY}"
SECRET_KEY="${SECRET_KEY}"

# AWS CLI configure
sudo -u ec2-user aws configure set aws_access_key_id "$ACCESS_KEY" --profile Terraform-user
sudo -u ec2-user aws configure set aws_secret_access_key "$SECRET_KEY" --profile Terraform-user
sudo -u ec2-user aws configure set region ap-northeast-2 --profile Terraform-user

# 1. EKS 클러스터 활성화 대기
echo "⌛ [1] EKS 클러스터 활성화 대기 중..."
for i in {1..20}; do
  CLUSTER_STATUS=$(aws eks describe-cluster --name grosmichel-cluster \
    --region ap-northeast-2 --profile Terraform-user \
    --query "cluster.status" --output text 2>/dev/null)

  echo "🔍 현재 클러스터 상태: $CLUSTER_STATUS"
  if [ "$CLUSTER_STATUS" = "ACTIVE" ]; then
    echo "✅ 클러스터가 준비되었습니다!"
    break
  fi
  sleep 60
done

# 2. kubectl 설치
echo "📦 [2] kubectl 설치"
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.15/2025-04-17/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

# 3. kubeconfig 업데이트
echo "🔧 [3] kubeconfig 설정"
aws eks update-kubeconfig --region ap-northeast-2 --name grosmichel-cluster --profile Terraform-user

# 4. Helm 설치
echo "📦 [4] Helm 설치"
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# 5. NGINX Ingress 설치
echo "🌐 [5] Ingress NGINX 설치"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.publishService.enabled=true || true

# 6. Argo CD 설치
echo "🚀 [6] Argo CD 설치"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
for i in {1..5}; do
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml && break
  echo "[WARN] ArgoCD 설치 실패 ($i/5). 10초 후 재시도..."
  sleep 10
done
for i in {1..10}; do
  kubectl get crd applications.argoproj.io &>/dev/null && echo '✅ ArgoCD CRD 준비 완료' && break
  echo "[WAIT] ArgoCD CRD 대기 중... ($i/10)"
  sleep 5
done
kubectl wait --for=condition=Established crd/applications.argoproj.io --timeout=60s || true

# 7. ArgoCD 앱 배포
echo "📁 [7] ArgoCD 앱 배포"
wget -qO /home/ec2-user/app-helm.yaml https://raw.githubusercontent.com/hose0504/Gros_Michel_gcp/main/gcp/helm/static-site/templates/app-helm.yaml
kubectl apply -f /home/ec2-user/app-helm.yaml || true

# 8. ExternalDNS 설치
echo "🌍 [8] ExternalDNS 설치"
cd /home/ec2-user
wget -q https://grosmichel-terraform-state.s3.ap-northeast-2.amazonaws.com/global/external-dns.tar.gz
tar -xzf external-dns.tar.gz
helm upgrade --install external-dns ./external-dns \
  --namespace external-dns --create-namespace

echo "🎉 EKS 자동화 user-data 완료!"
