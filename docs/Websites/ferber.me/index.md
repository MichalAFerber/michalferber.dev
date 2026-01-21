---
layout: default
title: "ferber.me"
parent: "Websites"
has_children: true
---

# The Ferber Family Website

![Ferber Family Crest](https://raw.githubusercontent.com/MichalAFerber/ferber.me/main/assets/images/ferber_crest.jpg){: target="_blank" }

A family history website for the Ferber family, built with Jekyll and the [Just the Docs](https://just-the-docs.com/){: target="_blank" } theme.

## 🌐 Live Site

Visit: [https://ferber.me](https://ferber.me){: target="_blank" }

## 🚀 Local Development

### Prerequisites

- Ruby 3.0+
- Bundler

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/ferber.me.git
   cd ferber.me
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Start the local server:
   ```bash
   bundle exec jekyll serve
   ```

4. Open [http://localhost:4000](http://localhost:4000){: target="_blank" } in your browser.

## 📁 Project Structure

```
ferber.me/
├── _config.yml          # Jekyll configuration
├── index.md             # Home page
├── history.md           # Family history page
├── photos.md            # Photo gallery
├── assets/
│   └── docs/            # Site documents
│   └── images/          # Site images
│       └── gallery01/   # Family photos
├── .github/
│   └── workflows/
│       └── pages.yml    # GitHub Pages deployment
```

## 🎨 Theme

This site uses the [Just the Docs](https://github.com/just-the-docs/just-the-docs){: target="_blank" } theme for Jekyll.

## 📄 License

Copyright © 2011-2026 Michal Ferber
