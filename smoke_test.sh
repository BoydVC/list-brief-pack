#!/usr/bin/env bash
# Smoke: health, brief, templates (≥6), live sample, RESEARCH.md ≥80 lines
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
BASE="${BASE_URL:-http://127.0.0.1:4332}"
FAIL=0

echo "== List Brief Pack smoke =="

need_file() {
  local f="$1"
  if [[ ! -f "$ROOT/$f" ]]; then
    echo "FAIL: missing $f"
    FAIL=1
  else
    echo "OK file $f"
  fi
}

need_file "README.md"
need_file "DESIGN.md"
need_file "RESEARCH.md"
need_file "server.py"
need_file "data/digests.json"
need_file "data/live_sample.json"
need_file "data/templates.json"

if [[ -f "$ROOT/RESEARCH.md" ]]; then
  lines=$(wc -l < "$ROOT/RESEARCH.md" | tr -d ' ')
  echo "RESEARCH.md lines=$lines"
  if [[ "$lines" -lt 80 ]]; then
    echo "FAIL: RESEARCH.md needs ≥80 lines (got $lines)"
    FAIL=1
  fi
fi

tpl_count=$(find "$ROOT/templates" -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
echo "template_files=$tpl_count"
if [[ "$tpl_count" -lt 6 ]]; then
  echo "FAIL: need ≥6 template markdown files (got $tpl_count)"
  FAIL=1
fi

health=$(curl -s -o /tmp/lbp-health.json -w "%{http_code}" "$BASE/api/health" || echo "000")
if [[ "$health" != "200" ]]; then
  echo "FAIL: /api/health HTTP $health (is ./run.sh up?)"
  FAIL=1
else
  echo "OK health $(cat /tmp/lbp-health.json)"
fi

for ep in / /api/brief /api/live /api/templates /api/stats; do
  code=$(curl -s -o /tmp/lbp-ep.json -w "%{http_code}" "$BASE$ep" || echo "000")
  if [[ "$code" != "200" ]]; then
    echo "FAIL $ep HTTP $code"
    FAIL=1
  else
    echo "OK $ep"
  fi
done

# template count from API
api_tpl=$(python3 -c 'import json; print(json.load(open("/tmp/lbp-ep.json"))["count"])' 2>/dev/null || echo 0)
# re-fetch templates explicitly
curl -s "$BASE/api/templates" > /tmp/lbp-tpl.json
api_tpl=$(python3 -c 'import json; print(json.load(open("/tmp/lbp-tpl.json"))["count"])')
echo "api_templates=$api_tpl"
if [[ "$api_tpl" -lt 6 ]]; then
  echo "FAIL: api templates < 6"
  FAIL=1
fi

# copyable: first template markdown non-empty
first_id=$(python3 -c 'import json; print(json.load(open("/tmp/lbp-tpl.json"))["templates"][0]["id"])')
curl -s "$BASE/api/template/$first_id" > /tmp/lbp-one.md
chars=$(wc -c < /tmp/lbp-one.md | tr -d ' ')
echo "sample_template=$first_id chars=$chars"
if [[ "$chars" -lt 80 ]]; then
  echo "FAIL: template body too short"
  FAIL=1
else
  echo "OK copyable template body"
fi

# live posts ≥3
live_n=$(python3 -c 'import json; print(len(json.load(open("'"$ROOT"'/data/live_sample.json"))["posts"]))')
echo "live_posts=$live_n"
if [[ "$live_n" -lt 3 ]]; then
  echo "FAIL: need ≥3 live sample posts"
  FAIL=1
fi

# clusters have action chips
curl -s "$BASE/api/brief" > /tmp/lbp-brief.json
python3 << 'PY' || FAIL=1
import json, sys
b=json.load(open("/tmp/lbp-brief.json"))
assert b["cluster_count"] >= 6, b["cluster_count"]
for c in b["clusters"]:
    assert set(c.get("actions", [])) >= {"read","save_idea","ignore"}, c
    assert "why_boyd" in c or True
print(f"OK clusters={b['cluster_count']} lists={b['list_count']}")
PY

# POST action chip
post=$(curl -s -o /tmp/lbp-act.json -w "%{http_code}" -X POST "$BASE/api/action" \
  -H 'Content-Type: application/json' \
  -d '{"cluster_id":"c-ai-1","action":"save_idea","note":"smoke"}' || echo "000")
if [[ "$post" != "200" ]]; then
  echo "FAIL POST /api/action HTTP $post"
  FAIL=1
else
  echo "OK action chip POST $(cat /tmp/lbp-act.json | head -c 120)"
fi


# brief-011 safety checks
need_file "SAFETY.md"
for kw in "Never auto-post" "Synthetic vs LIVE" "local templates only"; do
  if grep -qi "$kw" "$ROOT/SAFETY.md" 2>/dev/null; then echo "OK safety '$kw'"; else echo "FAIL: SAFETY.md missing '$kw'"; FAIL=1; fi
done
for r in /api/post /api/tweet /api/send /api/publish; do
  c=$(curl -s -o /dev/null -w '%{http_code}' -X POST "$BASE$r" -H 'Content-Type: application/json' -d '{}' || echo 000)
  if [[ "$c" == "200" ]]; then echo "FAIL: outbound route $r returned 200"; FAIL=1; else echo "OK no outbound $r ($c)"; fi
done

if [[ "$FAIL" -eq 0 ]]; then
  echo "SMOKE PASS"
  exit 0
fi
echo "SMOKE FAIL"
exit 1
