# =========================
# Qutebrowser Config
# =========================

config.load_autoconfig()

# General settings
c.auto_save.session = False  # Remember open tabs between sessions
c.confirm_quit = ["never"]  # No annoying quit confirmation
c.content.private_browsing = False  # Change to True for private mode
c.url.start_pages = ["https://duckduckgo.com"]  # Start page
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
}

# Enable adblocking
c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
]

# Content blocking
c.content.canvas_reading = False
c.content.headers.do_not_track = True

# Default: sell your soul
c.content.cookies.accept = "all"
c.content.cookies.store = True

# Alias to add websites to Whitelist
c.aliases["whitelist"] = (
    "set content.cookies.store True;; set content.cookies.accept all"
)
c.aliases["temp-allow"] = (
    "set -p content.cookies.store True;; set -p content.cookies.accept all"
)
c.aliases["unlist"] = (
    "set content.cookies.store False;; set content.cookies.accept never"
)
c.aliases["no3rd"] = (
    "set content.cookies.store True;; set content.cookies.accept no-3rdparty"
)

# External player for YouTube
config.bind("Y", 'spawn mpv "{url}" best')

# External player for Live Streams
# works wonderfully
config.bind("t", 'spawn streamlink --player mpv "{url}" best')


# =========================
# Appearance
# =========================
# Colors (matching your terminal)
bg = "#1e1b18"
surface = "#2a2622"
text = "#e6e1dc"
subtext = "#a8a29e"
amber = "#d97742"
sage = "#9bb39b"

# Status bar
c.statusbar.show = "always"
c.statusbar.padding = {"top": 2, "bottom": 2, "left": 5, "right": 5}
c.colors.statusbar.normal.bg = bg
c.colors.statusbar.normal.fg = text
c.colors.statusbar.insert.bg = sage
c.colors.statusbar.insert.fg = bg
c.colors.statusbar.command.bg = surface
c.colors.statusbar.command.fg = text

# Hints
c.fonts.hints = "10pt Monospace"
c.hints.border = "1px solid #666"
c.hints.padding = {"top": 0, "bottom": 0, "left": 1, "right": 1}

# Tabs
c.tabs.position = "top"
c.tabs.background = True
c.colors.tabs.bar.bg = surface
c.colors.tabs.selected.even.bg = bg
c.colors.tabs.selected.even.fg = text
c.colors.tabs.selected.odd.bg = bg
c.colors.tabs.selected.odd.fg = text

# Completion menu
c.colors.completion.fg = text
# c.colors.completion.bg = surface

c.colors.completion.item.selected.bg = bg
c.colors.completion.item.selected.fg = amber

c.colors.completion.category.fg = sage
c.colors.completion.category.bg = bg
c.colors.completion.category.border.top = bg
c.colors.completion.category.border.bottom = bg

# Dark mode for webpages
c.colors.webpage.preferred_color_scheme = "dark"

# Fonts
c.fonts.default_family = ["Fira Code", "Monospace"]
c.fonts.default_size = "14pt"

# Completion menu
c.completion.height = "25%"
c.fonts.completion.entry = "12pt Fira Code"
c.fonts.completion.category = "13pt Fira Code"
c.fonts.completion.entry = "12pt Fira Code"

# =========================
# Keybindings
# =========================

# =========================
# Downloads
# =========================
c.downloads.location.directory = "~/Downloads"
