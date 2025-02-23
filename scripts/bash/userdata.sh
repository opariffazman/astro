#!/bin/bash

LOG_FILE="/var/log/userdata.log"
TIER_NAME="${TIER_NAME}"
TIER_PORT="${TIER_PORT}"

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') $1" | tee -a $LOG_FILE
}

log "Waiting for network connectivity..."
until ping -c 1 -W 1 8.8.8.8; do
    sleep 1
done

log "Updating system packages..."
yum update -y

log "Installing required packages..."
yum install -y httpd

log "Starting and enabling Apache..."
systemctl start httpd
systemctl enable httpd

log "Creating simple web page..."
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>${TIER_NAME} Server</title>
</head>
<body>
    <h1>Hello from ${TIER_NAME} Server!</h1>
    <p>Running on port ${TIER_PORT}</p>
</body>
</html>
EOF

log "Creating health check endpoint..."
cat <<EOF > /var/www/html/health
OK
EOF

log "${TIER_NAME} server setup complete!"
