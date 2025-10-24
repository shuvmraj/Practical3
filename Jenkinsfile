pipeline {
    agent any

    tools {
        jdk 'JDK_HOME'
        maven 'Maven_3'
        nodejs 'node20'
    }

    environment {
        JAVA_HOME = '/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home'
        PATH = "${JAVA_HOME}/bin:${PATH}"
        BACKEND_DIR = 'crud_backend/crud_backend-main'
        FRONTEND_DIR = 'crud_frontend/crud_frontend-main'

        // Local Tomcat Configuration
        TOMCAT_HOST = 'localhost'
        TOMCAT_PORT = '9090'
        TOMCAT_MANAGER_URL = "http://${TOMCAT_HOST}:${TOMCAT_PORT}/manager/text"
        TOMCAT_USER = 'admin'
        TOMCAT_PASS = 'admin'

        // Build artifacts
        BACKEND_WAR = 'cruddemo-0.0.1-SNAPSHOT.war'
        FRONTEND_BUILD_DIR = 'dist'
        
        // Deployment context paths
        BACKEND_CONTEXT = '/springapp1'
        FRONTEND_CONTEXT = '/frontapp1'
    }

    stages {
        stage('Checkout') {
            steps {
                echo "📋 Checking out repository..."
                checkout scm
            }
        }

        stage('Build Frontend (Vite + React)') {
            steps {
                echo "🔨 Building Frontend Application..."
                dir("${env.FRONTEND_DIR}") {
                    sh '''
                        echo "Installing dependencies..."
                        npm install
                        
                        echo "Building application..."
                        npm run build
                        
                        echo "Build output:"
                        ls -la dist/
                    '''
                }
            }
        }

        stage('Package Frontend as WAR') {
            steps {
                echo "📦 Packaging Frontend as WAR..."
                dir("${env.FRONTEND_DIR}") {
                    sh '''
                        # Create WAR structure
                        mkdir -p frontapp1_war/WEB-INF
                        
                        # Copy built files
                        cp -r dist/* frontapp1_war/
                        
                        # Create WEB-INF directory with basic web.xml if needed
                        if [ ! -f frontapp1_war/WEB-INF/web.xml ]; then
                            cat > frontapp1_war/WEB-INF/web.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<web-app version="3.1" xmlns="http://xmlns.jcp.org/xml/ns/javaee" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd">
    <display-name>frontapp1</display-name>
</web-app>
EOF
                        fi
                        
                        # Create WAR file
                        cd frontapp1_war
                        jar cvf ../frontapp1.war .
                        cd ..
                        
                        ls -lh *.war
                    '''
                    sh "cp frontapp1.war ../../frontapp1.war"
                }
            }
        }

        stage('Build Backend (Spring Boot)') {
            steps {
                echo "🔨 Building Backend Application..."
                dir("${env.BACKEND_DIR}") {
                    sh '''
                        echo "Running Maven clean package..."
                        echo "JAVA_HOME is: $JAVA_HOME"
                        echo "Java version:"
                        $JAVA_HOME/bin/java -version
                        
                        ./mvnw clean package -DskipTests
                        
                        echo "Build artifacts:"
                        ls -lh target/*.war
                    '''
                }
            }
        }

        stage('Verify Artifacts') {
            steps {
                echo "✅ Verifying build artifacts..."
                sh '''
                    echo "Backend WAR:"
                    ls -lh "${BACKEND_DIR}/target/${BACKEND_WAR}" 2>/dev/null || echo "Not found at expected location"
                    
                    echo "Frontend WAR:"
                    ls -lh frontapp1.war
                '''
            }
        }

        stage('Deploy Backend to Tomcat') {
            steps {
                echo "🚀 Deploying Backend to Tomcat..."
                script {
                    sh '''
                        BACKEND_WAR_PATH="${BACKEND_DIR}/target/${BACKEND_WAR}"
                        
                        # Check if WAR exists
                        if [ ! -f "$BACKEND_WAR_PATH" ]; then
                            echo "❌ Backend WAR not found at $BACKEND_WAR_PATH"
                            exit 1
                        fi
                        
                        echo "Uploading Backend WAR to Tomcat..."
                        curl -v -u "${TOMCAT_USER}:${TOMCAT_PASS}" \
                          --upload-file "$BACKEND_WAR_PATH" \
                          "${TOMCAT_MANAGER_URL}/deploy?path=${BACKEND_CONTEXT}&update=true"
                        
                        echo "\n✅ Backend deployment triggered"
                        sleep 3
                    '''
                }
            }
        }

        stage('Deploy Frontend to Tomcat') {
            steps {
                echo "🚀 Deploying Frontend to Tomcat..."
                script {
                    sh '''
                        if [ ! -f "frontapp1.war" ]; then
                            echo "❌ Frontend WAR not found"
                            exit 1
                        fi
                        
                        echo "Uploading Frontend WAR to Tomcat..."
                        curl -v -u "${TOMCAT_USER}:${TOMCAT_PASS}" \
                          --upload-file frontapp1.war \
                          "${TOMCAT_MANAGER_URL}/deploy?path=${FRONTEND_CONTEXT}&update=true"
                        
                        echo "\n✅ Frontend deployment triggered"
                        sleep 3
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "🔍 Verifying deployment..."
                script {
                    sh '''
                        echo "Checking Tomcat Manager..."
                        curl -s -u "${TOMCAT_USER}:${TOMCAT_PASS}" \
                          "${TOMCAT_MANAGER_URL}/list" | grep -E "(springapp1|frontapp1)" || true
                        
                        echo "\n⏳ Waiting for applications to start..."
                        sleep 5
                        
                        echo "Backend health check..."
                        curl -s -o /dev/null -w "Backend Status: %{http_code}\\n" \
                          "http://${TOMCAT_HOST}:${TOMCAT_PORT}${BACKEND_CONTEXT}/" || echo "Backend not yet available"
                        
                        echo "Frontend health check..."
                        curl -s -o /dev/null -w "Frontend Status: %{http_code}\\n" \
                          "http://${TOMCAT_HOST}:${TOMCAT_PORT}${FRONTEND_CONTEXT}/" || echo "Frontend not yet available"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo """
            
            ✅ ========== DEPLOYMENT SUCCESSFUL ==========
            
            🔗 Application URLs:
               Backend:  http://localhost:9090/springapp1
               Frontend: http://localhost:9090/frontapp1
            
            📊 Tomcat Manager: http://localhost:9090/manager/html
               Username: admin
               Password: admin
            
            ✅ ==================================================
            """
        }
        failure {
            echo """
            
            ❌ ========== DEPLOYMENT FAILED ==========
            
            Please check:
            1. Tomcat is running on http://localhost:9090/
            2. Tomcat manager credentials are correct
            3. Build logs for any compilation errors
            
            ❌ =========================================
            """
        }
        always {
            echo "Pipeline execution completed."
        }
    }
}
