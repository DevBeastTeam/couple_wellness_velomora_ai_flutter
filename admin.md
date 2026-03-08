# ReactJS + vite js + tailwinf css. Admin Panel — Velmora AI (Couples' Wellness & Relationship App)

## Project Context

Build a **production-ready ReactJS admin dashboard** for **Velmora AI**, a mobile application (Flutter, iOS & Android) focused on couple wellness, relationship coaching, and interactive games. The app uses **Firebase** as its entire backend (Firestore, Firebase Auth, Firebase Storage, Firebase Cloud Messaging, Firebase Analytics, Firebase Crashlytics, Firebase Performance). The admin panel must connect directly to the **same Firebase project** the mobile app uses, providing full administrative control over every aspect of the application.

> **Tech Stack for Admin Panel:**
> - **Frontend:** React 18+ with React Router v6 
> - **UI Library:** Material UI (MUI) v5 or Ant Design
> - **State Management:** React Context API or Zustand
> - **Backend:** Firebase Admin SDK (Firestore, Auth, Storage)
> - **Charts:** Recharts or Chart.js
> - **Auth:** Firebase Authentication (Email/Password for admin users)
> - **Hosting:** Firebase Hosting
> - **Language:** TypeScript
> - **css:** : tailwindcss
> - **build tool:** vite js
---

## Firebase Firestore Collections Reference

The mobile app uses these Firestore collections. The admin panel must read/write to them:

| Collection | Purpose |
|---|---|
| `users` | All user profiles, subscription status, preferences, feature access |
| `users/{uid}/chatMessages` | AI chat history per user |
| `users/{uid}/notifications` | In-app notifications per user |
| `users/{uid}/game_content_views` | Game content view tracking per user |
| `users/{uid}/kegel_data` | Kegel exercise progress per user |
| `user_daily_limits` | Daily AI message limits (doc ID: `{uid}_{YYYY-MM-DD}`) |
| `rate_limits` | Per-user rate limiting data |
| `games` | Game definitions (Truth or Truth, Love Language Quiz, Reflection & Discussion) |
| `game_sessions` | Active/completed game sessions |
| `game_content` | AI-generated game questions (versioned, refreshed monthly) |
| `ai_config/settings` | AI configuration (API key, model, system prompt, safety settings, temperature, tokens) |
| `admin/support_messages/submissions` | User support messages |
| `admin/bug_reports/submissions` | User bug reports |
| `admin/legal_docs/items` | Legal documents (Privacy Policy, Terms of Service) |
| `admin/faqs/items` | FAQ entries |

---

## Complete Feature Requirements

### 1. Authentication & Access Control

- Admin login via Firebase Auth (Email/Password only)
- Role-based access control with at least 2 roles: **Super Admin**, **Moderator**
- Store admin roles in a Firestore `admins` collection with fields: `uid`, `email`, `role`, `createdAt`
- Protected routes — unauthenticated users redirect to login
- Session persistence with auto-logout after 30 minutes of inactivity
- Admin activity logging (who changed what, when)

### 2. Dashboard (Home Page)

A real-time overview with KPI cards and charts:

**KPI Cards (top row):**
- Total Users (count of `users` collection)
- Active Subscribers (users where `subscriptionStatus == 'premium'`)
- Active Trials (users where `subscriptionStatus == 'trial'` and `trialEndTime > now`)
- Today's AI Messages (sum of `aiMessageCount` in `user_daily_limits` for today's date)
- Total Games Played (count of `game_sessions` where `status == 'completed'`)
- Active Users Today (users where `lastLoginAt` is today)
- Total Revenue (calculated from subscription data)
- Pending Support Tickets (count of `admin/support_messages/submissions` where `status == 'pending'`)

**Charts:**
- User Growth (line chart — new registrations per day/week/month from `createdAt`)
- Subscription Distribution (pie chart — free vs trial vs premium)
- Daily AI Message Volume (bar chart — messages per day from `user_daily_limits`)
- Game Popularity (bar chart — sessions per game type from `game_sessions`)
- Kegel Completion Rate (line chart — daily completions from user kegel data)
- Revenue Over Time (line chart — subscriptions × plan price over time)

### 3. User Management

**User List Page:**
- Paginated, searchable, sortable table of all users
- Columns: Avatar, Display Name, Email, Subscription Status, Preferred Language, Last Login, Created At, Actions
- Filters: Subscription status (free/trial/premium), Language (en/ar/fr), Date range, Active/Inactive
- Bulk actions: Send notification, Export CSV

**User Detail Page:**
- Profile info: UID, email, display name, profile picture (from Firebase Storage `profile_pictures/{uid}.jpg`), preferred language, subscription status, created/updated timestamps
- Subscription Management:
  - View current plan, expiry date, trial start/end times
  - Manually upgrade/downgrade subscription status (`free`, `trial`, `premium`)
  - Set/extend trial period
  - View subscription history
