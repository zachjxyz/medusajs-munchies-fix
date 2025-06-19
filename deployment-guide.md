# MedusaJS B2C Starter - Complete Deployment Guide

## 🚀 Overview
This monorepo consists of:
- **Backend**: MedusaJS e-commerce API (Node.js)
- **Storefront**: Next.js frontend with Sanity CMS integration
- **Database**: PostgreSQL required
- **File Storage**: AWS S3 integration
- **Payment**: Stripe integration
- **CMS**: Sanity.io for content management

## Prerequisites
- Node.js 20+ installed
- pnpm package manager
- PostgreSQL database
- Redis instance
- AWS S3 bucket
- Stripe account
- Sanity.io account

---

## Step 1: Environment Setup

### 1.1 Backend Environment Variables (.env in backend/)
```bash
# Database
DATABASE_URL=postgresql://username:password@localhost:5432/medusa_db
REDIS_URL=redis://localhost:6379

# CORS Settings
STORE_CORS=http://localhost:3000,https://yourdomain.com
ADMIN_CORS=http://localhost:7001,https://admin.yourdomain.com
AUTH_CORS=http://localhost:3000,https://yourdomain.com

# Security
JWT_SECRET=your-super-secret-jwt-key-here
COOKIE_SECRET=your-super-secret-cookie-key-here

# Sanity Integration
SANITY_API_TOKEN=your-sanity-api-token
SANITY_PROJECT_ID=your-sanity-project-id

# AWS S3 File Storage
S3_FILE_URL=https://your-bucket.s3.region.amazonaws.com
S3_REGION=us-east-1
S3_BUCKET=your-bucket-name
S3_ENDPOINT=https://s3.us-east-1.amazonaws.com

# Stripe Payment
STRIPE_API_KEY=sk_test_your-stripe-secret-key

# Email (Resend)
RESEND_API_KEY=your-resend-api-key
```

### 1.2 Storefront Environment Variables (.env.local in storefront/)
```bash
# Medusa Backend
NEXT_PUBLIC_MEDUSA_BACKEND_URL=http://localhost:9000
NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=pk_your-medusa-publishable-key

# Sanity CMS
NEXT_PUBLIC_SANITY_PROJECT_ID=your-sanity-project-id
NEXT_PUBLIC_SANITY_DATASET=production
NEXT_PUBLIC_SANITY_API_VERSION=2024-01-01
SANITY_API_TOKEN=your-sanity-api-token
SANITY_REVALIDATE_SECRET=your-revalidate-secret

# Stripe (Frontend)
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_your-stripe-publishable-key
```

---

## Step 2: Service Setup

### 2.1 PostgreSQL Database Setup
1. **Local Development:**
   ```bash
   # Install PostgreSQL
   brew install postgresql  # macOS
   sudo apt-get install postgresql  # Ubuntu

   # Start PostgreSQL
   brew services start postgresql  # macOS
   sudo service postgresql start  # Ubuntu

   # Create database
   createdb medusa_db
   ```

2. **Production (Recommended Services):**
   - **Supabase**: Free tier with PostgreSQL
   - **Railway**: Easy PostgreSQL hosting
   - **AWS RDS**: Enterprise-grade
   - **DigitalOcean Managed Databases**

### 2.2 Redis Setup
1. **Local Development:**
   ```bash
   # Install Redis
   brew install redis  # macOS
   sudo apt-get install redis-server  # Ubuntu

   # Start Redis
   brew services start redis  # macOS
   sudo service redis-server start  # Ubuntu
   ```

2. **Production (Recommended Services):**
   - **Upstash**: Serverless Redis
   - **Railway**: Redis hosting
   - **AWS ElastiCache**

### 2.3 AWS S3 Setup
1. Create an S3 bucket in AWS Console
2. Set up IAM user with S3 permissions:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Action": [
           "s3:GetObject",
           "s3:PutObject",
           "s3:DeleteObject"
         ],
         "Resource": "arn:aws:s3:::your-bucket-name/*"
       }
     ]
   }
   ```
3. Configure CORS for your bucket:
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

### 2.4 Sanity.io Setup
1. Create a new Sanity project at https://sanity.io
2. Get your Project ID from the project dashboard
3. Generate an API token with Editor permissions
4. Set the API version to today's date (YYYY-MM-DD format)

### 2.5 Stripe Setup
1. Create a Stripe account at https://stripe.com
2. Get your API keys from the Stripe dashboard
3. Set up webhooks for order processing

---

## Step 3: Local Development Setup

### 3.1 Install Dependencies
```bash
# Install pnpm if not already installed
npm install -g pnpm

