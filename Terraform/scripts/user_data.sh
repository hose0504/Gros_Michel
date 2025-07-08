#!/bin/bash
set -e

# EKS 연결
aws eks --region ap-northeast-2 update-kubeconfig --name gros-cluster

# YAML 작성
mkdir -p /home/ec2-user/k8s

cat <<EOF > /home/ec2-user/k8s/web-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: web-container
        image: jwh0722/web_v1:latest
        ports:
        - containerPort: 80
EOF

cat <<EOF > /home/ec2-user/k8s/web-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  type: LoadBalancer
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
EOF

# 배포
kubectl apply -f /home/ec2-user/k8s/web-deployment.yaml
kubectl apply -f /home/ec2-user/k8s/web-service.yaml
