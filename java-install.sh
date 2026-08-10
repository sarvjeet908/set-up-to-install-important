#!/bin/bash
set -euo pipefail

# Update package index
echo "Updating package index..."
sudo apt-get update -y

# Install default JDK (Java Development Kit)
echo "Installing Java JDK..."
sudo apt-get install -y default-jdk

# Verify installation
echo "Verifying Java installation..."
java -version
javac -version

echo "Java installation completed successfully!"