# Install all dependencies
pnpm install
```

### 3.2 Database Migration
```bash
# Navigate to backend
cd backend

# Run database migrations
pnpm run build
pnpm run start
```

### 3.3 Seed Database (Optional)
```bash
cd backend
pnpm run seed
```

### 3.4 Start Development Servers
```bash
# From root directory
pnpm dev
```

This will start:
- Backend API on http://localhost:9000
- Storefront on http://localhost:3000
- Sanity Studio on http://localhost:3000/cms

---

## Step 4: Production Deployment

### 4.1 Backend Deployment Options

#### Option A: Railway (Recommended for beginners)
1. Connect your GitHub repository to Railway
2. Create a new project and select the backend folder
3. Add all environment variables in Railway dashboard
4. Deploy automatically

#### Option B: Vercel (Serverless)
1. Install Vercel CLI: `npm i -g vercel`
2. From backend directory: `vercel`
3. Configure environment variables in Vercel dashboard

#### Option C: DigitalOcean App Platform
1. Create new app from GitHub repository
2. Select backend folder as source
3. Configure environment variables
4. Deploy

### 4.2 Storefront Deployment (Vercel Recommended)

1. **Connect to Vercel:**
   ```bash
   cd storefront
   npx vercel
   ```

2. **Configure Build Settings:**
   - Build Command: `pnpm run build`
   - Output Directory: `.next`
   - Install Command: `pnpm install`

3. **Environment Variables in Vercel:**
   Add all the storefront environment variables in Vercel dashboard

### 4.3 Update Configuration Files

Update the hardcoded URLs in your configuration:

1. **Backend medusa-config.ts:**
   ```typescript
   admin: {
     backendUrl: "https://your-backend-domain.com",
   },
   ```

2. **Storefront config.ts:**
   Update any hardcoded URLs to your actual domains

---

## Step 5: Post-Deployment Configuration

### 5.1 Medusa Admin Setup
1. Access your backend URL + `/admin`
2. Create admin user
3. Create publishable API key
4. Update `NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY` in storefront

### 5.2 Sanity Studio Configuration
1. Access your storefront URL + `/cms`
2. Configure content types
3. Add initial content

### 5.3 Stripe Webhook Setup
1. In Stripe dashboard, create webhook endpoint
2. Point to: `https://your-backend-domain.com/webhooks/stripe`
3. Add webhook secret to backend environment

---

## Step 6: Common Issues & Solutions

### Issue 1: Database Connection Errors
- Ensure DATABASE_URL format is correct
- Check if database server is running
- Verify firewall settings for production databases

### Issue 2: CORS Errors
- Update STORE_CORS, ADMIN_CORS, AUTH_CORS with your actual domains
- Include both HTTP and HTTPS versions for development

### Issue 3: Sanity Integration Issues
- Verify SANITY_PROJECT_ID and SANITY_API_TOKEN
- Ensure API version is in YYYY-MM-DD format
- Check Sanity project permissions

### Issue 4: File Upload Issues
- Verify S3 bucket permissions and CORS configuration
- Check AWS credentials and region settings
- Ensure S3_FILE_URL matches your bucket URL

### Issue 5: Payment Processing Issues
- Verify Stripe API keys (test vs live)
- Check webhook configuration
- Ensure HTTPS for production Stripe integration

---

## Step 7: Monitoring & Maintenance

### 7.1 Health Checks
- Backend: `GET /health`
- Monitor database connections
- Check Redis connectivity

### 7.2 Logging
- Enable application logging
- Monitor error rates
- Set up alerts for critical issues

### 7.3 Backups
- Regular database backups
- S3 bucket versioning
- Environment variable backups

---

## Deployment Checklist

- [ ] PostgreSQL database created and accessible
- [ ] Redis instance running
- [ ] AWS S3 bucket configured with proper permissions
- [ ] Sanity project created with API token
- [ ] Stripe account set up with API keys
- [ ] All environment variables configured
- [ ] Backend deployed and accessible
- [ ] Storefront deployed and accessible
- [ ] Database migrations completed
- [ ] Admin user created in Medusa
- [ ] Publishable API key generated
- [ ] Stripe webhooks configured
- [ ] DNS records configured (if using custom domain)
- [ ] SSL certificates installed
- [ ] Health checks passing

---

## Support Resources

- [MedusaJS Documentation](https://docs.medusajs.com/)
- [Next.js Deployment Guide](https://nextjs.org/docs/deployment)
- [Sanity.io Documentation](https://www.sanity.io/docs)
- [Stripe Integration Guide](https://stripe.com/docs)

Remember to use test/development keys during development and switch to production keys only when ready to go live! 