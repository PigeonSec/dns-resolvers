#!/usr/bin/env bash
set -euo pipefail

# ── CONFIG ──────────────────────────────────────────────────────────────
REPO_DIR="/root/pigeonsec/dns-resolvers"

# Load secrets from .env file
if [ -f "$REPO_DIR/.env" ]; then
  source "$REPO_DIR/.env"
else
  echo "ERROR: .env file not found at $REPO_DIR/.env"
  echo "Please copy .env.example to .env and configure it."
  exit 1
fi
DNS_LIST="https://public-dns.info/nameservers.txt"
JSON_OUT="$REPO_DIR/resolvers.json"

FAST_OUT="$REPO_DIR/fast_resolvers.txt"
MEDIUM_OUT="$REPO_DIR/medium_resolvers.txt"
ALL_OUT="$REPO_DIR/all_resolvers.txt"

# ── CHECK DEPENDENCIES ─────────────────────────────────────────────────
for cmd in jq pyresolvers git curl; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "Missing dependency: $cmd"
    exit 1
  }
done

# ── HEALTHCHECKS START ─────────────────────────────────────────────────
curl -fsS -m 10 --retry 5 -o /dev/null "${HC_BASE_URL}/start" || true
start_ts=$(date +%s)

{
  cd "$REPO_DIR"

  echo "[+] Running pyresolvers at $(date)..."
  /root/venv/bin/pyresolvers -tL "$DNS_LIST" -threads 100 --format json -o "$JSON_OUT"

  # ── BUILD TXT LISTS WITH jq ──────────────────────────────────────────
  echo "[+] Creating resolver lists..."

  jq -r '.servers[].ip' "$JSON_OUT" > "$ALL_OUT"
  jq -r '.servers[] | select(.latency_ms != null and .latency_ms < 50) | .ip' "$JSON_OUT" > "$FAST_OUT"
  jq -r '.servers[] | select(.latency_ms != null and .latency_ms < 150) | .ip' "$JSON_OUT" > "$MEDIUM_OUT"

  # ── COUNT TOTAL AND FAST RESOLVERS ───────────────────────────────────
  total_count=$(jq '.count // (.servers | length)' "$JSON_OUT")
  fast_count=$(wc -l < "$FAST_OUT" | tr -d ' ')
  medium_count=$(wc -l < "$MEDIUM_OUT" | tr -d ' ')
  end_ts=$(date +%s)
  duration=$(( end_ts - start_ts ))

  duration_min=$(( duration / 60 ))
  timestamp=$(date -u +"%Y-%m-%d %H:%M UTC")

  # ── COMMIT & PUSH WITH BETTER MESSAGE ────────────────────────────────
  COMMIT_MSG="🤖 Auto-update by pyresolvers-bot | ${timestamp}
⏱️ Duration: ${duration_min} min
🌐 Total: ${total_count} | ⚡ Fast: ${fast_count} | ⚙️ Medium: ${medium_count}"

  echo "[+] Committing updates..."
  git add resolvers.json fast_resolvers.txt medium_resolvers.txt all_resolvers.txt
  git commit -m "$COMMIT_MSG" >/dev/null 2>&1 || echo "No changes to commit."
  git push origin main >/dev/null 2>&1

  # ── HEALTHCHECK SUCCESS ─────────────────────────────────────────────
  curl -fsS -m 10 --retry 5 -o /dev/null "${HC_BASE_URL}?duration=${duration}" || true

  echo "[+] Done in ${duration_min} min (${duration}s)."
  echo "[+] ${total_count} total, ${fast_count} fast, ${medium_count} medium resolvers committed."

} || {
  # On failure
  curl -fsS -m 10 --retry 5 -o /dev/null "${HC_BASE_URL}/fail" || true
  echo "[!] pyresolvers job failed!"
  exit 1
}