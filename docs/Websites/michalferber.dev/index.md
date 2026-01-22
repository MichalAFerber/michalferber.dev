---
layout: default
title: "michalferber.dev"
parent: "Websites"
has_children: true
---

# Michal Ferber's Dev Hub

<img src="https://raw.githubusercontent.com/MichalAFerber/michalferber.dev/main/assets/images/michalferber_logo.png" align="right" width="128" alt="Michal Ferber Logo">

[![Deploy Jekyll site to Pages](https://github.com/MichalAFerber/michalferber.dev/actions/workflows/jekyll.yml/badge.svg){: target="_blank" }](https://github.com/MichalAFerber/michalferber.dev/actions/workflows/jekyll.yml)

This repository creates a static documentation site using [Jekyll](https://jekyllrb.com/){: target="_blank" } and the [Just the Docs](https://just-the-docs.com/){: target="_blank" } theme. It serves as a central hub for all my technical documentation, project logs, applications, websites, and scripts.

**Live Site:** [michalferber.dev](https://michalferber.dev){: target="_blank" }
**Author:** Michal Ferber, aka TechGuyWithABeard

## 🚀 Features

- **Automated Sync**: Content is imported from an external Obsidian Vault using a custom Ruby script.
- **Auto-Navigation**: The script automatically generates `index.md` files and frontmatter to build the sidebar navigation based on folder structure.
- **Asset Management**: Images and attachments referenced in Obsidian are automatically copied and linked correctly.
- **GitHub Pages**: Deployed automatically via GitHub Actions.

## 🛠️ Local Development

### Prerequisites

- Ruby 3.0+
- Bundler (`gem install bundler`)

### Setup

1.  Clone the repository:
    ```bash
    git clone https://github.com/MichalAFerber/michalferber.dev.git
    cd michalferber.dev
    ```
2.  Install dependencies:
    ```bash
    bundle install
    ```

### Importing Content (Optional)

If you have access to the source Obsidian vault, you can sync content. **Note:** This requires the `Obsidian-Master` folder to be present at the configured path in `import_docs.rb`.

```bash
ruby import_docs.rb
```

This script will:

- Clear the docs and attachments folders.
- Import markdown files and attachments.
- Inject necessary Frontmatter (titles, layout, parent/child relationships).
- Move the root index to the project root.

## Configuration

The site is configured via `_config.yml` with the following key settings:
- **Theme:** `just-the-docs` (via `jekyll-remote-theme`)
- **Color Scheme:** Dark mode enabled
- **Plugins:**
  - `jekyll-seo-tag`
  - `jekyll-sitemap`
  - `jekyll-include-cache`

### Running Locally

To run this site locally:

```bash
# Install dependencies
bundle install

# Serve the site locally
bundle exec jekyll serve

# The site will be available at http://localhost:4000
```

## 📦 Deployment

This site is deployed to **GitHub Pages** automatically whenever changes are pushed to the `main` branch.

- **Workflow**: `.github/workflows/jekyll.yml`
- **Source**: Static files built from this repo.

## Theme

Built with [Just the Docs](https://just-the-docs.com/){: target="_blank" } - A modern, high-performance Jekyll theme for documentation.

## 📝 License

This project is open-source and available under the [MIT License](LICENSE).