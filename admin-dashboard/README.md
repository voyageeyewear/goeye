# Eyejack Admin Dashboard

A professional, elegant admin dashboard for managing the Eyejack Flutter app content in real-time.

**⚠️ Admin Tool - Designed for Local Use Only**

This dashboard is an **administrative tool** meant to run on your local computer. It connects to your production backend API and database, allowing you to manage app content securely from your development environment.

## Features

- 📊 **Dashboard Overview**: View statistics and quick actions
- 🎨 **Sections Management**: Add, edit, delete, and reorder app sections
- 🎨 **Theme Settings**: Customize colors and global styles
- 👁️ **Live Preview**: See how your changes look in real-time
- ⚡ **Real-time Updates**: Changes are applied instantly without app rebuild
- 🔒 **Secure**: Runs locally on your machine for maximum security

## Tech Stack

- **React 18** with TypeScript
- **Vite** for fast development
- **Tailwind CSS** for styling
- **React Query** for data fetching
- **React Router** for navigation
- **Axios** for API calls
- **Lucide React** for icons

## Getting Started

### Installation

```bash
npm install
```

### Running the Dashboard (Local Development)

```bash
npm run dev
```

The dashboard will be available at `http://localhost:5173`

**Important**: This dashboard is designed to run locally on your computer. It connects to your production backend on Railway, so all changes you make are real and will affect your live app!

### Build (Optional - For Testing)

```bash
npm run build
```

This creates an optimized production build in the `dist/` folder. However, **you typically don't need this** since the dashboard is meant for local admin use only.

## Configuration

Create a `.env` file in the root directory:

```env
VITE_API_BASE_URL=https://motivated-intuition-production.up.railway.app
```

## Features Guide

### Dashboard
- View total sections, theme settings, and active sections
- Quick access to common actions
- Overview of section types

### Sections Management
- View all sections in order
- Toggle section visibility (active/inactive)
- Edit section settings with JSON editor
- Delete sections
- Drag to reorder (coming soon)

### Theme Settings
- Edit color values with color picker
- Modify text and number settings
- Changes apply instantly to the app

### Live Preview
- See current app configuration
- Auto-refreshes every 5 seconds
- View detailed section settings

## API Integration

The dashboard connects to your PostgreSQL backend via REST API:

- `GET /api/admin/sections` - Get all sections
- `POST /api/admin/sections` - Create new section
- `PUT /api/admin/sections/:id` - Update section
- `DELETE /api/admin/sections/:id` - Delete section
- `GET /api/admin/theme-settings` - Get theme settings
- `PUT /api/admin/theme-settings/:key` - Update theme setting
- `GET /api/admin/dashboard-stats` - Get dashboard statistics

## Why Local Only?

### Security & Control
- ✅ **Secure**: Admin tools shouldn't be publicly accessible
- ✅ **No authentication needed**: Since it's only accessible from your computer
- ✅ **Full control**: You control when it runs and who has access
- ✅ **Cost-effective**: No hosting costs for admin dashboard
- ✅ **Fast development**: Instant updates and debugging

### Architecture
```
Your Computer (Local)          Railway (Production)
┌─────────────────┐           ┌──────────────────┐
│   Dashboard     │  ───────> │   Backend API    │
│   localhost     │  API Call │   PostgreSQL DB  │
└─────────────────┘           └──────────────────┘
                                       │
                                       ▼
                              ┌──────────────────┐
                              │   Flutter App    │
                              │   (Mobile)       │
                              └──────────────────┘
```

The dashboard runs locally but manages production data through the Railway API.

## License

Proprietary - Eyejack Application
