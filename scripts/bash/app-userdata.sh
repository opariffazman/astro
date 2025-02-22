#!/bin/bash
apt-get update
apt-get install -y nginx docker.io awslogs

# Configure CloudWatch Logs
cat >/etc/awslogs/awslogs.conf <<EOF
[general]
state_file = /var/lib/awslogs/agent-state

[/var/log/syslog]
file = /var/log/syslog
log_group_name = /ec2/application/syslog
log_stream_name = {instance_id}
datetime_format = %b %d %H:%M:%S

[/var/log/nginx/access.log]
file = /var/log/nginx/access.log
log_group_name = /ec2/application/nginx-access
log_stream_name = {instance_id}
datetime_format = %d/%b/%Y:%H:%M:%S %z
EOF

systemctl enable awslogsd.service
systemctl start awslogsd
systemctl enable docker
systemctl start docker

docker pull nginx:latest
docker run -d -p 8080:80 nginx:latest

echo "OK" >/var/www/html/health.html
