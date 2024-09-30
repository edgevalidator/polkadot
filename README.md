# Manually setup a server
## First you will need a working server setup. We advise an ubuntu 22.04 LTS on dedicated hardware

  The [polkadot wiki] (https://wiki.polkadot.network/docs/maintain-guides-how-to-validate-kusama) also has a lot of good information about seting up a validator node.

## It is wise to start setting your hostname (preferably matched bij the reverse dns on your provider), copying your ssh keys to your server and disable plain password authentication.

  vi /etc/hostname
  yourhostname.yourhostdomain

  vi /etc/ssh/sshd_config
  PasswordAuthentication no

  systemctl restart sshd.service

# Firewall
## Polkadot needs some ports open in the firewall, especially the p2p port

30333: p2p port
9933: HTTP RPC
9944: WS RPC
9615: prometheus port

  ufw allow openssh
  ufw enable
  ufw allow from any port 30300:30399 proto tcp
  ufw allow 30300:30399/tcp

# Packages

  apt-mark hold linux-generic linux-headers-generic linux-image-generic

# Import the security@parity.io GPG key
  gpg --recv-keys --keyserver hkps://keys.mailvelope.com 9D4B2B6EB8F97156D19669A9FF0812D491B96798
  gpg --export 9D4B2B6EB8F97156D19669A9FF0812D491B96798 > /usr/share/keyrings/parity.gpg
# Add the Parity repository and update the package index
  echo 'deb [signed-by=/usr/share/keyrings/parity.gpg] https://releases.parity.io/deb release main' > /etc/apt/sources.list.d/parity.list
  apt update
# Install the `parity-keyring` package - This will ensure the GPG key
# used by APT remains up-to-date
  apt install parity-keyring
# Install polkadot
  apt install polkadot

  systemctl daemon-reload
  systemctl start validator.service
  systemctl enable validator.service
  journalctl -u validator.service -f
