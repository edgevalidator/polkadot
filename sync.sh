#!/bin/bash

# Define variables
VALIDATOR_NAME="YourValidatorName"
LOG_FILE="/var/log/polkadot-validator-monitor.log"
THRESHOLD_BLOCKS=10 # Maximum allowed lag in blocks before taking action

# Function to log messages
log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

# Get current block number from Polkadot node
CURRENT_BLOCK=$(curl -s http://localhost:9933 -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"system_syncState","params":[],"id":1}' | jq .result.currentBlock)

# Get highest block from Polkadot node
HIGHEST_BLOCK=$(curl -s http://localhost:9933 -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"system_syncState","params":[],"id":1}' | jq .result.highestBlock)

# Calculate the difference between the highest and current blocks
BLOCK_LAG=$(($HIGHEST_BLOCK - $CURRENT_BLOCK))

# Log current block and highest block
log_message "Current block: $CURRENT_BLOCK"
log_message "Highest block: $HIGHEST_BLOCK"
log_message "Block lag: $BLOCK_LAG"

# Check if the node is out of sync
if [ "$BLOCK_LAG" -gt "$THRESHOLD_BLOCKS" ]; then
    log_message "Validator $VALIDATOR_NAME is out of sync by more than $THRESHOLD_BLOCKS blocks."

    # Optionally, send notification (example using mail command)
    # echo "Validator $VALIDATOR_NAME is out of sync!" | mail -s "Polkadot Validator Alert" your-email@example.com

    # Restart validator service if it's out of sync
    log_message "Restarting validator service..."
    sudo systemctl restart validator.service

    # Log service restart
    log_message "Validator service restarted."
else
    log_message "Validator $VALIDATOR_NAME is in sync."
fi
