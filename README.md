# 🔒 VPN

Based on the [kylemanna/openvpn](https://hub.docker.com/r/kylemanna/openvpn) image.

A virtual private network (VPN) extends a private network across a public network and enables users to send and receive data across shared or public networks as if their computing devices were directly connected to the private network.

***

## Installation

Run once

```bash
mkdir -p /opt/bin/vpn && cd "$_" && \
  curl -s https://raw.githubusercontent.com/devem-tech/vpn/main/vpn -o vpn && \
  bash vpn init example.com # Enter CA Key Passphrase
```

##### Parameters

| Name          | Description |
| ------------- | ----------- |
| `example.com` | Domain name |

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
bash vpn add client-name
```

##### Parameters

| Name          | Description |
| ------------- | ----------- |
| `client-name` | Filename    |

#### ➖ Remove certificate

```bash
bash vpn remove client-name
```

##### Parameters

| Name          | Description |
| ------------- | ----------- |
| `client-name` | Filename    |
