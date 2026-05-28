#!/usr/bin/env sh
set -eu

CLIENT_NAME="${1:-}"
OUTPUT_DIR="${2:-$(pwd)}"

if [ -z "$CLIENT_NAME" ]; then
  echo "Usage: $0 <ClientName> [outputDir]"
  echo "Example: $0 BMW /Users/ethan/work"
  exit 1
fi

APP_ID=$(printf "%s" "$CLIENT_NAME" \
  | tr '[:upper:]' '[:lower:]' \
  | sed 's/[^a-z0-9]/-/g; s/--*/-/g; s/^-//; s/-$//')
PACKAGE_SEGMENT=$(printf "%s" "$APP_ID" | sed 's/[^a-z0-9]//g')

if [ -z "$APP_ID" ] || [ -z "$PACKAGE_SEGMENT" ]; then
  echo "ClientName must contain at least one letter or number."
  exit 1
fi

APP_TITLE="${CLIENT_NAME} AEM"
GROUP_ID="com.${PACKAGE_SEGMENT}"
ARTIFACT_ID="${APP_ID}-aem"
PACKAGE_NAME="com.${PACKAGE_SEGMENT}"

mkdir -p "$OUTPUT_DIR"
cd "$OUTPUT_DIR"

mvn -B org.apache.maven.plugins:maven-archetype-plugin:3.3.1:generate \
  -DarchetypeGroupId=com.merkle.aem \
  -DarchetypeArtifactId=eaem-project-archetype \
  -DarchetypeVersion=1.0.0-SNAPSHOT \
  -DappTitle="$APP_TITLE" \
  -DappId="$APP_ID" \
  -DgroupId="$GROUP_ID" \
  -DartifactId="$ARTIFACT_ID" \
  -Dpackage="$PACKAGE_NAME" \
  -Dversion="0.0.1-SNAPSHOT" \
  -DaemVersion="cloud" \
  -DfrontendModule="general"

echo "Generated $APP_TITLE at $OUTPUT_DIR/$ARTIFACT_ID"
