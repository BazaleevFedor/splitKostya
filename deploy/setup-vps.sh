#!/bin/bash

# Скрипт для настройки VPS для деплоя SplitKostya
# Запускать от имени root или с sudo

set -e

echo "Setting up VPS for SplitKostya deployment..."

# Обновляем систему
apt update && apt upgrade -y

# Устанавливаем необходимые пакеты
apt install -y curl git nginx

# Устанавливаем Node.js 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# Проверяем версии
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"

# Создаем пользователя для приложения
useradd -m -s /bin/bash www-data || echo "User www-data already exists"

# Создаем директории для проекта
mkdir -p /var/www/splitKostya/{current,releases,backup,repo}
chown -R www-data:www-data /var/www/splitKostya

# Копируем systemd сервис
cp splitkostya.service /etc/systemd/system/
systemctl daemon-reload

# Настраиваем nginx
cat > /etc/nginx/sites-available/splitkostya << 'EOF'
server {
    listen 80;
    server_name your-domain.com; # Замените на ваш домен

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    location /static/ {
        alias /var/www/splitKostya/current/dist/splitKostya/browser/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

# Активируем сайт
ln -sf /etc/nginx/sites-available/splitkostya /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Проверяем конфигурацию nginx
nginx -t

# Перезапускаем nginx
systemctl restart nginx
systemctl enable nginx

# Настраиваем firewall (если используется ufw)
if command -v ufw &> /dev/null; then
    ufw allow 22
    ufw allow 80
    ufw allow 443
    ufw --force enable
fi

echo "VPS setup completed!"
echo "Next steps:"
echo "1. Configure GitHub Secrets in your repository"
echo "2. Push to main branch to trigger deployment"
echo "3. Check service status: sudo systemctl status splitkostya.service"
