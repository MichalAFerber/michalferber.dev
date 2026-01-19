---
layout: default
title: "ipcow-geo-proxy"
parent: "ipcow.com"
grand_parent: "Websites"
---

# ipcow-geo-proxy

A Cloudflare Worker that acts as a secure proxy for the [ipstack](https://ipstack.com/){: target="_blank" } API. This service helps power the geolocation features of [ipcow.com](https://ipcow.com){: target="_blank" } by hiding the API key and providing CORS support.

## Features

- **Secure API Key Storage**: The `IPSTACK_KEY` is stored as a Cloudflare Worker secret, preventing it from being exposed in client-side code.
- **Dual-Stack Support**: Can resolve the visitor's connecting IP (`CF-Connecting-IP`) or accept an explicit IP address via query parameter (useful for getting IPv4 location when the client connects via IPv6).
- **CORS Handling**: Sends appropriate headers to allow usage from the `ipcow.com` frontend.
- **Error Handling**: Graceful fallback and error messaging if the upstream API fails.

## Usage

### Endpoint

`GET https://geo.ipcow.com/`

### Query Parameters

| Parameter | Type   | Description |
|xy-------|--------|-------------|
| `ip`      | string | (Optional) The specific IP address to look up. If omitted, the worker uses `CF-Connecting-IP`. |
| `_`       | number | (Optional) Cache-busting timestamp (ignored by logic, but useful for clients). |

### Examples

**1. Get location of the current visitor:**
```http
GET https://geo.ipcow.com/
```

**2. Get location of a specific IP:**
```http
GET https://geo.ipcow.com/?ip=8.8.8.8
```

## Setup & Deployment

### Prerequisites

- [Cloudflare Account](https://dash.cloudflare.com/){: target="_blank" }
- [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/install-and-update/){: target="_blank" } installed.
- An [ipstack](https://ipstack.com/){: target="_blank" } API Key.

### Local Development

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd ipcow-geo-proxy
   ```

2. **Install dependencies (if applicable):**
   *(Currently, this is a dependency-free single file worker)*

3. **Run locally:**
   ```bash
   wrangler dev
   ```

### Configuration

You must set the `IPSTACK_KEY` secret in your Cloudflare Worker environment.

**Using Wrangler:**
```bash
wrangler secret put IPSTACK_KEY
# Enter your ipstack API key when prompted
```

**Using Cloudflare Dashboard:**
1. Go to **Workers & Pages**.
2. Select your worker (`ipcow-geo-proxy`).
3. Go to **Settings** > **Variables and Secrets**.
4. Add `IPSTACK_KEY`.

### Deployment

Deploy to Cloudflare Workers:
```bash
wrangler deploy
```

## API Response

The response mirrors the [ipstack API JSON format](https://ipstack.com/documentation){: target="_blank" }, with standard HTTP status codes.

**Sample Success Response:**
```json
{
  "ip": "134.201.250.155",
  "type": "ipv4",
  "continent_code": "NA",
  "continent_name": "North America",
  "country_code": "US",
  "country_name": "United States",
  "region_code": "CA",
  "region_name": "California",
  "city": "Los Angeles",
  "zip": "90013",
  "latitude": 34.0453,
  "longitude": -118.2413,
  "location": {
    "geoname_id": 5368361,
    "capital": "Washington D.C.",
    "languages": [
      {
        "code": "en",
        "name": "English",
        "native": "English"
      }
    ],
    "country_flag": "https://assets.ipstack.com/flags/us.svg",
    "country_flag_emoji": "🇺🇸",
    "country_flag_emoji_unicode": "U+1F1FA U+1F1F8",
    "calling_code": "1",
    "is_eu": false
  }
}
```

## License

This project is part of the IP Cow ecosystem.