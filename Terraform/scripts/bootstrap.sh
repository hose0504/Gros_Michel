#!/bin/bash
set -e

# 로그 위치
LOGFILE="/var/log/bootstrap.log"

# 1. 기본 패키지 및 준비
echo "[BOOTSTRAP] installing base tools..." | tee -a $LOGFILE
yum update -y
yum install -y curl unzip git jq awscli python3 python3-pip bash-completion

# 2. 파일 다운로드 및 권한 부여
cd /home/ec2-user
mkdir -p scripts
cd scripts

# 이 예시에서는 스크립트를 local-file로 두고 AMI에 baking하거나,
# S3 혹은 GitHub 등에서 다운로드 받아도 됨 (여기선 local 파일 복사 가정)
cp /tmp/deploy.sh ./
cp /tmp/user_data.sh ./
chmod +x *.sh

# 3. 2단계: deploy 실행
echo "[BOOTSTRAP] running deploy.sh" | tee -a $LOGFILE
./deploy.sh >> $LOGFILE 2>&1

# 4. 3단계: user_data 실행
echo "[BOOTSTRAP] running user_data.sh" | tee -a $LOGFILE
./user_data.sh >> $LOGFILE 2>&1

echo "[BOOTSTRAP] all done ✅" | tee -a $LOGFILE
