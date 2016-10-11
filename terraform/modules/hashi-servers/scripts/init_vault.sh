#!/bin/bash
set -e

export VAULT_ADDR=http://127.0.0.1:8200

cget() { curl -sf "http://127.0.0.1:8500/v1/kv/service/vault/$1?raw"; }

unseal() {
  echo "Unsealing the Vault."
  echo "Unsealing Vault with key 1"
  vault unseal $(cget unseal-key-1)
  echo "Unsealing Vault with key 2"
  vault unseal $(cget unseal-key-2)
  echo "Unsealing Vault with key 3"
  vault unseal $(cget unseal-key-3)
  echo "Vault unseal complete.";
}

if [ ! $(cget root-token) ]; then

  echo "Initialise Vault"
  vault init | sudo tee /tmp/vault.init > /dev/null

  # Store master keys in consul for operator to retrieve and remove

  echo "Store unseal key 1 in consul"
  curl -X PUT -s -d "$(sed "1q;d" /tmp/vault.init  | awk -F': ' '{print $2}')" http://127.0.0.1:8500/v1/kv/service/vault/unseal-key-1
  echo "Store unseal key 2 in consul"
  curl -X PUT -s -d "$(sed "3q;d" /tmp/vault.init  | awk -F': ' '{print $2}')" http://127.0.0.1:8500/v1/kv/service/vault/unseal-key-2
  echo "Store unseal key 3 in consul"
  curl -X PUT -s -d "$(sed "5q;d" /tmp/vault.init  | awk -F': ' '{print $2}')" http://127.0.0.1:8500/v1/kv/service/vault/unseal-key-3
  echo "Store unseal key 4 in consul"
  curl -X PUT -s -d "$(sed "7q;d" /tmp/vault.init  | awk -F': ' '{print $2}')" http://127.0.0.1:8500/v1/kv/service/vault/unseal-key-4
  echo "Store unseal key 5 in consul"
  curl -X PUT -s -d "$(sed "9q;d" /tmp/vault.init  | awk -F': ' '{print $2}')" http://127.0.0.1:8500/v1/kv/service/vault/unseal-key-5
  echo "Store root token in consul"
  curl -X PUT -s -d "$(sed "11q;d" /tmp/vault.init  | awk -F': ' '{print $2}')" http://127.0.0.1:8500/v1/kv/service/vault/root-token

  echo "Remove master keys from disk"
  sudo shred /tmp/vault.init

  echo "Vault initialisation complete."
  
  unseal

  echo "Authenticating the root token"
  vault auth $(cget root-token)
  echo "Root token authentication complete."
else
  echo "Vault has already been initialised, skipping."
  unseal
fi
