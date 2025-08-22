# Настройка CI/CD для SplitKostya

Этот проект настроен для автоматического деплоя на VPS при каждом push в ветку `main`.

## Что происходит автоматически

### При любом push в любую ветку:
1. ✅ Запускается линтер (ESLint)
2. ✅ Запускаются тесты (Karma + Jasmine)
3. ✅ Собирается проект (Angular build)
4. ✅ Собирается production версия

### При merge в main (дополнительно):
1. 🔄 Все проверки выше
2. 🚀 Автоматический деплой на VPS
3. 📦 Обновление приложения на сервере

## Настройка GitHub Secrets

В вашем GitHub репозитории перейдите в **Settings → Secrets and variables → Actions** и добавьте следующие секреты:

- `VPS_HOST` - IP адрес или домен вашего VPS
- `VPS_USERNAME` - имя пользователя для SSH (обычно `www-data`)
- `VPS_SSH_KEY` - приватный SSH ключ для подключения к VPS
- `VPS_PORT` - SSH порт (обычно `22`)

## Настройка VPS

### 1. Подключитесь к VPS по SSH

```bash
ssh username@your-vps-ip
```

### 2. Запустите скрипт настройки

```bash
# Скачайте файлы деплоя
git clone https://github.com/your-username/splitKostya.git
cd splitKostya/deploy

# Сделайте скрипт исполняемым
chmod +x setup-vps.sh

# Запустите настройку (требует sudo)
sudo ./setup-vps.sh
```

### 3. Настройте домен (опционально)

Отредактируйте файл `/etc/nginx/sites-available/splitkostya` и замените `your-domain.com` на ваш реальный домен.

### 4. Перезапустите nginx

```bash
sudo systemctl restart nginx
```

## Структура деплоя на VPS

```
/var/www/splitKostya/
├── current/          # Символическая ссылка на текущую версию
├── releases/         # Все версии приложения
├── backup/           # Резервные копии
└── repo/             # Git репозиторий
```

## Проверка работы

### Статус сервиса
```bash
sudo systemctl status splitkostya.service
```

### Логи
```bash
sudo journalctl -u splitkostya.service -f
```

### Проверка nginx
```bash
sudo nginx -t
sudo systemctl status nginx
```

## Ручной деплой

Если нужно запустить деплой вручную:

1. Перейдите в **Actions** в GitHub
2. Выберите workflow **CI/CD Pipeline**
3. Нажмите **Run workflow**
4. Выберите ветку и нажмите **Run workflow**

## Troubleshooting

### Проблемы с SSH
- Убедитесь, что SSH ключ добавлен в `~/.ssh/authorized_keys` на VPS
- Проверьте права доступа к SSH ключу (должны быть 600)

### Проблемы с правами
```bash
sudo chown -R www-data:www-data /var/www/splitKostya
sudo chmod -R 755 /var/www/splitKostya
```

### Проблемы с портами
```bash
# Проверьте, что порт 3000 не занят
sudo netstat -tlnp | grep :3000

# Если занят, найдите процесс и остановите
sudo lsof -i :3000
```

### Откат к предыдущей версии
```bash
cd /var/www/splitKostya
sudo ln -sfn releases/YYYYMMDD-HHMMSS current
sudo systemctl restart splitkostya.service
```
