# Ningyuan Zhou — Portfolio

A hand-written static portfolio: **plain HTML + CSS + JavaScript**. No framework, no build step, no backend.
Open `index.html` directly, or serve the folder. Hosted on GitHub Pages.

> **Contact:** `x20250081@stu.biuh.edu.cn` is the address wired into the footer, the contact page and the contact form (`data-mailto`). Check that `github.com/swdlawa` is the account you want linked.

---

## 1. Pages

```
portfolio-site/
├── index.html              Home: hero, selected work, principles, skills, CTA
├── work.html               All projects, filterable (All / LLM apps / Full-stack / Front-end)
├── project-dsh.html        Case study: local LLM agent deployment
├── project-qqbot.html      Case study: QQ chatbot
├── project-web.html        Case study: AI-assisted web development
├── about.html              About: bio, timeline, skills table, next three months
├── contact.html            Contact: email, GitHub, message form, FAQ
├── 404.html                Not-found page
├── manifest.webmanifest    Web app manifest (icons, theme colour)
├── css/
│   └── styles.css          All styling: design tokens, responsive layout, dark mode
├── js/
│   └── main.js             Theme, mobile nav, project filter, copy, form validation, reveal
├── assets/
│   ├── favicon.svg         Site mark (vector, preferred)
│   ├── favicon.png         64×64 fallback
│   ├── apple-touch-icon.png 180×180 iOS home screen
│   ├── icon-192.png        192×192 manifest icon
│   ├── icon-512.png        512×512 manifest icon (also declared maskable)
│   ├── og-image.png        1200×630 social card
│   ├── cover-dsh.svg       Original illustration: agent → gateway → model
│   ├── cover-qqbot.svg     Original illustration: chat window, daemon, memory
│   ├── cover-web.svg       Original illustration: browser / API / database
│   └── desk.svg            Original illustration: top-down desk
├── scripts/
│   ├── generate-images.ps1 Rebuilds the OG card, favicon and app icons
│   ├── serve.mjs           Zero-dependency local preview server
│   └── shoot.mjs           Dev-only screenshot helper (not part of the site)
├── .nojekyll               Stops GitHub Pages running Jekyll
└── README.md
```

---

## 2. How the brief is met

| Requirement | How this site does it |
| --- | --- |
| **Pages** — at least four, with working navigation | Eight pages. Shared header nav and footer nav, `aria-current="page"` on the active item, breadcrumbs and prev/next on case studies |
| **Content** — your own words and images, or properly sourced | Copy is written from three real projects; every illustration is an original SVG, so there is no third-party licence to clear |
| **Structure** — semantic HTML | `header / nav / main / article / section / aside / figure / figcaption / time / dl / table / form / footer`; table has `caption` and `th scope`; heading levels never skip |
| **Layout** — responsive on a phone | `clamp()` fluid type, auto-fitting Grid cards, nav collapses below 780px, tables scroll horizontally. Checked at 390px and 1440px |
| **Behaviour** — responds to the user | Dark-mode toggle, mobile menu, **project filter**, copy-email button, validated contact form that composes an email, scroll-reveal, back-to-top |
| **Live** — a real address | GitHub Pages: `https://swdlawa.github.io/portfolio/` |
| **History** — grows week by week | See §6. The repository is new, so the history starts now and cannot honestly contain earlier weeks |
| **Identity** — OG image, favicon, app icon | `og-image.png` 1200×630, `favicon.svg` + `favicon.png`, `apple-touch-icon.png`, `icon-192/512.png`, plus `manifest.webmanifest` and full OG/Twitter meta tags on every page |

Accessibility: skip link, visible focus rings, `aria-live` result regions, `aria-expanded` / `aria-pressed` states, keyboard-operable filters, and `prefers-reduced-motion` support.

---

## 3. Run it locally

```bash
# Option 1: just open index.html

# Option 2: serve it (recommended — paths match production)
node scripts/serve.mjs 8080
# then visit http://localhost:8080
```

---

## 4. Make it yours

1. **Name** — search for `Ningyuan Zhou`, replace it. The romanisation also appears in `<title>` tags and the OG image.
2. **Email** — search for `x20250081@stu.biuh.edu.cn`; it appears in the footer of every page, on the contact page (link, copy button and form) and in `contact.html`'s `data-mailto`.
3. **Project copy** — the case studies are `project-*.html`; the cards live in `work.html`. Replace them with things you actually did, and delete any sentence you can't defend.
4. **Timeline** — the `<ol class="timeline">` in `about.html`; use real dates.
5. **Palette** — the `:root` variables at the top of `css/styles.css`; one change propagates everywhere.
6. **Identity images** — edit the parameters at the top of `scripts/generate-images.ps1`, then run:

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/generate-images.ps1
   ```

   This rebuilds `og-image.png`, `favicon.png`, `apple-touch-icon.png`, `icon-192.png` and `icon-512.png`.

---

## 5. Image licensing

- Every file in `assets/` is original work for this site (hand-written SVG, or generated by the script above). Modify freely.
- If you add photographs, use your own, or a properly licensed source (Unsplash, Pexels, Openverse), and credit the author in the `<figcaption>`.

---

## 6. A note on Git history

The brief asks for history that shows the site growing week by week. The honest way to get that is to commit weekly from now on — not to make one huge commit and backdate it, which is forging the record.

The repository currently contains eight commits, split by feature, all pushed the day the site was built:

1. `docs: project plan, structure and ignore rules`
2. `feat: original SVG illustrations and identity images`
3. `feat: design tokens, responsive layout and dark theme`
4. `feat: theme toggle, mobile nav, filters and form validation`
5. `feat: home page with hero, selected work and skills`
6. `feat: work index and three project case studies`
7. `feat: about, contact, 404 and web app manifest`
8. `docs: clarify commit sequence and live URL`

If the course has weeks left, make one small real change per week (a new case study, a note, a copy edit) and commit it:

```bash
git log --oneline --reverse --date=short --pretty=format:"%ad  %s"
```

---

## 7. Deploying to GitHub Pages

```bash
git init
git add .
git commit -m "feat: initial portfolio"
git branch -M main
git remote add origin https://github.com/<your-username>/portfolio.git
git push -u origin main
```

Then in the repository: **Settings → Pages → Source: Deploy from a branch → `main` / `(root)` → Save**.
After a minute or two the site is at `https://<your-username>.github.io/portfolio/`.

> `og:image` must be absolute, so every `<head>` already points at `https://swdlawa.github.io/portfolio/...`.
> If the username or repository changes, replace that prefix everywhere.

`.nojekyll` is included so files with leading underscores are not ignored.

---

## 8. Browser support

Uses CSS that current browsers have supported since 2023 (`clamp()`, `color-mix()`, Grid, logical properties).
Where `color-mix()` is unsupported, only a few translucent backgrounds differ — content and layout are unaffected.
