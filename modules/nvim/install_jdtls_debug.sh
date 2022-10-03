#!/bin/bash
set -eo pipefail

mkdir -p "$HOME/.m2"

# https://github.com/microsoft/java-debug/issues/419#issuecomment-1149499580
cat << EOF > "$HOME/.m2/settings.xml"
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
  <mirrors>
    <mirror>
      <id>JDT.LS</id>
      <mirrorOf>JDT.LS</mirrorOf>
      <url>https://download.eclipse.org/jdtls/milestones/1.12.0/repository/</url>
      <layout>p2</layout>
      <mirrorOfLayouts>p2</mirrorOfLayouts>
    </mirror>
  </mirrors>
</settings>
EOF

mkdir -p "$HOME/.local/share/nvim/mason/packages"
cd "$HOME/.local/share/nvim/mason/packages" || exit 1
git clone https://github.com/microsoft/java-debug
cd java-debug || exit 1
./mvnw clean install

cd "$HOME/.local/share/nvim/mason/packages" || exit 1
git clone https://github.com/microsoft/vscode-java-test
cd vscode-java-test || exit 1
npm install
npm run build-plugin
