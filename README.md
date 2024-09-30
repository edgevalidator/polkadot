# Manually Set Up a Server

## 1. Prepare a Working Server
First, you will need a functioning server setup. We recommend using **Ubuntu 22.04 LTS** on dedicated hardware.

The [Polkadot Wiki](https://wiki.polkadot.network/docs/maintain-guides-how-to-validate-kusama) provides valuable information on setting up a validator node.

## 2. Configure Hostname and SSH
It is recommended to set up your hostname (preferably matching the reverse DNS provided by your host), copy your SSH keys to your server, and disable plain password authentication for security.

```bash
# Edit the hostname
vi /etc/hostname
yourhostname.yourhostdomain

# Disable password authentication in the SSH config
vi /etc/ssh/sshd_config
PasswordAuthentication no

# Restart the SSH service to apply changes
systemctl restart sshd.service

3. Configure the Firewall
Polkadot requires specific ports to be opened in the firewall, particularly the P2P port.

Port	Description
30333	P2P Port
9933	HTTP RPC
9944	WebSocket RPC
9615	Prometheus Port
