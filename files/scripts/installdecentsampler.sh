#!/usr/bin/env bash
set -euo pipefail

curl -L -o /tmp/decent-sampler.tar.gz "https://cdn.decentsamples.com/production/builds/ds/1.18.1/Decent_Sampler-1.18.1-Linux-Static-x86_64.tar.gz"
tar xvf /tmp/decent-sampler.tar.gz -C /tmp

cd /tmp/Decent_Sampler-1.18.1-Linux-Static-x86_64
./install.sh

rm -rf /tmp/decent-sampler.tar.gz /tmp/Renoise* || true

exit 0
