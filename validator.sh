#!/bin/bash

# Update system packages
sudo apt update

# Install necessary dependencies
sudo apt install curl git clang libssl-dev llvm libudev-dev -y

# Install Rust (used for building Polkadot)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# Clone the Polkadot repository
git clone https://github.com/paritytech/polkadot.git
cd polkadot

# Build Polkadot
cargo build --release

# Move the Polkadot binary to /usr/local/bin for global access
sudo cp target/release/polkadot /usr/local/bin/polkadot

# Create a systemd service for the validator
sudo tee /etc/systemd/system/validator.service > /dev/null <<EOF
[Unit]
Description=Validator Node Service
After=network.target

[Service]
User=$USER
ExecStart=/usr/local/bin/polkadot --validator --name "YourValidatorName" --chain kusama
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to apply the new service
sudo systemctl daemon-reload

# Enable the validator service to start on boot
sudo systemctl enable validator.service

# Start the validator service
sudo systemctl start validator.service

# Check the status of the validator service
sudo systemctl status validator.service
