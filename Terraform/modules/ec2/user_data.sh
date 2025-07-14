#!/bin/bash

ACCESS_KEY="${ACCESS_KEY}"
SECRET_KEY="${SECRET_KEY}"

# 1. AWS CLI 자격 증명 설정
sudo -u ec2-user aws configure set aws_access_key_id "${ACCESS_KEY}" --profile admin
sudo -u ec2-user aws configure set aws_secret_access_key "${SECRET_KEY}" --profile admin
sudo -u ec2-user aws configure set region ap-northeast-2 --profile admin

# 2. kubectl 설치
sudo -u ec2-user mkdir -p /home/ec2-user/bin
sudo curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl
sudo mv /kubectl /home/ec2-user/bin/kubectl
sudo chown ec2-user:ec2-user /home/ec2-user/bin/kubectl
sudo chmod +x /home/ec2-user/bin/kubectl

# 3. kubeconfig 설정
sudo -u ec2-user aws eks update-kubeconfig --region ap-northeast-2 --name my-eks --profile admin

# 4. Helm 설치
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# 5. Ingress NGINX 설치
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.publishService.enabled=true || true
