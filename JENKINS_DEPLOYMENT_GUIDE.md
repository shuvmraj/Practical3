# Jenkins Deployment Guide for Full Stack Application

## Overview
This guide explains how to set up and deploy your full-stack CRUD application (React frontend + Spring Boot backend) using Jenkins, with both applications running on Apache Tomcat.

**Environment:**
- Jenkins: `http://localhost:8085/`
- Tomcat: `http://localhost:9090/`
- Tomcat Manager: `http://localhost:9090/manager/html`

---

## Prerequisites

### 1. Verify Tomcat Setup
```bash
# Check if Tomcat is running
curl -s http://localhost:9090/ | head -20

# Access Tomcat Manager (admin/admin)
curl -u admin:admin http://localhost:9090/manager/text/list
```

### 2. Verify Jenkins Setup
- Navigate to: `http://localhost:8085/`
- Ensure you have admin access

---

## Jenkins Configuration Steps

### Step 1: Install Required Plugins

1. Go to **Manage Jenkins** → **Plugins**
2. Search for and install:
   - **Maven Integration Plugin** (for Spring Boot build)
   - **NodeJS Plugin** (for React build)
   - **Pipeline Plugin** (if not already installed)

### Step 2: Configure JDK in Jenkins

1. Go to **Manage Jenkins** → **Tools**
2. Scroll to **JDK** section
3. Click **Add JDK**
   - Name: `JDK_HOME`
   - JAVA_HOME: `/Library/Java/JavaVirtualMachines/openjdk17.jdk/Contents/Home` (adjust for your JDK 17 path)
   - Leave "Install automatically" unchecked

### Step 3: Configure Maven in Jenkins

1. In **Manage Jenkins** → **Tools** → **Maven**
2. Click **Add Maven**
   - Name: `MAVEN_HOME`
   - MAVEN_HOME: Leave empty or point to your Maven installation
   - Select "Install automatically" and choose the latest version
   - Or point to your local Maven: `/usr/local/opt/maven` (if using Homebrew)

### Step 4: Configure NodeJS in Jenkins

1. In **Manage Jenkins** → **Tools** → **NodeJS**
2. Click **Add NodeJS**
   - Name: `NODE_HOME`
   - Version: Select `latest` or `20.x` or `18.x`
   - Select "Install automatically"

### Step 5: Create a New Pipeline Job

1. Click **New Item**
2. Enter job name: `FullStack-CRUD-Deploy`
3. Select **Pipeline**
4. Click **OK**

### Step 6: Configure Pipeline

1. Under **Pipeline** section, select **Pipeline script from SCM**
2. Select **Git**
3. Enter repository URL:
   ```
   https://github.com/shuvmraj/Practical3.git
   ```
   (or your local repo URL)
4. Enter credentials if needed
5. Specify branch: `*/main`
6. Script path: `Jenkinsfile`
7. Click **Save**

---

## Pre-Deployment Checks

### Check 1: Tomcat Manager Access
```bash
# Test Tomcat Manager credentials
curl -u admin:admin http://localhost:9090/manager/text/list

# Expected output:
# OK - Server information
# /manager:running:0:manager
# /host-manager:running:0:host-manager
```

### Check 2: Database Connection
Verify that your MySQL database is accessible:
```bash
# Check backend application.properties for correct DB details:
# - URL: jdbc:mysql://database-1.ckhoqoim0209.us-east-1.rds.amazonaws.com:3306/cicd
# - Username: root
# - Password: Shubham@16
```

### Check 3: Local Build Test
```bash
cd crud_backend/crud_backend-main
./mvnw clean package

cd ../../crud_frontend/crud_frontend-main
npm install
npm run build
```

---

## Running the Pipeline

1. Go to your Jenkins job: `FullStack-CRUD-Deploy`
2. Click **Build Now**
3. Monitor the build in **Console Output**

### Build Stages:
1. ✅ **Checkout** - Clones the repository
2. ✅ **Build Frontend** - npm install + npm run build
3. ✅ **Package Frontend as WAR** - Creates frontapp1.war
4. ✅ **Build Backend** - mvn clean package
5. ✅ **Verify Artifacts** - Checks WAR files exist
6. ✅ **Deploy Backend to Tomcat** - Uploads cruddemo-0.0.1-SNAPSHOT.war to /springapp1
7. ✅ **Deploy Frontend to Tomcat** - Uploads frontapp1.war to /frontapp1
8. ✅ **Verify Deployment** - Health checks and listing

---

## Accessing Deployed Applications

After successful deployment:

### Backend (Spring Boot API)
- URL: `http://localhost:9090/springapp1`
- API endpoints: `http://localhost:9090/springapp1/api/...`

### Frontend (React)
- URL: `http://localhost:9090/frontapp1`
- Interacts with backend via API

