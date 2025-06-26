#!/bin/bash

# Update the package index
yum update -y

# -----------------------
# Install OpenJDK 17
# -----------------------
amazon-linux-extras enable corretto17
yum install -y java-17-amazon-corretto

# -----------------------
# Install AWS CLI
# -----------------------
yum install -y awscli

# -----------------------
# Install kubectl (latest stable version)
# -----------------------
curl -LO "https://dl.k8s.io/release/v1.29.2/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# -----------------------
# Create a tomcat user and group
# -----------------------
useradd -r -m -U -d /opt/tomcat -s /bin/nologin tomcat

# -----------------------
# Install Apache Tomcat 11
# -----------------------
TOM_VER="11.0.8"

wget -O /tmp/tomcat.tar.gz \
  https://dlcdn.apache.org/tomcat/tomcat-11/v$TOM_VER/bin/apache-tomcat-$TOM_VER.tar.gz

mkdir -p /opt/tomcat
tar -xf /tmp/tomcat.tar.gz -C /opt/tomcat/
mv /opt/tomcat/apache-tomcat-$TOM_VER /opt/tomcat/tomcat-11

chown -RH tomcat:tomcat /opt/tomcat/tomcat-11

# -----------------------
# Create systemd service for Tomcat
# -----------------------
cat <<EOF > /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat 11
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto"
Environment="CATALINA_HOME=/opt/tomcat/tomcat-11"
Environment="CATALINA_BASE=/opt/tomcat/tomcat-11"
Environment="CATALINA_PID=/opt/tomcat/tomcat-11/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
ExecStart=/opt/tomcat/tomcat-11/bin/startup.sh
ExecStop=/opt/tomcat/tomcat-11/bin/shutdown.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# -----------------------
# Start Tomcat service
# -----------------------
systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat

# -----------------------
# Check status
# -----------------------
systemctl status tomcat
kubectl version --client

#!/bin/bash
set -e

# 필수 패키지 설치
yum update -y
yum install -y curl unzip bash-completion jq gettext git

# eksctl 설치
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin
chmod +x /usr/local/bin/eksctl

# Helm 3 설치
curl -sSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# AWS CLI v2 설치 (Amazon Linux 2에서 기본 설치 안 돼 있는 경우)
if ! command -v aws &> /dev/null; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  ./aws/install
fi

# kubectl 확인 (Amazon Linux 2에는 기본 설치됨, 없으면 설치)
if ! command -v kubectl &> /dev/null; then
  curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.0/2024-05-31/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  mv ./kubectl /usr/local/bin
fi

# Helm repo 추가 및 업데이트
helm repo add eks https://aws.github.io/eks-charts
helm repo update

#!/bin/bash
set -e

# Python 환경 구성
yum update -y
yum install -y python3 python3-pip

# FastAPI 및 Uvicorn 설치
pip3 install fastapi uvicorn

# FastAPI 수신기 코드 작성
cat <<EOF > /home/ec2-user/receive_logs.py
from fastapi import FastAPI, Request

app = FastAPI()

@app.post("/receive-log")
async def receive_log(request: Request):
    data = await request.json()
    print("✅ 받은 로그:", data)
    return {"status": "ok"}
EOF

# FastAPI 자동 실행 (nohup 백그라운드)
nohup uvicorn receive_logs:app --host 0.0.0.0 --port 8000 &
