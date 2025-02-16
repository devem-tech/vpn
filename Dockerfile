FROM alpine:latest

# Установка пакетов
RUN apk update && apk add --no-cache openvpn easy-rsa iptables bash curl

# Задаём рабочую директорию
WORKDIR /etc/openvpn

# Копируем конфигурационный файл сервера (server.conf) в контейнер
COPY server.conf /etc/openvpn/

# Копируем скрипт инициализации PKI и запуска OpenVPN
COPY init.sh /etc/openvpn/

# Копируем скрипт для генерации клиентского OVPN файла
COPY client.sh /client.sh

# Делаем скрипты исполняемыми
RUN chmod +x /etc/openvpn/init.sh /client.sh

# Задаём переменные окружения для работы EasyRSA
ENV EASYRSA_BATCH=1
ENV EASYRSA_REQ_CN=server

# Открываем UDP порт 1194 для OpenVPN
EXPOSE 1194/udp

# Точка входа — скрипт инициализации, который создаст PKI (если ещё не создана) и запустит OpenVPN
ENTRYPOINT ["/etc/openvpn/init.sh"]
