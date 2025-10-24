#!/bin/bash

# Pre-deployment checklist script for Jenkins + Tomcat deployment
# This script verifies all prerequisites are met before running the pipeline

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Counters
PASSED=0
FAILED=0
WARNINGS=0

# Helper functions
pass() {
    echo -e "${GREEN}✅ PASS${NC}: $1"
    ((PASSED++))
}

fail() {
    echo -e "${RED}❌ FAIL${NC}: $1"
    ((FAILED++))
}

warn() {
    echo -e "${YELLOW}⚠️  WARN${NC}: $1"
    ((WARNINGS++))
}

info() {
    echo -e "${CYAN}ℹ️  INFO${NC}: $1"
}

header() {
    echo ""
    echo -e "${MAGENTA}════════════════════════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}$1${NC}"
    echo -e "${MAGENTA}════════════════════════════════════════════════════════════${NC}"
}

# Main script starts here
clear
header "JENKINS + TOMCAT DEPLOYMENT VERIFICATION"

# Test 1: Java/JDK
header "TEST 1: Java Development Kit (JDK)"
if command -v java &> /dev/null; then
    JAVA_PATH=$(which java)
    JAVA_VERSION=$(java -version 2>&1 | grep version)
    pass "Java found at: $JAVA_PATH"
    info "$JAVA_VERSION"
    
    # Check for Java 17
    if echo "$JAVA_VERSION" | grep -q "17\|20\|21"; then
        pass "Java version is compatible (17 or newer)"
    else
        warn "Java version might be too old (need Java 17+): $JAVA_VERSION"
    fi
else
    fail "Java not found. Install JDK 17 or newer"
    info "macOS Homebrew: brew install openjdk@17"
    info "macOS Oracle: Download from https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html"
fi

# Test 2: Maven
header "TEST 2: Apache Maven"
if command -v mvn &> /dev/null; then
    MAVEN_VERSION=$(mvn -v 2>&1 | head -1)
    pass "Maven found"
    info "$MAVEN_VERSION"
else
    fail "Maven not found"
    info "macOS Homebrew: brew install maven"
    info "Or download from: https://maven.apache.org/download.cgi"
fi

# Test 3: Node.js
header "TEST 3: Node.js & npm"
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    NPM_VERSION=$(npm -v)
    pass "Node.js found: $NODE_VERSION"
    pass "npm found: $NPM_VERSION"
else
    fail "Node.js not found"
    info "macOS Homebrew: brew install node"
    info "Or download from: https://nodejs.org/"
fi

# Test 4: Git
header "TEST 4: Git"
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    pass "$GIT_VERSION"
    
    if [ -d ".git" ]; then
        CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")
        REMOTE=$(git remote get-url origin 2>/dev/null || echo "no remote")
        pass "Git repository initialized"
        info "Current branch: $CURRENT_BRANCH"
        info "Remote: $REMOTE"
    else
        warn "Current directory is not a git repository"
        info "Initialize with: git init"
    fi
else
    fail "Git not found"
    info "macOS Homebrew: brew install git"
fi

