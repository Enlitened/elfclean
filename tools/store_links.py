"""Switch the site's App Store buttons between pre-launch and launch.

Before ElfClean is on the Mac App Store its page returns 404, so every store button
asks for an email instead:

    python3 tools/store_links.py prelaunch
    python3 tools/store_links.py launch      # the day the app is on sale

Each store link keeps its real address and label in data-store-href and
data-store-label, so the switch works both ways. Elements marked data-prelaunch
(the "coming soon" notes) are shown before launch and hidden after.
Stdlib only.
"""
import re
import sys
from pathlib import Path

SITE = Path(__file__).resolve().parent.parent
NOTIFY = "mailto:csergay@gmail.com?subject=Tell%20me%20when%20ElfClean%20is%20out"
STORE = re.compile(r'<a class="button([^"]*)" href="(https://apps\.apple\.com/app/apple-store/id6819001057[^"]*)">([^<]*)</a>')
PRE = re.compile(r'<a class="button([^"]*)" href="mailto:[^"]*" data-store-href="([^"]*)" data-store-label="([^"]*)">[^<]*</a>')


def prelaunch(html):
    def swap(m):
        cls, href, label = m.groups()
        text = "Get notified" if "small" in cls else "Email me when it's out"
        return f'<a class="button{cls}" href="{NOTIFY}" data-store-href="{href}" data-store-label="{label}">{text}</a>'
    html = STORE.sub(swap, html)
    return html.replace("data-prelaunch hidden", "data-prelaunch")


def launch(html):
    html = PRE.sub(lambda m: f'<a class="button{m.group(1)}" href="{m.group(2)}">{m.group(3)}</a>', html)
    return re.sub(r"data-prelaunch(?! hidden)", "data-prelaunch hidden", html)


def main():
    if len(sys.argv) != 2 or sys.argv[1] not in ("prelaunch", "launch"):
        sys.exit(__doc__)
    change = prelaunch if sys.argv[1] == "prelaunch" else launch
    for page in sorted(SITE.glob("*.html")):
        old = page.read_text()
        new = change(old)
        if new != old:
            page.write_text(new)
            print("updated", page.name)


if __name__ == "__main__":
    main()
