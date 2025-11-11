# dns-resolvers

Automated DNS resolver testing and publication system. This repository uses [pyresolvers](https://github.com/PigeonSec/pyresolvers) to test public DNS servers and publish curated lists every 48 hours.

## What It Does

This cronjob system:

1. **Fetches** the latest public DNS server list from [public-dns.info](https://public-dns.info/nameservers.txt)
2. **Tests** each DNS server using `pyresolvers` with 100 parallel threads to check:
   - Availability (responds to queries)
   - Latency (response time in milliseconds)
3. **Categorizes** resolvers into three lists:
   - `fast_resolvers.txt` - Resolvers with < 50ms latency
   - `medium_resolvers.txt` - Resolvers with < 150ms latency
   - `all_resolvers.txt` - All working resolvers
4. **Publishes** results as:
   - `resolvers.json` - Full data with latency metrics
   - Plain text lists (one IP per line)
5. **Monitors** job health via [Healthchecks.io](https://healthchecks.io/)
6. **Commits** and pushes updates to this repository automatically

## How It Works

### Architecture

```
┌─────────────────┐
│   Cron Job      │  Runs every 48 hours
│  (cron.sh)      │
└────────┬────────┘
         │
         ├─→ 1. Load secrets from .env
         │
         ├─→ 2. Ping Healthchecks.io (start)
         │
         ├─→ 3. Download DNS list
         │
         ├─→ 4. Run pyresolvers
         │      (test all servers)
         │
         ├─→ 5. Parse JSON output
         │      (create categorized lists)
         │
         ├─→ 6. Git commit & push
         │
         └─→ 7. Ping Healthchecks.io (success/fail)
```

### Files Generated

- **`resolvers.json`** - Complete dataset with all tested servers and their latency
- **`fast_resolvers.txt`** - Best performers (< 50ms)
- **`medium_resolvers.txt`** - Good performers (< 150ms)
- **`all_resolvers.txt`** - All working resolvers

### Security

The `HC_BASE_URL` (Healthchecks.io monitoring URL) is stored in `.env` and **never committed** to the repository. See deployment instructions below.

## Deployment

### Prerequisites

1. A Linux server with root access
2. Git installed
3. Python 3 with `pyresolvers` installed
4. `jq` for JSON parsing
5. `curl` for HTTP requests
6. A [Healthchecks.io](https://healthchecks.io/) account (optional but recommended)

### Installation Steps

1. **Clone the repository:**
   ```bash
   cd /root/pigeonsec
   git clone <your-repo-url> dns-resolvers
   cd dns-resolvers
   ```

2. **Install pyresolvers:**
   ```bash
   python3 -m venv /root/venv
   /root/venv/bin/pip install pyresolvers
   ```

3. **Configure secrets:**
   ```bash
   cp .env.example .env
   nano .env
   # Set your Healthchecks.io URL:
   # HC_BASE_URL="https://hc-ping.com/your-uuid-here"
   ```

4. **Set up Git authentication:**
   ```bash
   # Option A: SSH key (recommended)
   ssh-keygen -t ed25519 -C "bot@yourserver"
   cat ~/.ssh/id_ed25519.pub  # Add to GitHub deploy keys

   # Option B: Personal Access Token
   git config credential.helper store
   ```

5. **Make the script executable:**
   ```bash
   chmod +x cron.sh
   ```

6. **Test the script manually:**
   ```bash
   ./cron.sh
   ```

7. **Set up the cron job (runs every 48 hours):**
   ```bash
   crontab -e
   # Add this line:
   0 */48 * * * /root/pigeonsec/dns-resolvers/cron.sh >> /var/log/dns-resolvers.log 2>&1
   ```

### Cron Schedule Options

- **Every 48 hours:** `0 */48 * * *` (default)
- **Daily at 2 AM:** `0 2 * * *`
- **Twice daily:** `0 */12 * * *`
- **Weekly (Mondays at 3 AM):** `0 3 * * 1`

### Monitoring

The script reports status to Healthchecks.io at three points:

1. **Start** - Job begins execution
2. **Success** - Job completed (includes duration)
3. **Fail** - Job encountered an error

View your monitoring dashboard at [https://healthchecks.io/checks/](https://healthchecks.io/checks/)

### Logs

View cron job logs:
```bash
tail -f /var/log/dns-resolvers.log
```

### Troubleshooting

**Script fails with "Missing dependency":**
```bash
# Install missing tools
apt-get update
apt-get install -y jq curl git
```

**Git push fails:**
```bash
# Check authentication
git remote -v
git push origin main  # Test manually
```

**`.env` file not found:**
```bash
# Ensure .env exists in the repo directory
ls -la /root/pigeonsec/dns-resolvers/.env
```

## Development

To modify the script:

1. Edit `cron.sh` locally
2. Test changes: `bash cron.sh`
3. Commit and push: `git push origin main`
4. Pull on server: `cd /root/pigeonsec/dns-resolvers && git pull`

## License

MIT