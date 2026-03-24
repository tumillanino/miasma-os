#!/usr/bin/env bash

set -oue pipefail

systemctl enable realtime-setup.service
systemctl enable realtime-entsk.service