### Tomcat Manager Console
- URL: `http://localhost:9090/manager/html`
- Username: `admin`
- Password: `admin`
- From here you can:
  - Start/Stop applications
  - View deployed apps
  - Monitor sessions
  - Undeploy applications

---

## Troubleshooting

### Issue 1: "Frontend WAR not found"
**Solution:**
```bash
# Manually build and verify
cd crud_frontend/crud_frontend-main
npm install
npm run build
# Check that dist/ directory exists with files
```

### Issue 2: "Backend WAR not found"
**Solution:**
```bash
cd crud_backend/crud_backend-main
./mvnw clean package -X  # -X for debug output
# Check target/ directory has the WAR file
```

### Issue 3: Tomcat Deployment Fails (403 Forbidden)
**Solution:**
- Verify Tomcat manager credentials in Jenkinsfile
- Check Tomcat is running: `curl http://localhost:9090/`
- SSH into Tomcat server and check logs:
  ```bash
  tail -f $CATALINA_HOME/logs/catalina.out
  ```

### Issue 4: Applications showing 404
**Solution:**
1. Check Tomcat Manager Console
2. Verify apps are in "running" state
3. Check Tomcat logs:
   ```bash
   tail -100 $CATALINA_HOME/logs/catalina.$(date +%Y-%m-%d).log
   ```

### Issue 5: Database Connection Error
**Solution:**
- Verify MySQL RDS endpoint is accessible
- Check database credentials in `application.properties`
- Test connection:
  ```bash
  mysql -h database-1.ckhoqoim0209.us-east-1.rds.amazonaws.com -u admin -p
  ```

### Issue 6: CORS Issues Between Frontend and Backend
**Solution:**
Add CORS configuration to your backend `AppController.java`:
```java
@CrossOrigin(origins = "http://localhost:9090")
@RestController
@RequestMapping("/api")
public class AppController {
    // Your endpoints
}
```

---

## Pipeline Execution Flow

```
START
  ↓
CHECKOUT (Git clone)
  ↓
BUILD FRONTEND (npm install + build)
  ↓
PACKAGE FRONTEND (Create WAR)
  ↓
BUILD BACKEND (Maven package)
  ↓
VERIFY ARTIFACTS (Check WAR files)
  ↓
DEPLOY BACKEND (Upload to /springapp1)
  ↓
DEPLOY FRONTEND (Upload to /frontapp1)
  ↓
VERIFY DEPLOYMENT (Health checks)
  ↓
SUCCESS/FAILURE POST
```

---

## Automated Deployments

### Enable Webhook for Automatic Builds (Optional)

1. In GitHub repository → **Settings** → **Webhooks**
2. Add webhook:
   - Payload URL: `http://your-jenkins-server:8085/github-webhook/`
   - Content type: `application/json`
   - Trigger: `Just the push event`
3. In Jenkins job → Configure → **Build Triggers** → Check `GitHub hook trigger`

Now every git push will automatically trigger the pipeline!

---

## Monitoring & Logs

### Jenkins Console Log
View real-time build logs in Jenkins UI:
- Job → Build # → Console Output

### Tomcat Logs
```bash
# View catalina logs
tail -f $CATALINA_HOME/logs/catalina.out

# View application logs
tail -f $CATALINA_HOME/logs/localhost.$(date +%Y-%m-%d).log
```

### Application Logs
For Spring Boot application, logs are typically in:
```
$CATALINA_HOME/webapps/springapp1/logs/
```

---

## Rollback Procedure

If you need to rollback to a previous version:

1. **From Tomcat Manager:**
   - Go to `http://localhost:9090/manager/html`
   - Find your application
   - Click the red "X" to undeploy

2. **Redeploy Previous Version:**
   - Option A: Rebuild previous commit in Jenkins
   - Option B: Manually upload previous WAR file via Manager

---

## Performance Tips

1. **Skip Tests on Deploy:** Add `-DskipTests` flag in Maven (already in Jenkinsfile)
2. **Enable Caching:** Jenkins will cache npm and Maven artifacts
3. **Parallel Builds:** Configure Jenkins executor count for parallel builds
4. **Monitor Memory:** 
   ```bash
   # Check Tomcat memory usage
   ps aux | grep tomcat
   ```

---

## Additional Resources

- [Jenkins Documentation](https://jenkins.io/doc/)
- [Apache Tomcat Manager](https://tomcat.apache.org/tomcat-9.0-doc/manager-howto.html)
- [Spring Boot WAR Deployment](https://spring.io/guides/gs/convert-jar-to-war/)
- [Vite Build Guide](https://vitejs.dev/guide/build.html)

---

## Contact & Support

For issues, check:
1. Jenkins Console Output
2. Tomcat logs
3. Application error logs
4. Database connectivity

---

**Last Updated:** October 24, 2025
**Status:** Ready for Deployment ✅
