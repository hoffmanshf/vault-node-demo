#!/bin/sh
export VAULT_API_VERSION=v1
export VAULT_PROTOCOL=https
export VAULT_HOST=ciam.getpitstop.io
export VAULT_PORT=8200
# RoleID will be written to Dockerfile in production
export VAULT_APPROLE_ROLE_ID=4e324765-b399-cb5b-aca5-3a17fe5f378f
# Response-wrapped SecretID will be retrieved by CI like Jenkins or CircleCI
export VAULT_WRAP_TOKEN=s.zDkcLVYgSDW6l6o6F1SMGyMM

export VAULT_APPROLE_SECRET_ID=$( \
  curl \
    --silent \
    --header "X-Vault-Token: ${VAULT_WRAP_TOKEN}" \
    --request POST \
    "${VAULT_PROTOCOL}://${VAULT_HOST}:${VAULT_PORT}/${VAULT_API_VERSION}/sys/wrapping/unwrap" \
  | jq -r '.data.secret_id' \
)

export VAULT_TOKEN=$( \
  curl \
    --silent \
    --data '{"role_id": "'$VAULT_APPROLE_ROLE_ID'", "secret_id": "'$VAULT_APPROLE_SECRET_ID'"}' \
    --request POST \
      "${VAULT_PROTOCOL}://${VAULT_HOST}:${VAULT_PORT}/${VAULT_API_VERSION}/auth/approle/login" \
  | jq -r '.auth.client_token' \
)
