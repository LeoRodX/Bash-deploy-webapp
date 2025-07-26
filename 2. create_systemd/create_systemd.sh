#!/bin/bash

# Скрипт для создания и настройки systemd сервиса с автозапуском
# Требует запуска с правами root (sudo)

# --------------------------
# НАСТРОЙКИ (можно менять)
# --------------------------
SERVICE_NAME="myapp"          # Имя сервиса
APP_DIR="/home/$USER/projects/$SERVICE_NAME"  # Путь к приложению
APP_FILE="app.py"             # Главный файл приложения
USER_NAME="$USER"             # Пользователь от которого запускать
VENV_PATH="$APP_DIR/venv"     # Путь к виртуальному окружению
PORT="5000"                   # Порт приложения

# --------------------------
# СКРИПТ
# --------------------------

# Проверяем что скрипт запущен с правами root
if [ "$(id -u)" -ne 0 ]; then
    echo "Этот скрипт должен запускаться с правами root (sudo)"
    exit 1
fi

# Проверяем существование папки приложения
if [ ! -d "$APP_DIR" ]; then
    echo "Ошибка: Папка приложения $APP_DIR не найдена!"
    exit 1
fi

# Проверяем существование файла приложения
if [ ! -f "$APP_DIR/$APP_FILE" ]; then
    echo "Ошибка: Файл приложения $APP_FILE не найден в $APP_DIR!"
    exit 1
fi

# Создаем сервисный файл
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

echo "Создаем сервисный файл: $SERVICE_FILE"
cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=$SERVICE_NAME Service
After=network.target

[Service]
User=$USER_NAME
Group=$USER_NAME
WorkingDirectory=$APP_DIR
Environment="PATH=$VENV_PATH/bin:$PATH"
ExecStart=$VENV_PATH/bin/python $APP_DIR/$APP_FILE
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# Применяем изменения
echo "Применяем изменения systemd..."
systemctl daemon-reload
systemctl enable $SERVICE_NAME
systemctl start $SERVICE_NAME

# Проверяем статус
echo "Проверяем статус сервиса..."
systemctl status $SERVICE_NAME --no-pager

echo "Готово!"
echo "Сервис $SERVICE_NAME успешно настроен и запущен"
echo "Управление:"
echo "  Запуск:    sudo systemctl start $SERVICE_NAME"
echo "  Остановка: sudo systemctl stop $SERVICE_NAME"
echo "  Перезапуск: sudo systemctl restart $SERVICE_NAME"
echo "  Статус:    sudo systemctl status $SERVICE_NAME"
echo "  Логи:      sudo journalctl -u $SERVICE_NAME -f"