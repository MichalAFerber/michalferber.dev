---
layout: default
title: "michalferber.me"
parent: "Websites"
has_children: true
---

![Header](https://raw.githubusercontent.com/MichalAFerber/michalaferber.github.io/main/assets/img/github-header-banner.png){: target="_blank" }

# Michal’s Beautiful Jekyll (Bootstrap 5 + Prism)

A streamlined fork of [Beautiful Jekyll] with:

* **Bootstrap 5** UI
* **Font Awesome 7**
* **PrismJS** with a polished look, copy-to-clipboard, show language, download button, match-braces, treeview, previewers, inline-color, autolinker
* **Fira Code** everywhere for code
* **Dark/Light mode** toggle (persists)
* **Great defaults** for performance, accessibility, and code readability
* **Zero npm at runtime** (key vendor files are checked in)

Live site: **[https://michalferber.me](https://michalferber.me){: target="_blank" }**

> If you’re here just to write posts, jump to **[Writing posts](#writing-posts)**.

## Quick start (local)

Prereqs: Ruby (3.x), Bundler.

```bash
bundle install
bundle exec jekyll serve
# http://127.0.0.1:4000
```

## What’s included

```bash
assets/
  css/
    beautifuljekyll.css        # theme styles
    change-skin.css            # dark/light toggle styles
    custom.css                 # custom styles & media queries
  js/
    beautifuljekyll.js         # theme scripts (incl. skin toggle)
  vendor/
    prism/                     # Prism core, theme, plugins, languages
      prism.js
      themes/prism-tomorrow.min.css
      plugins/...
      components/...
_includes/
  head.html, footer-scripts.html (load Bootstrap, Prism, fonts, etc.)
_layouts/
  default.html, post.html, home.html, ...
CNAME                         # custom domain (michalferber.me)
robots.txt                    # crawler directives
humans.txt                    # authorship & colophon
```

* **Bootstrap 5.3.x** is loaded from CDN by default (can self-host).
* **PrismJS** is **vendored** in `assets/vendor/prism` (no CDN 404/MIME issues).
* **Fira Code** is loaded via Google Fonts; can be self-hosted if desired.

See **[DEPS.md](./DEPS.md)** for “how to update” vendor files.

## Writing posts

Create a file in the repo root or `_posts/`:

````markdown
---
layout: post
title: "My Great Post"
subtitle: >
  I turn <img src="/assets/img/landing_coffee.avif" alt="coffee"> and
  <img src="/assets/img/landing_mountain-dew.avif" alt="dew"> into code.
date: 2025-08-13
tags: [css, responsive, performance]
thumbnail-img: /assets/img/my-hero-image.jpg
cover-img: /assets/img/my-hero-image.jpg
redirect_from:
  - /legacy/path/to/post/
---

Intro text…

```css
/* Your code block – language is important for Prism */
@media (min-width: 900px) { ... }
````

### Notes

* Front-matter `subtitle:` supports inline HTML (use `>` or quotes).
* Code blocks: use triple backticks + language (e.g., `css`, `js`, `html`, `python`).
* Line numbers are added automatically.
* Code blocks **wrap** by default. To force horizontal scroll on a specific block, add the class `no-wrap` to the `<pre>` tag (optional).

## Dark/Light mode

Top-right toggle switches themes and saves the choice in `localStorage`. Prism token colors are tuned for both modes.

## Deployment (GitHub Pages + custom domain)

* GitHub Pages builds from the default branch.
* `CNAME` file is committed with: `michalferber.me`.
* DNS points the apex/root to GitHub Pages (already set up).

If you need to re-link the project to a different repo or branch later, update the repository’s **Settings → Pages** and keep the `CNAME` file in the published branch.

## Keeping current with upstream (Beautiful Jekyll)

This fork tracks [`daattali/beautiful-jekyll`] for ongoing improvements.

One-time setup (already done locally, repeat on a new machine):

```bash
git remote add upstream https://github.com/daattali/beautiful-jekyll.git
````

Pull upstream changes into your main branch:

```bash
git checkout main
git fetch upstream
git merge upstream/master     # or: git rebase upstream/master
# resolve conflicts if any, then:
git push origin main
```

> Large customizations? Do them on feature branches and merge back into `main`.

## Updating dependencies

* **PrismJS** (core/theme/plugins/components) is **vendored**. See **[DEPS.md]** for exact curl commands and optional SRI steps.
* **Bootstrap 5**: bump the CDN version in `_includes/head.html` and `footer-scripts.html` (or vendor files under `assets/vendor/bootstrap` and switch links).
* **Font Awesome 7**: update the CDN `<link>` in the head include.

## Authoring tips

* **Images**: prefer AVIF/WebP; include `width`/`height` to avoid CLS; add `loading="lazy"` for non-hero images.
* **Accessibility**: ensure link text is descriptive; headings are hierarchical; color contrast passes.
* **Performance**: keep third-party scripts minimal (e.g., only Disqus if you truly need comments).

## License & credits

* Theme code derived from **Beautiful Jekyll** by Dean Attali (MIT).
* Your content (posts, images) remains yours.
* See the upstream license in the original project.

## Support / questions

Open an issue on this repo or ping me on X: **@MichalAFerber**.

[Beautiful Jekyll]: https://beautifuljekyll.com
[DEPS.md]: ./DEPS.md