# Test 5: Jenkins
header "TEST 5: Jenkins Server"
if timeout 5 curl -s http://localhost:8085/ > /dev/null 2>&1; then
    pass "Jenkins is accessible at http://localhost:8085/"
    
    # Try to get Jenkins version
    JENKINS_VERSION=$(curl -s -I http://localhost:8085/ 2>/dev/null | grep -i 'X-Jenkins:' | sed 's/X-Jenkins: //' | tr -d '[:space:]' || echo "unknown")
    if [ ! -z "$JENKINS_VERSION" ]; then
        info "Jenkins Version: $JENKINS_VERSION"
    fi
else
    fail "Jenkins is NOT accessible at http://localhost:8085/"
    info "Start Jenkins with:"
    info "  macOS Homebrew: brew services start jenkins"
    info "  Or: java -jar jenkins.war --httpPort=8085"
fi

# Test 6: Tomcat
header "TEST 6: Apache Tomcat Server"
if timeout 5 curl -s http://localhost:9090/ > /dev/null 2>&1; then
    pass "Tomcat is accessible at http://localhost:9090/"
else
    fail "Tomcat is NOT accessible at http://localhost:9090/"
    info "Start Tomcat with:"
    info "  macOS Homebrew: brew services start tomcat"
    info "  Or: \$CATALINA_HOME/bin/startup.sh"
fi

# Test 7: Tomcat Manager
header "TEST 7: Tomcat Manager Console"
if timeout 5 curl -s -u admin:admin http://localhost:9090/manager/text/list 2>&1 | grep -q "OK"; then
    pass "Tomcat Manager is accessible (admin/admin)"
    
    # List deployed applications
    APPS=$(curl -s -u admin:admin http://localhost:9090/manager/text/list 2>&1 | tail -n +2)
    info "Currently deployed applications:"
    echo "$APPS" | while read line; do
        if [ ! -z "$line" ]; then
            info "  $line"
        fi
    done
else
    fail "Tomcat Manager is NOT accessible"
    fail "Check credentials: admin/admin"
    warn "Verify Tomcat conf/tomcat-users.xml contains:"
    info '  <user username="admin" password="admin" roles="manager-gui,manager-script" />'
fi

# Test 8: Database Connectivity (Optional but important)
header "TEST 8: MySQL Database (Optional)"
if command -v mysql &> /dev/null; then
    if timeout 5 mysql -h database-1.ckhoqoim0209.us-east-1.rds.amazonaws.com -u admin -padminadmin -e "SELECT 1" > /dev/null 2>&1; then
        pass "Database connection successful"
    else
        warn "Could not connect to database"
        info "This might be OK if AWS RDS is not accessible from your network"
    fi
else
    warn "mysql client not found (optional)"
    info "Install with: brew install mysql-client"
fi

# Test 9: Build directories
header "TEST 9: Project Structure"
if [ -d "crud_backend/crud_backend-main" ]; then
    pass "Backend project found"
    if [ -f "crud_backend/crud_backend-main/pom.xml" ]; then
        pass "Backend pom.xml found"
    else
        fail "Backend pom.xml not found"
    fi
else
    fail "Backend project not found at crud_backend/crud_backend-main"
fi

if [ -d "crud_frontend/crud_frontend-main" ]; then
    pass "Frontend project found"
    if [ -f "crud_frontend/crud_frontend-main/package.json" ]; then
        pass "Frontend package.json found"
    else
        fail "Frontend package.json not found"
    fi
else
    fail "Frontend project not found at crud_frontend/crud_frontend-main"
fi

# Test 10: Jenkinsfile
header "TEST 10: Jenkinsfile"
if [ -f "Jenkinsfile" ]; then
    pass "Jenkinsfile found"
    
    # Check if it contains the pipeline keyword
    if grep -q "pipeline {" Jenkinsfile; then
        pass "Jenkinsfile contains valid pipeline syntax"
    else
        warn "Jenkinsfile might not be a valid Groovy pipeline"
    fi
else
    fail "Jenkinsfile not found in project root"
fi

# Test 11: Documentation
header "TEST 11: Documentation Files"
for doc in "QUICK_START.md" "JENKINS_DEPLOYMENT_GUIDE.md" "TROUBLESHOOTING.md" "ARCHITECTURE.md"; do
    if [ -f "$doc" ]; then
        pass "$doc found"
    else
        warn "$doc not found (but can be regenerated)"
    fi
done

# Test 12: Local build test
header "TEST 12: Local Build Test"
read -p "Do you want to test building the backend and frontend locally? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Testing backend build..."
    cd crud_backend/crud_backend-main
    if ./mvnw clean package -DskipTests > /tmp/backend_build.log 2>&1; then
        pass "Backend builds successfully"
        if [ -f "target/cruddemo-0.0.1-SNAPSHOT.war" ]; then
            WAR_SIZE=$(ls -lh target/cruddemo-0.0.1-SNAPSHOT.war | awk '{print $5}')
            pass "Backend WAR created ($WAR_SIZE)"
        fi
    else
        fail "Backend build failed"
        tail -20 /tmp/backend_build.log | sed 's/^/  /'
    fi
    cd - > /dev/null
    
    echo "Testing frontend build..."
    cd crud_frontend/crud_frontend-main
    if npm install > /tmp/frontend_build.log 2>&1 && npm run build >> /tmp/frontend_build.log 2>&1; then
        pass "Frontend builds successfully"
        if [ -d "dist" ]; then
            FILE_COUNT=$(find dist -type f | wc -l)
            pass "Frontend built ($FILE_COUNT files in dist/)"
        fi
    else
        fail "Frontend build failed"
        tail -20 /tmp/frontend_build.log | sed 's/^/  /'
    fi
    cd - > /dev/null
fi

# Summary
header "VERIFICATION SUMMARY"
echo ""
echo -e "${GREEN}✅ PASSED: $PASSED${NC}"
echo -e "${RED}❌ FAILED: $FAILED${NC}"
echo -e "${YELLOW}⚠️  WARNINGS: $WARNINGS${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}🎉 ALL CHECKS PASSED! YOU'RE READY TO DEPLOY!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Create a new Pipeline job in Jenkins"
    echo "2. Configure it to use the Jenkinsfile from this repository"
    echo "3. Run: Build Now"
    echo ""
    echo "Monitor the build at: http://localhost:8085/"
    echo "Access apps at:"
    echo "  - Backend:  http://localhost:9090/springapp1"
    echo "  - Frontend: http://localhost:9090/frontapp1"
else
    echo -e "${RED}════════════════════════════════════════════════════════════${NC}"
    echo -e "${RED}❌ SOME CHECKS FAILED - PLEASE FIX ABOVE ISSUES${NC}"
    echo -e "${RED}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Review the TROUBLESHOOTING.md file for help with common issues"
    exit 1
fi

echo ""
