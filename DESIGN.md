# DESIGN.md — List Brief Pack

## Problem

Boyd's bookmarks (Jim · Interests, Oct 20–26) cluster on **Grok Bot product/use**: Roemmele templates, marketplace, X Lists as news, multi-agent peer review. The For You feed is noisy; Lists are the chronological filter. He also under-burns the **Grok Bot weekly** pool when cool work runs on Cursor cloud agents instead.

## Product shape

Three panes, one local server:

1. **Daily Brief** — clusters per List theme, not a raw timeline. Each cluster answers: what happened, why Boyd cares, what to do (read / save idea / ignore).
2. **Live Sample** — a thin strip of *actually fetched* public posts so the demo is not 100% synthetic.
3. **Marketplace Pack** — ≥6 prompt cards Boyd can copy into fleet bots (email triage, CoS routing, list-news brief, peer-review loop, vault hygiene, sports Sunday, pack builder).

## Architecture

```
browser ──► static/* (HTML/CSS/JS)
         └► /api/*   (server.py, stdlib ThreadingHTTPServer)
                ├─ digests.json   (SYNTHETIC)
                ├─ live_sample.json (LIVE, session-fetched)
                ├─ templates.json + templates/*.md
                └─ actions.json   (chip POSTs)
```

- Port **4332**, bind **127.0.0.1** only.
- No DB. JSON files under `data/`.
- Action chips append to `actions.json` (local preference signal for later ranking).

## UX principles

- **Skim < 5 minutes.** Clusters beat feeds.
- **Label honesty.** SYNTHETIC vs LIVE badges everywhere.
- **Copyability.** Templates are markdown you can paste; one click Copy.
- **Irreversible gate.** Templates remind: never send/post/pay without named approval.
- **Boyd-personal why.** Every cluster carries a why_boyd string grounded in Jim's snapshot.

## Non-goals (this burn)

- Live List API polling (would need List IDs + ongoing egress)
- Publishing to x.ai marketplace
- X Money reports or money moves
- Call-a-business (not enabled)
- Cursor cloud agents

## Success metrics (smoke)

- `./run.sh` → health 200
- ≥6 templates with copyable bodies
- ≥3 live posts with URLs
- ≥6 clusters with three action chips
- RESEARCH.md ≥80 lines with public citations

## Safety model (brief-011: X Lists / interest-signal packs)

- **Jim Lists lane:** bookmarks + Lists → pack manifest → local brief template. Agent reads; human posts, if ever.
- **No write principal.** Burn/overnight runs hold zero post/reply/DM/list.write/bookmark-mutate tools; smoke asserts the server exposes no outbound route.
- **Fail-closed holds.** No timeout-to-publish. Proposed bookmark actions are never auto-executed.
- **Honesty labels.** SYNTHETIC vs LIVE on every item; LIVE needs URL + fetched_at (America/New_York). Stale/empty Lists are flagged, not summarized as calm. Dedupe by post_id.
- **Untrusted feed text** is fenced data (LLM01); never merged into prompts.
- Full rules: `SAFETY.md`.
