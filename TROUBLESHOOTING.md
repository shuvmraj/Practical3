#!/bin/bash

# Jenkins & Tomcat Troubleshooting Commands
# Use these commands to debug deployment issues

echo "==== JENKINS & TOMCAT TROUBLESHOOTING COMMANDS ===="
echo ""
echo "Copy and paste these commands in your terminal to troubleshoot"
echo ""

# Section 1: Check Services Status
echo "═══════════════════════════════════════════════════════════════"
echo "1️⃣  CHECK IF SERVICES ARE RUNNING"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "🔍 Check Jenkins:"
echo "   curl -s http://localhost:8085/ | head -20"
echo ""

echo "🔍 Check Tomcat:"
echo "   curl -s http://localhost:9090/ | head -20"
echo ""

echo "🔍 Check Tomcat Manager Access:"
echo "   curl -v -u admin:admin http://localhost:9090/manager/text/list"
echo ""

# Section 2: Maven Troubleshooting
echo "═══════════════════════════════════════════════════════════════"
echo "2️⃣  MAVEN & BACKEND TROUBLESHOOTING"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "✓ Check Maven version:"
echo "   mvn -v"
echo ""

echo "✓ Build backend locally:"
echo "   cd crud_backend/crud_backend-main"
echo "   mvn clean package -X"
echo ""

echo "✓ Check if backend WAR was created:"
echo "   ls -lh crud_backend/crud_backend-main/target/*.war"
echo ""

echo "✓ Clear Maven cache (if stuck):"
echo "   rm -rf ~/.m2/repository"
echo "   mvn clean package"
echo ""

# Section 3: Node.js/NPM Troubleshooting
echo "═══════════════════════════════════════════════════════════════"
echo "3️⃣  NODE.JS & FRONTEND TROUBLESHOOTING"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "✓ Check Node & NPM version:"
echo "   node -v && npm -v"
echo ""

echo "✓ Build frontend locally:"
echo "   cd crud_frontend/crud_frontend-main"
echo "   npm install"
echo "   npm run build"
echo ""

echo "✓ Check if dist folder exists:"
echo "   ls -la crud_frontend/crud_frontend-main/dist/"
echo ""

echo "✓ Clear npm cache (if stuck):"
echo "   npm cache clean --force"
echo "   rm -rf node_modules package-lock.json"
echo "   npm install"
echo ""

# Section 4: Tomcat Logs
echo "═══════════════════════════════════════════════════════════════"
echo "4️⃣  VIEW TOMCAT LOGS"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "✓ Find Tomcat home (macOS Homebrew):"
echo "   brew --prefix tomcat"
echo ""

echo "✓ Or find manually:"
echo "   find /Library -name 'tomcat*' -type d 2>/dev/null"
echo "   find ~/* -name 'tomcat*' -type d 2>/dev/null"
echo ""

echo "✓ View real-time Tomcat logs:"
echo "   tail -f \$CATALINA_HOME/logs/catalina.out"
echo ""

echo "✓ View today's application logs:"
echo "   tail -f \$CATALINA_HOME/logs/localhost.\$(date +%Y-%m-%d).log"
echo ""

echo "✓ View last 100 lines of catalina logs:"
echo "   tail -100 \$CATALINA_HOME/logs/catalina.out"
echo ""

# Section 5: Java/JDK Troubleshooting
echo "═══════════════════════════════════════════════════════════════"
echo "5️⃣  JAVA & JDK TROUBLESHOOTING"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "✓ Check Java version:"
echo "   java -version"
echo ""

echo "✓ Find Java installation path:"
echo "   which java"
echo "   /usr/libexec/java_home -v 17"
echo ""

echo "✓ List all Java installations (macOS):"
echo "   /usr/libexec/java_home -V"
echo ""

# Section 6: Database Troubleshooting
echo "═══════════════════════════════════════════════════════════════"
echo "6️⃣  DATABASE TROUBLESHOOTING"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "✓ Test MySQL connection:"
echo "   mysql -h database-1.ckhoqoim0209.us-east-1.rds.amazonaws.com -u admin -p"
echo "   (Password: adminadmin)"
echo ""

echo "✓ List databases:"
echo "   SHOW DATABASES;"
echo ""

echo "✓ Check database exists:"
echo "   SHOW DATABASES LIKE 'cicd';"
echo ""

# Section 7: Process Management
echo "═══════════════════════════════════════════════════════════════"
echo "7️⃣  PROCESS MANAGEMENT"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "✓ Check running Java processes:"
echo "   ps aux | grep java"
echo ""

