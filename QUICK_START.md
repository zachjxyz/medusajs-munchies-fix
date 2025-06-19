# 🚀 Complete Quick Start Deployment Guide

## 📋 Prerequisites (Install These First)

Before starting, ensure you have these installed on your system:

```bash
# Check if Node.js is installed (need version 20+)
node --version

# Check if Git is installed
git --version

# If Node.js is not installed:
# macOS: brew install node
# Windows: Download from nodejs.org
# Ubuntu: sudo apt install nodejs npm

# Install pnpm globally (required package manager)
npm install -g pnpm

# Verify pnpm installation
pnpm --version
```

---

## 🏗️ Step 1: Clone and Setup Project Structure

### 1.1 Clone the Repository
```bash
# Clone your repository (replace with your actual repo URL)
git clone https://github.com/your-username/your-repo-name.git

# Navigate to the project directory
cd your-repo-name

# Verify you're in the correct directory (should see backend/ and storefront/ folders)
ls -la
```

### 1.2 Install Root Dependencies
```bash
# Install monorepo dependencies from root
pnpm install

# This installs dependencies for both backend and storefront
```

---

## 🔧 Step 2: Set Up Required External Services

**⚠️ CRITICAL: You MUST set up these services before proceeding. The app will not work without them.**

### 2.1 Database Setup (Choose ONE option)

