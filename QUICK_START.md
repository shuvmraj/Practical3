# 🚀 Quick Start Guide - Jenkins Deployment

## What You Have
✅ Spring Boot Backend (React + MySQL integration)  
✅ React Frontend (Vite)  
✅ Updated Jenkinsfile (configured for localhost)  

## What You Need
- ✅ Jenkins running on `http://localhost:8085/`
- ✅ Tomcat running on `http://localhost:9090/`
- ✅ Java 17 installed
- ✅ Maven installed
- ✅ Node.js installed

---

## Step 1: Verify Your Environment (2 minutes)

```bash
cd /Users/shubhamraj/Desktop/CICD\ SKILL/Practical3

# Make the check script executable
chmod +x check-env.sh

# Run environment check
./check-env.sh
```

This will verify:
- ✅ Java/JDK
- ✅ Maven
- ✅ Node.js
- ✅ Jenkins accessibility
- ✅ Tomcat accessibility
- ✅ Tomcat Manager credentials

---

## Step 2: Configure Jenkins (10 minutes)

### 2a. Access Jenkins
Open: `http://localhost:8085/`

### 2b. Install Required Plugins
1. **Manage Jenkins** → **Plugins** (or **Manage Plugins**)
2. Go to **Available** tab
3. Search and install:
   - ✅ `Maven Integration`
   - ✅ `NodeJS`
   - ✅ `Pipeline` (usually pre-installed)
4. Restart Jenkins (if needed)

### 2c. Configure Tools

#### Configure JDK:
1. **Manage Jenkins** → **Tools** → **JDK**
2. Click **Add JDK**
   - **Name:** `JDK_HOME`
   - **JAVA_HOME:** (find yours with `which java` → go up to JDK folder)
     - Example macOS Homebrew: `/opt/homebrew/opt/openjdk@17`
     - Example Oracle: `/Library/Java/JavaVirtualMachines/jdk-17.0.x.jdk/Contents/Home`
   - Leave "Install automatically" **unchecked**
3. **Save**

#### Configure Maven:
1. **Manage Jenkins** → **Tools** → **Maven**
2. Click **Add Maven**
   - **Name:** `MAVEN_HOME`
   - **MAVEN_HOME:** Leave empty
   - Check "Install automatically" → Select latest version
   - OR provide your Maven path: `/opt/homebrew/opt/maven` (Homebrew)
3. **Save**

#### Configure NodeJS:
1. **Manage Jenkins** → **Tools** → **NodeJS**
2. Click **Add NodeJS**
   - **Name:** `NODE_HOME`
   - **Version:** Select `20.x` or `latest`
   - Check "Install automatically"
3. **Save**

---

## Step 3: Create Pipeline Job (5 minutes)

1. Jenkins Home → **New Item**
2. **Job Name:** `FullStack-CRUD-Deploy`
3. **Type:** Select **Pipeline**
4. Click **OK**

### Configure Pipeline:
1. Scroll to **Pipeline** section
2. **Definition:** Select **Pipeline script from SCM**
3. **SCM:** Select **Git**
4. **Repository URL:** 
   ```
   https://github.com/shuvmraj/Practical3.git
   ```
   (or `/Users/shubhamraj/Desktop/CICD\ SKILL/Practical3` for local)
5. **Credentials:** Skip (public repo or use your credentials)
6. **Branch Specifier:** `*/main`
7. **Script Path:** `Jenkinsfile`
8. Click **Save**

---

## Step 4: Run the Pipeline (5-10 minutes)

1. Open your job: `FullStack-CRUD-Deploy`
2. Click **Build Now**
3. Click the build number (e.g., `#1`)
4. Watch **Console Output** in real-time

### Expected Output Flow:
```
✓ Checkout - Clone repository
✓ Build Frontend - npm install + build
✓ Package Frontend as WAR - Create frontapp1.war
✓ Build Backend - mvn clean package
✓ Verify Artifacts - Check WAR files
✓ Deploy Backend to Tomcat - Upload to /springapp1
✓ Deploy Frontend to Tomcat - Upload to /frontapp1
✓ Verify Deployment - Health checks
```

