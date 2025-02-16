#!/bin/bash
set -e

# Если имя клиента не передано, генерируем UUID
if [ -z "$1" ]; then
  CLIENT=$(cat /proc/sys/kernel/random/uuid)
  echo "No client name provided. Generated client name: ${CLIENT}" >&2
else
  CLIENT="$1"
fi

# Переходим в директорию PKI
cd /etc/openvpn/pki

# Если сертификат клиента не найден, генерируем его
if [ ! -f "pki/issued/${CLIENT}.crt" ]; then
  ./easyrsa build-client-full "$CLIENT" nopass >/dev/null 2>&1
fi

# Определяем IP сервера: если переменная SERVER_IP не задана, пытаемся получить его автоматически
if [ -z "$SERVER_IP" ]; then
  SERVER_IP=$(curl -s ifconfig.me)
fi

# Вывод базовой конфигурации клиента в stdout
cat <<EOF
client
dev tun
proto udp
remote ${SERVER_IP} 1194
resolv-retry infinite
nobind
persist-key
persist-tun
cipher AES-256-CBC
verb 3

<ca>
EOF

# Вставляем содержимое CA-сертификата
cat pki/ca.crt
echo "</ca>"

# Вставляем сертификат клиента
echo "<cert>"
awk '/-----BEGIN CERTIFICATE-----/{flag=1} flag; /-----END CERTIFICATE-----/{flag=0}' pki/issued/${CLIENT}.crt
echo "</cert>"

# Вставляем приватный ключ клиента
echo "<key>"
cat pki/private/${CLIENT}.key
echo "</key>"
