#!/bin/bash

echo "🔍 Testing Java Setup"
echo "===================="
echo ""

JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-23.jdk/Contents/Home"
export JAVA_HOME

echo "JAVA_HOME: $JAVA_HOME"
echo ""

echo "Testing Java binary..."
if [ -x "$JAVA_HOME/bin/java" ]; then
    echo "✅ Java executable found"
    $JAVA_HOME/bin/java -version
else
    echo "❌ Java executable NOT found at $JAVA_HOME/bin/java"
    exit 1
fi

echo ""
echo "Testing Maven wrapper..."
cd "$(dirname "$0")/crud_backend/crud_backend-main"

if [ ! -x "./mvnw" ]; then
    echo "❌ mvnw not executable"
    exit 1
fi

echo "✅ mvnw is executable"

echo ""
echo "Testing Maven version..."
./mvnw -version

echo ""
echo "✅ Java setup verified!"
