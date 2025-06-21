# 🛍️ Munchies MedusaJS Template by Tinloof (fixed by ZachJxyz)

A complete e-commerce solution built with **MedusaJS 2.8.4** (backend) and **Next.js 15** (storefront), integrated with **Sanity CMS** for content management.

## 🚀 Quick Deploy

Deploy your store in **5 steps** using Railway (backend) + Vercel (frontend):

### 1. Clone & Install
```bash
git clone https://github.com/zachjxyz/medusajs-munchies-fix.git
cd medusajs-munchies-fix

# Install backend dependencies
cd backend
pnpm install

# Install storefront dependencies  
cd ../storefront
pnpm install
cd ..
```

### 2. Setup Railway (Database + Backend)
1. **Create Railway Account**: [railway.app](https://railway.app)
2. **Create New Project** → **Deploy from GitHub repo**
3. **Add PostgreSQL**: Add PostgreSQL service to your project
4. **Add Redis**: Add Redis service to your project  
5. **Copy Database URLs**: Copy `DATABASE_URL` and `REDIS_URL` from Railway dashboard

### 3. Setup External Services

| Service | Purpose | Setup Time | Required |
|---------|---------|------------|----------|
| **AWS S3** | File storage | 10 min | ✅ Yes |
| **Sanity.io** | CMS | 5 min | ✅ Yes |
| **Stripe** | Payments | 10 min | ✅ Yes |

**AWS S3 Setup:**
1. Create AWS account → S3 bucket
2. Get: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `S3_BUCKET`, `AWS_REGION`

**Sanity Setup:**
1. Create account at [sanity.io](https://sanity.io)
2. Create new project → Get `PROJECT_ID` and create `API_TOKEN`

**Stripe Setup:**
1. Create account at [stripe.com](https://stripe.com)
2. Get: `STRIPE_API_KEY` (secret) and `STRIPE_PUBLISHABLE_KEY`

### 4. Create Environment Files

Create these files with your actual values:

**Backend** (`backend/.env.local`):
```bash
# Database (from Railway)
DATABASE_URL="postgresql://user:pass@host:port/db"
REDIS_URL="redis://user:pass@host:port"

# Security (generate random strings)
JWT_SECRET="your-super-secret-jwt-key-here"
COOKIE_SECRET="your-super-secret-cookie-key-here"

# Backend URL
MEDUSA_BACKEND_URL="https://your-backend.railway.app"
MEDUSA_PUBLISHABLE_KEY="pk_your_publishable_key_from_medusa_admin"

# Frontend URL (for email templates)
NEXT_PUBLIC_BASE_URL="https://your-storefront.vercel.app"

# Sanity CMS
SANITY_PROJECT_ID="your_sanity_project_id"
SANITY_API_TOKEN="your_sanity_api_token"
SANITY_STUDIO_URL="https://your-storefront.vercel.app/cms"

# AWS S3
AWS_ACCESS_KEY_ID="your_aws_access_key"
AWS_SECRET_ACCESS_KEY="your_aws_secret_key"
S3_BUCKET="your-s3-bucket-name"
AWS_REGION="us-east-1"
S3_ENDPOINT="https://s3.amazonaws.com"

# Stripe
STRIPE_API_KEY="sk_test_your_stripe_secret_key"

# CORS (use your actual URLs)
STORE_CORS="https://your-storefront.vercel.app,http://localhost:3000"
ADMIN_CORS="https://your-storefront.vercel.app,http://localhost:3000,http://localhost:7001"
AUTH_CORS="https://your-storefront.vercel.app,http://localhost:3000"
```

**Storefront** (`storefront/.env.local`):
```bash
# Backend Connection
NEXT_PUBLIC_MEDUSA_BACKEND_URL="https://your-backend.railway.app"
NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY="pk_your_publishable_key_from_medusa_admin"

# Sanity CMS
NEXT_PUBLIC_SANITY_PROJECT_ID="your_sanity_project_id"
NEXT_PUBLIC_SANITY_DATASET="production"
SANITY_API_READ_TOKEN="your_sanity_read_token"

# Stripe
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY="pk_test_your_stripe_publishable_key"

# Base URL
NEXT_PUBLIC_BASE_URL="https://your-storefront.vercel.app"
```

### 5. Deploy & Test

**Deploy Backend to Railway:**
```bash
cd backend
pnpm run build
# Push to GitHub - Railway will auto-deploy
```

**Deploy Storefront to Vercel:**
```bash
cd storefront  
pnpm run build
# Deploy to Vercel via GitHub integration
```

**Test Everything:**
1. Visit your storefront URL
2. Visit `your-backend-url/admin` to access admin
3. Create admin user and test order flow

---

## 🔄 Upgrading MedusaJS

This template has been upgraded to **MedusaJS 2.8.4** (latest). To upgrade in the future:

### Safe Upgrade Process

1. **Check Release Notes**: Always check [MedusaJS releases](https://github.com/medusajs/medusa/releases) for breaking changes

2. **Backup Database**: 
```bash
# Create database backup before upgrading
pg_dump $DATABASE_URL > backup.sql
```

3. **Update Dependencies**:
```bash
cd backend
# Update all @medusajs packages to same version
pnpm add @medusajs/medusa@latest @medusajs/framework@latest @medusajs/admin-sdk@latest @medusajs/cli@latest @medusajs/test-utils@latest
```

4. **Run Migrations**:
```bash
# CRITICAL: Always run migrations after upgrading
pnpm medusa db:migrate
```

5. **Test Thoroughly**:
```bash
# Test locally first
pnpm run dev
# Test admin, storefront, and API endpoints
```

### Version Compatibility

- ✅ **Minor Updates** (2.8.x → 2.9.x): Generally safe, may include new features
- ⚠️ **Major Updates** (2.x → 3.x): Require careful migration planning
- 🔒 **Current**: MedusaJS 2.8.4 (December 2024)

### Rollback if Needed

If upgrade fails:
```bash
# Restore database
psql $DATABASE_URL < backup.sql

# Revert package.json versions
git checkout HEAD~1 -- backend/package.json
pnpm install
```

---

## 🏗️ Local Development

### Prerequisites
- Node.js 20+
- pnpm 9+
- Railway account (for databases)

### Setup Steps
1. **Clone & Install** (see step 1 above)
2. **Setup Railway Services** (see step 2 above)  
3. **Setup External Services** (see step 3 above)
4. **Create .env.local files** (see step 4 above)
5. **Run Database Migrations**:
```bash
cd backend
pnpm medusa db:migrate
```

6. **Start Development**:
```bash
# Terminal 1: Backend
cd backend
pnpm run dev

# Terminal 2: Storefront  
cd storefront
pnpm run dev
```

7. **Access Applications**:
- 🛍️ **Storefront**: http://localhost:3000
- ⚙️ **Admin**: http://localhost:9000/app
- 🎨 **Sanity Studio**: http://localhost:3000/cms

---

## 📁 Project Structure

```
├── backend/                 # MedusaJS 2.8.4 API
│   ├── src/
│   │   ├── admin/          # Admin customizations
│   │   ├── api/            # API routes
│   │   ├── modules/        # Custom modules
│   │   ├── subscribers/    # Event handlers
│   │   └── workflows/      # Business logic
│   └── medusa-config.ts    # Backend configuration
├── storefront/             # Next.js 15 frontend
│   ├── app/               # App router pages
│   ├── components/        # React components
│   ├── sanity/           # Sanity CMS schemas
│   └── next.config.mjs   # Next.js configuration
└── README.md             # This file
```

---

## 🎯 What You Get

✅ **Complete E-commerce Platform**  
✅ **Modern Admin Dashboard**  
✅ **Responsive Storefront**  
✅ **Content Management (Sanity)**  
✅ **Payment Processing (Stripe)**  
✅ **File Storage (AWS S3)**  
✅ **Email System**  
✅ **SEO Optimized**  
✅ **Mobile Responsive**  
✅ **Production Ready**

---

## 📚 Documentation

- 📖 **[Detailed Setup Guide](./QUICK_START.md)** - Complete step-by-step instructions
- 🚀 **[Other Deployment Options](./OTHER_DEPLOYMENT_OPTIONS.md)** - Alternative deployment methods
- 📋 **[Deployment Guide](./deployment-guide.md)** - Production deployment checklist
- 🔧 **[MedusaJS Docs](https://docs.medusajs.com)** - Official documentation
- ⚡ **[Next.js Docs](https://nextjs.org/docs)** - Frontend framework docs
- 🎨 **[Sanity Docs](https://www.sanity.io/docs)** - CMS documentation

---

## 🆘 Support & Troubleshooting

### Critical Setup Issues & Solutions

#### 🔧 **Admin Login "process is not defined" Error**
**Problem**: Admin shows `process is not defined` error in browser console  
**Solution**: This is fixed in this template. If you encounter it:
```typescript
// In backend/src/admin/lib/sdk.ts, ensure this code:
export const backendUrl = typeof window !== "undefined" 
  ? `${window.location.protocol}//${window.location.hostname}:9000`
  : "http://localhost:9000";
```

#### 🔧 **Railway Database Connection Issues**
**Problem**: `getaddrinfo ENOTFOUND postgres.railway.internal`  
**Solution**: Use **PUBLIC** database URLs for local development:
1. Go to Railway dashboard → PostgreSQL service
2. Copy `DATABASE_PUBLIC_URL` (not `DATABASE_URL`)
3. Copy `REDIS_PUBLIC_URL` (not `REDIS_URL`)
4. Update your `.env` file with public URLs

#### 🔧 **Admin User Creation**
**Problem**: Can't access admin after deployment  
**Solution**: Create admin user via CLI:
```bash
cd backend
npx medusa user --email your@email.com --password yourpassword
```

#### 🔧 **CORS Errors**
**Problem**: Frontend can't connect to backend  
**Solution**: Update CORS settings in backend `.env`:
```bash
STORE_CORS="https://your-storefront.vercel.app,http://localhost:3000"
ADMIN_CORS="https://your-storefront.vercel.app,http://localhost:3000"
AUTH_CORS="https://your-storefront.vercel.app,http://localhost:3000"
```

#### 🔧 **Build Failures on Railway**
**Problem**: Deployment fails with build errors  
**Solution**: Ensure all environment variables are set in Railway:
1. Go to Railway project → Variables tab
2. Add ALL variables from your `.env.template`
3. Use **production** values (not localhost URLs)

### Railway Deployment Checklist

#### ✅ **Pre-Deployment Steps**
1. **Test locally first** - Ensure everything works with Railway databases
2. **Update environment variables** - Use production URLs, not localhost
3. **Build locally** - Run `pnpm build` to catch build errors early
4. **Commit all changes** - Railway deploys from your Git repository

#### ✅ **Railway Configuration**
1. **Root Directory**: Set to `backend` in Railway settings
2. **Build Command**: `pnpm install && pnpm build`
3. **Start Command**: `pnpm start`
4. **Environment Variables**: Copy from your working `.env` file

#### ✅ **Critical Environment Variables for Railway**
```bash
# Database (Railway provides these)
DATABASE_URL="postgresql://..."
REDIS_URL="redis://..."

# Backend URL (Railway provides this)
MEDUSA_BACKEND_URL="https://your-app.railway.app"

# Security (generate new ones for production)
JWT_SECRET="production-jwt-secret-here"
COOKIE_SECRET="production-cookie-secret-here"

# External services (same as local)
SANITY_PROJECT_ID="..."
SANITY_API_TOKEN="..."
AWS_ACCESS_KEY_ID="..."
AWS_SECRET_ACCESS_KEY="..."
S3_BUCKET="..."
STRIPE_API_KEY="..."

# CORS (use your production URLs)
STORE_CORS="https://your-storefront.vercel.app"
ADMIN_CORS="https://your-storefront.vercel.app"
AUTH_CORS="https://your-storefront.vercel.app"
```

#### ✅ **Post-Deployment Steps**
1. **Check deployment logs** - Look for any errors in Railway logs
2. **Test health endpoint** - Visit `https://your-app.railway.app/health`
3. **Create admin user** - Use Railway CLI or connect to deployed database
4. **Test admin access** - Visit `https://your-app.railway.app/app`
5. **Update storefront** - Point `NEXT_PUBLIC_MEDUSA_BACKEND_URL` to Railway URL

### Common Issues

#### Database Connection
- **Local Development**: Use Railway's **PUBLIC** database URLs
- **Production**: Railway automatically provides internal URLs
- **Format**: Ensure DATABASE_URL includes all connection parameters

#### CORS Errors  
- **Development**: Include `http://localhost:3000` in CORS settings
- **Production**: Use your actual domain URLs
- **Multiple URLs**: Separate with commas (no spaces)

#### Build Failures
- **Missing Variables**: All environment variables must be set
- **Node Version**: Ensure Railway uses Node.js 20+
- **Dependencies**: Run `pnpm install` before building

#### Admin Access
- **URL**: Use `/app` not `/admin` for MedusaJS 2.0+
- **User Creation**: Must create admin user via CLI first
- **Browser Issues**: Try incognito mode if admin won't load

### Get Help
- 💬 **[MedusaJS Discord](https://discord.gg/medusajs)**
- 📖 **[MedusaJS Documentation](https://docs.medusajs.com)**
- 🐛 **[Report Issues](https://github.com/medusajs/medusa/issues)**
- 💡 **[Community Forum](https://github.com/medusajs/medusa/discussions)**
- 🚂 **[Railway Documentation](https://docs.railway.app)**

---

**Built with ❤️ by [Tinloof](https://tinloof.com) • Fixed & Enhanced by [ZachJxyz](https://github.com/ZachJxyz)**
