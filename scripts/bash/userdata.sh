#!/bin/bash

LOG_FILE="/var/log/userdata.log"

TIER_NAME=${TIER_NAME:-default_tier}
TIER_PORT=${TIER_PORT:-8080}

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') $1" | tee -a $LOG_FILE
}

export DEBIAN_FRONTEND=noninteractive

log "Updating system packages..."
apt-get update -y && apt-get upgrade -y >>$LOG_FILE 2>&1

log "Installing required packages (Nginx, Node.js, npm)..."
apt-get install -y nginx nodejs npm >>$LOG_FILE 2>&1

log "Creating application directory..."
mkdir -p /var/www/${TIER_NAME}
cd /var/www/${TIER_NAME}

log "Creating Node.js application..."
cat <<EOF >server.js
const http = require('http');
const port = ${TIER_PORT};

const requestHandler = (req, res) => {
    if (req.url === "/health") {
        res.writeHead(200, {'Content-Type': 'application/json'});
        res.end(JSON.stringify({ status: "healthy" }));
    } else {
        res.writeHead(200, {'Content-Type': 'text/plain'});
        res.end('Hello from ${TIER_NAME} Tier!');
    }
};

const server = http.createServer(requestHandler);
server.listen(port, () => {
    console.log(\`Server running on port \${TIER_PORT}\`);
});
EOF

log "Installing PM2 process manager..."
npm install -g pm2 >>$LOG_FILE 2>&1

log "Starting the Node.js application with PM2..."
pm2 start server.js >>$LOG_FILE 2>&1
pm2 startup systemd >>$LOG_FILE 2>&1
pm2 save >>$LOG_FILE 2>&1

log "Configuring Nginx as a reverse proxy..."
cat <<EOF >/etc/nginx/sites-available/${TIER_NAME}
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:${TIER_PORT};
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    location /health {
        proxy_pass http://localhost:${TIER_PORT}/health;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

log "Enabling Nginx configuration..."
ln -s /etc/nginx/sites-available/${TIER_NAME} /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

log "Restarting Nginx..."
systemctl restart nginx

log "${TIER_NAME} tier setup complete!"
