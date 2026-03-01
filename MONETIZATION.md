# Avoid App — Monetization Strategy

## Tier Structure

**Free (forever):** Everything currently in the app — unlimited habits, all stats, streaks, notifications, location reminders, contacts, tags, badges, relapse logging, full analytics.

**Pro ($2.99/mo or $19.99/yr):** New premium-only features added on top. No existing features removed.

Pricing rationale: matches Quitzilla (most direct competitor), low end of market — appropriate since the free tier is already generous.

---

## Premium Features to Build (in recommended order)

### 1. RevenueCat + Paywall Screen — Foundation (~2 days)
Must be done before any other feature.
- Add `purchases_flutter` package
- Create subscription products in App Store Connect + Google Play Console
- `lib/services/subscription_service.dart` — wraps RevenueCat SDK, exposes `isPro` stream
- `lib/screens/paywall_screen.dart` — shown when a Pro feature is tapped
- Gate each Pro feature with `if (!isPro) showPaywall()`

### 2. Home Screen Widget (~2-3 days)
- Shows streak + habit name on iOS/Android home screen
- Package: `home_widget` (no backend needed)
- High perceived value, zero infrastructure cost
- iOS: WidgetKit extension; Android: AppWidgetProvider

### 3. Cloud Backup & Sync (~3-4 days)
- Export SQLite → JSON → iCloud Drive (iOS) / Google Drive (Android)
- No server required, no sync conflicts
- Manual backup/restore or auto on app open
- Strong retention driver (fear of data loss)

### 4. AI Weekly Insights (~4-5 days)
- Every Sunday: personalized paragraph based on trigger patterns, relapse day-of-week data, streaks
- Requires a serverless proxy (Cloudflare Workers or Vercel, free tier) to call Claude API securely
- Uses data already tracked: trigger notes, relapse timing, streak history
- Ongoing API cost per user → justifies subscription

### 5. Accountability Partner (~1-2 weeks)
- User generates a shareable invite code
- Partner enters code and receives push notifications on relapses + weekly summaries
- Backend: Firebase (Firestore + FCM) — free tier sufficient for early stage
- Most complex, but strongest viral growth driver (partner becomes a potential new user)

---

## Competitive Reference

| App | Model | Price |
|-----|-------|-------|
| Quitzilla | Freemium + subscription | $2.99/mo or $19.99/yr |
| Habitify | Freemium + subscription | $4.99/mo or $64.99 lifetime |
| Streaks | Paid upfront | $4.99 one-time |
| Accountable2You | Subscription (accountability focus) | $7/mo |

---

## Notes
- Accountability partner is the single most compelling feature to eventually build: it's viral by design (inviting a partner introduces a new potential user), has no direct competitor in this app category, and research shows it raises habit success rates to 95%.
- AI insights justifies subscription because it has a real ongoing cost and delivers ongoing value every week.
- Cloud backup addresses the user pain point of losing all streak/relapse history if they switch phones — high willingness to pay.
- Widget is the quickest win with the highest perceived value per hour of work.
