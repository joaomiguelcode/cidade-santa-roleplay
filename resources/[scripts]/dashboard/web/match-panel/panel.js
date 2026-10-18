import { copy as c, setMatchPanelCopy } from "./copy.js";

const host = document.createElement("div");
host.id = "match-staff-panel";
host.hidden = true;
document.body.append(host);
const root = host.attachShadow({ mode: "open" });
const sheet = document.createElement("link");
sheet.rel = "stylesheet";
sheet.href = new URL("./panel.css", import.meta.url).href;
root.append(sheet);
const surface = document.createElement("div");
root.append(surface);
const esc = (value) =>
  String(value ?? "").replace(
    /[&<>"']/g,
    (char) =>
      ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[
        char
      ],
  );
const icons = {
  close: '<path d="m6 6 12 12M18 6 6 18"/>',
  search: '<circle cx="10.5" cy="10.5" r="6.5"/><path d="m16 16 4 4"/>',
  clock: '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',
  eye: '<path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12Z"/><circle cx="12" cy="12" r="3"/>',
  trash: '<path d="M3 6h18M9 6V3h6v3M5 6l1 15h12l1-15M10 10v7m4-7v7"/>',
  house: '<path d="m3 10 9-7 9 7v11h-7v-7h-4v7H3Z"/>',
  arrow: '<path d="m9 5-7 7 7 7M2 12h20"/>',
};
const icon = (name) =>
  `<svg viewBox="0 0 24 24" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">${icons[name] || ""}</svg>`;
const dateInput = (date) =>
  `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(date.getDate()).padStart(2, "0")}`;
const initial = () => ({
  open: false,
  tab: "matches",
  search: "",
  kind: "",
  period: "week",
  from: dateInput(new Date(Date.now() - 13 * 86400000)),
  until: dateInput(new Date()),
  snapshot: { matches: [], queue: [], timestamp: 0 },
  history: [],
  historyCursor: null,
  historyRange: null,
  historyHasMore: false,
  historyScroll: 0,
  visit: false,
  confirm: null,
  error: "",
  toast: "",
  busy: false,
  historyLoading: false,
  historyLoaded: false,
  updated: 0,
  offset: 0,
});
let state = initial(),
  epoch = 0,
  requestId = 0,
  polling = false,
  toastTimer;
let historyTimer,
  historyBusy = false,
  historyNextAt = 0,
  historyFrame;
const HISTORY_ROW_HEIGHT = 72;
const HISTORY_WINDOW = 30;
const now = () => Math.floor(Date.now() / 1000) + state.offset;
async function loadMatchPanelCopy(locale) {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 3000);
  try {
    const response = await fetch('https://localization/getLang', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ resourceName: 'dashboard', locale }),
      signal: controller.signal,
    });
    if (!response.ok) return null;
    const dictionary = await response.json();
    return dictionary?.matchPanel || null;
  } catch {
    return null;
  } finally {
    clearTimeout(timeout);
  }
}
const duration = (value) => {
  const s = Math.max(0, Math.floor(value || 0));
  return `${String(Math.floor(s / 60)).padStart(2, "0")}:${String(s % 60).padStart(2, "0")}`;
};
const session = (value) => {
  const m = Math.max(0, Math.floor((now() - value) / 60));
  return m < 60
    ? `${m}min`
    : `${Math.floor(m / 60)}h${String(m % 60).padStart(2, "0")}`;
};

