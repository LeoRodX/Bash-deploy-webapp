#!/bin/bash

# Универсальный скрипт для создания структуры папок и файлов приложения
# Параметры можно изменить под конкретный проект

# --------------------------
# НАСТРОЙКИ (можно менять)
# --------------------------
APP_NAME="myapp"              # Название приложения
APP_DIR="$HOME/projects/$APP_NAME"  # Путь где создавать папку проекта
PYTHON_ENV=true              # Создать виртуальное окружение Python

# Структура папок и файлов (добавляйте/удаляйте по необходимости)
STRUCTURE=(
    "app.py"            # Основной файл приложения
    "templates/"             # Шаблоны (для Flask/Django и т.д.)
    "templates/index.html"    
    "requirements.txt"       # Зависимости Python
    "README.md"              # Описание проекта
)

# --------------------------
# СКРИПТ
# --------------------------

# Создаем папку проекта
echo "Создаем папку проекта: $APP_DIR"
mkdir -p "$APP_DIR"
cd "$APP_DIR" || exit

# Создаем структуру папок и файлов
echo "Создаем структуру проекта..."
for item in "${STRUCTURE[@]}"; do
    if [[ "$item" == *"/" && ! -f "$item" ]]; then
        mkdir -p "$item"
        echo "Создана папка: $item"
    else
        touch "$item"
        echo "Создан файл: $item"
    fi
done

# Инициализируем виртуальное окружение Python
if [ "$PYTHON_ENV" = true ]; then
    echo "Создаем виртуальное окружение Python..."
    python3 -m venv venv
    echo "Активируйте окружение командой: source venv/bin/activate"
    
    # Создаем базовый requirements.txt
    echo "# Основные зависимости" > requirements.txt
    echo "flask" >> requirements.txt
    #echo "python-dotenv==1.0.0" >> requirements.txt
fi

# Создаем базовый README
cat > README.md <<EOL
# $APP_NAME

## Описание проекта

Краткое описание вашего приложения.

## Установка

1. Установить зависимости:
   \`\`\`bash
   pip install -r requirements.txt
   \`\`\`

2. Запустить приложение:
   \`\`\`bash
   python app.py
   \`\`\`
EOL

# Создаем базовый app.py
cat > app.py <<EOL
from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(debug=True)
EOL

# Создаем базовый index.html
cat > templates/index.html <<EOL
<!DOCTYPE html>
<html>
<head>
    <title>$APP_NAME</title>
</head>
<body>
    <h1>Добро пожаловать в $APP_NAME!</h1>
    <p>Приложение успешно работает.</p>
</body>
</html>
EOL

echo "Готово! Проект $APP_NAME создан в $APP_DIR"
echo "Структура проекта:"
tree -L 2