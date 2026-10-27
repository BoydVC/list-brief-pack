const $ = (s, el = document) => el.querySelector(s);
const $$ = (s, el = document) => [...el.querySelectorAll(s)];

function toast(msg) {
  const t = $("#toast");
  t.hidden = false;
  t.textContent = msg;
  clearTimeout(toast._timer);
  toast._timer = setTimeout(() => { t.hidden = true; }, 2200);
}

function urgencyBadge(u) {
  return `<span class="badge ${u || "low"}">${u || "low"}</span>`;
}

async function loadStats() {
  const s = await (await fetch("/api/stats")).json();
  $("#stats").innerHTML = [
    ["Lists", s.lists],
    ["Clusters", s.clusters],
    ["Live", s.live_posts],
    ["Templates", s.templates],
    ["Port", s.port],
  ].map(([k, v]) => `<span class="pill"><b>${v}</b> ${k}</span>`).join("");
}

async function loadBrief() {
  const b = await (await fetch("/api/brief")).json();
  $("#disclaimer").textContent = b.disclaimer || "";
  $("#clusters").innerHTML = b.clusters.map(c => `
    <article class="card" data-id="${c.id}">
      <div class="row">
        <h2>${escapeHtml(c.headline)}</h2>
        <div class="meta">
          ${c.synthetic ? '<span class="badge synth">SYNTHETIC</span>' : ''}
          ${c.live_anchor ? '<span class="badge live">LIVE ANCHOR</span>' : ''}
          ${urgencyBadge(c.urgency)}
          <span class="badge">${escapeHtml(c.list_name)}</span>
        </div>
      </div>
      <p class="summary">${escapeHtml(c.summary)}</p>
      <p class="why"><strong>Why Boyd:</strong> ${escapeHtml(c.why_boyd || "")}</p>
      ${c.live_anchor ? `<p><a href="${c.live_anchor}" target="_blank" rel="noopener">Live post ↗</a></p>` : ""}
      <div class="chips">
        ${(c.actions || ["read","save_idea","ignore"]).map(a =>
          `<button class="chip" data-action="${a}" data-cluster="${c.id}">${labelAction(a)}</button>`
        ).join("")}
      </div>
    </article>
  `).join("");

  $$("#clusters .chip").forEach(btn => {
    btn.addEventListener("click", async () => {
      const action = btn.dataset.action;
      const cluster_id = btn.dataset.cluster;
      const res = await fetch("/api/action", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ cluster_id, action }),
      });
      const data = await res.json();
      if (!res.ok) { toast(data.error || "failed"); return; }
      $$(".chip", btn.parentElement).forEach(b => b.classList.remove("saved", "ignored"));
      if (action === "save_idea" || action === "read") btn.classList.add("saved");
      if (action === "ignore") btn.classList.add("ignored");
      toast(`${labelAction(action)} · ${cluster_id}`);
    });
  });
}

function labelAction(a) {
  return ({ read: "Read", save_idea: "Save idea", ignore: "Ignore" })[a] || a;
}

async function loadLive() {
  const live = await (await fetch("/api/live")).json();
  $("#live").innerHTML = live.posts.map(p => `
    <article class="card">
      <div class="row">
        <h2>@${escapeHtml(p.handle)}</h2>
        <div class="meta">
          <span class="badge live">LIVE</span>
          <span class="badge">${escapeHtml(p.theme)}</span>
          <span class="badge">${escapeHtml(p.created_at_et)}</span>
        </div>
      </div>
      <p class="summary">${escapeHtml(p.text)}</p>
      <p class="why"><strong>Why Boyd:</strong> ${escapeHtml(p.why_boyd)}</p>
      <p><a href="${p.url}" target="_blank" rel="noopener">${p.url}</a> · ${p.likes} likes</p>
    </article>
  `).join("");
}

async function loadTemplates() {
  const pack = await (await fetch("/api/templates")).json();
  const bodies = await Promise.all(
    pack.templates.map(async t => {
      const md = await (await fetch(`/api/template/${t.id}`)).text();
      return { ...t, md };
    })
  );
  $("#templates").innerHTML = bodies.map(t => `
    <article class="card" id="tpl-${t.id}">
      <div class="row">
        <div>
          <h2>${escapeHtml(t.title)}</h2>
          <p class="summary">${escapeHtml(t.what_it_does)}</p>
          <div class="meta" style="margin-top:.4rem">
            ${(t.tags || []).map(tag => `<span class="badge">${escapeHtml(tag)}</span>`).join("")}
          </div>
        </div>
        <button class="btn" data-copy="${t.id}">Copy prompt</button>
      </div>
      <pre class="prompt" id="body-${t.id}">${escapeHtml(t.md)}</pre>
    </article>
  `).join("");

  $$("[data-copy]").forEach(btn => {
    btn.addEventListener("click", async () => {
      const id = btn.dataset.copy;
      const text = $(`#body-${id}`).textContent;
      try {
        await navigator.clipboard.writeText(text);
        toast(`Copied ${id}`);
      } catch {
        const ta = document.createElement("textarea");
        ta.value = text; document.body.appendChild(ta); ta.select();
        document.execCommand("copy"); ta.remove();
        toast(`Copied ${id}`);
      }
    });
  });
}

function escapeHtml(s) {
  return String(s ?? "").replace(/[&<>"']/g, c => ({
    "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;"
  })[c]);
}

$$(".tab").forEach(tab => {
  tab.addEventListener("click", () => {
    $$(".tab").forEach(t => t.classList.remove("active"));
    $$(".panel").forEach(p => p.classList.remove("active"));
    tab.classList.add("active");
    $(`#panel-${tab.dataset.tab}`).classList.add("active");
  });
});

(async function init() {
  await Promise.all([loadStats(), loadBrief(), loadLive(), loadTemplates()]);
})();
