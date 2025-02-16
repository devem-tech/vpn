#!/bin/bash
set -e

echo "Проверка инициализации PKI..."

# Если папка с PKI не найдена, выполняем инициализацию
if [ ! -d "/etc/openvpn/pki/pki" ]; then
    echo "PKI не найдена. Инициализируем PKI..."
    # Копируем EasyRSA (убедитесь, что путь /usr/share/easy-rsa корректный для вашего образа)
    cp -r /usr/share/easy-rsa /etc/openvpn/pki
    cd /etc/openvpn/pki

    # Инициализация каталога PKI
    ./easyrsa init-pki

    # Построение CA (с использованием переменной EASYRSA_REQ_CN)
    ./easyrsa build-ca nopass

    # Генерация запроса и ключа для сервера
    ./easyrsa gen-req server nopass

    # Подписание запроса для сервера
    ./easyrsa sign-req server server

    # Генерация параметров Диффи-Хеллмана
    ./easyrsa gen-dh
fi

# Настройка iptables для NAT (MASQUERADE) для клиентов VPN
VPN_SUBNET="10.8.0.0/24"
# Предполагаем, что внешний интерфейс внутри контейнера называется "eth0"
EXTERNAL_IF="eth0"

echo "Настройка iptables для NAT для подсети ${VPN_SUBNET} через интерфейс ${EXTERNAL_IF}..."

# Если правило ещё не добавлено, добавляем его
iptables -t nat -C POSTROUTING -s ${VPN_SUBNET} -o ${EXTERNAL_IF} -j MASQUERADE 2>/dev/null || \
iptables -t nat -A POSTROUTING -s ${VPN_SUBNET} -o ${EXTERNAL_IF} -j MASQUERADE

echo "Запуск OpenVPN..."
exec openvpn --config /etc/openvpn/server.conf
