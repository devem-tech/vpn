# 🔒 VPN

Based on the [kylemanna/openvpn](https://hub.docker.com/r/kylemanna/openvpn) image.

A virtual private network (VPN) extends a private network across a public network and enables users to send and receive data across shared or public networks as if their computing devices were directly connected to the private network.

***

## Requirements

- Docker

## Installation

Run once

```bash
mkdir -p /opt/vpn && cd "$_" && \
  curl -s https://raw.githubusercontent.com/devem-tech/vpn/main/vpn -o vpn && \
  bash vpn init <DOMAIN_NAME_OR_IP_ADDRESS> # Enter CA Key Passphrase
```

##### Arguments

| Name                        | Description              |
| --------------------------- | ------------------------ |
| `DOMAIN_NAME_OR_IP_ADDRESS` | Domain name / IP address |

#### ➕ Start service

```bash
bash vpn start
```

#### ➖ Stop service

```bash
bash vpn stop
```

***

## Certificates

All client certificates are located in the `clients` folder.

#### ➕ Add certificate

```bash
bash vpn add <CLIENT_NAME>
```

##### Arguments

| Name          | Description           |
| ------------- | --------------------- |
| `CLIENT_NAME` | Any alphanumeric name |

#### ➖ Remove certificate

```bash
bash vpn remove <CLIENT_NAME>
```

##### Arguments

| Name          | Description           |
| ------------- | --------------------- |
| `CLIENT_NAME` | Any alphanumeric name |
