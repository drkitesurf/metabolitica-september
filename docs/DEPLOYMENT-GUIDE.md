# 🚀 Metabolitica September - Deployment Guide

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Local Development Setup](#local-development-setup)
3. [Docker Deployment](#docker-deployment)
4. [Production Deployment](#production-deployment)
5. [CI/CD Pipeline](#cicd-pipeline)
6. [Monitoring & Health Checks](#monitoring--health-checks)
7. [Troubleshooting](#troubleshooting)

## 🔧 Prerequisites

### System Requirements

- **Operating System**: Linux (Ubuntu 20.04+), macOS 12+, or Windows 10+
- **Node.js**: Version 18.0.0 or higher
- **npm**: Version 9.0.0 or higher
- **Python**: Version 3.9 or higher
- **Docker**: Version 20.10 or higher
- **Docker Compose**: Version 2.0 or higher
- **Git**: Version 2.30 or higher

### Required Accounts & API Keys

- **GitHub**: For source code repository
- **OpenAI**: API key for AI features
- **PostgreSQL**: Database hosting (or local installation)
- **Redis**: Cache hosting (or local installation)
- **AWS/S3**: File storage (optional)
- **SMTP**: Email service credentials
- **Twilio**: SMS service (optional)

## 🏠 Local Development Setup

### 1. Clone and Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/metabolitica-september.git
cd metabolitica-september

# Run the automated setup script
./scripts/setup.sh
```

### 2. Environment Configuration

```bash
# Copy environment template
cp env.example .env

# Edit .env with your configuration
nano .env
```

**Required Environment Variables:**
```bash
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/metabolitica

# Redis
REDIS_URL=redis://localhost:6379

# JWT
JWT_SECRET=your-secret-key

# AI Services
OPENAI_API_KEY=your-openai-key
```

### 3. Start Development Servers

```bash
# Start all services
npm run dev

# Or start individually:
npm run dev:frontend    # Frontend on http://localhost:3000
npm run dev:backend     # Backend on http://localhost:3001
npm run dev:ml          # ML Engine on http://localhost:8000
```

## 🐳 Docker Deployment

### 1. Quick Start with Docker Compose

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### 2. Individual Service Deployment

```bash
# Frontend only
docker-compose up frontend -d

# Backend only
docker-compose up backend -d

# ML Engine only
docker-compose up ml-engine -d
```

### 3. Custom Docker Configuration

```bash
# Build custom images
docker-compose build --no-cache

# Use custom environment
docker-compose --env-file .env.prod up -d
```

## 🌐 Production Deployment

### 1. Server Requirements

- **CPU**: 4+ cores (8+ recommended)
- **RAM**: 8GB+ (16GB+ recommended)
- **Storage**: 100GB+ SSD
- **Network**: Stable internet connection
- **OS**: Ubuntu 20.04 LTS or CentOS 8

### 2. Production Environment Setup

```bash
# Set production environment
export NODE_ENV=production

# Install production dependencies
npm ci --only=production

# Build applications
npm run build

# Start production servers
npm run start:prod
```

### 3. Reverse Proxy Configuration (Nginx)

```nginx
# /etc/nginx/sites-available/metabolitica
server {
    listen 80;
    server_name metabolitica.yourdomain.com;
    
    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name metabolitica.yourdomain.com;
    
    # SSL Configuration
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    
    # Frontend
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    # Backend API
    location /api {
        proxy_pass http://localhost:3001;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    # ML Engine
    location /ml {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 4. SSL Certificate Setup

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx

# Obtain SSL certificate
sudo certbot --nginx -d metabolitica.yourdomain.com

# Auto-renewal
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

## 🔄 CI/CD Pipeline

### 1. GitHub Actions Workflow

```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run tests
      run: npm test
    
    - name: Build applications
      run: npm run build
    
    - name: Deploy to server
      uses: appleboy/ssh-action@v0.1.5
      with:
        host: ${{ secrets.HOST }}
        username: ${{ secrets.USERNAME }}
        key: ${{ secrets.KEY }}
        script: |
          cd /var/www/metabolitica
          git pull origin main
          npm ci --only=production
          npm run build
          pm2 restart metabolitica
```

### 2. Automated Testing

```bash
# Run test suite
npm test

# Run with coverage
npm run test:coverage

# Run E2E tests
npm run test:e2e
```

### 3. Quality Gates

- **Code Coverage**: Minimum 80%
- **Linting**: No ESLint errors
- **Type Checking**: No TypeScript errors
- **Security**: No known vulnerabilities
- **Performance**: Lighthouse score > 90

## 📊 Monitoring & Health Checks

### 1. Application Monitoring

```bash
# Health check endpoint
curl http://localhost:3001/health

# Metrics endpoint
curl http://localhost:3001/metrics

# Status dashboard
open http://localhost:3001/status
```

### 2. System Monitoring

```bash
# Check system resources
htop
iotop
nethogs

# Check Docker containers
docker stats
docker-compose ps
```

### 3. Log Management

```bash
# View application logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f backend

# Export logs
docker-compose logs > logs.txt
```

### 4. Prometheus & Grafana

```bash
# Access Prometheus
open http://localhost:9090

# Access Grafana
open http://localhost:3001
# Default credentials: admin/admin
```

## 🚨 Troubleshooting

### Common Issues

#### 1. Port Already in Use

```bash
# Find process using port
lsof -i :3000

# Kill process
kill -9 <PID>
```

#### 2. Database Connection Issues

```bash
# Check PostgreSQL status
sudo systemctl status postgresql

# Test connection
psql -h localhost -U metabolitica -d metabolitica
```

#### 3. Docker Issues

```bash
# Reset Docker
docker-compose down -v
docker system prune -a
docker-compose up -d
```

#### 4. Memory Issues

```bash
# Check memory usage
free -h

# Increase Node.js memory limit
export NODE_OPTIONS="--max-old-space-size=4096"
```

### Performance Optimization

#### 1. Database Optimization

```sql
-- Create indexes
CREATE INDEX idx_health_metrics_user_id ON health_metrics(user_id);
CREATE INDEX idx_health_metrics_timestamp ON health_metrics(timestamp);

-- Analyze tables
ANALYZE health_metrics;
```

#### 2. Caching Strategy

```bash
# Redis cache warming
redis-cli FLUSHALL
npm run cache:warm
```

#### 3. Load Balancing

```nginx
# Nginx upstream configuration
upstream metabolitica_backend {
    server 127.0.0.1:3001;
    server 127.0.0.1:3002;
    server 127.0.0.1:3003;
}
```

## 🔐 Security Checklist

- [ ] HTTPS enabled with valid SSL certificate
- [ ] Environment variables properly configured
- [ ] Database credentials secured
- [ ] API rate limiting enabled
- [ ] CORS properly configured
- [ ] Input validation implemented
- [ ] SQL injection protection
- [ ] XSS protection enabled
- [ ] CSRF protection enabled
- [ ] Audit logging enabled
- [ ] Regular security updates
- [ ] Backup strategy implemented

## 📚 Additional Resources

- [Node.js Production Best Practices](https://nodejs.org/en/docs/guides/nodejs-docker-webapp/)
- [Docker Production Guidelines](https://docs.docker.com/develop/dev-best-practices/)
- [Nginx Configuration Guide](https://nginx.org/en/docs/)
- [PostgreSQL Performance Tuning](https://www.postgresql.org/docs/current/performance.html)
- [Redis Best Practices](https://redis.io/topics/optimization)

---

*For additional support, please refer to the project documentation or create an issue on GitHub.* 🚀