#### Option A: Supabase (Recommended - Free)
1. Go to [supabase.com](https://supabase.com)
2. Create account and new project
3. Go to Settings → Database
4. Copy the connection string (starts with `postgresql://`)
5. Save this as your `DATABASE_URL`

#### Option B: Railway (Easy)
1. Go to [railway.app](https://railway.app)
2. Create account → New Project → Add PostgreSQL
3. Go to Variables tab, copy `DATABASE_URL`

#### Option C: Local PostgreSQL
```bash
# macOS
brew install postgresql
brew services start postgresql
createdb medusa_db

# Ubuntu
sudo apt-get install postgresql
sudo service postgresql start
sudo -u postgres createdb medusa_db

# Your DATABASE_URL will be:
# postgresql://username:password@localhost:5432/medusa_db
```

### 2.2 Redis Setup (Choose ONE option)

#### Option A: Upstash (Recommended - Free)
1. Go to [upstash.com](https://upstash.com)
2. Create account → Create Redis Database
3. Copy the Redis URL (starts with `redis://` or `rediss://`)

#### Option B: Railway
1. In your Railway project → Add Redis
2. Copy the `REDIS_URL` from Variables tab

#### Option C: Local Redis
```bash
# macOS
brew install redis
brew services start redis

# Ubuntu
sudo apt-get install redis-server
sudo service redis-server start

# Your REDIS_URL will be: redis://localhost:6379
```

### 2.3 AWS S3 Setup (File Storage)
1. Go to [AWS Console](https://console.aws.amazon.com)
2. Create S3 bucket:
   - Choose unique bucket name
   - Select region (e.g., us-east-1)
   - Uncheck "Block all public access"
3. Set bucket CORS policy:
   ```json
   [
     {
       "AllowedHeaders": ["*"],
       "AllowedMethods": ["GET", "PUT", "POST", "DELETE"],
       "AllowedOrigins": ["*"],
       "ExposeHeaders": []
     }
   ]
   ```
4. Create IAM user with S3 permissions
5. Save: bucket name, region, access keys

### 2.4 Sanity CMS Setup
1. Go to [sanity.io](https://sanity.io)
2. Create account → New Project
3. Choose project name and dataset (use "production")
4. Go to API tab → Add API token with "Editor" permissions
5. Save: Project ID and API token

### 2.5 Stripe Setup (Payments)
1. Go to [stripe.com](https://stripe.com)
2. Create account
3. Go to Developers → API Keys
4. Copy both Publishable key (pk_test_...) and Secret key (sk_test_...)

---

## 📝 Step 3: Create Environment Files

### 3.1 Backend Environment File
```bash
# Navigate to backend folder
cd backend

# Create environment file
touch .env

# Open .env file in your editor and add these variables:
```

**Copy this into `backend/.env`:**
```bash
# Database (Replace with your actual database URL)
DATABASE_URL=postgresql://username:password@host:5432/database_name
REDIS_URL=redis://host:6379

# Security (Generate random 32+ character strings)
JWT_SECRET=your-super-secret-jwt-key-minimum-32-characters-long
COOKIE_SECRET=your-super-secret-cookie-key-minimum-32-characters-long

# CORS Settings (Update with your actual domains)
STORE_CORS=http://localhost:3000,https://yourdomain.com
ADMIN_CORS=http://localhost:7001,https://admin.yourdomain.com
AUTH_CORS=http://localhost:3000,https://yourdomain.com

# Sanity CMS (From your Sanity project)
SANITY_API_TOKEN=your-sanity-api-token
SANITY_PROJECT_ID=your-sanity-project-id

# AWS S3 File Storage (From your S3 setup)
S3_FILE_URL=https://your-bucket.s3.region.amazonaws.com
S3_REGION=us-east-1
S3_BUCKET=your-bucket-name
S3_ENDPOINT=https://s3.us-east-1.amazonaws.com

# Stripe Payment (From your Stripe dashboard)
STRIPE_API_KEY=sk_test_your-stripe-secret-key

# Email Service (Optional - from Resend.com)
RESEND_API_KEY=your-resend-api-key
```

### 3.2 Storefront Environment File
```bash
# Navigate to storefront folder (from project root)
cd ../storefront

# Create environment file
touch .env.local

# Open .env.local file in your editor and add these variables:
```

**Copy this into `storefront/.env.local`:**
```bash
# Medusa Backend (Will be localhost for development, your domain for production)
NEXT_PUBLIC_MEDUSA_BACKEND_URL=http://localhost:9000
NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=pk_your-medusa-publishable-key

# Sanity CMS (Same values as backend)
NEXT_PUBLIC_SANITY_PROJECT_ID=your-sanity-project-id
NEXT_PUBLIC_SANITY_DATASET=production
NEXT_PUBLIC_SANITY_API_VERSION=2024-01-01
SANITY_API_TOKEN=your-sanity-api-token
SANITY_REVALIDATE_SECRET=your-random-secret-string

# Stripe Frontend (Publishable key from Stripe)
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_your-stripe-publishable-key
```

---

## 🔨 Step 4: Install Dependencies and Build

### 4.1 Backend Setup
```bash
# Navigate to backend folder (from project root)
cd backend

# Install backend dependencies
pnpm install

# Build the backend
pnpm run build

# Verify build completed successfully
ls -la dist/
```

### 4.2 Storefront Setup
```bash
# Navigate to storefront folder (from project root)
cd ../storefront

# Install storefront dependencies
pnpm install

# Generate Sanity types (required before building)
pnpm run sanity:typegen

# Build the storefront
pnpm run build

# Verify build completed successfully
ls -la .next/
```

---

## 🚀 Step 5: Local Development Testing

### 5.1 Start Development Servers
```bash
# From project root directory
cd ..

# Start both backend and storefront in development mode
pnpm dev
```

This will start:
- **Backend API**: http://localhost:9000
- **Storefront**: http://localhost:3000
- **Sanity Studio**: http://localhost:3000/cms

### 5.2 Verify Everything Works
1. **Backend Health Check**: Visit http://localhost:9000/health
2. **Storefront**: Visit http://localhost:3000
3. **Admin Panel**: Visit http://localhost:9000/admin
4. **Sanity Studio**: Visit http://localhost:3000/cms

### 5.3 Create Admin User
1. Go to http://localhost:9000/admin
2. Create your first admin user
3. Login to admin panel
4. Go to Settings → Publishable API Keys
5. Create a new publishable key
6. Copy the key and update `NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY` in `storefront/.env.local`

---

## 🌐 Step 6: Production Deployment

### Option A: Vercel + Railway (Recommended)

#### 6.1 Deploy Backend to Railway
```bash
# From project root
cd backend

# Install Railway CLI
npm install -g @railway/cli

# Login to Railway
railway login

# Initialize and deploy
railway init
railway up
```

#### 6.2 Deploy Storefront to Vercel
```bash
# From project root
cd storefront

# Install Vercel CLI
npm install -g vercel

# Deploy to Vercel
vercel

# Follow prompts and add environment variables in Vercel dashboard
```

### Option B: Docker Deployment
```bash
# From project root
# Make sure Docker is installed and running

# Create .env file for Docker Compose
cp backend/.env .env

# Start all services
docker-compose up -d

# Check logs
docker-compose logs -f
```

### Option C: All-in-One Platforms
- **Railway**: Deploy entire monorepo
- **DigitalOcean App Platform**: Full-stack deployment
- **Render**: Deploy both services

---

## ✅ Step 7: Post-Deployment Configuration

### 7.1 Update Environment Variables for Production
1. Update `NEXT_PUBLIC_MEDUSA_BACKEND_URL` in storefront to your backend URL
2. Update CORS settings in backend to include your frontend domain
3. Switch to production Stripe keys when ready to go live

### 7.2 Configure Stripe Webhooks
1. In Stripe dashboard → Webhooks
2. Add endpoint: `https://your-backend-domain.com/webhooks/stripe`
3. Select events: `payment_intent.succeeded`, `payment_intent.payment_failed`
4. Copy webhook secret and add to backend environment

### 7.3 Set Up Domain (Optional)
1. Configure custom domain in Vercel/Railway
2. Update environment variables with new domain
3. Update Stripe webhook URLs

---

## 🔍 Verification Checklist

- [ ] All external services are set up and accessible
- [ ] Environment files created with real values (not placeholders)
- [ ] Backend builds successfully (`pnpm run build` in backend/)
- [ ] Storefront builds successfully (`pnpm run build` in storefront/)
- [ ] Local development servers start without errors
- [ ] Backend health check responds at `/health`
- [ ] Storefront loads at http://localhost:3000
- [ ] Admin panel accessible and admin user created
- [ ] Sanity Studio accessible at `/cms`
- [ ] Publishable API key created and added to storefront
- [ ] Production deployment successful
- [ ] All environment variables updated for production
- [ ] Stripe webhooks configured

---

## 🆘 Common Issues & Solutions

### Issue: "Cannot connect to database"
```bash
# Check your DATABASE_URL format
# Should be: postgresql://username:password@host:port/database
# Verify database is running and accessible
```

### Issue: "Redis connection failed"
```bash
# Check your REDIS_URL format
# Should be: redis://host:port or rediss://host:port for SSL
# Verify Redis instance is running
```

### Issue: "Sanity types not found"
```bash
cd storefront
pnpm run sanity:typegen
pnpm run build
```

### Issue: "CORS errors in browser"
```bash
# Update STORE_CORS in backend/.env
STORE_CORS=http://localhost:3000,https://your-production-domain.com
```

### Issue: "Build fails with missing environment variables"
```bash
# Verify all required variables are set
# Check for typos in variable names
# Ensure no trailing spaces in .env files
```

---

## 📞 Support Commands

```bash
# Check Node.js version
node --version

# Check pnpm version
pnpm --version

# Clear all caches and reinstall
rm -rf node_modules backend/node_modules storefront/node_modules
rm -rf backend/.next storefront/.next
pnpm install

# View logs in development
pnpm dev --verbose

# Build for production
pnpm run build

# Check for linting errors
cd storefront && pnpm run lint
```

---

**⏱️ Estimated Total Time: 45-90 minutes** (depending on service setup)

**🎯 Success Criteria**: When you can access your storefront, add products via Sanity CMS, and complete a test purchase with Stripe. 