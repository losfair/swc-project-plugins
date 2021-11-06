#!/usr/bin/env bash
set -eu

LATEST_TAG=$(curl -s https://api.github.com/repos/swc-project/swc-dev/releases/latest | jq -r '.tag_name')

echo "Downloading swc-dev@${LATEST_TAG}"

EXT=''

if [[ $RUNNER_OS = 'Windows' ]]; then
  EXT='.exe'
fi


BIN_URL="https://github.com/swc-project/swc-dev/releases/download/$LATEST_TAG/swc-dev-$RUNNER_OS$EXT"

echo "Using $BIN_URL"

mkdir -p swc-dev-built
curl -L $BIN_URL -o swc-dev-built/swc-dev
chmod +x swc-dev-built/swc-dev

# In docker, we don't add it to path.
if [ ! -z "${GITHUB_PATH+x}" ];then
  echo "$(pwd)/swc-dev-built" >> $GITHUB_PATH
fi

ls -al ./swc-dev-built

./swc-dev-built/swc-dev --help