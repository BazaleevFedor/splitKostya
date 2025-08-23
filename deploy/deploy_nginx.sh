#!/bin/bash
set -e

echo "🚀 Деплой Nginx конфига..."

# Копируем конфиг в нужное место
sudo cp ./deploy/nginx.conf /etc/nginx/sites-available/splitkostya

# Ставим симлинк (если нет)
if [ ! -L /etc/nginx/sites-enabled/splitkostya ]; then
  sudo ln -s /etc/nginx/sites-available/splitkostya /etc/nginx/sites-enabled/
fi

# Проверяем конфиг
sudo nginx -t

# Перезапускаем Nginx
sudo systemctl reload nginx

echo "✅ Nginx конфиг обновлён!"
