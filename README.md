# ElfClean website

The public site for [ElfClean](https://apps.apple.com/app/id6819001057), a Mac app that frees up
space from AI tools and code. Served by Vercel at <https://elfclean.app/> from `main`
(`vercel.json`: clean URLs, so `support.html` is `/support`).

- Home: <https://elfclean.app/>
- Support: <https://elfclean.app/support>
- Privacy policy: <https://elfclean.app/privacy>
- Press kit and creators: `/press` (full-size images in `assets/press/`), `/creators`
- Guides: `delete-node-modules-mac`, `remove-ollama-hugging-face-models`,
  `ai-coding-agents-disk-space`, `clear-xcode-deriveddata`, `system-data-mac`,
  `find-large-files-duplicates-mac`, `docker-disk-space-mac`, `clear-developer-caches-mac`,
  `mac-cleaner-for-developers` (competitor facts read from vendor pages on 2026-10-23;
  recheck before quoting them elsewhere)

GitHub Pages still publishes `main` at `enlitened.github.io/elfclean/`, which the shipped app
(Settings › Help and Privacy) and the App Store listing link to. A script in each page's head
forwards those visits to the same page on elfclean.app (the old root was the support page),
and every page's canonical link names elfclean.app.

Plain static HTML, no build step. The colours and font are the app's (`Styles.swift`'s Palette,
Hanken Grotesk under the OFL in `assets/fonts/`). Screenshots in `assets/shots/` are offscreen
renders from the app repository's `ParitySnapshotTests` and `SettingsSnapshotTests` against a
fixture home, light and dark. App Store links carry `ct=web_*` campaign names for App Analytics.

When adding a page, add it to `sitemap.xml` and `llms.txt`.

**Launch day:** the App Store page returns 404 until ElfClean is on sale, so the store
buttons ask for an email and a "coming soon" note shows. When it's on sale, run
`python3 tools/store_links.py launch`, commit and push.

**Search engines:** Google Search Console and Bing Webmaster Tools verify through the
two meta tags at the top of `index.html`; keep them. `0e8745614ace16b6bedc9b32e2a71208.txt`
is the IndexNow key, for telling Bing about new pages:

    curl "https://api.indexnow.org/indexnow?url=https://elfclean.app/NEW-PAGE&key=0e8745614ace16b6bedc9b32e2a71208"

Contact: csergay@gmail.com
