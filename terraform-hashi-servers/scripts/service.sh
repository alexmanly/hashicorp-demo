#!/usr/bin/env bash
set -e

echo "Starting Consul..."
sudo start consul
sleep 20
echo "Starting Vault..."
sudo start vault
sleep 20
echo "Starting Nomad..."
sudo start nomad
