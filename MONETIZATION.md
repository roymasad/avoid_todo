# Avoid App — Monetization Strategy

## Tier Structure

| Tier | Who it's for | Price |
|------|-------------|-------|
| **Free** | Everyone | $0 forever |
| **Plus** | Pay-once crowd (no subscriptions) | ~$5.99 one-time |
| **Pro** | Power users wanting cloud + AI | ~$2.99/mo or $19.99/yr |

**Core principle:** Free keeps everything currently in the app. Plus adds local-only extras (no server cost). Pro adds cloud/AI features with real ongoing cost — subscription is justified.

---

## Free Tier (forever)
Everything currently in the app:
- Unlimited habits
- Streaks, relapse logging, trigger notes
- Full statistics & charts
- Location-based reminders, contact linking
- Tags, badges, notifications
- Daily commitment button (see below)
- Basic XP & levels

---

## Plus Tier — One-Time ~$5.99
Local features only, no API or server costs.

- **Home screen widget** — streak + habit name on home screen (`home_widget` package, no backend)
- **XP boosts & unlockable titles** — expanded level names, cosmetic title badges (e.g. *Rookie → Resistant → Disciplined → Unbreakable*)
- **Unlockable accent colors** — cosmetic theme unlocks tied to level milestones
- **Local smart tips** — algo-based personalized suggestions (pattern detection from existing data, on-device, no LLM)
- **Habit replacement suggestions** — "try this instead" shown on relapse, algo-selected based on habit tags/type
- **Advanced local stats** — extended history, calendar heatmap view, monthly/yearly trends

---

## Pro Tier — ~$2.99/mo or $19.99/yr
Everything in Plus, plus cloud/AI features:

- **Cloud backup & sync** — SQLite → JSON → iCloud Drive (iOS) / Google Drive (Android). No server needed, just cloud storage the user already has.
- **AI counsellor** — Real-time conversational support during a craving moment. Knows your habit history, trigger patterns, weak days. Powered by LLM via serverless proxy (Cloudflare Workers / Vercel). Most defensible premium feature.
- **AI-powered replacement tips** — Same as Plus habit replacement but actually personalized by LLM using the user's specific context, not just rule-based.
- **AI weekly insights** — Every Sunday, a personalized paragraph: trigger patterns, best/worst days, projected savings. Uses data already tracked.
- **Accountability partner** — Shareable invite code. Partner receives push notifications on relapses + weekly summaries. Requires Firebase (Firestore + FCM). Strongest viral growth driver.

---

## Engagement & Gamification System (Free for all tiers)

### XP Sources
| Action | XP |
|--------|----|
| Daily login | +10 XP |
| Daily commitment button | +20 XP |
| Streak milestone (7d, 30d, 90d...) | +50–200 XP |
| Logging a relapse (honesty rewarded) | +15 XP |
| Logging a trigger note | +10 XP |
| Archiving a completed habit | +100 XP |

### Daily Commitment Button
A dedicated screen shown once per day (or accessible from home) where the user makes a soft daily pledge — not a strict rule, but a psychological pep talk and intention-setting moment. Backed by implementation intention research (stating "I will avoid X today" measurably increases follow-through).

UI concept: calm full-screen moment, their habit list shown, a single "I'm committed today" button. Tapping it awards XP and dismisses. No guilt if they don't — purely positive reinforcement.

### Levels & Titles (examples)
| Level | XP Required | Title |
|-------|-------------|-------|
| 1 | 0 | Beginner |
| 2 | 100 | Aware |
| 5 | 500 | Resistant |
| 10 | 1500 | Disciplined |
| 20 | 5000 | Unbreakable |
| 30 | 12000 | Legend |

Plus unlocks: custom title colors, cosmetic accent themes at milestone levels.

---

## Build Order

1. **RevenueCat + Paywall** — Foundation for all monetization. `purchases_flutter` package. ~2 days.
2. **XP / Levels / Daily Commitment Button** — High retention, no backend, works on Free tier. ~3 days.
3. **Home Screen Widget** — Quick win for Plus. ~2-3 days.
4. **Cloud Backup** — High-value Pro feature, no server needed. ~3-4 days.
5. **AI Weekly Insights** — First LLM feature, serverless proxy. ~4-5 days.
6. **AI Counsellor** — Flagship Pro feature, conversational. ~1 week.
7. **Accountability Partner** — Firebase backend, viral. ~1-2 weeks.

---

## Competitive Reference

| App | Model | Price | Notes |
|-----|-------|-------|-------|
| Quitzilla | Freemium + subscription | $2.99/mo or $19.99/yr | Closest competitor, virtual pet gamification |
| Habitify | Freemium + subscription | $4.99/mo or $64.99 lifetime | Habit building focus |
| Streaks | Paid upfront | $4.99 one-time | iOS only, no analytics |
| Days Since | Free + ads | $0 | Very basic, just counters |
| Delust | Subscription | Unknown | Niche (porn), has panic button concept |
| Accountable2You | Subscription | $7/mo | Accountability partner only |

---

## Key Insights
- **Avoid's differentiation:** only app combining relapse trigger analysis + cost quantification + location/contact avoidance in one place.
- **Subscription justification:** cloud and AI features have real ongoing cost; one-time Plus for local features is a fair split users understand intuitively.
- **Accountability partner** is the single highest-leverage feature to build eventually — viral by design, proven willingness to pay ($7/mo just for this elsewhere), no competitor in the avoidance-app space.
- **Daily commitment button** doubles as a retention mechanism (daily open habit) and an XP source — two birds, one stone.
- **Habit replacement tip** keeps the app focused (no full habit-building module) while acknowledging that substitution is scientifically more effective than pure avoidance.
