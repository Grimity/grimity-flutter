#!/bin/bash
# Script to generate Firebase configuration files for different environments/flavors
# Feel free to reuse and adapt this script for your own projects

# useage
# ./flutterfire-config.sh dev - android, ios - Build configuration - Debug-dev
# ./flutterfire-config.sh prod - android, ios - Build configuration - Release-prod

if [[ $# -eq 0 ]]; then
  echo "Error: No environment specified. Use 'dev' or 'prod'."
  exit 1
fi

case $1 in
  dev)
    flutterfire config \
      --project=grimity-dev-4911f \
      --out=lib/firebase_options_dev.dart \
      --ios-bundle-id=com.grimity.app.dev \
      --ios-out=ios/flavors/dev/GoogleService-Info.plist \
      --android-package-name=com.grimity.app.dev \
      --android-out=android/app/src/dev/google-services.json
    ;;
  prod)
     flutterfire config \
      --project=grimity \
      --out=lib/firebase_options_prod.dart \
      --ios-bundle-id=com.grimity.app \
      --ios-out=ios/flavors/prod/GoogleService-Info.plist \
      --android-package-name=com.grimity.app \
      --android-out=android/app/src/prod/google-services.json
    ;;
  *)
    echo "Error: Invalid environment specified. Use 'dev' or 'prod'."
    exit 1
    ;;
esac