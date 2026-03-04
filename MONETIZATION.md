# Avoid App — Monetization Strategy

## Tier Structure

| Tier | Who it's for | Price |
|------|-------------|-------|
| **Free** | Everyone | $0 forever |
| **Plus** | Pay-once crowd (no subscriptions) | $2.99 one-time |
| **Pro** | Power users wanting AI + partner features | $3.99/mo or $27.99/yr |

**Core principle:** Free gives real, lasting value. Plus is an affordable permanent upgrade for local features — priced as an impulse buy. Pro adds AI and real-time partner features that have ongoing server costs — subscription is justified there only. Pro includes all Plus features while subscribed; cancelling Pro drops back to Free (or Plus if purchased separately).

---

## Free Tier (forever)

- Unlimited habits
- Streak counter, relapse logging, trigger notes
- Location-based reminders, contact linking
- Tags, basic manual notifications
- Basic badges (5 existing achievements)
- XP & levels 1–20
- Stats for the last 2 weeks

---

## Plus Tier — One-Time $2.99

Everything in Free, plus:

- **Daily commitment therapeutic flow** — a calm daily screen where the user commits to each habit, sees their relevant tips for today, earns XP, and unlocks achievements. The core daily ritual of the app.
- **Pre-coded habit replacement tips** — a curated local library of practical tips categorized by habit type and tag (e.g. money habits, people avoidance, place avoidance). Shown during and after a relapse moment. No AI, no server — fully on-device.
- **Smart scheduled notifications** — proactive heads-up reminders based on the user's own relapse patterns (e.g. "You tend to slip on Fridays — heads up"), plus a next-day follow-up after a relapse ("Yesterday was tough — how are you doing today?").
- **Full stats history** — everything older than 2 weeks: calendar heatmap, monthly/yearly trends, full relapse timeline.
- **XP levels beyond 20** — unlimited progression with custom level titles (*Unbreakable → Legend → ...*) and unlockable accent color themes at milestones.
- **Goals system** — multiple active daily/weekly/monthly goals (e.g. "Avoid this habit 5 times this week", "Save $50 this month", "Hit a 14-day streak"). Progress bars, XP on completion.
- **Home screen widget** — streak + habit name visible without opening the app (`home_widget` package, no backend).
- **Export stats** — export your full history as a CSV file.
- **Cloud account & sync** — sign in and sync data across devices via iCloud (iOS) / Google Drive (Android). Uses the user's own cloud storage — no server cost on our end, which is why this can be a one-time price.
- **"Why you failed / how you succeeded" follow-ups** — when a relapse is logged, a quick structured question ("what caused this?"). When a streak milestone is hit, ask "what's working?" Over time, builds a personal pattern the user can actually learn from, visible in stats.
- **Extra achievements & milestone medals** — expanded badge collection (30d streak, 90d streak, $100 saved, 100 avoidances, 1-year anniversary, etc.) styled like milestone coins.

---

## Pro Tier — $3.99/mo or $27.99/yr

Everything in Plus, plus:

- **Accountability trusted circle** — up to 3 accountability partners, each with their own notification preferences (e.g. spouse gets real-time relapses, therapist gets weekly report only). When you relapse, your circle is notified instantly via email and push notification (if they have the app). WhatsApp via Twilio is a future option. Requires Firebase (Firestore + FCM). Strongest viral growth driver — proven $7/mo willingness to pay elsewhere.
- **Daily relapse risk forecast** — every morning, the AI analyses your patterns (day of week, recent sleep from Health, upcoming calendar events, days since last slip) and shows a simple risk score with a short reason. Like a weather forecast for your habits — unique, actionable, no other app does this.
- **AI suggestions on relapse** — when a relapse is logged, an AI that knows your habit history, trigger patterns, and current context gives you a personalized suggestion in the moment. Not generic tips — actually tailored to you.
- **AI counsellor** — a conversational assistant that knows your full history and pattern data. You can ask it anything ("why do I keep slipping on weekends?", "what's working?"). 500 messages/month cap. Powered by LLM via serverless proxy.
- **AI weekly insights & reports** — every Sunday, a personalized written summary: your best/worst days, what triggers came up most, projected savings if you continue the trend. Uses all your tracked data.
- **Monthly PDF report** — a well-designed one-page monthly summary you can bring to a therapist or coach: streaks, top triggers, savings, trend direction. Bridges the app to professional care. Generated on-device, no extra server cost.
- **Apple Watch / Wear OS companion** — streak on your wrist, one-tap daily commitment, and a "I'm struggling" button that pings your accountability circle instantly. The most personal device someone owns — powerful for a habit app. *Potential future addition: context-aware stress detection using HRV and EDA sensors already on Apple Watch — if a stress spike is detected during a known high-risk window, the Watch delivers a gentle wrist tap intervention before a relapse happens. Needs real-world validation before committing.*
- **Apple Health / Google Fit integration** — the AI can see your sleep and activity data and correlate it with your patterns (e.g. "you tend to slip on days you slept under 6 hours"). Opt-in.
- **Calendar integration** — connect Google or Apple Calendar. AI can flag upcoming events that might be high-risk (e.g. "you have a party Saturday — heads up").

