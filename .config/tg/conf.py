import os

def get_pass(key):
    # retrieves key from password store
    return os.popen("pass show {} | head -n 1".format(key)).read().strip()


PHONE = get_pass("telegram-phone")
NOTIFY_CMD = "/usr/bin/notify-send -a Telegram -i {icon_path} {title} {msg}"
CHAT_FLAGS = {
    "online": "●",
    "pinned": " 📌",
    "muted": " 🔇",
    # chat is marked as unread
    "unread": " U",
    # last msg haven't been seen by recipient
    "unseen": " ✓",
    "secret": "🔒",
    "seen": "✓✓",  # leave empty if you don't want to see it
}
MSG_FLAGS = {
    "selected": "*",
    "forwarded": "⇒",
    "new": "🖂",
    "secret": "🔒",
    "edited": "🖊",
    "pending": "🕗",
    "failed": "❌",
    "unseen": " ✓",
    "seen": "✓✓",  # leave empty if you don't want to see it
}
# to make one color for all users
USERS_COLORS = (4,)

# cleanup cache
# Values: N days, None (never)
KEEP_MEDIA = 7
MAILCAP_FILE = os.path.expanduser("~/.config/tg/mailcap")
DOWNLOAD_DIR = os.path.expanduser("~/Downloads/")  # copy file to this dir