- Feature Access toggle: Games, Kegel, Chat (stored in `featuresAccess` map)
- AI Chat History: Read-only view of `users/{uid}/chatMessages` (ordered by timestamp)
  - Show sender (user/AI), message content, timestamp
  - Option to clear chat history
- Game Activity: List of game sessions from `game_sessions` filtered by this user
  - Game type, status (in_progress/completed), scores, timestamps
- Kegel Progress: Read from `users/{uid}/kegel_data`
  - Total exercises completed, current streak, longest streak, total minutes
  - Achievements earned
  - 30-day challenge progress (days completed out of 30)
  - Weekly/monthly progress charts
- Notification History: List from `users/{uid}/notifications`
- Rate Limit Status: Current daily AI message count from `user_daily_limits`
- **Actions:**
  - Send in-app notification
  - Reset daily AI limit
  - Disable/Enable account
  - Delete account (remove Auth user + Firestore doc + Storage files)

### 4. Subscription Management

**Subscription Overview:**
- Summary cards: Total Premium, Total Trial, Total Free, Expired Trials
- Subscription plan breakdown: Monthly ($3.99), Quarterly ($9.99), Yearly ($29.99)
- Revenue calculations per plan
- Trial conversion rate (trials that became premium / total trials)

**Subscription Table:**
- List of all users with subscription info
- Columns: User, Plan, Status, Start Date, Expiry Date, Auto-Renew, Platform (iOS/Android)
- Quick actions: Extend, Cancel, Upgrade

**Configuration:**
- Edit subscription plan prices (stored in Firestore config)
- Set trial duration (currently 48 hours)
- Toggle free trial availability

### 5. AI Configuration & Management

**AI Settings Panel (reads/writes `ai_config/settings`):**
- **API Key Management:** View (masked), update Gemini API key
- **Model Selection:** Dropdown to select model (default: `gemini-2.0-flash`)
- **Parameters:**
  - Temperature (slider: 0.0 – 1.0, default: 0.7)
  - Max Tokens (number input, default: 500)
  - Top K (number input, default: 40)
  - Top P (slider: 0.0 – 1.0, default: 0.95)
- **System Instruction:** Large text editor to view/edit the AI's system prompt (the persona definition)
- **Safety Settings:** Dropdowns for each category:
  - Sexually Explicit: `BLOCK_NONE` / `BLOCK_ONLY_HIGH` / `BLOCK_MEDIUM_AND_ABOVE` / `BLOCK_LOW_AND_ABOVE`
  - Hate Speech: same options
  - Harassment: same options
  - Dangerous Content: same options
- **Enable/Disable AI toggle** (global kill switch)
- **Test Chat:** An embedded chat widget to test the AI with current settings before saving
- Save & discard buttons with confirmation dialog

**AI Usage Analytics:**
- Total AI messages today / this week / this month
- Average response time
- API error rate
- Token usage estimation
- Top users by AI usage
- Messages per language breakdown (en/ar/fr)

**Daily Limits Configuration:**
- Set free-tier daily AI message limit (currently 3 per day)
- View users who hit their daily limit today
- Manually reset individual user limits

### 6. Game Content Management

**Game Definitions:**
- List of 3 games: Truth or Truth, Love Language Quiz, Reflection & Discussion
- For each game: name, description, icon, rules, premium requirement, player count, estimated duration
- Toggle game availability (enable/disable)

**Game Content (Questions) Management:**
- **Truth or Truth:** CRUD for questions — each question is a text string. Current 10 default questions + AI-generated monthly refreshes
- **Love Language Quiz:** CRUD for questions — each question has text + 5 options (each option maps to a love language category: Words of Affirmation, Quality Time, Receiving Gifts, Acts of Service, Physical Touch)
- **Reflection & Discussion:** CRUD for prompts — open-ended reflection questions

**AI Content Generation:**
- Trigger manual content refresh per game (calls AI to generate new questions)
- View content versions (version number, generation date, question count)
- Schedule automatic monthly content refresh
- Preview generated content before publishing
- Rollback to previous version

**Game Analytics:**
- Games played per day/week/month
- Most popular game
- Average session duration per game
- Completion rate per game
- Player engagement metrics

### 7. Kegel Exercise Management

**Routine Configuration:**
- View/edit 3 routine definitions:
  - Beginner: 5 min, 3 sets
  - Intermediate: 10 min, 5 sets
  - Advanced: 15 min, 7 sets
- Edit hold/release durations per routine

**30-Day Challenge Configuration:**
- Edit week-by-week plan structure:
  - Week 1 (Foundation): days 1-7, beginner routines
  - Week 2 (Consistency): days 8-14, maintain daily
  - Week 3 (Progress): days 15-21, intermediate routines
  - Week 4 (Mastery): days 22-30, advanced routines
