# terraform-vault-kmip
a terraform example for seting up the ADP KMIP Secret engine and generating a left certificate for the KMIP Client.


to run this code, export the vault address and vault token enviroment variables.

```bash
export VAULT_ADDR=http://localhost:8200

export VAULT_TOKEN=root
```

for Hashicorp folk: I've Basically automated this Instruqt track: https://play.instruqt.com/hashicorp/tracks/vault-kmip-secrets-engine-mongodb
