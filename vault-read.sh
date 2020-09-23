#!/bin/bash

version=$(curl -s https://api.github.com/repos/kir4h/rvault/releases/latest | jq -r .tag_name)
platform=$(uname | tr '[:upper:]' '[:lower:]')
wget https://github.com/kir4h/rvault/releases/latest/download/rvault-${version}-${platform}-amd64.tar.gz
tar xzf rvault-${version}-${platform}-amd64.tar.gz

./rvault read secret -f json -k 1 -p api-server | tail -n +2 | jq . > secret.json
rm rvault-${version}-${platform}-amd64.tar.gz
rm rvault
