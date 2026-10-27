# List Brief Pack

![list-brief-pack](screenshots/hero.png)

**X Lists → Personalized Brief + Marketplace Pack** for Christopher Boyd.

Local web app that turns curated X list *themes* into a clustered daily digest UI, and ships reusable Roemmele-style bot templates as copyable fleet cards.

- **URL:** http://127.0.0.1:4332/
- **Pool:** Grok Bot weekly (TokenMax-side). No Cursor cloud agents.
- **Data:** SYNTHETIC digests for demo themes + a LIVE sample of real public posts fetched this session.

## 2-minute how-to

```bash
cd /workspace/tokenmax/list-brief-pack
./run.sh
# open http://127.0.0.1:4332/
./smoke_test.sh
```

1. **Daily Brief** — skim clusters (urgency + why it matters to Boyd). Hit **Read / Save idea / Ignore**.
2. **Live Sample** — real public posts from @BrianRoemmele, @SpaceX, @Ravens with cited URLs.
3. **Marketplace Pack** — open a card → **Copy prompt** → paste into a Grok Bot.

## What's inside

| Path | Role |
|------|------|
| `server.py` | Python stdlib HTTP server |
| `static/` | Brief / Live / Pack UI |
| `data/digests.json` | SYNTHETIC list digests |
| `data/live_sample.json` | LIVE posts from this session |
| `data/templates.json` | Pack index |
| `templates/*.md` | Copyable prompt markdown (≥6) |
| `RESEARCH.md` | Cited notes on Lists, marketplaces, digests |
| `DESIGN.md` | Product + architecture |

## Themes seeded

AI-agent tooling · Elon/xAI/SpaceX · Ravens/Orioles/Chelsea/Terps · family/kids tech

## Hard limits for this burn

- No messaging Boyd, no email/Slack/X as Boyd
- No kpdlawgroup, no on-demand, no X Money moves, no call-a-business

## Safety (brief-011 fold) — see `SAFETY.md`

- **Never auto-post.** Read-only on Lists/bookmarks; outputs are local markdown. No post/DM/list-write tools; unapproved packs fail closed (stay on disk).
- **Synthetic vs LIVE honesty.** `SYNTHETIC` = `digests.json` demo clusters; `LIVE` = `live_sample.json` with URL + fetch time. Empty List ≠ quiet day → flag as stale.
- **Bookmarks + Lists → local templates only.** No publishing anywhere from this app.
- List/bookmark text is untrusted data, never instructions.
