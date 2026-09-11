#!/usr/bin/env python3
"""
Square favicon of the Pheirce Bytes bear: the head, clipped to a circle,
on a coarse grid of 1s and 0s in Matrix green.

Two render modes, because a favicon has to work at 16 px as well as 256:
  * glyph mode (256 px and up) - each cell is a green 1 or 0, outlines
    brightest, like the big logo.
  * block mode (128 px and down) - each cell is a solid square. Digits are
    unreadable this small, so the cells flip to silhouette style: fur
    bright, ink marks (eyes, nose, mouth, ear rims) dark. That is what
    stays recognisable as a bear in a browser tab.

Usage: python3 scripts/make-favicon.py
Writes assets/favicon.ico (16-256 px), assets/favicon-512.png, assets/favicon-32.png
"""
import random
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "pheircebytes.jpg"
OUT = ROOT / "assets"
FONT = "/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf"
HEAD_BOX = (80, 0, 720, 640)   # square crop centred on the face in the 814x814 source
SEED = 7

# ---- source classification (same idea as make-matrix-bear.py) --------
src = Image.open(SRC).convert("RGB")
MARK = (255, 0, 255)
flood = src.copy()
w, h = flood.size
for corner in [(0, 0), (w - 1, 0), (0, h - 1), (w - 1, h - 1)]:
    ImageDraw.floodfill(flood, corner, MARK, thresh=60)
inside = Image.new("L", (w, h), 0)
inside.putdata([0 if px == MARK else 255 for px in flood.get_flattened_data()])

src, inside = src.crop(HEAD_BOX), inside.crop(HEAD_BOX)
w, h = src.size
grey = src.convert("L")
blank = Image.new("L", (w, h), 0)
outline = Image.composite(grey.point(lambda v: 255 if v < 64 else 0), blank, inside)
key = Image.composite(grey.point(lambda v: 255 if v > 200 else 0), blank, inside)

def green(t):
    t = max(0.0, min(1.0, t))
    return (int(30 * t), int(40 + 215 * t), int(50 * t))

def grid(n, silhouette):
    """Return [(x, y, digit, colour)] for an n x n grid clipped to a circle."""
    rnd = random.Random(SEED)
    cov = lambda im: im.resize((n, n), Image.BOX)
    inside_c, outline_c, key_c = cov(inside), cov(outline), cov(key)
    cells = []
    for y in range(n):
        for x in range(n):
            dx, dy = (x + 0.5) / n - 0.5, (y + 0.5) / n - 0.5
            if dx * dx + dy * dy > 0.25 or inside_c.getpixel((x, y)) < 128:
                continue
            ink = min(1.0, outline_c.getpixel((x, y)) / 255 * 2.2)
            is_key = key_c.getpixel((x, y)) > 128
            if silhouette:
                base = 0.95 if is_key else 0.75
                t = base - (base - 0.12) * ink
            else:
                base = 0.30 if is_key else 0.14
                t = base + (1 - base) * ink
            cells.append((x, y, rnd.choice("01"), green(t)))
    return cells

def render_glyphs(n, size):
    c = size / n
    font = ImageFont.truetype(FONT, int(c * 1.15))
    cells = grid(n, silhouette=False)
    def draw(img):
        d = ImageDraw.Draw(img)
        for x, y, ch, col in cells:
            d.text((x * c + c / 2, y * c + c / 2), ch, fill=col, font=font, anchor="mm")
    crisp = Image.new("RGB", (size, size), (0, 0, 0))
    draw(crisp)
    img = Image.blend(crisp.filter(ImageFilter.GaussianBlur(c * 0.5)), crisp, 0.7)
    draw(img)
    return img

def render_blocks(n, size):
    img = Image.new("RGB", (n, n), (0, 0, 0))
    for x, y, _, col in grid(n, silhouette=True):
        img.putpixel((x, y), col)
    return img.resize((size, size), Image.LANCZOS if size < n else Image.NEAREST)

master = render_glyphs(24, 512)
master.save(OUT / "favicon-512.png")

icon_sizes = {
    256: master.resize((256, 256), Image.LANCZOS),
    128: render_blocks(32, 128),
    64: render_blocks(32, 64),
    48: render_blocks(24, 48),
    32: render_blocks(32, 32),
    16: render_blocks(16, 16),
}
icon_sizes[32].save(OUT / "favicon-32.png")
# Pillow's ICO writer resizes one image; build the file from our own per-size renders instead.
biggest = icon_sizes[256]
biggest.save(OUT / "favicon.ico", sizes=[(s, s) for s in icon_sizes], append_images=[icon_sizes[s] for s in sorted(icon_sizes) if s != 256])

for f in ["favicon.ico", "favicon-512.png", "favicon-32.png"]:
    print(OUT / f, f"{(OUT / f).stat().st_size // 1024} KB")

# Preview sheet for eyeballing (not committed)
sheet = Image.new("RGB", (512 + 16 + 6 * 136, 512), (40, 40, 40))
sheet.paste(master, (0, 0))
x = 528
for s in (128, 64, 48, 32, 16):
    sheet.paste(icon_sizes[s].resize((128, 128), Image.NEAREST), (x, 0)); x += 136
sheet.save("/tmp/claude-1000/-home-bkirkby-devel-pb-aicoding-minecraft/0a313097-68dd-4b74-9ddb-3e8df9529789/scratchpad/favicon-sheet.png")
