---
layout: default
title: "ipcow-assets"
parent: "ipcow.com"
grand_parent: "Websites"
---

# ipcow-assets

This repository serves as the central storage for static assets used across the [IP Cow](https://ipcow.com){: target="_blank" } ecosystem. It hosts stylesheets, scripts, fonts, and images that are consumed by the main website and associated services.

## Structure

- **css/**: Global stylesheets, including Pure.css customization and responsive overrides.
- **js/**: Core JavaScript logic.
  - `main.js`: Utility functions (like copy-to-clipboard) and footer injection.
  - `theme-toggle.js`: Logic for handling dark/light mode switching.
- **fonts/**: Custom font definitions (`fonts.css`) and font files.
- **favicon/**: Site icons and web manifest.
- **svg/** & **webp/**: Optimized vector and raster images.
- **_headers**: Configuration for Cloudflare Pages (CORS headers, caching policies).

## Deployment

These assets are deployed to **assets.ipcow.com**. This separation allows for aggressive caching and shared usage across different subdomains if needed.

## Key Files

### `_headers`

This file configures the response headers for the static assets. Crucially, it sets:
- `Access-Control-Allow-Origin: *` to allow `ipcow.com` to fetch fonts and scripts via CDN.
- `Cache-Control` headers for performance.

### `js/main.js`

Contains shared UI logic, including:
- Dynamic footer copyright year injection.
- "Click to copy" functionality with tooltips.

## Usage

Assets are typically linked in the main project like so:

```html
<link rel="stylesheet" href="https://assets.ipcow.com/css/styles.css">
<script src="https://assets.ipcow.com/js/main.js" async></script>
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
