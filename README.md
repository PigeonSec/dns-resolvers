# dns-resolvers

## Status

These resolver lists are no longer updated automatically.

The dedicated update server was shut down because it cost too much to keep running. Until a cheaper replacement exists, this repository should be treated as a manual / best-effort snapshot rather than a continuously refreshed feed.

Tested and curated DNS resolver lists. The old automatic 48-hour refresh is currently paused.

## Download

| File | Description | Raw URL |
|------|-------------|---------|
| `resolvers.json` | Full dataset with latency metrics | `https://raw.githubusercontent.com/PigeonSec/dns-resolvers/refs/heads/main/resolvers.json` |
| `fast_resolvers.txt` | Fast resolvers (< 50ms) | `https://raw.githubusercontent.com/PigeonSec/dns-resolvers/refs/heads/main/fast_resolvers.txt` |
| `medium_resolvers.txt` | Medium resolvers (< 150ms) | `https://raw.githubusercontent.com/PigeonSec/dns-resolvers/refs/heads/main/medium_resolvers.txt` |
| `all_resolvers.txt` | All working resolvers | `https://raw.githubusercontent.com/PigeonSec/dns-resolvers/refs/heads/main/all_resolvers.txt` |

**Quick Download:**

```bash
curl -O https://raw.githubusercontent.com/PigeonSec/dns-resolvers/refs/heads/main/fast_resolvers.txt
```

## About

Automated testing of public DNS servers using [pyresolvers](https://github.com/PigeonSec/pyresolvers). Resolvers are categorized by latency:
- **Fast** - Under 50ms response time
- **Medium** - Under 150ms response time
- **All** - All working resolvers

These lists were previously updated automatically every 48 hours from [public-dns.info](https://public-dns.info/nameservers.txt). That automation is currently paused.

## Self-Hosting

Want to run your own DNS resolver testing? See [DEPLOYMENT.md](DEPLOYMENT.md) for setup instructions.

---

<p align="center">
  <sub>Powered by <a href="https://github.com/PigeonSec/pyresolvers">pyresolvers</a> | Data from <a href="https://public-dns.info">public-dns.info</a></sub>
</p>
