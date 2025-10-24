#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Full Stack Deployment - Environment Check${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Check 1: Java/JDK
echo -e "${YELLOW}[1/7] Checking Java/JDK...${NC}"
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | grep 'version')
    echo -e "${GREEN}✓ Java installed${NC}"
    echo "   $JAVA_VERSION"
else
    echo -e "${RED}✗ Java not found - Install JDK 17${NC}"
fi
echo ""

# Check 2: Maven
echo -e "${YELLOW}[2/7] Checking Maven...${NC}"
if command -v mvn &> /dev/null; then
    MVN_VERSION=$(mvn -v | head -1)
    echo -e "${GREEN}✓ Maven installed${NC}"
    echo "   $MVN_VERSION"
else
    echo -e "${RED}✗ Maven not found - Install Maven${NC}"
fi
echo ""

# Check 3: Node.js
echo -e "${YELLOW}[3/7] Checking Node.js...${NC}"
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    NPM_VERSION=$(npm -v)
    echo -e "${GREEN}✓ Node.js installed${NC}"
    echo "   Node: $NODE_VERSION, npm: $NPM_VERSION"
else
    echo -e "${RED}✗ Node.js not found - Install Node.js${NC}"
fi
echo ""

# Check 4: Jenkins
echo -e "${YELLOW}[4/7] Checking Jenkins...${NC}"
if curl -s http://localhost:8085/ > /dev/null 2>&1; then
    JENKINS_VERSION=$(curl -s -I http://localhost:8085/ 2>/dev/null | grep -i 'X-Jenkins:' || echo "Unknown version")
    echo -e "${GREEN}✓ Jenkins is running${NC}"
    echo "   URL: http://localhost:8085/"
else
    echo -e "${RED}✗ Jenkins not accessible at http://localhost:8085/${NC}"
    echo "   Start Jenkins and try again"
fi
echo ""

# Check 5: Tomcat
echo -e "${YELLOW}[5/7] Checking Tomcat...${NC}"
if curl -s http://localhost:9090/ > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Tomcat is running${NC}"
    echo "   URL: http://localhost:9090/"
else
    echo -e "${RED}✗ Tomcat not accessible at http://localhost:9090/${NC}"
    echo "   Start Tomcat and try again"
fi
echo ""

# Check 6: Tomcat Manager
echo -e "${YELLOW}[6/7] Checking Tomcat Manager...${NC}"
if curl -s -u admin:admin http://localhost:9090/manager/text/list 2>&1 | grep -q "OK"; then
    echo -e "${GREEN}✓ Tomcat Manager accessible (admin/admin)${NC}"
    curl -s -u admin:admin http://localhost:9090/manager/text/list | head -5
else
    echo -e "${RED}✗ Tomcat Manager credentials issue${NC}"
    echo "   Try: curl -u admin:admin http://localhost:9090/manager/text/list"
fi
echo ""

# Check 7: Git Repository
echo -e "${YELLOW}[7/7] Checking Git Repository...${NC}"
if [ -d ".git" ]; then
    BRANCH=$(git branch --show-current)
    REMOTE=$(git remote get-url origin 2>/dev/null || echo "No remote")
    echo -e "${GREEN}✓ Git repository detected${NC}"
    echo "   Branch: $BRANCH"
    echo "   Remote: $REMOTE"
else
    echo -e "${RED}✗ Not a git repository${NC}"
fi
echo ""

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${GREEN}Frontend Application:${NC}"
echo "  - Location: crud_frontend/crud_frontend-main"
echo "  - Build: npm install && npm run build"
echo "  - Deploy Path: /frontapp1"
echo "  - Access: http://localhost:9090/frontapp1"
echo ""
echo -e "${GREEN}Backend Application:${NC}"
echo "  - Location: crud_backend/crud_backend-main"
echo "  - Build: mvn clean package"
echo "  - Deploy Path: /springapp1"
echo "  - Access: http://localhost:9090/springapp1"
echo ""
echo -e "${GREEN}Tomcat Manager:${NC}"
echo "  - URL: http://localhost:9090/manager/html"
echo "  - User: admin"
echo "  - Pass: admin"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "  1. Ensure all services are running (Jenkins, Tomcat)"
echo "  2. Review JENKINS_DEPLOYMENT_GUIDE.md"
echo "  3. Create Pipeline job in Jenkins"
echo "  4. Configure JDK, Maven, and NodeJS in Jenkins Tools"
echo "  5. Run the pipeline"
echo ""
