---
layout: default
title: "michalferber.me"
parent: "Websites"
has_children: true
---

![Header](https://raw.githubusercontent.com/MichalAFerber/michalaferber.github.io/main/assets/img/github-header-banner.png){: target="_blank" }
# Michal's Beautiful Jekyll

A streamlined personal website built with [Beautiful Jekyll](https://beautifuljekyll.com){: target="_blank" } using GitHub's `remote_theme` feature for minimal maintenance.

Live site: **[https://michalferber.me](https://michalferber.me){: target="_blank" }**

## Features

- **Remote Theme**: Uses `daattali/beautiful-jekyll@6.0.1` via `remote_theme` - no need to maintain theme files locally
- **Bootstrap 5** UI (loaded via theme)
- **Font Awesome 6** icons (loaded via theme)
- **Splide.js** for lightweight image carousels
- **Dark theme** with custom color scheme
- **Disqus** comments
- **Google Analytics 4**

## Quick Start (Local Development)

Prerequisites: Ruby 3.x, Bundler

```bash
bundle install
bundle exec jekyll serve --livereload
# http://127.0.0.1:4000
```

## Project Structure

```
├── _config.yml              # Site configuration + remote_theme
├── _data/
│   ├── programming-skills.yml
│   ├── other-skills.yml
│   └── timeline.yml
├── _includes/
│   ├── buymeacoffee.html    # Footer donation button
│   ├── splide-css.html      # Splide carousel CSS
│   └── elements/            # Custom includes
│       ├── adobe.html       # PDF viewer embed
│       ├── button.html      # Styled buttons
│       ├── carousel.html    # Splide image carousel
│       ├── list.html        # List/TOC generator
│       └── video.html       # Video embed (YouTube, Vimeo, etc.)
│   └── about/               # About page components
│       ├── skills.html
│       └── timeline.html
├── _posts/                  # Blog posts
├── assets/
│   ├── css/custom.css       # Custom styles (carousel, etc.)
│   ├── img/                 # Images
│   ├── badges/              # Certification badges
│   ├── certs/               # Certificate images & PDFs
│   ├── docs/                # Embedded documents
│   └── downloads/           # Downloadable files
├── about.html               # About page
├── index.html               # Home page
└── plex.md                  # Plex request page
```

## Why Remote Theme?

Using `remote_theme` instead of vendoring all theme files provides:

- **Less maintenance**: Theme updates come from the upstream repo automatically
- **Cleaner repository**: ~30+ fewer files to manage
- **Easier updates**: Pin to a specific version tag (e.g., `@6.0.1`)
- **Override only what you need**: Keep custom includes/layouts, theme provides the rest

## Customizations

### Custom Includes

- **Splide Carousel**: Lightweight image slider for badges/certifications
- **Adobe PDF Viewer**: Embedded PDF documents
- **Video Embed**: Support for YouTube, Vimeo, Rumble, Dailymotion
- **Buy Me A Coffee**: Footer donation button on all pages

### Custom Styles

`assets/css/custom.css` contains:
- Carousel container sizing
- Splide dark theme overrides

## Writing Posts

Create a file in `_posts/` with the format `YYYY-MM-DD-title.md`:

```markdown
---
layout: post
title: "My Post Title"
subtitle: "Optional subtitle"
date: 2025-01-19
tags: [tag1, tag2]
thumbnail-img: /assets/img/my-image.jpg
---

Your content here...
```

## Deployment

This site is deployed via **GitHub Pages**:

- GitHub Pages builds from the default branch
- `CNAME` file contains: `michalferber.me`
- DNS is configured to point to GitHub Pages

## Configuration Highlights

Key settings in `_config.yml`:

```yaml
remote_theme: daattali/beautiful-jekyll@6.0.1

# Custom colors (dark theme)
page-col: "#27262b"
text-col: "#e6e1e8"
link-col: "#56b4fc"
navbar-col: "#27262b"
footer-col: "#27262b"

# Custom CSS
site-css:
  - "/assets/css/custom.css"

# Footer extras (Buy Me A Coffee on all pages)
defaults:
  - scope:
      path: ""
    values:
      footer-extra: ["buymeacoffee.html"]
```

## License & Credits

- Theme: [Beautiful Jekyll](https://beautifuljekyll.com){: target="_blank" } by Dean Attali (MIT)
- Carousel: [Splide.js](https://splidejs.com/){: target="_blank" } (MIT)
- Content: © Michal Ferber

## Contact

- Website: [michalferber.me](https://michalferber.me){: target="_blank" }
- GitHub: [@MichalAFerber](https://github.com/MichalAFerber){: target="_blank" }
- X/Twitter: [@MichalAFerber](https://twitter.com/MichalAFerber){: target="_blank" }