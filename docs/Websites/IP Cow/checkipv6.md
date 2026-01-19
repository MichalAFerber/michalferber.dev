---
layout: default
title: "IPv6 Address Checker"
parent: "IP Cow"
grand_parent: "Websites"
---

# IPv6 Address Checker

A lightweight utility hosted on Cloudflare Pages that returns the user's public IP address as plain text. Perfect for CLI usage with `curl` or quick browser checks.

## Usage 

### CLI 

-   Get your IPv6 address: 
    ```bash
    curl -6 https://checkipv6.ipcow.com/
    ```
    Example output: `2606:4700:4700::1001` 

### Browser 
- Visit [https://checkipv6.ipcow.com/](https://checkipv6.ipcow.com/){: target="_blank" } 
- Displays your IPv6 address if you have one assigned as plain text. 

### How It Works 
- Built with Cloudflare Pages and a single Function (`functions/\[\[path]].js`).
- Uses the `CF-Connecting-IP` header to detect the client’s public IP.
- Returns plain text for simplicity and expanded use cases. 

### Notes  
This service requires an IPv6 connection. If you run `curl https://checkipv6.ipcow.com/` without `-6` and get "No IPv6 address detected," your client likely connected over IPv4. Use `curl -6 https://checkipv6.ipcow.com/` to force an IPv6 connection and retrieve your IPv6 address. If your network lacks IPv6 support, this service will not return an IP address.

Use [https://checkip.ipcow.com/](https://checkip.ipcow.com/){: target="_blank" } instead. For a dual-IP display, check out <https://ipcow.com/>.
No external dependencies—just pure Cloudflare magic. Use at your will, no guarantees implied.

### License  
MIT License - feel free to use, modify, and share!