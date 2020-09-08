#!/bin/sh
export VAULT_API_VERSION=v1
export VAULT_PROTOCOL=https
export VAULT_HOST=ciam.getpitstop.io
export VAULT_PORT=8200
# RoleID will be written to Dockerfile in production
export VAULT_APPROLE_ROLE_ID=28a175d5-5024-23ca-422e-59def85dc8fb
# Response-wrapped SecretID will be retrieved by CI like Jenkins or CircleCI
export VAULT_WRAP_TOKEN=s.dXsGKp8iAV8XrVKSZ9fhRijS
export VAULT_DATABASE_SECRETS_PATH=postgres

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

#DATABASE_VALUES=$(
#  curl \
#    --silent \
#    --header "X-Vault-Token: ${VAULT_TOKEN}" \
#    --request GET \
#      "${VAULT_PROTOCOL}://${VAULT_HOST}:${VAULT_PORT}/${VAULT_API_VERSION}/${VAULT_SECRETS_ENGINE_PATH}/${NODE_ENV}/${VAULT_DATABASE_SECRETS_PATH}" \
#  | jq '.data' \
#)
#
#export DB_PROTOCOL=$(echo $DATABASE_VALUES | jq -r '.DB_PROTOCOL // empty')
#export DB_USERNAME=$(echo $DATABASE_VALUES | jq -r '.DB_USERNAME // empty')
#export DB_PASSWORD=$(echo $DATABASE_VALUES | jq -r '.DB_PASSWORD // empty')
#export DB_HOST=$(echo $DATABASE_VALUES | jq -r '.DB_HOST // empty')
#export DB_PORT=$(echo $DATABASE_VALUES | jq -r '.DB_PORT // empty')
#export DB_NAME=$(echo $DATABASE_VALUES | jq -r '.DB_NAME // empty')
