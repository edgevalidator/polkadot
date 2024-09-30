<img src="https://imagizer.imageshack.com/img923/2583/fR9IY1.png" alt="Server Setup" width="150"/> 

# Manually Set Up a Server

## 1. Prepare a Working Server
First, you will need a functioning server setup. We recommend using **Ubuntu 22.04 LTS** on dedicated hardware. The [Polkadot Wiki](https://wiki.polkadot.network/docs/maintain-guides-how-to-validate-kusama) provides valuable information on setting up a validator node.

## 2. Configure Hostname and SSH
It is recommended to set up your hostname (preferably matching the reverse DNS provided by your host), copy your SSH keys to your server, and disable plain password authentication for security.

```bash
vi /etc/hostname
yourhostname.yourhostdomain

vi /etc/ssh/sshd_config
PasswordAuthentication no

systemctl restart sshd.service
```

## 3. Configure the Firewall
Polkadot requires specific ports to be opened in the firewall, particularly the **P2P port**.

| Port   | Description      |
|--------|------------------|
| 30333  | P2P Port         |
| 9933   | HTTP RPC         |
| 9944   | WebSocket RPC    |
| 9615   | Prometheus Port  |

```bash
ufw allow openssh
ufw enable
ufw allow from any port 30300:30399 proto tcp
ufw allow 30300:30399/tcp
```

## 4. Hold Linux Packages
To prevent automatic updates that may interfere with your server, you can hold certain Linux packages.

```bash
apt-mark hold linux-generic linux-headers-generic linux-image-generic
```

## 5. Import the Parity GPG Key
To ensure the authenticity of packages from Parity, import their GPG key.

```bash
gpg --recv-keys --keyserver hkps://keys.mailvelope.com 9D4B2B6EB8F97156D19669A9FF0812D491B96798
gpg --export 9D4B2B6EB8F97156D19669A9FF0812D491B96798 > /usr/share/keyrings/parity.gpg
```

## 6. Add the Parity Repository and Update the Package Index
Add the official Parity repository to your package sources list and update the package index.

```bash
echo 'deb [signed-by=/usr/share/keyrings/parity.gpg] https://releases.parity.io/deb release main' > /etc/apt/sources.list.d/parity.list
apt update
```

## 7. Install Parity Keyring and Polkadot
Install the `parity-keyring` package to ensure the GPG key used by APT remains up-to-date, and then install Polkadot.

```bash
apt install parity-keyring
apt install polkadot
```

## 8. Start and Enable the Validator Service
Once everything is installed, start and enable the validator service to run on boot.

```bash
systemctl daemon-reload
systemctl start validator.service
systemctl enable validator.service
journalctl -u validator.service -f
```

## 9. Try our auto-install script
 ```bash
source <(curl -s https://raw.githubusercontent.com/edgevalidator/polkadot/main/validator.sh)
```
