# OpenVPN Docker 🚀

Этот репозиторий содержит Docker-образ для запуска OpenVPN-сервера с автоматизированной настройкой PKI с использованием EasyRSA, а также с возможностью генерации клиентских конфигурационных файлов (OVPN) в один шаг. Образ оптимизирован для производительности и безопасности и основан на Alpine Linux.

## Особенности ✨

- **OpenVPN сервер:** Использует UDP на порту 1194.
- **Автоматизированная PKI:** Генерация CA, серверного и клиентских сертификатов с помощью EasyRSA.
- **Docker Compose:** Легко разворачивается через Docker Compose.
- **Генерация клиентского OVPN:** Скрипт `client.sh` автоматически генерирует файл конфигурации для подключения клиента, включая встроенные сертификаты и ключи.
- **Настройка NAT:** Скрипт `init.sh` добавляет правило iptables для MASQUERADE, позволяющее клиентам VPN иметь доступ к интернету.
- **Минимальный размер и повышенная безопасность:** Образ основан на Alpine Linux.

## Запуск 🏁

### 1. Docker Compose

Создайте файл `docker-compose.yml` со следующим содержимым:

```yaml
services:
  vpn:
    image: ghcr.io/devem-tech/vpn
    restart: always
    ports:
      - "1194:1194/udp"
    volumes:
      - vpn_data:/etc/openvpn
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun

volumes:
  vpn_data:
```

Запустите контейнер:

```bash
docker compose up -d
```

Контейнер будет автоматически запущен и настроен для работы OpenVPN-сервера.

### 2. Генерация клиентской конфигурации

Чтобы получить файл конфигурации для подключения клиента (сгенерируется новый клиентский сертификат и ключ, если они еще не существуют), выполните команду:

```bash
docker compose exec -T vpn /client.sh > client.ovpn
```

> **Примечание:** Использование флага `-T` гарантирует, что вывод, генерируемый скриптом, не будет содержать лишних управляющих символов, и весь результат будет корректно перенаправлен в файл `client.ovpn`.

### 3. Подключение к VPN 🔒

1. Скопируйте полученный файл `client.ovpn` на устройство, с которого хотите подключаться.
2. Импортируйте этот файл в клиентское приложение OpenVPN (например, OpenVPN Connect, Tunnelblick или другое).
3. Запустите подключение и наслаждайтесь безопасным доступом к сети.

## Настройка и кастомизация ⚙️

- **SERVER_IP:**  
  По умолчанию, при генерации клиентского файла, если переменная `SERVER_IP` не задана, скрипт попытается автоматически определить публичный IP с помощью `curl`. Вы можете задать `SERVER_IP` в переменных окружения контейнера для явного указания адреса сервера.

- **Настройка OpenVPN:**  
  Файл `server.conf` и скрипты `init.sh` и `client.sh` можно модифицировать для изменения параметров сервера, шифрования, DNS и других настроек OpenVPN.

- **PKI и сертификаты:**  
  При первом запуске контейнера PKI автоматически инициализируется и генерируются необходимые сертификаты и ключи. Все данные сохраняются в томе `vpn_data`.

## Решение проблем 🛠

- **Отсутствие доступа в интернет у клиентов:**  
  Убедитесь, что на хосте включен IP forwarding, а также проверьте, что правило NAT (MASQUERADE) корректно применяется (оно настраивается автоматически в `init.sh`).

- **Проблемы с генерацией сертификатов:**  
  Если возникают ошибки при создании клиентских сертификатов, проверьте логи контейнера на предмет ошибок EasyRSA и убедитесь, что контейнер запущен с нужными правами (например, с `NET_ADMIN`).

## Лицензия 📄

Этот проект распространяется под лицензией [MIT License](LICENSE).

## Контакты 📬

Если у вас возникнут вопросы или предложения, пожалуйста, создайте issue в репозитории или свяжитесь с разработчиком.
