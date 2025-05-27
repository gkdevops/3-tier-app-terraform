#!/bin/bash
yum -y install nginx
cat >/usr/share/nginx/html/index.html <<EOF
<h1>Web tier healthy</h1>
EOF
# Simple reverse proxy to internal NLB
cat >/etc/nginx/conf.d/app.conf <<EOF
server {
    listen 80;
    location / {
        proxy_pass http://${INTERNAL_NLB_DNS}:${APP_PORT};
    }
}
EOF
systemctl enable nginx
systemctl restart nginx
