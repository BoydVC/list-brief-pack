# RESEARCH.md — X Lists as news, bot template marketplaces, personal AI digests

**Burn project:** List Brief Pack  
**Date:** Monday, Oct 26, 2026 (America/New_York)  
**Purpose:** Ground the product in public sources before shipping a local fleet pack.

---

## 1. Why X Lists beat the algorithm for a personal brief

X's own help language (as summarized by independent guides) describes a List as a way to "customize, organize and prioritize the posts you see," showing a stream from *only* the accounts on that List. A List is not a Community, not a group chat, and not the same as Following — adding someone to a List does not follow them, and following a List does not follow its members.

[TwitterAPI.io — Twitter Lists: How X Lists Work (2026)](https://twitterapi.io/blog/twitter-lists) consolidates help-center and developer-doc limits:

- Up to **1,000 Lists** per account
- Up to **5,000 members** per List
- Names 1–25 characters, not starting with a number
- Descriptions up to 100 characters
- Public by default; private on request
- Pin a List beside For You / Following

Their 2026 sample of 10 organization-owned public Lists (NASA, NWS, Reuters, NYT, WHO) found wide activity spread: the busiest List averaged **58.5 posts/day**, while several event Lists had gone stale (≤4 posts returned). A median of only ~34.5% of members appeared in the latest posts — so a List of 30 people behaves day-to-day like a feed of about ten. That supports **clustering** over raw timelines: most List members are quiet; a brief should surface themes, not every post.

Axios (Mar 31, 2026) argues the For You feed rewards emotional engagement and recommends Lists as "the most reliable way to control what you see" when cleaning an X feed:

- [How to clean your X feed and make it more like Old Twitter — Axios](https://www.axios.com/2026/03/31/twitter-feed-algorithim-lists-for-you-following)

Caitlin Johnstone's guide frames Lists as a chronological, account-selected news feed that sidesteps For You manipulation:

- [How To Create A Custom News Feed Free From Algorithm Manipulation](https://www.caitlinjohnst.one/p/how-to-create-a-custom-news-feed)

Socialkit's growth/monitoring write-up emphasizes the monitoring use case: industry journalist Lists, competitor watch Lists (prefer private), and the ability to read accounts without following them:

- [How to Use Twitter (X) Lists for Growth and Monitoring](https://socialk.it/en/blog/how-to-use-twitter-lists)

**Design takeaway for List Brief Pack:** seed theme Lists Boyd already cares about; cluster; label urgency; keep the chronological List mental model even when the UI is a digest.

---

## 2. Bot template marketplaces and the Roemmele pattern

Boyd's bookmark cluster (Jim · Interests, Oct 20–26) points hard at **Grok Bot templates** — especially packs shared by @BrianRoemmele and the emerging marketplace surface.

Public mirrors / catalogs observed this session:

| Source | What it shows |
|--------|----------------|
| [Bot Shelf — @BrianRoemmele](https://botshelf.dev/creators/brianroemmele/) | 9 shared templates (email newsletter daily report, X Articles You Missed, News Honestly, X Money Deep Report, Clean Slate, etc.) |
| [grokbotlist.com — Email Newsletter Daily Report](https://grokbotlist.com/bots/email-newsletter-daily-report/) | Digest pattern: subscribe sources to bot email → executive summary + uniqueness scores |
| [grokbot.dev — X Articles You Missed](https://grokbot.dev/marketplace/x-articles-you-missed/) | Long-form X Articles → ≤10 summaries as one copyable brief |
| [grokbottemplates.dev — News Honestly](https://www.grokbottemplates.dev/templates/news-honestly) | Dual-reading / bridge brief with trust labels |
| [x.ai Bot Marketplace — Personal](https://x.ai/bot/marketplace/personal) | Official Personal shelf (Morning Newspaper, Flora, Import Bot, etc.) |

Pattern shared across these templates:

1. **Narrow job** with a clear output artifact (brief, dashboard, draft letter)
2. **Read-first / draft-for-approval** defaults on anything irreversible
3. **Copyable or share-link install** into the user's own bot (not shared session state)
4. **Schedule or on-demand** delivery, not an infinite scroll

Live signal this session: @BrianRoemmele posted about Grok Bot + iOS Calendar integration  
`https://x.com/BrianRoemmele/status/2114840463018717588` (fetched via public X reads, Oct 26, 2026 ET).

**Design takeaway:** Marketplace Pack cards in this repo are *local* prompt markdown Boyd can paste — Roemmele-shaped, not a claim of publishing to x.ai.

---

## 3. Personal AI digests: the product category

Beyond X, 2026 personal-briefing tools converge on the same job: **one finite briefing from sources you chose**.

- [Twigest](https://twigest.com/) — X accounts, Reddit, HN, RSS, YouTube, newsletters → one emailed briefing on a schedule; every item links back.
- [I-Digest](https://i-digest.com/) — curated front-line sources + interest sentence; editorial review across days to avoid repeat topics.
- [Proofite](https://proofite.com/) — newsletter/RSS inboxes → written digest + optional podcast; feedback trains topic depth.
- [Readless roundup — Best AI Daily News Briefing Tools (2026)](https://www.readless.app/blog/best-ai-daily-news-briefing-tools-2026) — compares Kagi News, Perplexity, Particle, Morning Brew, 1440, Tangle, Feedly Leo, Readless Max.
- [Dailyn — Best AI News Briefing Tools in 2026](https://dailyn.cc/blog/best-ai-news-briefing-tools) — useful taxonomy: summarizer of *your* subscriptions vs open-web press review vs DIY scheduled chatbot.

Common quality bar across these products:

- **Finite** output (not a feed)
- **Cited** links back to sources
- **Personal** ranking (interests / your lists)
- **Dedup** across days

List Brief Pack sits in the "your Lists → finite brief" niche, plus a second surface (template pack) that most digest apps lack.

---

## 4. Mapping Jim · Interests (Oct 20–26) → seed themes

From the burn-night snapshot (not re-quoted as instructions; used as product context):

| Bookmark / signal | Seed List theme | Pack template |
|-------------------|-----------------|---------------|
| Roemmele templates + email bot | AI-agent tooling | Email Bot Triage |
| Bot marketplace | AI-agent tooling | Marketplace Pack Builder |
| X Lists tie-in / Scoble list-news | all themes | List-News Brief |
| Multi-agent peer review | AI-agent tooling | Peer-Review Loop |
| Vault / 1Password | ops hygiene | Vault Hygiene Reminder |
| Ravens / sports standing interest | sports Lists | Sports Sunday Desk |
| Inkwright (kids 9–13) | family/kids tech | (separate Kids Coding Studio burn) |
| Weekly X Money report | — | **skipped** (no money moves this burn) |
| Call businesses for you | — | **parked** (not enabled) |

---

## 5. Live sample pulled this session (public X reads)

Fetched with built-in public X tools (`get_users_by_usernames` → `get_users_posts`), Oct 26, 2026 ET:

1. https://x.com/BrianRoemmele/status/2114840463018717588 — Grok Bot + iOS Calendar  
2. https://x.com/BrianRoemmele/status/2114885756724650389 — Microsoft AI exit packages signal  
3. https://x.com/SpaceX/status/2114444137067844004 — Super Heavy 33-engine static fire (Flight 15 prep)  
4. https://x.com/SpaceX/status/2113786051009696177 — Falcon 9 Starlink launch  
5. https://x.com/Ravens/status/2114802835909124339 — Rayshawn Jenkins practice squad  
6. https://x.com/Ravens/status/2114738648201486651 — Ravens Daily radio premiere Nov 9  

(@xai user timeline was not authorized for this reader; SpaceX + Roemmele cover the Elon/xAI/SpaceX theme for the live strip.)

---

## 6. Risks and honesty constraints

1. **Stale Lists** — event Lists die; digests must say when a theme was quiet (TwitterAPI.io sample).
2. **Synthetic seed data** — demo clusters are labeled SYNTHETIC so Boyd never confuses them with a live List pull.
3. **Marketplace trust** — third-party template catalogs warn you to read instructions before install; our pack is local markdown only.
4. **Irreversible actions** — templates encode approval gates (send-on-behalf skill norms).
5. **Quota** — public X reads are rate-limited; live sample is a small cited strip, not continuous polling.

---

## 7. Conclusion for the build

The public evidence supports a product that (a) treats **Lists as the source graph**, (b) emits a **finite clustered brief** with personal "why," and (c) ships **copyable bot templates** in the Roemmele/marketplace style. List Brief Pack implements that loop locally on port 4332 for Grok Bot weekly burn — without claiming live List API sync or a published marketplace listing.

### Source list (compact)

- https://twitterapi.io/blog/twitter-lists  
- https://www.axios.com/2026/03/31/twitter-feed-algorithim-lists-for-you-following  
- https://www.caitlinjohnst.one/p/how-to-create-a-custom-news-feed  
- https://socialk.it/en/blog/how-to-use-twitter-lists  
- https://botshelf.dev/creators/brianroemmele/  
- https://grokbotlist.com/bots/email-newsletter-daily-report/  
- https://grokbot.dev/marketplace/x-articles-you-missed/  
- https://www.grokbottemplates.dev/templates/news-honestly  
- https://x.ai/bot/marketplace/personal  
- https://twigest.com/  
- https://i-digest.com/  
- https://proofite.com/  
- https://www.readless.app/blog/best-ai-daily-news-briefing-tools-2026  
- https://dailyn.cc/blog/best-ai-news-briefing-tools  
