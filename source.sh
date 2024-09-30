#!/bin/bash 
git clone https://github.com/paritytech/polkadot-sdk.git 
cd polkadot-sdk
git checkout polkadot-v1.16.0
cargo build --release