---

## Step 5: Access Your Applications

Once build succeeds:

### ✅ Backend API
```
http://localhost:9090/springapp1
```

### ✅ Frontend App
```
http://localhost:9090/frontapp1
```

### ✅ Tomcat Manager (Monitor Apps)
```
http://localhost:9090/manager/html
Username: admin
Password: admin
```

---

## 🔥 Common Issues & Fixes

### Issue: "Maven not found"
**Fix:**
```bash
# Install Maven
brew install maven

# Or download from: https://maven.apache.org/download.cgi
# Set MAVEN_HOME in Jenkins Tools
```

### Issue: "Node not found"
**Fix:**
```bash
# Install Node.js
brew install node

# Or download: https://nodejs.org/
# Jenkins will auto-install if you check "Install automatically"
```

### Issue: Tomcat Manager 403 Error
**Fix:**
1. Check Tomcat `conf/tomcat-users.xml`
2. Ensure user has manager-script role:
   ```xml
   <user username="admin" password="admin" roles="manager-gui,manager-script" />
   ```
3. Restart Tomcat

### Issue: Build Fails - "Port 9090 refused"
**Fix:**
```bash
# Check if Tomcat is running
curl http://localhost:9090/

# If not, start Tomcat
$CATALINA_HOME/bin/startup.sh

# Or (if using Homebrew)
brew services start tomcat
```

### Issue: Database Connection Error
**Fix:** Check `crud_backend/crud_backend-main/src/main/resources/application.properties`
```properties
spring.datasource.url=jdbc:mysql://YOUR_HOST:3306/YOUR_DB
spring.datasource.username=YOUR_USER
spring.datasource.password=YOUR_PASS
```

---

## 📊 Pipeline Stages Explained

| Stage | What it Does | Duration |
|-------|-------------|----------|
| **Checkout** | Clone code from git | 5s |
| **Build Frontend** | npm install + npm run build | 30-60s |
| **Package Frontend** | Create WAR from dist folder | 5s |
| **Build Backend** | mvn clean package (Spring Boot) | 60-120s |
| **Verify Artifacts** | Check WAR files exist | 2s |
| **Deploy Backend** | Upload to Tomcat /springapp1 | 10-15s |
| **Deploy Frontend** | Upload to Tomcat /frontapp1 | 10-15s |
| **Verify Deployment** | Health checks | 10s |

**Total Estimated Time:** 2-4 minutes (first run may take longer for Maven/npm downloads)

---

## 🎯 Success Indicators

After build completes, you should see:

✅ **Console Output:**
```
✅ Backend deployment triggered
✅ Frontend deployment triggered
```

✅ **Tomcat Manager** (`http://localhost:9090/manager/html`):
- `/springapp1` shown as **running**
- `/frontapp1` shown as **running**

✅ **Application URLs:**
- Backend: `http://localhost:9090/springapp1` returns 200 OK
- Frontend: `http://localhost:9090/frontapp1` loads HTML

---

## 🔄 Re-run Deployment

To deploy again after making changes:

1. Push changes to git repository
2. In Jenkins, click **Build Now**
3. Monitor console output
4. Check applications are updated

Or enable **webhook** for automatic builds on every git push!

---

## 📚 Detailed Documentation

For more detailed setup instructions, see:
👉 **JENKINS_DEPLOYMENT_GUIDE.md** (in your project root)

---

## 💡 Tips

- **First build is slow:** Maven and npm will download dependencies
- **Subsequent builds are faster:** Dependencies are cached
- **Check logs:** Jenkins Console Output + Tomcat logs (`$CATALINA_HOME/logs/`)
- **Restart services:** Sometimes helps - restart Jenkins and/or Tomcat
- **Clear Tomcat:** Remove old apps from Manager before redeploying

---

## ✨ You're All Set!

Your full-stack application is ready for CI/CD deployment. 

**Next Step:** Run `Build Now` in your Jenkins job and watch the magic happen! 🎉

---

Need help? Check the detailed guide: `JENKINS_DEPLOYMENT_GUIDE.md`