---

## Engagement & Gamification System

### XP Sources

| Action | XP | Tier |
|--------|-----|------|
| Daily login | +10 | Free |
| Logging a relapse (honesty rewarded) | +15 | Free |
| Logging a trigger note | +10 | Free |
| Archiving a completed habit | +100 | Free |
| Streak milestone (7d, 30d, 90d…) | +50–200 | Free |
| Daily commitment button | +20 | Plus |
| Goal completion | +50–150 | Plus |
| "Why I slipped" follow-up answered | +10 | Plus |
| "What worked" follow-up answered | +10 | Plus |

### Goals System (Plus)

Daily, weekly, and monthly quest-style goals that keep the app feeling alive. Examples:
- "Avoid [habit] 5 times this week"
- "Save $50 this month by avoiding [thing]"
- "Maintain a 7-day streak"
- "Avoid 3 different habit categories this week"

Free users see 1 preset active goal at a time. Plus unlocks multiple simultaneous goals and custom amounts.

### Levels & Titles

| Level | XP Required | Title |
|-------|-------------|-------|
| 1 | 0 | Beginner |
| 2 | 100 | Aware |
| 5 | 500 | Resistant |
| 10 | 1,500 | Disciplined |
| 20 | 5,000 | Unbreakable |
| 30 | 12,000 | Legend |
| 50 | 30,000 | Mythic |

Levels 1–20 are Free. Levels 21+ require Plus. Plus also unlocks custom title colors and accent themes at milestone levels.

### Achievements & Medals (like AA coins)

| Achievement | Condition |
|-------------|-----------|
| First Step | First habit added |
| 24h Free | 1-day streak |
| 7 Day Warrior | 7-day streak |
| Iron Month | 30-day streak |
| Quarter Year | 90-day streak |
| Half Year | 180-day streak |
| One Year | 365-day streak |
| Budget Saver | $50 saved |
| Mega Saver | $200 saved |
| High Roller | $1,000 saved |
| Century | 100 successful avoidances |
| Honest | 25 relapses logged (courage to face it) |
| Consistency | 5+ active habits |
| Veteran | 1 year since first habit added |

First 5 badges free. Full medal collection unlocked by Plus.

---

## Build Order

1. **RevenueCat + Paywall** ✅ Done — `purchases_flutter`, Statistics screen gated.
2. **XP / Levels / Daily Commitment Flow** — Free XP system (levels 1–20) + Plus daily therapeutic flow. ~3 days.
3. **Goals System + Achievements** — Quest-style goals with progress bars, expanded medal collection. ~3 days.
4. **Smart Notifications + Follow-up Flow** — Pattern-based heads-up reminders, relapse day-after follow-up, success follow-up. ~2–3 days.
5. **Home Screen Widget** — Streak + habit name widget via `home_widget`. ~2 days.
6. **Export Stats** — CSV export of full history. ~1 day.
7. **Cloud Sync** — iCloud / Google Drive sync using user's own storage. ~3–4 days.
8. **AI Weekly Insights** — First LLM feature via serverless proxy. ~4–5 days.
9. **AI Counsellor** — Conversational, knows full user history, 500 msg/month cap. ~1 week.
10. **Accountability Trusted Circle** — Firebase backend, email + FCM notifications, up to 3 partners, per-partner notification preferences, invite codes. ~1–2 weeks.
11. **Daily Relapse Risk Forecast** — AI morning score using pattern data + Health + Calendar context. ~3–4 days.
12. **Monthly PDF Report** — On-device generated monthly summary, shareable with therapist/coach. ~2 days.
13. **Health & Calendar Integration** — Apple Health / Google Fit + Google/Apple Calendar for AI context. ~1 week.
14. **Apple Watch / Wear OS Companion** — Streak glance, one-tap commitment, panic button to circle. ~1 week.

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

- **Avoid's differentiation:** only app combining relapse trigger analysis + cost quantification + location/contact avoidance + gamified progression in one place.
- **Plus is the daily experience:** the commitment flow, goals, and smart notifications touch the user every day — not just once a week like stats alone. At $2.99 one-time it's an impulse buy with no second-guessing.
- **Subscription justified only for Pro:** AI inference and Firebase have real ongoing costs. One-time Plus is fair because it's local + user's own cloud storage.
- **Accountability trusted circle** is the single highest-leverage Pro feature — viral by design (each user onboards up to 3 partners), proven $7/mo willingness to pay elsewhere, nothing like it in the avoidance-app space.
- **Daily risk forecast + Watch companion** make Pro feel alive every single day — not just when something goes wrong. This is what justifies the monthly subscription beyond the AI features.
- **Cloud sync in Plus (not Pro):** by using iCloud/Google Drive (user's own storage), we avoid server costs and can offer this at a one-time price. Firebase is only introduced in Pro for real-time partner notifications.
- **Gamification isn't cosmetic:** goals, XP, and achievements are the mechanisms that keep users returning daily. The psychology of progress and milestones (same reason AA gives coins) is what sustains long-term habit change.
