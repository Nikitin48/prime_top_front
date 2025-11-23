#!/bin/bash

# Скрипт для запуска Flutter Web на macOS без флага --no-sandbox

# Устанавливаем путь к Chrome
export CHROME_EXECUTABLE="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

# Запускаем Flutter Web с веб-сервером (без автоматического открытия браузера)
# Это позволяет избежать проблемы с флагом --no-sandbox
echo "Запуск Flutter Web..."
echo "После запуска откройте браузер по указанному адресу"
flutter run -d web-server


