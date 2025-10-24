# Full Stack CRUD Application - Jenkins CI/CD Deployment

## 📋 Overview

This repository contains a complete full-stack CRUD application with automated CI/CD deployment using Jenkins and Apache Tomcat.

**Components:**
- 🔙 **Backend:** Spring Boot REST API (Java)
- 🔗 **Frontend:** React + Vite (JavaScript)
- 💾 **Database:** MySQL (AWS RDS)
- 🚀 **CI/CD:** Jenkins Pipeline

**Deployment Targets:**
- Jenkins: http://localhost:8085/
- Tomcat: http://localhost:9090/

---

## ⚡ Quick Start (5 Minutes)

### 1. Verify Your Environment
```bash
chmod +x pre-deployment-check.sh
./pre-deployment-check.sh
```

### 2. Configure Jenkins
- Go to http://localhost:8085/
- Install plugins: Maven Integration, NodeJS, Pipeline
- Configure tools: JDK (17), Maven, NodeJS

### 3. Create Pipeline Job
- **New Item** → `FullStack-CRUD-Deploy` → **Pipeline**
- Pipeline from SCM → Git → https://github.com/shuvmraj/Practical3.git
- Script path: `Jenkinsfile`

### 4. Deploy!
- Click **Build Now**
- Monitor in Console Output
- Access apps:
  - Backend: http://localhost:9090/springapp1
  - Frontend: http://localhost:9090/frontapp1

---

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| **[QUICK_START.md](QUICK_START.md)** | 5-minute setup guide |
| **[JENKINS_DEPLOYMENT_GUIDE.md](JENKINS_DEPLOYMENT_GUIDE.md)** | Comprehensive configuration |
| **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** | Common issues & fixes |
| **[ARCHITECTURE.md](ARCHITECTURE.md)** | System design diagrams |
| **[deployment-setup-summary.md](deployment-setup-summary.md)** | Setup summary |

---

## 🏗️ Project Structure

```
Practical3/
├── Jenkinsfile                      ← Pipeline definition
├── README.md                        ← This file
├── QUICK_START.md                  ← Start here!
├── JENKINS_DEPLOYMENT_GUIDE.md
├── TROUBLESHOOTING.md
├── ARCHITECTURE.md
├── check-env.sh                    ← Quick checks
├── pre-deployment-check.sh         ← Pre-flight check
│
├── crud_backend/
│   └── crud_backend-main/
│       ├── pom.xml                 ← Maven config
│       ├── mvnw                    ← Maven wrapper
│       └── src/
│           ├── main/java/com/klu/
│           │   ├── AppController.java
│           │   ├── Service.java
│           │   ├── Repo.java
│           │   ├── Product.java
│           │   ├── CruddemoApplication.java
│           │   └── ServletInitializer.java
│           ├── main/resources/
│           │   └── application.properties
│           └── test/java/...
│
└── crud_frontend/
    └── crud_frontend-main/
        ├── package.json            ← npm config
        ├── vite.config.js          ← Build config
        ├── index.html
        ├── src/
        │   ├── App.jsx             ← Main component
        │   ├── App.css
        │   ├── main.jsx
        │   └── index.css
        ├── public/
        └── dist/                   ← Build output
```

---

## 🔧 Prerequisites

- ✅ **Java 17+** (or compatible version)
- ✅ **Maven 3.8+**
- ✅ **Node.js 18+** (npm 9+)
- ✅ **Git**
- ✅ **Jenkins** (running on port 8085)
- ✅ **Apache Tomcat 9+** (running on port 9090)
- ✅ **MySQL Database** (AWS RDS or local)

### Installation

**macOS with Homebrew:**
```bash
# Java
brew install openjdk@17

# Maven
brew install maven

# Node.js
brew install node

# Git
brew install git

# Jenkins
brew install jenkins

# Tomcat
brew install tomcat
```

---

## 🚀 Deployment Flow

```
1. Git Commit
   ↓
2. Push to Repository (GitHub)
   ↓
3. Webhook triggers Jenkins
   ↓
4. Jenkins Pipeline:
   - Checkout code
   - Build Frontend (npm)
   - Build Backend (Maven)
   - Package as WAR files
   ↓
5. Deploy to Tomcat:
   - Upload frontend WAR → /frontapp1
   - Upload backend WAR → /springapp1
   ↓
6. Applications Running:
   - React Frontend: http://localhost:9090/frontapp1
   - Spring Boot API: http://localhost:9090/springapp1
```

---

## 📊 Pipeline Stages

