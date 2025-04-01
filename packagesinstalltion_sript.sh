#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Updating SSH configuration..."
# Enable password authentication in SSH
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Restart SSH service to apply changes
echo "Restarting SSH service..."
systemctl restart sshd

echo "Modifying sudoers file for Jenkins user..."
# Add Jenkins user to sudoers file with no password requirement
echo "jenkins ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/jenkins

echo "Configuration completed successfully!"
