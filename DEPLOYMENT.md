# Deployment Guide

## Prerequisites

- Linux server with root access
- Git, Python 3, jq, curl
- [Healthchecks.io](https://healthchecks.io/) account (optional)

## Installation

1. **Clone and setup:**
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
   # Set HC_BASE_URL without quotes
   ```

4. **Git authentication:**
   ```bash
   # SSH key (recommended)
   ssh-keygen -t ed25519 -C "bot@yourserver"
   cat ~/.ssh/id_ed25519.pub  # Add to GitHub deploy keys
   ```

5. **Test and schedule:**
   ```bash
   chmod +x cron.sh
   ./cron.sh  # Test manually

   # Add to crontab
   crontab -e
   # Add: 0 */48 * * * /root/pigeonsec/dns-resolvers/cron.sh >> /var/log/dns-resolvers.log 2>&1
   ```

## Cron Schedule Options

- Every 48 hours: `0 */48 * * *`
- Daily at 2 AM: `0 2 * * *`
- Twice daily: `0 */12 * * *`
- Weekly: `0 3 * * 1`

## Troubleshooting

**Missing dependencies:**
```bash
apt-get update && apt-get install -y jq curl git
```

**View logs:**
```bash
tail -f /var/log/dns-resolvers.log
```

**Test healthcheck:**
```bash
source .env
curl -v "${HC_BASE_URL}/start"
```