echo "✓ Kill running Tomcat (if stuck):"
echo "   pkill -f tomcat"
echo "   sleep 2"
echo "   \$CATALINA_HOME/bin/startup.sh"
echo ""

echo "✓ Check which process is using port 8085 (Jenkins):"
echo "   lsof -i :8085"
echo ""

echo "✓ Check which process is using port 9090 (Tomcat):"
echo "   lsof -i :9090"
echo ""

echo "✓ Kill process on specific port:"
echo "   kill -9 <PID>"
echo ""

# Section 8: Network Troubleshooting
echo "═══════════════════════════════════════════════════════════════"
echo "8️⃣  NETWORK & CONNECTIVITY TESTS"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "✓ Test Jenkins connectivity:"
echo "   curl -v http://localhost:8085/"
echo ""

echo "✓ Test Tomcat connectivity:"
echo "   curl -v http://localhost:9090/"
echo ""

echo "✓ Test Tomcat Manager (verbose):"
echo "   curl -v -u admin:admin http://localhost:9090/manager/html"
echo ""

echo "✓ Test deployed applications:"
echo "   curl -v http://localhost:9090/springapp1/"
echo "   curl -v http://localhost:9090/frontapp1/"
echo ""

# Section 9: Jenkins Troubleshooting
echo "═══════════════════════════════════════════════════════════════"
echo "9️⃣  JENKINS SPECIFIC TROUBLESHOOTING"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "✓ Jenkins log file (typical locations):"
echo "   ~/.jenkins/logs/all.log"
echo "   tail -f ~/.jenkins/logs/all.log"
echo ""

echo "✓ Find Jenkins home:"
echo "   echo \$JENKINS_HOME"
echo "   ps aux | grep jenkins"
echo ""

echo "✓ Restart Jenkins (if running as service on macOS):"
echo "   brew services restart jenkins"
echo ""

# Section 10: Git & Repository
echo "═══════════════════════════════════════════════════════════════"
echo "🔟  GIT & REPOSITORY TROUBLESHOOTING"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "✓ Check current branch:"
echo "   git branch"
echo ""

echo "✓ Check remote URL:"
echo "   git remote -v"
echo ""

echo "✓ Pull latest changes:"
echo "   git pull origin main"
echo ""

echo "✓ Check git status:"
echo "   git status"
echo ""

# Section 11: WAR File Inspection
echo "═══════════════════════════════════════════════════════════════"
echo "1️⃣1️⃣  WAR FILE INSPECTION"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "✓ List WAR files in workspace:"
echo "   find . -name '*.war' -type f"
echo ""

echo "✓ Check WAR file size:"
echo "   ls -lh *.war"
echo ""

echo "✓ Extract and inspect WAR contents:"
echo "   jar -tf frontapp1.war | head -20"
echo "   jar -tf cruddemo-0.0.1-SNAPSHOT.war | head -20"
echo ""

echo "✓ Extract WAR to verify contents:"
echo "   unzip -l frontapp1.war"
echo ""

# Section 12: Common Fixes
echo "═══════════════════════════════════════════════════════════════"
echo "1️⃣2️⃣  QUICK FIXES"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo "🔧 NUCLEAR OPTION (if nothing else works):"
echo ""
echo "   1. Stop Jenkins:"
echo "      brew services stop jenkins (or manual stop)"
echo ""
echo "   2. Stop Tomcat:"
echo "      \$CATALINA_HOME/bin/shutdown.sh"
echo "      pkill -f tomcat"
echo ""
echo "   3. Clear caches:"
echo "      rm -rf ~/.m2/repository"
echo "      npm cache clean --force"
echo ""
echo "   4. Clear Tomcat webapps:"
echo "      rm -rf \$CATALINA_HOME/webapps/springapp1"
echo "      rm -rf \$CATALINA_HOME/webapps/frontapp1"
echo ""
echo "   5. Restart services:"
echo "      brew services start jenkins"
echo "      \$CATALINA_HOME/bin/startup.sh"
echo ""
echo "   6. Rebuild and redeploy"
echo ""

echo "═══════════════════════════════════════════════════════════════"
echo "✅ DEPLOYMENT CHECKLIST"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "Before running Jenkins pipeline, verify:"
echo ""
echo "☐ Jenkins is running and accessible"
echo "☐ Tomcat is running and accessible"
echo "☐ Tomcat manager is accessible (admin/admin)"
echo "☐ Java 17 is installed"
echo "☐ Maven is installed"
echo "☐ Node.js is installed"
echo "☐ Database is accessible"
echo "☐ Git repository is accessible"
echo "☐ Local build works (mvn & npm)"
echo ""
echo "═══════════════════════════════════════════════════════════════"
