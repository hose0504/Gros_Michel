#!/bin/bash

ACCESS_KEY="${ACCESS_KEY}"
SECRET_KEY="${SECRET_KEY}"

# AWS CLI configure
sudo -u ec2-user aws configure set aws_access_key_id "$ACCESS_KEY" --profile Terraform-user
sudo -u ec2-user aws configure set aws_secret_access_key "$SECRET_KEY" --profile Terraform-user
sudo -u ec2-user aws configure set region ap-northeast-2 --profile Terraform-user

# 1. EKS 클러스터 생성 대기 (고정 대기)
echo "⌛ [1] EKS 클러스터 생성 대기 중 (15분)"
sleep 900

# 2. kubectl 설치
echo "📦 [2] kubectl 설치"
sudo -u ec2-user curl -o /home/ec2-user/kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.15/2025-04-17/bin/linux/amd64/kubectl
chmod +x /home/ec2-user/kubectl
mv /home/ec2-user/kubectl /usr/local/bin/kubectl

# 3. kubeconfig 설정
echo "🔧 [3] kubeconfig 설정"
sudo -u ec2-user aws eks update-kubeconfig \
  --region ap-northeast-2 \
  --name grosmichel-cluster \
  --profile Terraform-user

# 4. Helm 설치
echo "📦 [4] Helm 설치"
sudo -u ec2-user curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# 5. NGINX Ingress 설치
echo "🌐 [5] Ingress NGINX 설치"
sudo -u ec2-user helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
sudo -u ec2-user helm repo update
sudo -u ec2-user helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.publishService.enabled=true || true

# 6. Argo CD 설치
echo "🚀 [6] Argo CD 설치"
sudo -u ec2-user kubectl create namespace argocd --dry-run=client -o yaml | sudo -u ec2-user kubectl apply -f -
for i in {1..5}; do
  sudo -u ec2-user kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml && break
  echo "[WARN] ArgoCD 설치 실패 ($i/5). 10초 후 재시도..."
  sleep 10
done
for i in {1..10}; do
  sudo -u ec2-user kubectl get crd applications.argoproj.io &>/dev/null && echo '✅ ArgoCD CRD 준비 완료' && break
  echo "[WAIT] ArgoCD CRD 대기 중... ($i/10)"
  sleep 5
done
sudo -u ec2-user kubectl wait --for=condition=Established crd/applications.argoproj.io --timeout=60s || true

# 7. ArgoCD 앱 배포
echo "📁 [7] ArgoCD 앱 배포"
sudo -u ec2-user wget -qO /home/ec2-user/app-helm.yaml https://raw.githubusercontent.com/hose0504/Gros_Michel_gcp/main/gcp/helm/static-site/templates/app-helm.yaml
sudo -u ec2-user kubectl apply -f /home/ec2-user/app-helm.yaml || true

# 8. ExternalDNS 설치
echo "🌍 [8] ExternalDNS 설치"
cd /home/ec2-user
sudo -u ec2-user wget -q https://grosmichel-terraform-state.s3.ap-northeast-2.amazonaws.com/global/external-dns.tar.gz
sudo -u ec2-user tar -xzf external-dns.tar.gz
sudo -u ec2-user helm upgrade --install external-dns ./external-dns \
  --namespace external-dns --create-namespace

echo "🎉 EKS 자동화 user-data 완료!"
