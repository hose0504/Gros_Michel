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
curl -o /usr/local/bin/kubectl \
  -LO "https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.0/2024-05-17/bin/linux/amd64/kubectl"
chmod +x /usr/local/bin/kubectl
kubectl version --client

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
