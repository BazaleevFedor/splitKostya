#!/bin/bash

# Скрипт для настройки SSL сертификатов
# Запускать после настройки домена

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 your-domain.com"
    exit 1
fi

DOMAIN=$1

echo "Setting up SSL certificate for $DOMAIN..."

# Устанавливаем certbot
apt update
apt install -y certbot python3-certbot-nginx

# Получаем SSL сертификат
certbot --nginx -d $DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN

# Копируем конфигурацию с SSL
cp nginx-ssl.conf /etc/nginx/sites-available/splitkostya
sed -i "s/your-domain.com/$DOMAIN/g" /etc/nginx/sites-available/splitkostya

# Проверяем конфигурацию
nginx -t

# Перезапускаем nginx
systemctl restart nginx

# Настраиваем автообновление сертификатов
echo "0 12 * * * /usr/bin/certbot renew --quiet" | crontab -

echo "SSL setup completed for $DOMAIN!"
echo "Certificate will auto-renew daily at 12:00"
