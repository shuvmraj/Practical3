# 🎯 Full Stack Deployment Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                          YOUR MACHINE                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────────────┐          ┌──────────────────────┐    │
│  │   Git Repository    │          │   Your Source Code   │    │
│  │ Practical3 (GitHub) │◄─────────┤  /Users/shubhamraj/  │    │
│  └─────────────────────┘          │  Desktop/CICD SKILL/ │    │
│           △                        │  Practical3/         │    │
│           │                        └──────────────────────┘    │
│           │ (webhook)                                           │
│           │                                                     │
│  ┌────────┴──────────┐                                          │
│  │                   │                                          │
│  ▼                   ▼                                          │
│ ┌────────────────────────────────────────────────────────────┐ │
│ │  JENKINS (http://localhost:8085/)                         │ │
│ │  ┌──────────────────────────────────────────────────────┐ │ │
│ │  │  Pipeline: FullStack-CRUD-Deploy                   │ │ │
│ │  │                                                      │ │ │
│ │  │  Stage 1: Checkout                                 │ │ │
│ │  │    └─► Git Clone                                   │ │ │
│ │  │                                                      │ │ │
│ │  │  Stage 2: Build Frontend                           │ │ │
│ │  │    └─► npm install + npm run build                 │ │ │
│ │  │        Output: dist/ folder                        │ │ │
│ │  │                                                      │ │ │
│ │  │  Stage 3: Package Frontend                         │ │ │
│ │  │    └─► Create frontapp1.war                        │ │ │
│ │  │                                                      │ │ │
│ │  │  Stage 4: Build Backend                            │ │ │
│ │  │    └─► mvn clean package                           │ │ │
│ │  │        Output: cruddemo-0.0.1-SNAPSHOT.war        │ │ │
│ │  │                                                      │ │ │
│ │  │  Stage 5: Deploy Backend                           │ │ │
│ │  │    └─► Upload to Tomcat /springapp1               │ │ │
│ │  │                                                      │ │ │
│ │  │  Stage 6: Deploy Frontend                          │ │ │
│ │  │    └─► Upload to Tomcat /frontapp1                │ │ │
│ │  │                                                      │ │ │
│ │  │  Stage 7: Verify Deployment                        │ │ │
│ │  │    └─► Health Checks                               │ │ │
│ │  │                                                      │ │ │
│ │  └──────────────────────────────────────────────────────┘ │ │
│ │                                                             │ │
│ └────────────────────────────────────────────────────────────┘ │
│                            │                                    │
│                            │ (Deploys)                          │
│                            ▼                                    │
│ ┌────────────────────────────────────────────────────────────┐ │
│ │  TOMCAT (http://localhost:9090/)                          │ │
│ │  ┌──────────────────────────────────────────────────────┐ │ │
│ │  │  Deployed Applications:                              │ │ │
│ │  │                                                      │ │ │
│ │  │  ┌────────────────────────────────────────────────┐ │ │
│ │  │  │ /springapp1 (Spring Boot Backend)             │ │ │
│ │  │  │ ├─ API Endpoints:                            │ │ │
│ │  │  │ │  ├─ GET    /api/products                  │ │ │
│ │  │  │ │  ├─ POST   /api/products                  │ │ │
│ │  │  │ │  ├─ PUT    /api/products/{id}             │ │ │
│ │  │  │ │  └─ DELETE /api/products/{id}             │ │ │
│ │  │  │ └─ Database: MySQL RDS (AWS)                │ │ │
│ │  │  └────────────────────────────────────────────────┘ │ │
│ │  │                                                      │ │ │
│ │  │  ┌────────────────────────────────────────────────┐ │ │
│ │  │  │ /frontapp1 (React Frontend)                   │ │ │
│ │  │  │ ├─ Static Files (HTML/CSS/JS)               │ │ │
│ │  │  │ ├─ React Components                         │ │ │
│ │  │  │ └─ Axios API Calls to /springapp1/api       │ │ │
│ │  │  └────────────────────────────────────────────────┘ │ │
│ │  │                                                      │ │ │
│ │  │  ┌────────────────────────────────────────────────┐ │ │
│ │  │  │ /manager/html (Tomcat Manager)               │ │ │
│ │  │  │ ├─ Deploy/Undeploy apps                     │ │ │
│ │  │  │ ├─ Start/Stop apps                          │ │ │
│ │  │  │ ├─ View logs                                │ │ │
│ │  │  │ └─ User: admin, Pass: admin                │ │ │
│ │  │  └────────────────────────────────────────────────┘ │ │
│ │  │                                                      │ │ │
│ │  └──────────────────────────────────────────────────────┘ │ │
│ │                                                             │ │
│ └────────────────────────────────────────────────────────────┘ │
│           │                                      │              │
│           │ (Serves)                            │ (Queries)    │
│           ▼                                      ▼              │
│  ┌──────────────────┐              ┌───────────────────────┐   │
│  │  Web Browsers    │              │  MySQL Database       │   │
│  │                  │              │  (AWS RDS)            │   │
│  │ localhost:9090   │              │                       │   │
│  │ /springapp1      │◄────────────►│ cicd database         │   │
│  │ /frontapp1       │              │ (user: admin)         │   │
│  └──────────────────┘              └───────────────────────┘   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Data Flow Diagram

```
1. LOCAL DEVELOPMENT
   ┌─────────────┐
   │ Git Commit  │ Developer makes changes
   └──────┬──────┘
          │
          ▼
   ┌─────────────────────┐
   │ Push to Repository  │
   └──────┬──────────────┘
          │
          │ (Webhook triggers)
          ▼
2. JENKINS PIPELINE
   ┌──────────────────────┐
   │ Checkout Code        │ Git pulls latest
   └──────┬───────────────┘
          │
          ▼
   ┌──────────────────────┐
   │ Build Frontend       │ npm install
   │                      │ npm run build → dist/
   └──────┬───────────────┘
          │
          ▼
   ┌──────────────────────┐
   │ Build Backend        │ mvn clean package
   │                      │ → cruddemo.war
   └──────┬───────────────┘
          │
          ▼
   ┌──────────────────────┐
   │ Verify Artifacts     │ Check WAR files
   └──────┬───────────────┘
          │
          ▼
3. DEPLOYMENT TO TOMCAT
   ┌──────────────────────────┐
   │ Deploy Frontend WAR      │ frontapp1.war
   │ To: /springapp1          │ → /manager/text/deploy
   └──────┬───────────────────┘
          │
          ▼
   ┌──────────────────────────┐
   │ Deploy Backend WAR       │ cruddemo.war
   │ To: /frontapp1           │ → /manager/text/deploy
   └──────┬───────────────────┘
          │
          ▼
4. RUNTIME
   ┌──────────────────────────┐
   │ Tomcat Starts Apps       │
   │ - Loads class files      │
   │ - Initializes servlets   │
   │ - Opens DB connections   │
   └──────┬───────────────────┘
          │
          ▼
   ┌──────────────────────────┐
   │ Applications Ready       │
   │ - React Frontend serves  │
   │ - Spring Boot API ready  │
   │ - Database connected    │
   └──────────────────────────┘
```

---

## Component Interaction

```
┌─────────────────────────────────────────────────────────────────┐
│                          USER'S BROWSER                         │
│                                                                  │
│  Opens: http://localhost:9090/frontapp1                        │
│                                                                  │
└────┬────────────────────────────────────────────────────────────┘
     │
     │ (HTTP GET)
     ▼
┌─────────────────────────────────────────────────────────────────┐
│                   TOMCAT SERVER (9090)                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ /frontapp1 (React Application)                           │  │
│  │                                                           │  │
│  │  Serves:                                                 │  │
│  │  - index.html                                            │  │
│  │  - App.jsx (React Components)                            │  │
│  │  - CSS files                                             │  │
│  │  - JavaScript bundles                                    │  │
│  │                                                           │  │
│  │  User Action: Click "Get Products"                       │  │
│  │       │                                                   │  │
│  │       ▼                                                   │  │
│  │  ┌─────────────────────────────────────────────────┐    │  │
│  │  │ axios.get('/api/products')                      │    │  │
│  │  │                                                  │    │  │
│  │  │ Makes AJAX call to:                            │    │  │
│  │  │ http://localhost:9090/springapp1/api/products │    │  │
│  │  └─────────────────────────────────────────────────┘    │  │
│  │       │                                                   │  │
│  │       ▼                                                   │  │
│  └──────────────────────────────────────────────────────────┘  │
│         │                                                       │
└─────────┼───────────────────────────────────────────────────────┘
          │
          │ (HTTP GET /api/products)
          ▼
┌─────────────────────────────────────────────────────────────────┐
│                   TOMCAT SERVER (9090)                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ /springapp1 (Spring Boot Application)                    │  │
│  │                                                           │  │
│  │  RequestMapping:                                         │  │
│  │  GET /api/products                                       │  │
│  │       │                                                   │  │
│  │       ▼                                                   │  │
│  │  ┌─────────────────────────────────────────────────┐    │  │
│  │  │ AppController                                   │    │  │
│  │  │ - Receives request                             │    │  │
│  │  │ - Calls Service layer                          │    │  │
│  │  └──────────────┬────────────────────────────────┘    │  │
│  │                 │                                       │  │
│  │                 ▼                                       │  │
│  │  ┌─────────────────────────────────────────────────┐    │  │
│  │  │ Service                                         │    │  │
│  │  │ - Business logic                               │    │  │
│  │  │ - Calls Repository                             │    │  │
│  │  └──────────────┬────────────────────────────────┘    │  │
│  │                 │                                       │  │
│  │                 ▼                                       │  │
│  │  ┌─────────────────────────────────────────────────┐    │  │
│  │  │ Repository (JPA)                               │    │  │
│  │  │ - Queries database                             │    │  │
│  │  └──────────────┬────────────────────────────────┘    │  │
│  │                 │                                       │  │
│  │                 ▼                                       │  │
│  └──────────────────────────────────────────────────────────┘  │
│                   │                                             │
└───────────────────┼─────────────────────────────────────────────┘
                    │
                    │ (JDBC Query)
                    ▼
┌─────────────────────────────────────────────────────────────────┐
│              MySQL Database (AWS RDS)                           │
│                                                                  │
│  database-1.ckhoqoim0209.us-east-1.rds.amazonaws.com:3306     │
│                                                                  │
│  Database: cicd                                                 │
│  Table: product                                                 │
│                                                                  │
│  SELECT * FROM product;                                         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                    │
                    │ (Result Set)
                    ▼
        Returns JSON: [
          {
            "id": 1,
            "name": "Product 1",
            "price": 100
          },
          ...
        ]
                    │
                    ▼
         (HTTP Response 200 OK)
                    │
                    ▼
        React Frontend receives data
        Renders Product list on UI
                    │
                    ▼
        User sees products in browser!
```

---

## Deployment Architecture

```
BEFORE DEPLOYMENT:
┌──────────────────┐       ┌──────────────────┐
│  Jenkins Build   │       │  Local Artifacts │
│  ┌────────────┐  │       │  ┌────────────┐  │
│  │ WAR Files  │  │──────►│  │ cruddemo   │  │
│  │            │  │       │  │ .war       │  │
│  │ frontapp1  │  │       │  │            │  │
│  │ .war       │  │       │  │ frontapp1  │  │
│  └────────────┘  │       │  │ .war       │  │
└──────────────────┘       └──────────────────┘


DEPLOYMENT PROCESS:
┌──────────────────────────────┐
│   Jenkins Deploy Stage       │
│                              │
│  curl -u admin:admin \       │
│    --upload-file backend.war │
│    http://localhost:9090/    │
│    manager/text/deploy       │
│    ?path=/springapp1         │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│   Tomcat Manager             │
│                              │
│  1. Receives WAR             │
│  2. Extracts to              │
│     webapps/springapp1/      │
│  3. Loads classes            │
│  4. Starts application       │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│   Tomcat Webapps             │
│                              │
│  ├─ manager/                 │
│  ├─ host-manager/            │
│  ├─ springapp1/ ✅ RUNNING   │
│  │  ├─ WEB-INF/              │
│  │  ├─ lib/                  │
│  │  ├─ classes/              │
│  │  └─ ...                   │
│  └─ frontapp1/ ✅ RUNNING    │
│     ├─ index.html            │
│     ├─ css/                  │
│     ├─ js/                   │
│     └─ ...                   │
└──────────────┬───────────────┘
               │
               ▼
        Applications Ready!
        User can access via:
        - Backend: :9090/springapp1
        - Frontend: :9090/frontapp1
```

---

## Pipeline Execution Timeline

```
TIME    STAGE                       DURATION    STATUS
────────────────────────────────────────────────────────
00:00   Checkout                    5s          ✅
00:05   Build Frontend (npm)        30-60s      ✅
01:05   Package Frontend WAR        5s          ✅
01:10   Build Backend (Maven)       60-120s     ✅
02:30   Verify Artifacts            2s          ✅
02:32   Deploy Backend              10-15s      ✅
02:47   Deploy Frontend             10-15s      ✅
03:02   Verify Deployment           10s         ✅
────────────────────────────────────────────────────────
03:12   ✅ PIPELINE COMPLETE
        Applications Ready at:
        - http://localhost:9090/springapp1
        - http://localhost:9090/frontapp1
```

---

## File Structure

```
Practical3/
├── Jenkinsfile                          ← Pipeline configuration
├── JENKINS_DEPLOYMENT_GUIDE.md         ← Detailed setup guide
├── QUICK_START.md                      ← Quick start guide
├── TROUBLESHOOTING.md                  ← Troubleshooting commands
├── ARCHITECTURE.md                     ← This file
├── check-env.sh                        ← Environment verification
│
├── crud_backend/
│   └── crud_backend-main/
│       ├── pom.xml                     ← Maven config
│       ├── mvnw                        ← Maven wrapper
│       ├── src/
│       │   ├── main/
│       │   │   ├── java/com/klu/
│       │   │   │   ├── AppController.java
│       │   │   │   ├── Service.java
│       │   │   │   ├── Repo.java
│       │   │   │   ├── Product.java
│       │   │   │   └── ...
│       │   │   └── resources/
│       │   │       └── application.properties
│       │   └── test/
│       │       └── java/...
│       └── target/
│           └── cruddemo-0.0.1-SNAPSHOT.war  ← Built artifact
│
└── crud_frontend/
    └── crud_frontend-main/
        ├── package.json                ← npm config
        ├── vite.config.js              ← Build tool config
        ├── src/
        │   ├── App.jsx                 ← React app
        │   ├── main.jsx
        │   └── ...
        ├── public/
        ├── dist/                       ← Build output
        │   ├── index.html
        │   ├── js/
        │   ├── css/
        │   └── ...
        └── frontapp1.war               ← Deployed artifact
```

---

## Security Considerations

```
┌─────────────────────────────────────────────────────────────┐
│                    SECURITY ARCHITECTURE                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Jenkins (http://localhost:8085)                            │
│  ├─ Authentication: Jenkins user/password                  │
│  ├─ Authorization: Job-level permissions                  │
│  └─ Credentials: Stored securely in Jenkins               │
│                                                              │
│  Tomcat (http://localhost:9090)                            │
│  ├─ Manager Access: admin/admin (local only)              │
│  ├─ Deployment: BASIC AUTH over HTTP (local only)         │
│  └─ Note: Use HTTPS in production!                        │
│                                                              │
│  Database (AWS RDS)                                        │
│  ├─ Host: database-1.ckhoqoim0209.us-east-1.rds.amazonaws.com │
│  ├─ Credentials: admin/adminadmin                          │
│  ├─ Network: Security group allows access                 │
│  └─ Note: Consider using environment variables            │
│                                                              │
│  RECOMMENDATIONS FOR PRODUCTION:                           │
│  ├─ ✅ Use HTTPS instead of HTTP                          │
│  ├─ ✅ Store credentials in environment variables         │
│  ├─ ✅ Use VPN/bastion hosts                              │
│  ├─ ✅ Enable database encryption at rest                 │
│  ├─ ✅ Use SSL/TLS for database connections              │
│  ├─ ✅ Implement network security groups                  │
│  ├─ ✅ Enable Jenkins authentication                      │
│  ├─ ✅ Regular security audits                            │
│  └─ ✅ Monitor logs for suspicious activity               │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

**Version:** 1.0  
**Updated:** October 24, 2025  
**Status:** Ready for Deployment ✅
