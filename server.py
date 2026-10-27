#!/usr/bin/env python3
"""List Brief Pack — X Lists → Personalized Brief + Marketplace Pack on 127.0.0.1:4332."""
from __future__ import annotations

import json
import os
import urllib.parse
from datetime import datetime, timezone
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
from pathlib import Path

ROOT = Path(__file__).resolve().parent
PORT = int(os.environ.get("PORT", "4332"))
HOST = "127.0.0.1"


def _read_json(path: Path):
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def _write_json(path: Path, data) -> None:
    tmp = path.with_suffix(path.suffix + ".tmp")
    with tmp.open("w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)
        f.write("\n")
    tmp.replace(path)


def _brief_payload() -> dict:
    digests = _read_json(ROOT / "data" / "digests.json")
    live = _read_json(ROOT / "data" / "live_sample.json")
    actions = _read_json(ROOT / "data" / "actions.json")
    clusters = []
    for lst in digests["lists"]:
        for c in lst["clusters"]:
            clusters.append({
                **c,
                "list_id": lst["id"],
                "list_name": lst["name"],
                "theme": lst["theme"],
                "why_boyd": lst["why_boyd"],
                "synthetic": lst.get("synthetic", True),
            })
    # sort high → medium → low
    order = {"high": 0, "medium": 1, "low": 2}
    clusters.sort(key=lambda x: (order.get(x.get("urgency", "low"), 9), x["list_name"]))
    return {
        "generated_at": digests.get("generated_at"),
        "disclaimer": digests.get("disclaimer"),
        "list_count": len(digests["lists"]),
        "cluster_count": len(clusters),
        "live_post_count": len(live.get("posts", [])),
        "action_count": len(actions.get("actions", [])),
        "clusters": clusters,
        "lists": digests["lists"],
    }


class Handler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(ROOT / "static"), **kwargs)

    def end_headers(self):
        self.send_header("Cache-Control", "no-store")
        super().end_headers()

    def log_message(self, fmt, *args):
        print(f"[list-brief] {self.address_string()} {fmt % args}", flush=True)

    def _send_json(self, code: int, payload) -> None:
        body = json.dumps(payload, indent=2).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _send_text(self, code: int, text: str, content_type: str) -> None:
        body = text.encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path

        if path == "/api/health":
            return self._send_json(200, {
                "ok": True,
                "service": "list-brief-pack",
                "port": PORT,
                "host": HOST,
            })

        if path == "/api/meta":
            return self._send_json(200, _read_json(ROOT / "data" / "meta.json"))

        if path == "/api/brief":
            return self._send_json(200, _brief_payload())

        if path == "/api/live":
            return self._send_json(200, _read_json(ROOT / "data" / "live_sample.json"))

        if path == "/api/templates":
            return self._send_json(200, _read_json(ROOT / "data" / "templates.json"))

        if path.startswith("/api/template/"):
            tid = urllib.parse.unquote(path[len("/api/template/"):]).strip("/")
            tpath = ROOT / "templates" / f"{tid}.md"
            if not tpath.is_file() or ".." in tid or "/" in tid:
                return self._send_json(404, {"error": "template not found", "id": tid})
            return self._send_text(200, tpath.read_text(encoding="utf-8"), "text/markdown; charset=utf-8")

        if path == "/api/actions":
            return self._send_json(200, _read_json(ROOT / "data" / "actions.json"))

        if path == "/api/stats":
            brief = _brief_payload()
            tpls = _read_json(ROOT / "data" / "templates.json")
            return self._send_json(200, {
                "lists": brief["list_count"],
                "clusters": brief["cluster_count"],
                "live_posts": brief["live_post_count"],
                "templates": tpls["count"],
                "port": PORT,
            })

        return super().do_GET()

    def do_POST(self):
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path
        length = int(self.headers.get("Content-Length", "0") or 0)
        raw = self.rfile.read(length) if length else b"{}"
        try:
            payload = json.loads(raw.decode("utf-8") or "{}")
        except json.JSONDecodeError:
            return self._send_json(400, {"error": "invalid json"})

        if path == "/api/action":
            cluster_id = payload.get("cluster_id")
            action = payload.get("action")
            if action not in ("read", "save_idea", "ignore"):
                return self._send_json(400, {"error": "action must be read|save_idea|ignore"})
            if not cluster_id:
                return self._send_json(400, {"error": "cluster_id required"})
            store = _read_json(ROOT / "data" / "actions.json")
            entry = {
                "cluster_id": cluster_id,
                "action": action,
                "at": datetime.now(timezone.utc).isoformat(),
                "note": payload.get("note") or "",
            }
            store.setdefault("actions", []).append(entry)
            store["updated_at"] = entry["at"]
            _write_json(ROOT / "data" / "actions.json", store)
            return self._send_json(200, {"ok": True, "entry": entry, "total": len(store["actions"])})

        return self._send_json(404, {"error": "not found"})


def main() -> None:
    httpd = ThreadingHTTPServer((HOST, PORT), Handler)
    print(f"List Brief Pack serving http://{HOST}:{PORT}/", flush=True)
    httpd.serve_forever()


if __name__ == "__main__":
    main()
