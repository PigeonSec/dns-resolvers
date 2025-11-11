# dns-resolvers

Tested and curated DNS resolver lists, updated every 48 hours.

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

Updated automatically every 48 hours from [public-dns.info](https://public-dns.info/nameservers.txt).

## Self-Hosting

Want to run your own DNS resolver testing? See [DEPLOYMENT.md](DEPLOYMENT.md) for setup instructions.

---

<p align="center">
  <sub>Powered by <a href="https://github.com/PigeonSec/pyresolvers">pyresolvers</a> | Data from <a href="https://public-dns.info">public-dns.info</a></sub>
</p>