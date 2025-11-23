# Многоэтапная сборка для Flutter Web
FROM ghcr.io/cirruslabs/flutter:stable AS build

# Установка рабочей директории
WORKDIR /app

# Копирование pubspec файлов
COPY pubspec.yaml ./
COPY pubspec.lock* ./

# Получение зависимостей
RUN flutter pub get

# Копирование всего проекта
COPY . .

# Сборка Flutter Web приложения
# Используем пустую строку для baseUrl, чтобы использовать относительные пути через nginx proxy
ARG API_BASE_URL=""
ENV API_BASE_URL=$API_BASE_URL
RUN flutter build web --release --dart-define=API_BASE_URL=$API_BASE_URL

# Финальный образ с nginx для раздачи статики
FROM nginx:alpine

# Копирование собранного приложения
COPY --from=build /app/build/web /usr/share/nginx/html

# Исправление прав доступа к файлам (чтобы nginx мог читать assets)
RUN chmod -R 755 /usr/share/nginx/html/assets

# Копирование конфигурации nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