| Stage | Command | Output | Time |
|-------|---------|--------|------|
| **Checkout** | git clone | Latest code | 5s |
| **Build Frontend** | npm install + build | dist/ folder | 30-60s |
| **Build Backend** | mvn clean package | cruddemo.war | 60-120s |
| **Package Frontend** | jar command | frontapp1.war | 5s |
| **Deploy Backend** | curl upload | Tomcat /springapp1 | 10s |
| **Deploy Frontend** | curl upload | Tomcat /frontapp1 | 10s |
| **Verify** | curl health checks | Status 200 | 10s |

**Total Time:** 2-4 minutes

---

## 🌐 Access URLs

| Service | URL | Credentials |
|---------|-----|-------------|
| Jenkins | http://localhost:8085/ | Your Jenkins user |
| Tomcat Manager | http://localhost:9090/manager/html | admin / admin |
| Backend API | http://localhost:9090/springapp1 | - |
| Frontend App | http://localhost:9090/frontapp1 | - |
| Tomcat Home | http://localhost:9090/ | - |

---

## 🔌 API Endpoints

### Backend (/springapp1)
```
GET    /api/products           - Get all products
GET    /api/products/{id}      - Get product by ID
POST   /api/products           - Create product
PUT    /api/products/{id}      - Update product
DELETE /api/products/{id}      - Delete product
```

### Frontend (/frontapp1)
```
GET /                          - React App
GET /api/products (proxied)    - API calls to backend
```

---

## 🛠️ Troubleshooting

### Common Issues

**Jenkins not accessible:**
```bash
brew services start jenkins
# Or: java -jar jenkins.war --httpPort=8085
```

**Tomcat not accessible:**
```bash
brew services start tomcat
# Or: $CATALINA_HOME/bin/startup.sh
```

**Port already in use:**
```bash
# Find process using port
lsof -i :8085  # Jenkins
lsof -i :9090  # Tomcat

# Kill process
kill -9 <PID>
```

**Build fails:**
1. Check Jenkins console output
2. Run `pre-deployment-check.sh`
3. Review `TROUBLESHOOTING.md`

---

## 📝 Database Configuration

Backend connects to:
- **Host:** database-1.ckhoqoim0209.us-east-1.rds.amazonaws.com
- **Port:** 3306
- **Database:** cicd
- **Username:** admin
- **Password:** adminadmin

Configure in: `crud_backend/crud_backend-main/src/main/resources/application.properties`

---

## 🔐 Security Notes

⚠️ **For Development Only!**
- Default credentials: admin/admin
- HTTP instead of HTTPS
- Hardcoded passwords in config

🔒 **For Production:**
- Use HTTPS/TLS
- Store secrets in environment variables
- Implement proper authentication
- Use AWS Secrets Manager or similar
- Enable database encryption
- Implement network security groups

---

## 🔄 CI/CD Best Practices

✅ **Implemented:**
- Automated builds on commit
- Multi-stage pipeline
- Artifact verification
- Health checks
- Error handling

📋 **Recommendations:**
- Enable webhook for automatic builds
- Add unit tests to pipeline
- Implement code quality checks (SonarQube)
- Add security scanning (SAST)
- Setup monitoring and alerting
- Implement proper branching strategy

---

## 📈 Scaling Considerations

Current setup is for **single machine/local development**.

For scaling:
- ✅ Use Docker containers
- ✅ Deploy to Kubernetes (AKS/EKS)
- ✅ Use managed services (App Service, Container Apps)
- ✅ Implement load balancing
- ✅ Setup proper logging (ELK Stack)
- ✅ Implement monitoring (Prometheus/Grafana)

---

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Push to repository
4. Jenkins pipeline will automatically deploy!

---

## 📞 Support

- **Setup Issues:** See `QUICK_START.md`
- **Configuration:** See `JENKINS_DEPLOYMENT_GUIDE.md`
- **Errors:** See `TROUBLESHOOTING.md`
- **Architecture:** See `ARCHITECTURE.md`
- **Environment Check:** Run `pre-deployment-check.sh`

---

## 📝 Version Info

- **Created:** October 24, 2025
- **Status:** ✅ Ready for Deployment
- **Compatibility:**
  - Java 17+
  - Maven 3.8+
  - Node.js 18+
  - Spring Boot 2.7+
  - React 19
  - Vite 6+

---

## 🎉 Quick Links

- 📖 [Quick Start Guide](QUICK_START.md)
- 🔧 [Deployment Guide](JENKINS_DEPLOYMENT_GUIDE.md)
- 🐛 [Troubleshooting](TROUBLESHOOTING.md)
- 📐 [Architecture Diagrams](ARCHITECTURE.md)
- ✅ [Pre-deployment Check](pre-deployment-check.sh)

---

## 📄 License

This project is for educational purposes.

---

**Ready to deploy? Start with [QUICK_START.md](QUICK_START.md)! 🚀**