- Set challenge completion badge/reward

**Achievement Definitions:**
- View/edit 6 achievements:
  - First Steps (complete 1 exercise)
  - Week Warrior (7-day streak)
  - Month Master (30-day streak)
  - Century Club (100 exercises)
  - Time Champion (500 total minutes)
  - Streak Legend (14-day longest streak)

**Kegel Analytics:**
- Total sessions completed globally
- Average sessions per user
- Most popular routine level
- Challenge completion rate
- Streak distribution chart

### 8. Notifications Management

**Push Notifications:**
- Send push notification to all users or filtered segments (by language, subscription status, platform)
- Send to individual user
- Notification composer: Title, Body, optional data payload
- Schedule future notifications
- View push notification history and delivery stats

**In-App Notifications:**
- View all in-app notifications stored in `users/{uid}/notifications`
- Types: `profile`, `exercise`, `game`, `subscription`, `system`
- Create/send bulk in-app notifications
- Template management for recurring notifications

**Notification Settings:**
- Configure default notification types (exercise reminders, game suggestions, AI tips, daily reminders)

### 9. Support & Bug Reports

**Support Messages:**
- Table view of all submissions from `admin/support_messages/submissions`
- Columns: User, Name, Email, Message, Status (pending/in_progress/resolved), Timestamp
- Status management: Change status, add admin notes
- Reply to user (store reply in document, optionally send push notification)

**Bug Reports:**
- Table view of all submissions from `admin/bug_reports/submissions`
- Columns: User, Title, Description, Status (pending/investigating/fixed/closed), Timestamp
- Status management with admin notes
- Priority tagging (low/medium/high/critical)

### 10. Legal & Content Management

**Legal Documents:**
- Rich text editor for Privacy Policy (stored in `admin/legal_docs/items/privacy_policy`)
- Rich text editor for Terms of Service (stored in `admin/legal_docs/items/terms_of_service`)
- Version history and publish/draft management
- Multi-language support (en, ar, fr) — separate content per language

**FAQ Management:**
- CRUD for FAQs stored in `admin/faqs/items`
- Fields: question, answer, order (for sorting), category, isActive
- Drag-and-drop reordering
- Multi-language support

### 11. Analytics & Reporting

**User Analytics:**
- New vs returning users
- User retention (Day 1, Day 7, Day 30)
- Geographic distribution (if available)
- Language preference distribution
- Device/platform breakdown (iOS vs Android)

**Engagement Analytics:**
- Daily Active Users (DAU) / Monthly Active Users (MAU)
- Average session duration
- Feature usage breakdown (Games vs Kegel vs Chat)
- Most active hours/days

**Revenue Analytics:**
- Monthly Recurring Revenue (MRR)
- Average Revenue Per User (ARPU)
- Subscription churn rate
- Plan popularity comparison
- Trial-to-paid conversion funnel

**Export:**
- Export any table/report to CSV/PDF
- Date range filters on all reports
- Scheduled report emails (optional)

### 12. Rate Limiting & Security

**Rate Limit Dashboard:**
- View current rate limit configuration per action type:
  - AI Messages: X per day (free users)
  - Game Play: X per hour
  - Kegel Sessions: X per day
  - Profile Updates: X per hour
  - Support Messages: X per day
- Edit rate limits
- View rate-limited users (who got blocked and when)
- Manual rate limit reset per user

**Security Logs:**
- Failed login attempts
- Suspicious activity alerts
- Account deletion log
- Admin action audit trail

### 13. Localization Management

**Translation Management:**
- View current translations for all 3 languages (en, ar, fr)
- The app uses a custom `AppLocalizations.dart` with ~500+ keys
- Admin panel should allow viewing/searching keys and their translations
- Flag missing translations per language
- Future: ability to add new languages without code changes

### 14. System Configuration

**App Configuration:**
- Feature flags (toggle features on/off globally)
- Maintenance mode toggle (show maintenance message in app)
- App version management (minimum required version, force update)
- Global announcements (banner shown to all users)

**Firebase Configuration:**
- Firestore security rules viewer (read-only display)
- Storage usage overview
- Cloud Functions status (if any deployed)

---

## UI/UX Requirements

