#!/usr/bin/env python3
"""
Render pheircebytes.jpg as a grid of 1s and 0s in "Matrix green".

How it works
  1. Flood-fill the white background from the corners so only white that
     touches the edge counts as background (the cream keyboard stays).
  2. Classify every source pixel as OUTLINE (dark ink), KEY (cream keycap)
     or FILL (fur, muzzle, everything else).
  3. Downsample each class to the character grid as a *coverage* value, so
     a cell knows how much outline it contains instead of averaging the
     outline away into the fur.
  4. Light each cell: outline coverage drives brightness up to full Matrix
     green, keycaps sit a little above the fur, fur is a dim base glow.
  5. Each lit cell gets a random 1 or 0 (seeded, so re-runs are identical).

Usage: python3 scripts/make-matrix-bear.py [--cols 128] [--cell 12] [--seed 7]
Writes assets/pheircebytes-matrix.png and assets/pheircebytes-matrix.svg
"""
import argparse, random
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "pheircebytes.jpg"
OUT = ROOT / "assets"
FONT = "/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf"

ap = argparse.ArgumentParser()
ap.add_argument("--cols", type=int, default=128, help="character columns")
ap.add_argument("--cell", type=int, default=12, help="pixel width of one cell in the PNG")
ap.add_argument("--seed", type=int, default=7)
ap.add_argument("--outline-max", type=int, default=64, help="luminance below this is outline ink")
ap.add_argument("--key-min", type=int, default=200, help="luminance above this (inside the bear) is a keycap")
ap.add_argument("--fill", type=float, default=0.14, help="brightness of fur cells, 0-1")
ap.add_argument("--key", type=float, default=0.30, help="brightness of keycap cells, 0-1")
args = ap.parse_args()
random.seed(args.seed)

# ---- 1. background via flood fill ------------------------------------
src = Image.open(SRC).convert("RGB")
MARK = (255, 0, 255)
flood = src.copy()
w, h = flood.size
for corner in [(0, 0), (w - 1, 0), (0, h - 1), (w - 1, h - 1)]:
    ImageDraw.floodfill(flood, corner, MARK, thresh=60)
inside = Image.new("L", (w, h), 0)
inside.putdata([0 if px == MARK else 255 for px in flood.get_flattened_data()])

bbox = inside.getbbox()
src, inside = src.crop(bbox), inside.crop(bbox)
w, h = src.size

# ---- 2. classify pixels ---------------------------------------------
grey = src.convert("L")
outline = grey.point(lambda v: 255 if v < args.outline_max else 0)
key = grey.point(lambda v: 255 if v > args.key_min else 0)
outline = Image.composite(outline, Image.new("L", (w, h), 0), inside)
key = Image.composite(key, Image.new("L", (w, h), 0), inside)

# ---- 3. downsample as coverage ---------------------------------------
CHAR_ASPECT = 0.6   # DejaVu Sans Mono glyph width : height
cols = args.cols
rows = round(h / w * cols * CHAR_ASPECT)
cov = lambda im: im.resize((cols, rows), Image.BOX)
inside_c, outline_c, key_c = cov(inside), cov(outline), cov(key)

# ---- 4. light the cells ----------------------------------------------
def green(t):
    t = max(0.0, min(1.0, t))
    return (int(30 * t), int(40 + 215 * t), int(50 * t))

cells = []
for y in range(rows):
    for x in range(cols):
        if inside_c.getpixel((x, y)) < 128:
            continue
        ink = min(1.0, outline_c.getpixel((x, y)) / 255 * 1.6)   # gain: thin lines still light up
        base = args.key if key_c.getpixel((x, y)) > 128 else args.fill
        t = base + (1.0 - base) * ink
        cells.append((x, y, random.choice("01"), green(t)))

# ---- 5a. PNG ---------------------------------------------------------
cw = args.cell
ch = round(cw / CHAR_ASPECT)
pad = cw * 2
W, H = cols * cw + pad * 2, rows * ch + pad * 2
font = ImageFont.truetype(FONT, int(ch * 0.95))

def draw_text(img):
    d = ImageDraw.Draw(img)
    for x, y, c, col in cells:
        d.text((pad + x * cw + cw / 2, pad + y * ch + ch / 2), c, fill=col, font=font, anchor="mm")

crisp = Image.new("RGB", (W, H), (0, 0, 0))
draw_text(crisp)
glow = crisp.filter(ImageFilter.GaussianBlur(cw * 0.7))
out = Image.blend(glow, crisp, 0.75)
draw_text(out)
png_path = OUT / "pheircebytes-matrix.png"
out.save(png_path)

# ---- 5b. SVG ---------------------------------------------------------
scw, sch = 10, round(10 / CHAR_ASPECT)
spad = scw * 2
sw, sh = cols * scw + spad * 2, rows * sch + spad * 2
lines = [
    f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {sw} {sh}" width="{sw}" height="{sh}">',
    '<defs><filter id="glow" x="-5%" y="-5%" width="110%" height="110%">'
    '<feGaussianBlur stdDeviation="3" result="b"/>'
    '<feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter></defs>',
    f'<rect width="{sw}" height="{sh}" fill="#000"/>',
    f'<g font-family="DejaVu Sans Mono, Menlo, Consolas, monospace" font-weight="bold" '
    f'font-size="{sch * 0.95:.1f}" text-anchor="middle" dominant-baseline="central" filter="url(#glow)">',
]
for x, y, c, (r, g, b) in cells:
    lines.append(f'<text x="{spad + x * scw + scw / 2:.1f}" y="{spad + y * sch + sch / 2:.1f}" '
                 f'fill="#{r:02x}{g:02x}{b:02x}">{c}</text>')
lines.append("</g></svg>")
svg_path = OUT / "pheircebytes-matrix.svg"
svg_path.write_text("\n".join(lines))

print(f"grid {cols}x{rows}, {len(cells)} cells")
print(png_path, out.size)
print(svg_path, f"{svg_path.stat().st_size // 1024} KB")
