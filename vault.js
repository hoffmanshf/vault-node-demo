// eslint-disable-next-line import/no-extraneous-dependencies,node/no-unpublished-require
const nodeVault = require("node-vault");

const apiVersion = process.env.VAULT_API_VERSION || "v1";
const protocol = process.env.VAULT_PROTOCOL || "http";
const host = process.env.VAULT_HOST || "localhost";
const port = process.env.VAULT_PORT || 8200;
const token = process.env.VAULT_TOKEN;

const endpoint = `${protocol}://${host}:${port}`;

const options = {
  apiVersion,
  endpoint,
  token,
};
const vault = nodeVault(options);

module.exports = vault;