### Design System
- **Theme:** Modern, clean admin dashboard with a **dark mode** and **light mode** toggle
- **Primary Color:** Deep Purple (#7C3AED) matching the app's brand
- **Accent Color:** Purple/Lavender (#A78BFA)
- **Typography:** Inter or Roboto font family
- **Layout:** Collapsible sidebar navigation + top header bar with admin info and notifications bell
- **Responsive:** Works on desktop (primary), tablet, and mobile

### Navigation Sidebar
```
📊 Dashboard
👥 Users
   └─ User List
   └─ User Details
💳 Subscriptions
🤖 AI Configuration
   └─ Settings
   └─ Usage Analytics
   └─ Daily Limits
🎮 Games
   └─ Game Definitions
   └─ Content Management
   └─ Analytics
🧘 Kegel Exercises
   └─ Routines
   └─ Challenge
   └─ Achievements
   └─ Analytics
🔔 Notifications
   └─ Send Push
   └─ In-App
   └─ Templates
🎫 Support
   └─ Messages
   └─ Bug Reports
📄 Content
   └─ Legal Docs
   └─ FAQs
📈 Analytics
   └─ Users
   └─ Engagement
   └─ Revenue
🔒 Security
   └─ Rate Limits
   └─ Audit Logs
🌍 Localization
⚙️ Settings
   └─ App Config
   └─ Feature Flags
   └─ Admins
```

### Page Patterns
- **List pages:** Data tables with search, filter, sort, pagination, bulk actions
- **Detail pages:** Tabbed layout with related information grouped
- **Form pages:** Inline validation, save/discard, confirmation dialogs
- **All actions** should have success/error toast notifications
- **Skeleton loaders** for data-fetching states
- **Empty states** with helpful illustrations and messages
- **Breadcrumb navigation** on all pages

---

## Technical Requirements

### Firebase Integration
```javascript
// Firebase config — use the SAME project as the mobile app
import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';
import { getAuth } from 'firebase/auth';
import { getStorage } from 'firebase/storage';
```

### Key Implementation Notes
1. **Real-time updates:** Use Firestore `onSnapshot` listeners for dashboard KPIs and live data
2. **Pagination:** Use Firestore cursor-based pagination (`startAfter`, `limit`) for all tables — never load all docs at once
3. **Security:** Admin panel must verify admin role on every Firestore operation via security rules
4. **Error handling:** Graceful error boundaries, retry logic, user-friendly error messages
5. **Performance:** Lazy load routes, virtualized tables for large datasets, debounced search
6. **Caching:** Cache Firestore query results where appropriate to reduce reads

### Firestore Security Rules (Admin)
```
// Add these rules to allow admin access
match /admins/{adminId} {
  allow read, write: if request.auth != null && exists(/databases/$(database)/documents/admins/$(request.auth.uid));
}

// Admin access to all collections
match /{document=**} {
  allow read, write: if request.auth != null && exists(/databases/$(database)/documents/admins/$(request.auth.uid));
}
```

### Folder Structure
```
src/
├── components/          # Reusable UI components
│   ├── Layout/          # Sidebar, Header, Breadcrumbs
│   ├── Tables/          # Generic data table component
│   ├── Charts/          # Chart wrapper components
│   ├── Forms/           # Form components
│   └── Common/          # Buttons, Cards, Modals, Loaders
├── pages/               # Page components (one per route)
│   ├── Dashboard/
│   ├── Users/
│   ├── Subscriptions/
│   ├── AIConfig/
│   ├── Games/
│   ├── Kegel/
│   ├── Notifications/
│   ├── Support/
│   ├── Content/
│   ├── Analytics/
│   ├── Security/
│   ├── Localization/
│   └── Settings/
├── services/            # Firebase service layer
│   ├── firebase.ts      # Firebase initialization
│   ├── authService.ts
│   ├── userService.ts
│   ├── subscriptionService.ts
│   ├── aiConfigService.ts
│   ├── gameService.ts
│   ├── kegelService.ts
│   ├── notificationService.ts
│   ├── supportService.ts
│   ├── analyticsService.ts
│   └── adminService.ts
├── hooks/               # Custom React hooks
├── contexts/            # React Context providers
├── types/               # TypeScript type definitions
├── utils/               # Utility functions
├── constants/           # App constants
└── routes/              # Route definitions
```

---

## Deployment

- Build with `npm run build`
- Deploy to **Firebase Hosting** under a custom subdomain (e.g., `admin.velmoraai.com`)
- Environment variables via `.env` for Firebase config
- CI/CD pipeline with GitHub Actions (build → test → deploy)

---

## Summary

This admin panel is the **central management hub** for the entire Velmora AI ecosystem. It must provide complete visibility and control over:
- **7,000+ potential users** and their data
- **3 interactive couple games** and their AI-generated content
- **AI chat system** powered by Gemini with configurable prompts, limits, and safety settings
- **Kegel wellness tracking** with routines, challenges, and achievements
- **Subscription lifecycle** (free → trial → premium) with revenue analytics
- **Push & in-app notification system**
- **Support ticketing** and bug report management
- **Legal documents and FAQs**
- **Rate limiting and security controls**
- **Multi-language content** (English, Arabic, French)

Every feature must be **real-time**, **production-grade**, and **beautifully designed** with a UI that matches the premium quality of the mobile app.