async function request(action, payload = {}) {
  const abort = new AbortController(),
    timer = setTimeout(() => abort.abort(), 10000);
  try {
    const resource =
      typeof GetParentResourceName === "function"
        ? GetParentResourceName()
        : "dashboard";
    const response = await fetch(`https://${resource}/matchPanel:request`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ action, payload }),
      signal: abort.signal,
    });
    if (!response.ok) throw new Error("network");
    return await response.json();
  } catch {
    return { ok: false, error: "unavailable" };
  } finally {
    clearTimeout(timer);
  }
}
function applySnapshot(response) {
  state.snapshot = response.data;
  state.visit = response.visit || false;
  state.offset = response.data.timestamp - Math.floor(Date.now() / 1000);
  state.updated = Date.now();
}
function periodRange() {
  const end = new Date();
  end.setHours(0, 0, 0, 0);
  const start = new Date(end);
  if (state.period === "custom")
    return {
      from: new Date(`${state.from}T00:00:00`).getTime() / 1000,
      untilAt: new Date(`${state.until}T00:00:00`).getTime() / 1000 + 86400,
    };
  if (state.period === "yesterday") start.setDate(start.getDate() - 1);
  else {
    start.setDate(
      start.getDate() -
        (state.period === "week" ? 6 : state.period === "fortnight" ? 13 : 0),
    );
    end.setDate(end.getDate() + 1);
  }
  return { from: start.getTime() / 1000, untilAt: end.getTime() / 1000 };
}
function loadHistory(reset = true) {
  clearTimeout(historyTimer);
  if (reset) {
    requestId++;
    state.history = [];
    state.historyCursor = null;
    state.historyRange = periodRange();
    state.historyHasMore = false;
    state.historyScroll = 0;
    state.historyLoaded = false;
    const body = surface.querySelector(".table-body");
    if (body) body.scrollTop = 0;
  } else if (state.historyLoading || !state.historyHasMore) return;
  state.historyLoading = true;
  state.error = "";
  render();
  const version = requestId,
    current = epoch;
  historyTimer = setTimeout(
    () => historyPage(version, current),
    Math.max(400, historyNextAt - Date.now()),
  );
}
async function historyPage(version, current) {
  if (
    current !== epoch ||
    version !== requestId ||
    state.tab !== "history" ||
    !state.open
  )
    return;
  if (historyBusy) {
    historyTimer = setTimeout(() => historyPage(version, current), 100);
    return;
  }
  historyBusy = true;
  historyNextAt = Date.now() + 400;
  const response = await request("history", {
    ...(state.historyRange || periodRange()),
    cursor: state.historyCursor || undefined,
    search: state.search,
    kind: state.kind,
  });
  historyBusy = false;
  if (current !== epoch || version !== requestId) return;
  if (response.error === "rate_limit") {
    historyTimer = setTimeout(
      () => historyPage(version, current),
      Math.max(400, response.retryAfterMs || 400),
    );
    return;
  }
  state.historyLoading = false;
  state.historyLoaded = response.ok;
  if (response.ok) {
    const known = new Set(state.history.map((row) => row.token));
    state.history.push(
      ...(response.history || []).filter((row) => !known.has(row.token)),
    );
    state.historyHasMore = !!response.hasMore;
    state.historyCursor = response.nextCursor || null;
  } else state.error = c.errors[response.error] || c.errors.unavailable;
  render();
  if (response.ok && !state.history.length && state.historyHasMore)
    loadHistory(false);
}
const matchesFilter = (players) => {
  const search = state.search
    .trim()
    .replace(/^#/, "")
    .toLocaleLowerCase("pt-BR");
  return (
    (!search ||
      players.some(
        (p) =>
          String(p.id).includes(search) ||
          p.name.toLocaleLowerCase("pt-BR").includes(search),
      )) &&
    (!state.kind || players.some((p) => p.kind === state.kind))
  );
};
const actions = (tab, token, passport, cancel = false) => `<div class="actions">
  <button class="tp" data-action="tp" data-tab="${tab}" data-token="${esc(token)}" data-passport="${esc(passport)}" ${state.busy ? "disabled" : ""}>TP</button>
  <button class="icon ${state.visit?.spec && ((token && state.visit.token === token) || state.visit.target === passport) ? "active" : ""}" data-action="spec" data-tab="${tab}" data-token="${esc(token)}" data-passport="${esc(passport)}" title="${c.spec}" aria-label="${c.spec}" ${state.busy ? "disabled" : ""}>${icon("eye")}</button>
  ${cancel ? `<button class="icon danger" data-action="confirm" data-token="${esc(token)}" aria-label="${c.cancel}" title="${c.cancel}">${icon("trash")}</button>` : ""}</div>`;
function player(p, wave, history = false) {
  const initials = p.name
    .trim()
    .split(/\s+/)
    .filter(Boolean)
    .slice(0, 2)
    .map((n) => n[0])
    .join("");
  return `<div class="player"><span class="avatar">${esc(initials)}</span><div class="identity"><strong>${esc(p.name)}</strong><small>#${esc(p.id)} · ${esc(c.kinds[p.kind] || c.kinds.unknown)}${p.sessionStartedAt && !history ? ` · ${c.session} <span data-session="${p.sessionStartedAt}">${session(p.sessionStartedAt)}</span>` : ""}</small></div>
    ${history ? `<span class="wave">${wave ? `${wave}/3` : "?"}</span>${actions("history", "", p.id)}` : ""}</div>`;
}
function when(time) {
  const date = new Date(time * 1000),
    today = new Date();
  today.setHours(0, 0, 0, 0);
  const yesterday = new Date(today);
  yesterday.setDate(yesterday.getDate() - 1);
  const label =
    date >= today
      ? c.periods.today
      : date >= yesterday
        ? c.periods.yesterday
        : date.toLocaleDateString("pt-BR", {
            day: "2-digit",
            month: "2-digit",
          });
  return `${label} ${date.toLocaleTimeString("pt-BR", { hour: "2-digit", minute: "2-digit" })}`;
}
function render() {
  host.hidden = !state.open;
  if (!state.open) {
    surface.innerHTML = "";
    return;
  }
  const focused = root.activeElement,
    focusKey = focused?.dataset.focus,
    selection = focused?.selectionStart;
  const scroll =
    state.tab === "history"
      ? state.historyScroll
      : surface.querySelector(".table-body")?.scrollTop || 0;
  const rows = (
    state.tab === "matches"
      ? state.snapshot.matches
      : state.tab === "queue"
        ? state.snapshot.queue
        : state.history
  ).filter(
    (row) =>
      state.tab === "history" || matchesFilter(row.players || [row.player]),
  );
  const start =
    state.tab === "history"
      ? Math.max(0, Math.floor(scroll / HISTORY_ROW_HEIGHT) - 5)
      : 0;
  const rendered =
    state.tab === "history" ? rows.slice(start, start + HISTORY_WINDOW) : rows;
  const total =
    state.tab === "matches"
      ? c.pairTotal
      : state.tab === "queue"
        ? c.queueTotal
        : c.historyTotal;
  const names = state.visit?.players?.map((p) => p.name).join(" e ");
  surface.innerHTML = `<div class="backdrop"><section class="panel" role="dialog" aria-modal="true" aria-labelledby="panel-title">
    <header><div><h1 id="panel-title">${c.title}</h1><p>${c.subtitle}</p></div><button class="icon close" data-action="close" aria-label="${c.close}">${icon("close")}</button></header>
    <div class="controls"><nav role="tablist">${Object.entries(c.tabs)
      .map(
        ([key, label]) =>
          `<button role="tab" aria-selected="${key === state.tab}" class="tab ${key === state.tab ? "selected" : ""}" data-action="tab" data-value="${key}">${label}</button>`,
      )
      .join(
        "",
      )}</nav><div class="live"><i></i><span data-updated>${c.updated} 0s</span></div></div>
    <div class="filters"><label class="search">${icon("search")}<input data-focus="search" aria-label="${c.search}" placeholder="${c.search}" value="${esc(state.search)}" maxlength="100"></label>
    <div class="kinds">${["iniciante", "novato", "veterano"].map((kind) => `<button class="chip ${state.kind === kind ? "selected" : ""}" aria-pressed="${state.kind === kind}" data-action="kind" data-value="${kind}">${c.kinds[kind]}</button>`).join("")}</div>
    ${
      state.tab === "history"
        ? `<div class="period"><span>${c.period}</span>${Object.entries(
            c.periods,
          )
            .map(
              ([key, label]) =>
                `<button class="chip ${state.period === key ? "selected" : ""}" data-action="period" data-value="${key}">${label}</button>`,
            )
            .join(
              "",
            )}${state.period === "custom" ? `<label>${c.from} <input type="date" data-focus="from" value="${state.from}"></label><label>${c.until} <input type="date" data-focus="until" value="${state.until}"></label>` : ""}</div>`
        : ""
    }
    <div class="total">${rows.length} ${state.tab === "history" ? c.historyLoaded : total}${state.tab === "history" ? ` · ${c.periods[state.period]}` : ""}</div></div>
    ${state.error ? `<div class="error" role="alert">${esc(state.error)} <button data-action="retry">${c.retry}</button></div>` : ""}
    <div class="table ${state.tab}"><div class="thead">${(state.tab === "matches" ? [c.matchTime, `${c.player} 1`, `${c.player} 2`, c.actions] : state.tab === "queue" ? [c.queueTime, c.player, c.type, c.gender, c.card, c.actions] : [c.when, `${c.player} 1`, `${c.player} 2`, c.duration, c.result]).map((text) => `<span>${text}</span>`).join("")}</div><div class="table-body">
    ${
      state.historyLoading && state.tab === "history" && !rows.length
        ? `<div class="empty" role="status">${c.loading}</div>`
        : rendered
            .map((row) => {
              const selected =
                state.visit &&
                (row.token
                  ? state.visit.token === row.token
                  : state.visit.target === row.player.id);
              if (state.tab === "matches")
                return `<div class="row ${selected ? "highlight" : ""}"><span class="timer">${icon("clock")}<span data-timer="${row.startedAt}">${duration(now() - row.startedAt)}</span></span>${row.players.map((p) => player(p)).join("")}${actions("matches", row.token, "", true)}</div>`;
              if (state.tab === "queue")
                return `<div class="row ${selected ? "highlight" : ""}"><span class="queue-clock"><span class="timer">${icon("clock")}<span data-timer="${row.queuedAt}">${duration(now() - row.queuedAt)}</span></span><span class="new" data-new="${row.queuedAt}" ${now() - row.queuedAt >= 30 ? "hidden" : ""}>${c.new}</span></span>${player(row.player)}<span>${c.kinds[row.player.kind] || c.kinds.unknown}</span><span>${c.genders[row.gender]}</span><span>${row.visible ? c.visible : c.hidden}</span>${actions("queue", "", row.player.id)}</div>`;
              return `<div class="row"><span class="when">${when(row.endedAt)}</span>${row.players.map((p, i) => player(p, row.waves?.[i], true)).join("")}<span class="timer">${duration(row.duration)}</span><span class="result ${row.result}"><i></i>${c.results[row.result] || c.results.legacy}</span></div>`;
            })
            .join("") ||
          `<div class="empty">${icon("house")}<span>${c.empty[state.tab]}</span></div>`
    }${state.tab === "history" ? `<div class="history-page" role="status">${state.historyLoading ? c.loading : state.historyHasMore ? `<button data-action="more">${c.historyMore}</button>` : rows.length ? c.historyEnd : ""}</div>` : ""}</div></div>
    ${state.visit ? `<div class="visit">${icon(state.visit.spec ? "eye" : "house")}<span>${state.visit.spec ? c.spectating : state.visit.tab === "matches" ? c.inHouse : c.visiting} <strong>${esc(names)}</strong></span>${state.visit.spec ? `<button data-action="stopSpec">${c.stop}</button>` : ""}</div>` : ""}
    <footer><button class="return ${state.visit ? "enabled" : ""}" data-action="return" ${!state.visit || state.busy ? "disabled" : ""}>${icon("arrow")}${c.return}</button></footer>
    ${state.confirm ? `<div class="overlay"><section class="modal" role="alertdialog" aria-modal="true" aria-labelledby="confirm-title"><h2 id="confirm-title">${c.confirm}</h2><p>${c.confirmText}</p><div class="pair">${state.confirm.players.map((p) => player(p)).join("")}</div><div class="modal-actions"><button class="primary" data-action="cancel" ${state.busy ? "disabled" : ""}>${state.busy ? c.loading : c.cancel}</button><button data-action="back" data-focus="modal-back" ${state.busy ? "disabled" : ""}>${c.back}</button></div></section></div>` : ""}
    </section>${state.toast ? `<div class="toast" role="status"><i></i>${esc(state.toast)}</div>` : ""}</div>`;
  const body = surface.querySelector(".table-body");
  if (body && state.tab === "history" && rows.length) {
    const top = document.createElement("div");
    top.className = "history-spacer";
    top.style.height = `${start * HISTORY_ROW_HEIGHT}px`;
    body.prepend(top);
    const bottom = document.createElement("div");
    bottom.className = "history-spacer";
    bottom.style.height = `${Math.max(0, rows.length - start - rendered.length) * HISTORY_ROW_HEIGHT}px`;
    body.querySelector(".history-page").before(bottom);
    body.dataset.start = start;
  }
  if (body) body.scrollTop = scroll;
  if (focusKey) {
    const next = root.querySelector(`[data-focus="${focusKey}"]`);
    next?.focus();
    if (next?.type === "text") next.setSelectionRange(selection, selection);
  }
  tick();
}
function tick() {
  if (!state.open) return;
  root
    .querySelectorAll("[data-timer]")
    .forEach(
      (el) => (el.textContent = duration(now() - Number(el.dataset.timer))),
    );
  root
    .querySelectorAll("[data-session]")
    .forEach((el) => (el.textContent = session(Number(el.dataset.session))));
  root
    .querySelectorAll("[data-new]")
    .forEach((el) => (el.hidden = now() - Number(el.dataset.new) >= 30));
  const updated = root.querySelector("[data-updated]");
  if (updated)
    updated.textContent = `${c.updated} ${Math.max(0, Math.floor((Date.now() - state.updated) / 1000))}s`;
}
async function poll() {
  if (!state.open || polling || state.tab === "history") return;
  polling = true;
  const current = epoch;
  const result = await request("snapshot");
  polling = false;
  if (current !== epoch) return;
  if (result.ok) {
    applySnapshot(result);
    render();
  } else {
    state.error = c.errors[result.error] || c.errors.unavailable;
    render();
  }
}
async function act(action, data = {}) {
  if (action === "close") {
    state.open = false;
    epoch++;
    render();
    await request("close");
    return;
  }
  if (state.busy) return;
  if (action === "tab") {
    clearTimeout(historyTimer);
    requestId++;
    state.historyLoading = false;
    state.tab = data.value;
    render();
    if (state.tab === "history" && !state.historyLoaded) void loadHistory();
    return;
  }
  if (action === "kind") {
    state.kind = state.kind === data.value ? "" : data.value;
    state.historyLoaded = false;
    if (state.tab === "history") {
      loadHistory();
      return;
    }
    render();
    return;
  }
  if (action === "period") {
    state.period = data.value;
    void loadHistory();
    return;
  }
  if (action === "confirm") {
    state.confirm =
      state.snapshot.matches.find((row) => row.token === data.token) || null;
    render();
    root.querySelector('[data-focus="modal-back"]')?.focus();
    return;
  }
  if (action === "back") {
    state.confirm = null;
    render();
    return;
  }
  if (action === "retry") {
    state.error = "";
    if (state.tab === "history") {
      state.historyLoading = false;
      state.historyHasMore = true;
      loadHistory(false);
    } else void poll();
    return;
  }
  if (action === "more") {
    loadHistory(false);
    return;
  }
  const payload =
    action === "cancel"
      ? { tab: "matches", token: state.confirm?.token }
      : {
          tab: data.tab || state.tab,
          token: data.token,
          passport: Number(data.passport) || undefined,
        };
  state.busy = true;
  state.error = "";
  render();
  const current = epoch;
  const result = await request(action, payload);
  if (current !== epoch) return;
  state.busy = false;
  if (!result.ok) {
    state.error = c.errors[result.error] || c.errors.unavailable;
    render();
    return;
  }
  if ("visit" in result) state.visit = result.visit;
  if (action === "cancel") {
    state.toast = `${c.ended} ${result.players.map((p) => p.name).join(" e ")} ${c.returned}`;
    state.confirm = null;
    state.historyLoaded = false;
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => {
      state.toast = "";
      render();
    }, 3200);
  }
  render();
  void poll();
}
root.addEventListener("click", (event) => {
  const button = event.target.closest("button[data-action]");
  if (button && !button.disabled)
    void act(button.dataset.action, button.dataset);
});
root.addEventListener(
  "scroll",
  (event) => {
    const body = event.target;
    if (state.tab !== "history" || !body.classList?.contains("table-body"))
      return;
    state.historyScroll = body.scrollTop;
    cancelAnimationFrame(historyFrame);
    historyFrame = requestAnimationFrame(() => {
      if (!state.open || state.tab !== "history") return;
      const start = Math.max(
        0,
        Math.floor(state.historyScroll / HISTORY_ROW_HEIGHT) - 5,
      );
      const nearEnd =
        body.scrollHeight - body.scrollTop - body.clientHeight < 360;
      if (Number(body.dataset.start || 0) !== start) render();
      if (
        nearEnd &&
        state.historyHasMore &&
        !state.historyLoading &&
        !state.error
      )
        loadHistory(false);
    });
  },
  true,
);
root.addEventListener("input", (event) => {
  if (event.target.dataset.focus === "search") {
    state.search = event.target.value;
    state.historyLoaded = false;
    if (state.tab === "history") {
      loadHistory();
      return;
    }
    render();
  }
});
root.addEventListener("change", (event) => {
  const key = event.target.dataset.focus;
  if (key === "from" || key === "until") {
    state[key] = event.target.value;
    void loadHistory();
  }
});
window.addEventListener(
  "keydown",
  (event) => {
    if (!state.open) return;
    const editing = ["INPUT", "TEXTAREA"].includes(root.activeElement?.tagName);
    if (event.key === "Escape") {
      event.preventDefault();
      event.stopImmediatePropagation();
      void act(state.confirm ? "back" : "close");
    } else if (
      !editing &&
      !state.confirm &&
      ["1", "2", "3"].includes(event.key)
    ) {
      event.preventDefault();
      void act("tab", {
        value: ["matches", "queue", "history"][Number(event.key) - 1],
      });
    } else if (event.key === "Tab") {
      const scope = surface.querySelector(state.confirm ? ".modal" : ".panel");
      const buttons = [
        ...scope.querySelectorAll("button:not(:disabled),input"),
      ];
      const index = buttons.indexOf(root.activeElement);
      if (event.shiftKey && index <= 0) {
        event.preventDefault();
        buttons.at(-1)?.focus();
      } else if (!event.shiftKey && index === buttons.length - 1) {
        event.preventDefault();
        buttons[0]?.focus();
      }
    }
  },
  true,
);
window.addEventListener("message", (event) => {
  if (event.data?.action === "matchPanel:probe") {
    const resource =
      typeof GetParentResourceName === "function"
        ? GetParentResourceName()
        : "dashboard";
    void fetch(`https://${resource}/matchPanel:ready`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ probe: event.data.probe }),
    }).catch(() => {});
    return;
  }
  if (event.data?.action === "matchPanel:open") {
    setMatchPanelCopy(null);
    surface.classList.toggle('match-panel-rtl', event.data.locale === 'ar-sa');
    const openingEpoch = ++epoch;
    state = initial();
    state.open = true;
    void loadMatchPanelCopy(event.data.locale).then((dictionary) => {
      if (!state.open || epoch !== openingEpoch) return;
      setMatchPanelCopy(dictionary);
      applySnapshot(event.data.data);
      render();
      root.querySelector('[data-focus="search"]')?.focus();
    });
  } else if (event.data?.action === "matchPanel:close") {
    state.open = false;
    epoch++;
    render();
  } else if (event.data?.action === "matchPanel:visitStopped") {
    state.visit = false;
    render();
  }
});
setInterval(tick, 1000);
setInterval(poll, 2500);
