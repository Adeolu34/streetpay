import os
import sys
import math
from PIL import Image, ImageDraw, ImageFont

# Target resolutions for App Store Connect (including Media Manager sizes)
SIZES = {
    '6.9_inch': (1320, 2868),       # iPhone 16 Pro Max / 17 Pro Max (6.9")
    '6.7_inch': (1290, 2796),       # iPhone 15 Pro Max / 14 Pro Max (6.7")
    '6.5_inch': (1242, 2688),       # iPhone 11 Pro Max / XS Max (6.5")
    '6.3_inch': (1206, 2622),       # iPhone 16 Pro / 17 Pro (6.3")
    '6.1_inch': (1179, 2556),       # iPhone 16 / 15 / 15 Pro / 14 Pro (6.1")
    'ipad_13_inch': (2064, 2752),   # iPad Pro 13-inch (M4) / iPad Air 13-inch
    'ipad_12_9_inch': (2048, 2732), # iPad Pro (2nd-6th Gen 12.9")
}

# Brand & Revamped UI Colors (matching Full revamp v36)
COLOR_BG_TOP = (7, 23, 17)          # Marketing outer backdrop #071711
COLOR_BG_BOTTOM = (11, 32, 24)      # #0B2018
COLOR_EMERALD = (86, 184, 75)       # #56B84B
COLOR_MINT = (127, 212, 114)        # #7FD472
COLOR_DARK_HEADER = (11, 32, 24)    # #0B2018
COLOR_CARD_DARK = (18, 54, 42)      # #12362A
COLOR_CARD_BORDER = (34, 81, 58)    # #22513A

# Revamped Light Body Colors (newhome, autodiscover1, manual_payment, billnew)
COLOR_LIGHT_BG = (246, 248, 246)    # #F6F8F6
COLOR_WHITE = (255, 255, 255)
COLOR_LIGHT_BORDER = (214, 234, 216)# #D6EAD8
COLOR_SOFT_GREEN = (237, 247, 238)  # #EDF7EE
COLOR_CHARCOAL = (16, 22, 20)       # #101614
COLOR_GRAY_TEXT = (110, 122, 114)   # #6E7A72
COLOR_GREEN_ICON = (47, 143, 60)    # #2F8F3C

COLOR_TEXT_WHITE = (255, 255, 255)
COLOR_TEXT_MUTED = (143, 179, 160)  # #8FB3A0
COLOR_TEXT_SUB = (165, 195, 180)


def get_font(size, bold=False):
    """Load system font with cross-platform fallbacks."""
    size = max(8, int(size))
    candidates = [
        "C:/Windows/Fonts/segoeuib.ttf" if bold else "C:/Windows/Fonts/segoeui.ttf",
        "C:/Windows/Fonts/arialbd.ttf" if bold else "C:/Windows/Fonts/arial.ttf",
        "/System/Library/Fonts/SFPro-Bold.ttf" if bold else "/System/Library/Fonts/SFPro-Regular.ttf",
        "/System/Library/Fonts/Helvetica.ttc",
        "/Library/Fonts/Arial Bold.ttf" if bold else "/Library/Fonts/Arial.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf" if bold else "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
    ]
    for path in candidates:
        if os.path.exists(path):
            try:
                return ImageFont.truetype(path, size)
            except Exception:
                continue
    return ImageFont.load_default()


def draw_vertical_gradient(draw, width, height, color1, color2):
    for y in range(0, height, 2):
        factor = y / height
        r = int(color1[0] * (1 - factor) + color2[0] * factor)
        g = int(color1[1] * (1 - factor) + color2[1] * factor)
        b = int(color1[2] * (1 - factor) + color2[2] * factor)
        draw.line([(0, y), (width, y)], fill=(r, g, b), width=2)


def draw_glowing_circle(img, center, radius, color, max_alpha=45):
    overlay = Image.new('RGBA', img.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    cx, cy = center
    steps = 20
    for i in range(steps, 0, -1):
        r = int(radius * (i / steps))
        alpha = int(max_alpha * (1 - (i / steps)))
        draw.ellipse([cx - r, cy - r, cx + r, cy + r], fill=(color[0], color[1], color[2], alpha))
    img.paste(Image.alpha_composite(img.convert('RGBA'), overlay).convert('RGB'))


def get_device_geometry(w, h):
    """Return (is_ipad, scale, px, py, pw, ph, corner_radius)."""
    is_ipad = (w / h) > 0.65
    if is_ipad:
        scale = min(w / 2048.0, h / 2732.0)
        pw, ph = int(1620 * scale), int(2140 * scale)
        px, py = (w - pw) // 2, int(440 * scale)
        corner_r = int(52 * scale)
        ui_scale = pw / 1060.0
    else:
        scale = min(w / 1290.0, h / 2796.0)
        pw, ph = int(1060 * scale), int(2260 * scale)
        px, py = (w - pw) // 2, int(410 * scale)
        corner_r = int(60 * scale)
        ui_scale = scale
    return is_ipad, scale, ui_scale, px, py, pw, ph, corner_r


def draw_marketing_header(draw, w, scale, is_ipad, tag_text, title_text, sub_text):
    m_scale = (w / 2048.0) * 1.25 if is_ipad else scale
    font_tag = get_font(int(24 * m_scale), bold=True)
    font_title = get_font(int(62 * m_scale), bold=True)
    font_sub = get_font(int(30 * m_scale), bold=False)

    tag_w = draw.textlength(tag_text, font=font_tag) + int(70 * m_scale)
    tag_y = int(115 * m_scale) if is_ipad else int(130 * scale)
    tag_h = int(54 * m_scale)
    draw.rounded_rectangle(
        [(w - tag_w) // 2, tag_y, (w + tag_w) // 2, tag_y + tag_h],
        radius=tag_h // 2,
        fill=(18, 54, 40),
        outline=COLOR_CARD_BORDER,
        width=2,
    )
    draw.text(((w - draw.textlength(tag_text, font=font_tag)) // 2, tag_y + int(12 * m_scale)), tag_text, font=font_tag, fill=COLOR_MINT)

    title_y = tag_y + tag_h + int(26 * m_scale)
    draw.text(((w - draw.textlength(title_text, font=font_title)) // 2, title_y), title_text, font=font_title, fill=COLOR_TEXT_WHITE)

    sub_y = title_y + int(84 * m_scale)
    draw.text(((w - draw.textlength(sub_text, font=font_sub)) // 2, sub_y), sub_text, font=font_sub, fill=COLOR_TEXT_SUB)


def draw_device_shell(draw, px, py, pw, ph, corner_r, screen_bg=COLOR_LIGHT_BG, is_ipad=False):
    # Outer dark titanium chassis
    draw.rounded_rectangle([px - 14, py - 14, px + pw + 14, py + ph + 14], radius=corner_r + 10, fill=(30, 36, 32), outline=(56, 70, 62), width=3)
    draw.rounded_rectangle([px - 4, py - 4, px + pw + 4, py + ph + 4], radius=corner_r + 2, fill=(10, 12, 11), outline=(22, 28, 24), width=2)
    draw.rounded_rectangle([px, py, px + pw, py + ph], radius=corner_r, fill=screen_bg)


def draw_status_bar(draw, px, py, pw, ui_scale, is_ipad=False, dark_header=True):
    txt_color = COLOR_TEXT_WHITE if dark_header else COLOR_CHARCOAL
    font_time = get_font(int(24 * ui_scale), bold=True)
    draw.text((px + int(48 * ui_scale), py + int(28 * ui_scale)), "9:41", font=font_time, fill=txt_color)

    if not is_ipad:
        island_w, island_h = int(180 * ui_scale), int(44 * ui_scale)
        island_x = px + (pw - island_w) // 2
        draw.rounded_rectangle([island_x, py + int(20 * ui_scale), island_x + island_w, py + int(20 * ui_scale) + island_h], radius=island_h // 2, fill=(0, 0, 0))
        draw.ellipse([island_x + island_w - int(36 * ui_scale), py + int(32 * ui_scale), island_x + island_w - int(18 * ui_scale), py + int(50 * ui_scale)], fill=(14, 18, 26))

    rx = px + pw - int(135 * ui_scale)
    for i in range(4):
        draw.rectangle([rx + i * int(8 * ui_scale), py + int(42 * ui_scale) - (i * int(4 * ui_scale)), rx + i * int(8 * ui_scale) + int(5 * ui_scale), py + int(42 * ui_scale)], fill=txt_color)
    draw.text((rx + int(38 * ui_scale), py + int(28 * ui_scale)), "5G", font=get_font(int(17 * ui_scale), bold=True), fill=txt_color)
    draw.rounded_rectangle([rx + int(75 * ui_scale), py + int(30 * ui_scale), rx + int(112 * ui_scale), py + int(46 * ui_scale)], radius=4, outline=txt_color, width=2)
    draw.rounded_rectangle([rx + int(78 * ui_scale), py + int(33 * ui_scale), rx + int(108 * ui_scale), py + int(43 * ui_scale)], radius=2, fill=txt_color)


def draw_home_indicator(draw, px, py, pw, ph, ui_scale, dark_bg=False):
    bar_w, bar_h = int(240 * ui_scale), int(7 * ui_scale)
    bar_x = px + (pw - bar_w) // 2
    bar_y = py + ph - int(22 * ui_scale)
    color = (220, 230, 224) if dark_bg else (30, 42, 34)
    draw.rounded_rectangle([bar_x, bar_y, bar_x + bar_w, bar_y + bar_h], radius=bar_h // 2, fill=color)


def draw_vector_icon(draw, name, cx, cy, size, color):
    """Draw crisp vector icons using PIL primitives (zero missing-emoji tofu boxes)."""
    s = size * 0.5
    w = max(2, int(size * 0.11))
    if name == 'sound':
        # Speaker cone + 2 waves
        draw.polygon([(cx - s*0.65, cy - s*0.25), (cx - s*0.25, cy - s*0.25), (cx + s*0.15, cy - s*0.6), (cx + s*0.15, cy + s*0.6), (cx - s*0.25, cy + s*0.25), (cx - s*0.65, cy + s*0.25)], fill=color)
        draw.arc([cx - s*0.1, cy - s*0.45, cx + s*0.5, cy + s*0.45], -55, 55, fill=color, width=w)
        draw.arc([cx + s*0.05, cy - s*0.75, cx + s*0.8, cy + s*0.75], -55, 55, fill=color, width=w)
    elif name == 'bell':
        draw.arc([cx - s*0.5, cy - s*0.65, cx + s*0.5, cy + s*0.4], 180, 360, fill=color, width=w)
        draw.rectangle([cx - s*0.5, cy - s*0.15, cx + s*0.5, cy + s*0.35], outline=color, width=w)
        draw.line([(cx - s*0.65, cy + s*0.38), (cx + s*0.65, cy + s*0.38)], fill=color, width=w)
        draw.ellipse([cx - s*0.15, cy + s*0.42, cx + s*0.15, cy + s*0.68], fill=color)
    elif name == 'settings':
        draw.ellipse([cx - s*0.42, cy - s*0.42, cx + s*0.42, cy + s*0.42], outline=color, width=w)
        for ang in range(0, 360, 45):
            rad = math.radians(ang)
            x1, y1 = cx + math.cos(rad) * s * 0.45, cy + math.sin(rad) * s * 0.45
            x2, y2 = cx + math.cos(rad) * s * 0.72, cy + math.sin(rad) * s * 0.72
            draw.line([(x1, y1), (x2, y2)], fill=color, width=w)
    elif name == 'eye':
        draw.arc([cx - s*0.75, cy - s*0.45, cx + s*0.75, cy + s*0.45], 190, 350, fill=color, width=w)
        draw.arc([cx - s*0.75, cy - s*0.45, cx + s*0.75, cy + s*0.45], 10, 170, fill=color, width=w)
        draw.ellipse([cx - s*0.22, cy - s*0.22, cx + s*0.22, cy + s*0.22], fill=color)
    elif name == 'radar':
        draw.arc([cx - s*0.7, cy - s*0.7, cx + s*0.7, cy + s*0.7], 210, 330, fill=color, width=w)
        draw.arc([cx - s*0.45, cy - s*0.45, cx + s*0.45, cy + s*0.45], 210, 330, fill=color, width=w)
        draw.ellipse([cx - s*0.18, cy + s*0.1, cx + s*0.18, cy + s*0.46], fill=color)
    elif name == 'people':
        draw.ellipse([cx - s*0.35, cy - s*0.6, cx + s*0.05, cy - s*0.2], fill=color)
        draw.arc([cx - s*0.6, cy - s*0.1, cx + s*0.3, cy + s*0.7], 180, 360, fill=color, width=w)
        draw.ellipse([cx + s*0.15, cy - s*0.45, cx + s*0.48, cy - s*0.12], outline=color, width=w)
    elif name == 'bank':
        draw.polygon([(cx, cy - s*0.65), (cx - s*0.7, cy - s*0.2), (cx + s*0.7, cy - s*0.2)], fill=color)
        for ox in (-0.42, 0.0, 0.42):
            draw.line([(cx + s*ox, cy - s*0.15), (cx + s*ox, cy + s*0.45)], fill=color, width=w)
        draw.line([(cx - s*0.7, cy + s*0.52), (cx + s*0.7, cy + s*0.52)], fill=color, width=w)
    elif name == 'phone':
        draw.rounded_rectangle([cx - s*0.38, cy - s*0.65, cx + s*0.38, cy + s*0.65], radius=max(2, int(s*0.15)), outline=color, width=w)
        draw.line([(cx - s*0.12, cy + s*0.42), (cx + s*0.12, cy + s*0.42)], fill=color, width=w)
    elif name == 'data':
        for idx, bh in enumerate((0.35, 0.65, 0.95)):
            bx = cx - s*0.5 + idx * s*0.42
            draw.rectangle([bx, cy + s*0.55 - s*1.1*bh, bx + s*0.24, cy + s*0.55], fill=color)
    elif name == 'bolt':
        draw.polygon([(cx + s*0.1, cy - s*0.7), (cx - s*0.45, cy + s*0.05), (cx + s*0.02, cy + s*0.05), (cx - s*0.15, cy + s*0.7), (cx + s*0.45, cy - s*0.08), (cx - s*0.02, cy - s*0.08)], fill=color)
    elif name == 'tv':
        draw.rounded_rectangle([cx - s*0.65, cy - s*0.45, cx + s*0.65, cy + s*0.35], radius=max(2, int(s*0.14)), outline=color, width=w)
        draw.line([(cx - s*0.3, cy + s*0.55), (cx + s*0.3, cy + s*0.55)], fill=color, width=w)
        draw.line([(cx, cy + s*0.35), (cx, cy + s*0.55)], fill=color, width=w)
    elif name == 'globe':
        draw.ellipse([cx - s*0.58, cy - s*0.58, cx + s*0.58, cy + s*0.58], outline=color, width=w)
        draw.ellipse([cx - s*0.26, cy - s*0.58, cx + s*0.26, cy + s*0.58], outline=color, width=max(1, w-1))
        draw.line([(cx - s*0.58, cy), (cx + s*0.58, cy)], fill=color, width=max(1, w-1))
    elif name == 'betting':
        draw.ellipse([cx - s*0.58, cy - s*0.58, cx + s*0.58, cy + s*0.58], outline=color, width=w)
        draw.polygon([(cx, cy - s*0.28), (cx + s*0.26, cy - s*0.08), (cx + s*0.16, cy + s*0.24), (cx - s*0.16, cy + s*0.24), (cx - s*0.26, cy - s*0.08)], fill=color)
    elif name == 'receipt':
        draw.rounded_rectangle([cx - s*0.45, cy - s*0.6, cx + s*0.45, cy + s*0.6], radius=max(2, int(s*0.12)), outline=color, width=w)
        draw.line([(cx - s*0.24, cy - s*0.22), (cx + s*0.24, cy - s*0.22)], fill=color, width=w)
        draw.line([(cx - s*0.24, cy + s*0.05), (cx + s*0.24, cy + s*0.05)], fill=color, width=w)
        draw.line([(cx - s*0.24, cy + s*0.32), (cx + s*0.1, cy + s*0.32)], fill=color, width=w)
    elif name == 'home':
        draw.polygon([(cx, cy - s*0.62), (cx - s*0.65, cy - s*0.05), (cx + s*0.65, cy - s*0.05)], fill=color)
        draw.rectangle([cx - s*0.45, cy - s*0.05, cx + s*0.45, cy + s*0.55], outline=color, width=w)
    elif name == 'clock':
        draw.ellipse([cx - s*0.55, cy - s*0.55, cx + s*0.55, cy + s*0.55], outline=color, width=w)
        draw.line([(cx, cy), (cx, cy - s*0.32)], fill=color, width=w)
        draw.line([(cx, cy), (cx + s*0.28, cy + s*0.12)], fill=color, width=w)
    elif name == 'gift':
        draw.rectangle([cx - s*0.5, cy - s*0.2, cx + s*0.5, cy + s*0.55], outline=color, width=w)
        draw.line([(cx, cy - s*0.2), (cx, cy + s*0.55)], fill=color, width=w)
        draw.line([(cx - s*0.55, cy - s*0.2), (cx + s*0.55, cy - s*0.2)], fill=color, width=w)
        draw.ellipse([cx - s*0.35, cy - s*0.52, cx, cy - s*0.2], outline=color, width=w)
        draw.ellipse([cx, cy - s*0.52, cx + s*0.35, cy - s*0.2], outline=color, width=w)
    elif name == 'arrow_up_right':
        draw.line([(cx - s*0.45, cy + s*0.45), (cx + s*0.45, cy - s*0.45)], fill=color, width=w)
        draw.line([(cx - s*0.1, cy - s*0.45), (cx + s*0.45, cy - s*0.45)], fill=color, width=w)
        draw.line([(cx + s*0.45, cy - s*0.45), (cx + s*0.45, cy + s*0.1)], fill=color, width=w)
    elif name == 'arrow_left':
        draw.line([(cx - s*0.48, cy), (cx + s*0.48, cy)], fill=color, width=w)
        draw.line([(cx - s*0.48, cy), (cx - s*0.05, cy - s*0.4)], fill=color, width=w)
        draw.line([(cx - s*0.48, cy), (cx - s*0.05, cy + s*0.4)], fill=color, width=w)
    elif name == 'check':
        draw.line([(cx - s*0.48, cy + s*0.05), (cx - s*0.12, cy + s*0.42), (cx + s*0.52, cy - s*0.38)], fill=color, width=max(3, w + 1))


def draw_bottom_nav_bar(draw, px, py, pw, ph, ui_scale, active_idx=0):
    nav_h = int(125 * ui_scale)
    nav_y = py + ph - nav_h
    draw.rectangle([px + 2, nav_y, px + pw - 2, py + ph - int(35 * ui_scale)], fill=COLOR_WHITE)
    draw.line([(px + 2, nav_y), (px + pw - 2, nav_y)], fill=(230, 236, 232), width=2)
    items = [("Home", "home"), ("History", "clock"), ("Radar", "radar"), ("Earn", "gift"), ("Settings", "settings")]
    col_w = pw // len(items)
    for idx, (label, icon_name) in enumerate(items):
        cx = px + idx * col_w + col_w // 2
        col = COLOR_GREEN_ICON if idx == active_idx else COLOR_GRAY_TEXT
        draw_vector_icon(draw, icon_name, cx, nav_y + int(34 * ui_scale), int(28 * ui_scale), col)
        f_lb = get_font(int(17 * ui_scale), bold=(idx == active_idx))
        draw.text((cx - draw.textlength(label, font=f_lb) // 2, nav_y + int(60 * ui_scale)), label, font=f_lb, fill=col)


# ============================================================
# SCREEN 1: Revamped Home Wallet (Matches NewhomeWidget v36)
# ============================================================
def render_screen_1(w, h):
    img = Image.new('RGB', (w, h), COLOR_BG_TOP)
    draw = ImageDraw.Draw(img)
    draw_vertical_gradient(draw, w, h, COLOR_BG_TOP, (13, 38, 28))
    draw_glowing_circle(img, (w // 2, int(h * 0.32)), int(w * 0.45), COLOR_EMERALD, max_alpha=40)

    is_ipad, scale, ui, px, py, pw, ph, corner_r = get_device_geometry(w, h)
    draw_marketing_header(
        draw, w, scale, is_ipad,
        "STREETPAY 9PSB · REVAMPED WALLET",
        "Your Everyday Digital Wallet",
        "Instant transfers, live balance control & StreetBox voice alerts",
    )

    draw_device_shell(draw, px, py, pw, ph, corner_r, screen_bg=COLOR_LIGHT_BG, is_ipad=is_ipad)

    # Top curved #0B2018 forest green header (behind user bar + top half of balance card)
    hdr_h = int(470 * ui)
    draw.rounded_rectangle([px, py, px + pw, py + hdr_h], radius=corner_r, fill=COLOR_DARK_HEADER)
    draw.rectangle([px, py + corner_r, px + pw, py + hdr_h - int(44 * ui)], fill=COLOR_DARK_HEADER)
    draw.rounded_rectangle([px, py + hdr_h - int(88 * ui), px + pw, py + hdr_h], radius=int(44 * ui), fill=COLOR_DARK_HEADER)

    draw_status_bar(draw, px, py, pw, ui, is_ipad=is_ipad, dark_header=True)

    # User Bar
    pad_x = int(42 * ui)
    cx = px + pad_x
    cw = pw - pad_x * 2
    uy = py + int(102 * ui)

    av_s = int(72 * ui)
    draw.ellipse([cx, uy, cx + av_s, uy + av_s], fill=(29, 67, 49))
    draw.text((cx + int(19 * ui), uy + int(19 * ui)), "AO", font=get_font(int(24 * ui), bold=True), fill=COLOR_MINT)
    draw.text((cx + av_s + int(20 * ui), uy + int(6 * ui)), "Akinwole Oluleye", font=get_font(int(26 * ui), bold=True), fill=COLOR_WHITE)
    draw.text((cx + av_s + int(20 * ui), uy + int(42 * ui)), "9PSB StreetPay · Tier 3", font=get_font(int(20 * ui), bold=False), fill=(137, 163, 148))

    # Top-right circular icons (Soundbox, Bell, Settings)
    ic_s = int(60 * ui)
    for idx, (ic_name, active) in enumerate([("sound", True), ("bell", False), ("settings", False)]):
        ix = cx + cw - (3 - idx) * (ic_s + int(12 * ui))
        fill_c = (32, 74, 52) if active else (21, 47, 35)
        out_c = COLOR_EMERALD if active else (30, 62, 46)
        draw.ellipse([ix, uy + int(6 * ui), ix + ic_s, uy + int(6 * ui) + ic_s], fill=fill_c, outline=out_c, width=2)
        draw_vector_icon(draw, ic_name, ix + ic_s // 2, uy + int(6 * ui) + ic_s // 2, int(26 * ui), COLOR_MINT if active else (207, 227, 214))

    # Floating Wallet Balance Card (#12362A)
    card_y = uy + int(102 * ui)
    card_h = int(430 * ui)
    draw.rounded_rectangle([cx, card_y, cx + cw, card_y + card_h], radius=int(38 * ui), fill=COLOR_CARD_DARK, outline=COLOR_CARD_BORDER, width=2)

    draw.text((cx + int(36 * ui), card_y + int(32 * ui)), "AVAILABLE BALANCE", font=get_font(int(19 * ui), bold=True), fill=COLOR_TEXT_MUTED)
    draw_vector_icon(draw, "eye", cx + cw - int(54 * ui), card_y + int(42 * ui), int(30 * ui), COLOR_TEXT_MUTED)
    draw.text((cx + int(36 * ui), card_y + int(76 * ui)), "₦142,850.00", font=get_font(int(58 * ui), bold=True), fill=COLOR_WHITE)

    # Account number + Copy pill
    acc_y = card_y + int(182 * ui)
    draw.text((cx + int(36 * ui), acc_y), "StreetPay · 9PSB", font=get_font(int(20 * ui), bold=False), fill=COLOR_TEXT_MUTED)
    draw.text((cx + int(215 * ui), acc_y), "1023456789", font=get_font(int(20 * ui), bold=True), fill=(207, 227, 214))
    draw.rounded_rectangle([cx + int(360 * ui), acc_y - int(4 * ui), cx + int(445 * ui), acc_y + int(32 * ui)], radius=int(10 * ui), fill=(26, 74, 52))
    draw.text((cx + int(378 * ui), acc_y + int(1 * ui)), "Copy", font=get_font(int(17 * ui), bold=True), fill=COLOR_MINT)

    # Action Buttons (+ Add money & Transfer)
    btn_y = card_y + int(272 * ui)
    btn_h = int(84 * ui)
    btn_w = (cw - int(92 * ui)) // 2
    draw.rounded_rectangle([cx + int(36 * ui), btn_y, cx + int(36 * ui) + btn_w, btn_y + btn_h], radius=int(22 * ui), fill=COLOR_EMERALD)
    t1 = "+ Add money"
    f_b = get_font(int(24 * ui), bold=True)
    draw.text((cx + int(36 * ui) + (btn_w - draw.textlength(t1, font=f_b)) // 2, btn_y + int(25 * ui)), t1, font=f_b, fill=(6, 33, 15))

    b2x = cx + int(56 * ui) + btn_w
    draw.rounded_rectangle([b2x, btn_y, b2x + btn_w, btn_y + btn_h], radius=int(22 * ui), fill=(18, 54, 42), outline=(44, 96, 69), width=2)
    t2 = "Transfer"
    draw_vector_icon(draw, "arrow_up_right", b2x + btn_w // 2 - int(65 * ui), btn_y + btn_h // 2, int(22 * ui), (207, 227, 214))
    draw.text((b2x + btn_w // 2 - int(36 * ui), btn_y + int(25 * ui)), t2, font=f_b, fill=(207, 227, 214))

    # 3. Discover Nearby Devices White Card (on #F6F8F6 light background!)
    disc_y = card_y + card_h + int(28 * ui)
    disc_h = int(128 * ui)
    draw.rounded_rectangle([cx, disc_y, cx + cw, disc_y + disc_h], radius=int(32 * ui), fill=COLOR_WHITE, outline=COLOR_LIGHT_BORDER, width=2)
    draw.rounded_rectangle([cx + int(24 * ui), disc_y + int(22 * ui), cx + int(108 * ui), disc_y + int(106 * ui)], radius=int(24 * ui), fill=COLOR_SOFT_GREEN)
    draw_vector_icon(draw, "radar", cx + int(66 * ui), disc_y + int(64 * ui), int(40 * ui), COLOR_GREEN_ICON)
    draw.text((cx + int(130 * ui), disc_y + int(28 * ui)), "Discover nearby devices", font=get_font(int(25 * ui), bold=True), fill=COLOR_CHARCOAL)
    draw.text((cx + int(130 * ui), disc_y + int(68 * ui)), "Find vendors & people around you to pay", font=get_font(int(20 * ui)), fill=COLOR_GRAY_TEXT)
    draw.text((cx + cw - int(46 * ui), disc_y + int(44 * ui)), "›", font=get_font(int(38 * ui), bold=True), fill=COLOR_GREEN_ICON)

    # 4. Quick Services 2x4 Grid (Matches newhome_widget.dart)
    grid_y = disc_y + disc_h + int(34 * ui)
    draw.text((cx, grid_y), "Quick services", font=get_font(int(26 * ui), bold=True), fill=COLOR_CHARCOAL)

    row1 = [("To StreetPay", "people", (47, 143, 60)), ("To Bank", "bank", (61, 95, 160)), ("Airtime", "phone", (37, 87, 181)), ("Data", "data", (2, 132, 199))]
    row2 = [("Electricity", "bolt", (217, 119, 6)), ("Cable TV", "tv", (124, 58, 237)), ("Internet", "globe", (13, 148, 136)), ("Betting", "betting", (234, 88, 12))]

    col_w = (cw - int(48 * ui)) // 4
    item_h = int(146 * ui)
    for r_idx, row in enumerate([row1, row2]):
        ry = grid_y + int(46 * ui) + r_idx * (item_h + int(18 * ui))
        for c_idx, (lbl, ic_name, ic_col) in enumerate(row):
            ix = cx + c_idx * (col_w + int(16 * ui))
            draw.rounded_rectangle([ix, ry, ix + col_w, ry + item_h], radius=int(26 * ui), fill=COLOR_WHITE, outline=(228, 236, 230), width=2)
            # Soft icon circle
            ic_r = int(34 * ui)
            ic_cx = ix + col_w // 2
            ic_cy = ry + int(50 * ui)
            draw.ellipse([ic_cx - ic_r, ic_cy - ic_r, ic_cx + ic_r, ic_cy + ic_r], fill=(237, 247, 238))
            draw_vector_icon(draw, ic_name, ic_cx, ic_cy, int(34 * ui), ic_col)
            f_lb = get_font(int(18 * ui), bold=True)
            draw.text((ic_cx - draw.textlength(lbl, font=f_lb) // 2, ry + int(100 * ui)), lbl, font=f_lb, fill=COLOR_CHARCOAL)

    # 5. Bill Requests Dark Card
    bill_y = grid_y + int(46 * ui) + 2 * (item_h + int(18 * ui)) + int(16 * ui)
    bill_h = int(136 * ui)
    if bill_y + bill_h < py + ph - int(145 * ui):
        draw.rounded_rectangle([cx, bill_y, cx + cw, bill_y + bill_h], radius=int(32 * ui), fill=COLOR_DARK_HEADER)
        draw.rounded_rectangle([cx + int(24 * ui), bill_y + int(26 * ui), cx + int(98 * ui), bill_y + int(100 * ui)], radius=int(22 * ui), fill=(29, 67, 49))
        draw_vector_icon(draw, "receipt", cx + int(61 * ui), bill_y + int(63 * ui), int(34 * ui), COLOR_MINT)
        draw.text((cx + int(120 * ui), bill_y + int(26 * ui)), "Bill requests", font=get_font(int(24 * ui), bold=True), fill=COLOR_WHITE)
        draw.rounded_rectangle([cx + int(285 * ui), bill_y + int(24 * ui), cx + int(375 * ui), bill_y + int(58 * ui)], radius=int(17 * ui), fill=COLOR_EMERALD)
        draw.text((cx + int(300 * ui), bill_y + int(29 * ui)), "2 new", font=get_font(int(18 * ui), bold=True), fill=(6, 33, 15))
        draw.text((cx + int(120 * ui), bill_y + int(68 * ui)), "Ask someone to pay a bill or settle one sent to you", font=get_font(int(18 * ui)), fill=(143, 165, 150))

    draw_bottom_nav_bar(draw, px, py, pw, ph, ui, active_idx=0)
    draw_home_indicator(draw, px, py, pw, ph, ui, dark_bg=False)
    return img


# ============================================================
# SCREEN 2: Send Money / Instant Bank Transfer (ManualPaymentWidget)
# ============================================================
def render_screen_2(w, h):
    img = Image.new('RGB', (w, h), COLOR_BG_TOP)
    draw = ImageDraw.Draw(img)
    draw_vertical_gradient(draw, w, h, COLOR_BG_TOP, (14, 40, 30))
    draw_glowing_circle(img, (w // 2, int(h * 0.32)), int(w * 0.45), COLOR_EMERALD, max_alpha=40)

    is_ipad, scale, ui, px, py, pw, ph, corner_r = get_device_geometry(w, h)
    draw_marketing_header(
        draw, w, scale, is_ipad,
        "INSTANT TRANSFERS · ALL NIGERIAN BANKS",
        "Send Money in Seconds",
        "Live beneficiary verification & instant transaction receipts",
    )

    draw_device_shell(draw, px, py, pw, ph, corner_r, screen_bg=COLOR_LIGHT_BG, is_ipad=is_ipad)
    # White App Bar
    appbar_h = int(165 * ui)
    draw.rounded_rectangle([px, py, px + pw, py + appbar_h], radius=corner_r, fill=COLOR_WHITE)
    draw.rectangle([px, py + corner_r, px + pw, py + appbar_h], fill=COLOR_WHITE)
    draw.line([(px + 2, py + appbar_h), (px + pw - 2, py + appbar_h)], fill=(230, 234, 231), width=2)
    draw_status_bar(draw, px, py, pw, ui, is_ipad=is_ipad, dark_header=False)

    pad_x = int(42 * ui)
    cx = px + pad_x
    cw = pw - pad_x * 2
    by = py + int(92 * ui)
    draw.ellipse([cx, by, cx + int(58 * ui), by + int(58 * ui)], fill=(243, 246, 243), outline=(230, 234, 231), width=2)
    draw_vector_icon(draw, "arrow_left", cx + int(29 * ui), by + int(29 * ui), int(24 * ui), COLOR_CHARCOAL)
    draw.text((cx + int(78 * ui), by + int(12 * ui)), "Transfer to Bank", font=get_font(int(28 * ui), bold=True), fill=COLOR_CHARCOAL)

    # Available Balance Strip
    bal_y = py + appbar_h + int(28 * ui)
    draw.rounded_rectangle([cx, bal_y, cx + cw, bal_y + int(96 * ui)], radius=int(24 * ui), fill=COLOR_DARK_HEADER)
    draw.text((cx + int(28 * ui), bal_y + int(16 * ui)), "AVAILABLE BALANCE", font=get_font(int(16 * ui), bold=True), fill=COLOR_TEXT_MUTED)
    draw.text((cx + int(28 * ui), bal_y + int(42 * ui)), "₦142,850.00", font=get_font(int(30 * ui), bold=True), fill=COLOR_WHITE)

    # Recipient Card (White)
    rec_y = bal_y + int(120 * ui)
    draw.rounded_rectangle([cx, rec_y, cx + cw, rec_y + int(310 * ui)], radius=int(28 * ui), fill=COLOR_WHITE, outline=COLOR_LIGHT_BORDER, width=2)
    draw.text((cx + int(30 * ui), rec_y + int(26 * ui)), "RECIPIENT BANK", font=get_font(int(17 * ui), bold=True), fill=COLOR_GRAY_TEXT)
    draw.rounded_rectangle([cx + int(30 * ui), rec_y + int(58 * ui), cx + cw - int(30 * ui), rec_y + int(126 * ui)], radius=int(16 * ui), fill=COLOR_LIGHT_BG, outline=(225, 232, 228), width=2)
    draw.text((cx + int(50 * ui), rec_y + int(76 * ui)), "Access Bank", font=get_font(int(24 * ui), bold=True), fill=COLOR_CHARCOAL)

    draw.text((cx + int(30 * ui), rec_y + int(150 * ui)), "ACCOUNT NUMBER", font=get_font(int(17 * ui), bold=True), fill=COLOR_GRAY_TEXT)
    draw.rounded_rectangle([cx + int(30 * ui), rec_y + int(182 * ui), cx + cw - int(30 * ui), rec_y + int(250 * ui)], radius=int(16 * ui), fill=COLOR_LIGHT_BG, outline=(225, 232, 228), width=2)
    draw.text((cx + int(50 * ui), rec_y + int(198 * ui)), "0123456789", font=get_font(int(26 * ui), bold=True), fill=COLOR_CHARCOAL)

    # Verified Name Pill
    ver_y = rec_y + int(330 * ui)
    draw.rounded_rectangle([cx, ver_y, cx + cw, ver_y + int(78 * ui)], radius=int(20 * ui), fill=COLOR_SOFT_GREEN, outline=COLOR_EMERALD, width=2)
    draw_vector_icon(draw, "check", cx + int(42 * ui), ver_y + int(39 * ui), int(22 * ui), COLOR_GREEN_ICON)
    draw.text((cx + int(68 * ui), ver_y + int(22 * ui)), "Verified: ADEOLU JOHN O.", font=get_font(int(22 * ui), bold=True), fill=COLOR_GREEN_ICON)

    # Amount Card (White)
    amt_y = ver_y + int(102 * ui)
    draw.rounded_rectangle([cx, amt_y, cx + cw, amt_y + int(210 * ui)], radius=int(28 * ui), fill=COLOR_WHITE, outline=COLOR_LIGHT_BORDER, width=2)
    draw.text((cx + int(30 * ui), amt_y + int(26 * ui)), "AMOUNT", font=get_font(int(17 * ui), bold=True), fill=COLOR_GRAY_TEXT)
    draw.text((cx + int(30 * ui), amt_y + int(68 * ui)), "₦25,000.00", font=get_font(int(56 * ui), bold=True), fill=COLOR_CHARCOAL)
    draw.text((cx + int(30 * ui), amt_y + int(152 * ui)), "Zero hidden fees · Instant settlement", font=get_font(int(19 * ui), bold=True), fill=COLOR_GREEN_ICON)

    # Transfer Success Preview Card
    suc_y = amt_y + int(236 * ui)
    suc_h = int(490 * ui)
    draw.rounded_rectangle([cx, suc_y, cx + cw, suc_y + suc_h], radius=int(32 * ui), fill=COLOR_DARK_HEADER, outline=COLOR_EMERALD, width=3)
    draw.ellipse([cx + (cw - int(84 * ui)) // 2, suc_y + int(32 * ui), cx + (cw + int(84 * ui)) // 2, suc_y + int(116 * ui)], fill=COLOR_EMERALD)
    draw_vector_icon(draw, "check", cx + cw // 2, suc_y + int(74 * ui), int(44 * ui), (6, 33, 15))
    f_ok = get_font(int(30 * ui), bold=True)
    ok_txt = "Transfer Successful!"
    draw.text((cx + (cw - draw.textlength(ok_txt, font=f_ok)) // 2, suc_y + int(134 * ui)), ok_txt, font=f_ok, fill=COLOR_WHITE)
    f_amt = get_font(int(48 * ui), bold=True)
    amt_txt = "₦25,000.00"
    draw.text((cx + (cw - draw.textlength(amt_txt, font=f_amt)) // 2, suc_y + int(184 * ui)), amt_txt, font=f_amt, fill=COLOR_MINT)

    for idx, (k, v) in enumerate([("Recipient", "ADEOLU JOHN O."), ("Bank", "Access Bank · 0123456789"), ("Reference", "SP-TXN-9PSB-88412")]):
        ry = suc_y + int(268 * ui) + idx * int(44 * ui)
        draw.text((cx + int(34 * ui), ry), k, font=get_font(int(18 * ui)), fill=COLOR_TEXT_MUTED)
        f_v = get_font(int(18 * ui), bold=True)
        draw.text((cx + cw - int(34 * ui) - draw.textlength(v, font=f_v), ry), v, font=f_v, fill=COLOR_WHITE)

    draw.rounded_rectangle([cx + int(34 * ui), suc_y + int(406 * ui), cx + cw - int(34 * ui), suc_y + int(468 * ui)], radius=int(20 * ui), fill=COLOR_EMERALD)
    sh_txt = "Share Receipt"
    f_sh = get_font(int(22 * ui), bold=True)
    draw.text((cx + (cw - draw.textlength(sh_txt, font=f_sh)) // 2, suc_y + int(423 * ui)), sh_txt, font=f_sh, fill=(6, 33, 15))

    draw_home_indicator(draw, px, py, pw, ph, ui, dark_bg=False)
    return img


# ============================================================
# SCREEN 3: StreetBox Voice Alerts (Revamped Home + Soundbox)
# ============================================================
def render_screen_3(w, h):
    img = Image.new('RGB', (w, h), COLOR_BG_TOP)
    draw = ImageDraw.Draw(img)
    draw_vertical_gradient(draw, w, h, COLOR_BG_TOP, (12, 36, 26))
    draw_glowing_circle(img, (w // 2, int(h * 0.35)), int(w * 0.45), COLOR_EMERALD, max_alpha=50)

    is_ipad, scale, ui, px, py, pw, ph, corner_r = get_device_geometry(w, h)
    draw_marketing_header(
        draw, w, scale, is_ipad,
        "STREETBOX™ · VOICE PAYMENT ALERTS",
        "Hear Every Payment Out Loud",
        "Hands-free spoken credit alerts for merchants & everyday users",
    )

    draw_device_shell(draw, px, py, pw, ph, corner_r, screen_bg=COLOR_LIGHT_BG, is_ipad=is_ipad)
    hdr_h = int(420 * ui)
    draw.rounded_rectangle([px, py, px + pw, py + hdr_h], radius=corner_r, fill=COLOR_DARK_HEADER)
    draw.rectangle([px, py + corner_r, px + pw, py + hdr_h - int(44 * ui)], fill=COLOR_DARK_HEADER)
    draw.rounded_rectangle([px, py + hdr_h - int(88 * ui), px + pw, py + hdr_h], radius=int(44 * ui), fill=COLOR_DARK_HEADER)
    draw_status_bar(draw, px, py, pw, ui, is_ipad=is_ipad, dark_header=True)

    pad_x = int(42 * ui)
    cx = px + pad_x
    cw = pw - pad_x * 2

    # Header row
    uy = py + int(102 * ui)
    draw.text((cx, uy), "StreetBox Soundbox", font=get_font(int(30 * ui), bold=True), fill=COLOR_WHITE)
    draw.text((cx, uy + int(42 * ui)), "Real-time audio confirmation active", font=get_font(int(20 * ui)), fill=COLOR_MINT)

    # Active Voice Alert Card
    sb_y = uy + int(108 * ui)
    sb_h = int(430 * ui)
    draw.rounded_rectangle([cx, sb_y, cx + cw, sb_y + sb_h], radius=int(36 * ui), fill=COLOR_CARD_DARK, outline=COLOR_EMERALD, width=3)

    # Pulsing Speaker Rings
    scx = cx + cw // 2
    scy = sb_y + int(145 * ui)
    for r, col in [(int(110 * ui), (30, 82, 56)), (int(82 * ui), (44, 114, 72))]:
        draw.ellipse([scx - r, scy - r, scx + r, scy + r], outline=col, width=3)
    r_in = int(56 * ui)
    draw.ellipse([scx - r_in, scy - r_in, scx + r_in, scy + r_in], fill=COLOR_EMERALD)
    draw_vector_icon(draw, "sound", scx, scy, int(48 * ui), (6, 33, 15))

    f_st = get_font(int(28 * ui), bold=True)
    st_t = "StreetBox Audio Active"
    draw.text((scx - draw.textlength(st_t, font=f_st) // 2, sb_y + int(270 * ui)), st_t, font=f_st, fill=COLOR_WHITE)

    # Spoken transcript pill
    draw.rounded_rectangle([cx + int(32 * ui), sb_y + int(325 * ui), cx + cw - int(32 * ui), sb_y + int(400 * ui)], radius=int(20 * ui), fill=(11, 32, 24), outline=COLOR_CARD_BORDER, width=2)
    q_txt = '“Received ₦25,000.00 from Chidi Okafor”'
    f_q = get_font(int(21 * ui), bold=True)
    draw.text((scx - draw.textlength(q_txt, font=f_q) // 2, sb_y + int(350 * ui)), q_txt, font=f_q, fill=COLOR_MINT)

    # Light body: Live Announced Credits List
    lst_y = sb_y + sb_h + int(36 * ui)
    draw.text((cx, lst_y), "Recent spoken alerts", font=get_font(int(26 * ui), bold=True), fill=COLOR_CHARCOAL)

    alerts = [
        ("Chidi Okafor", "Transfer In · Announced 10:14 AM", "+₦25,000.00"),
        ("Adaeze Nwosu", "StreetPay Tag · Announced 09:42 AM", "+₦8,500.00"),
        ("Bello Musa", "Nearby Pay · Announced 08:19 AM", "+₦12,000.00"),
    ]
    for i, (name, sub, amt) in enumerate(alerts):
        ay = lst_y + int(48 * ui) + i * int(146 * ui)
        draw.rounded_rectangle([cx, ay, cx + cw, ay + int(126 * ui)], radius=int(26 * ui), fill=COLOR_WHITE, outline=COLOR_LIGHT_BORDER, width=2)
        draw.ellipse([cx + int(24 * ui), ay + int(28 * ui), cx + int(94 * ui), ay + int(98 * ui)], fill=COLOR_SOFT_GREEN)
        draw_vector_icon(draw, "sound", cx + int(59 * ui), ay + int(63 * ui), int(28 * ui), COLOR_GREEN_ICON)
        draw.text((cx + int(116 * ui), ay + int(28 * ui)), name, font=get_font(int(24 * ui), bold=True), fill=COLOR_CHARCOAL)
        draw.text((cx + int(116 * ui), ay + int(66 * ui)), sub, font=get_font(int(18 * ui)), fill=COLOR_GRAY_TEXT)
        f_a = get_font(int(24 * ui), bold=True)
        draw.text((cx + cw - int(28 * ui) - draw.textlength(amt, font=f_a), ay + int(46 * ui)), amt, font=f_a, fill=COLOR_GREEN_ICON)

    draw_bottom_nav_bar(draw, px, py, pw, ph, ui, active_idx=0)
    draw_home_indicator(draw, px, py, pw, ph, ui, dark_bg=False)
    return img


# ============================================================
# SCREEN 4: Nearby Discovery (Matches Autodiscover1Widget v36)
# ============================================================
def render_screen_4(w, h):
    img = Image.new('RGB', (w, h), COLOR_BG_TOP)
    draw = ImageDraw.Draw(img)
    draw_vertical_gradient(draw, w, h, COLOR_BG_TOP, (12, 36, 26))
    draw_glowing_circle(img, (w // 2, int(h * 0.35)), int(w * 0.45), COLOR_EMERALD, max_alpha=45)

    is_ipad, scale, ui, px, py, pw, ph, corner_r = get_device_geometry(w, h)
    draw_marketing_header(
        draw, w, scale, is_ipad,
        "NEARBY DISCOVERY · SMART RADAR",
        "Pay Vendors & People Around You",
        "Discover nearby StreetPay users without typing account numbers",
    )

    draw_device_shell(draw, px, py, pw, ph, corner_r, screen_bg=COLOR_LIGHT_BG, is_ipad=is_ipad)

    # Top curved #0B2018 header (Autodiscover1Widget)
    hdr_h = int(600 * ui)
    draw.rounded_rectangle([px, py, px + pw, py + hdr_h], radius=corner_r, fill=COLOR_DARK_HEADER)
    draw.rectangle([px, py + corner_r, px + pw, py + hdr_h - int(44 * ui)], fill=COLOR_DARK_HEADER)
    draw.rounded_rectangle([px, py + hdr_h - int(88 * ui), px + pw, py + hdr_h], radius=int(44 * ui), fill=COLOR_DARK_HEADER)
    draw_status_bar(draw, px, py, pw, ui, is_ipad=is_ipad, dark_header=True)

    pad_x = int(42 * ui)
    cx = px + pad_x
    cw = pw - pad_x * 2

    # Nav row
    ny = py + int(96 * ui)
    draw.ellipse([cx, ny, cx + int(58 * ui), ny + int(58 * ui)], fill=(21, 47, 35))
    draw_vector_icon(draw, "arrow_left", cx + int(29 * ui), ny + int(29 * ui), int(24 * ui), (207, 227, 214))
    draw.text((cx + int(78 * ui), ny + int(12 * ui)), "Nearby Discovery", font=get_font(int(28 * ui), bold=True), fill=COLOR_WHITE)

    # Radar visualization inside dark green header
    rcx = px + pw // 2
    rcy = py + int(365 * ui)
    for r, col in [(int(175 * ui), (26, 68, 48)), (int(120 * ui), (40, 102, 68)), (int(66 * ui), (62, 148, 92))]:
        draw.ellipse([rcx - r, rcy - r, rcx + r, rcy + r], outline=col, width=3)
    draw.ellipse([rcx - int(34 * ui), rcy - int(34 * ui), rcx + int(34 * ui), rcy + int(34 * ui)], fill=COLOR_EMERALD)
    draw_vector_icon(draw, "radar", rcx, rcy, int(30 * ui), (6, 33, 15))

    # Nearby dots
    draw.ellipse([rcx - int(115 * ui), rcy - int(75 * ui), rcx - int(85 * ui), rcy - int(45 * ui)], fill=COLOR_MINT)
    draw.ellipse([rcx + int(75 * ui), rcy + int(45 * ui), rcx + int(105 * ui), rcy + int(75 * ui)], fill=COLOR_MINT)

    # Light body: Discovered Devices list
    ly = py + hdr_h + int(36 * ui)
    draw.text((cx, ly), "3 devices found nearby", font=get_font(int(25 * ui), bold=True), fill=COLOR_CHARCOAL)

    peers = [
        ("Mama T's Provisions", "Verified Merchant · 8m away", "MT"),
        ("Tunde Electronics", "Gadget Store · 15m away", "TE"),
        ("Chika's Kitchen", "Food & Drinks · 22m away", "CK"),
    ]
    for i, (name, dist, init) in enumerate(peers):
        dy = ly + int(48 * ui) + i * int(154 * ui)
        draw.rounded_rectangle([cx, dy, cx + cw, dy + int(134 * ui)], radius=int(28 * ui), fill=COLOR_WHITE, outline=COLOR_LIGHT_BORDER, width=2)
        draw.ellipse([cx + int(24 * ui), dy + int(30 * ui), cx + int(98 * ui), dy + int(104 * ui)], fill=COLOR_SOFT_GREEN, outline=COLOR_EMERALD, width=2)
        draw.text((cx + int(44 * ui), dy + int(50 * ui)), init, font=get_font(int(24 * ui), bold=True), fill=COLOR_GREEN_ICON)
        draw.text((cx + int(118 * ui), dy + int(32 * ui)), name, font=get_font(int(24 * ui), bold=True), fill=COLOR_CHARCOAL)
        draw.text((cx + int(118 * ui), dy + int(70 * ui)), dist, font=get_font(int(19 * ui)), fill=COLOR_GRAY_TEXT)

        # Green Pay Pill
        draw.rounded_rectangle([cx + cw - int(135 * ui), dy + int(40 * ui), cx + cw - int(24 * ui), dy + int(94 * ui)], radius=int(18 * ui), fill=COLOR_EMERALD)
        draw.text((cx + cw - int(104 * ui), dy + int(52 * ui)), "Pay", font=get_font(int(22 * ui), bold=True), fill=(6, 33, 15))

    draw_bottom_nav_bar(draw, px, py, pw, ph, ui, active_idx=2)
    draw_home_indicator(draw, px, py, pw, ph, ui, dark_bg=False)
    return img


# ============================================================
# SCREEN 5: Bills, Airtime & Bill Requests (BillnewWidget v36)
# ============================================================
def render_screen_5(w, h):
    img = Image.new('RGB', (w, h), COLOR_BG_TOP)
    draw = ImageDraw.Draw(img)
    draw_vertical_gradient(draw, w, h, COLOR_BG_TOP, (12, 36, 26))
    draw_glowing_circle(img, (w // 2, int(h * 0.35)), int(w * 0.45), COLOR_EMERALD, max_alpha=40)

    is_ipad, scale, ui, px, py, pw, ph, corner_r = get_device_geometry(w, h)
    draw_marketing_header(
        draw, w, scale, is_ipad,
        "UTILITY BILLS · AIRTIME · DATA",
        "Pay Bills & Top Up Effortlessly",
        "Zero surcharge on Electricity, Cable TV, Airtime & Data bundles",
    )

    draw_device_shell(draw, px, py, pw, ph, corner_r, screen_bg=COLOR_LIGHT_BG, is_ipad=is_ipad)
    appbar_h = int(165 * ui)
    draw.rounded_rectangle([px, py, px + pw, py + appbar_h], radius=corner_r, fill=COLOR_WHITE)
    draw.rectangle([px, py + corner_r, px + pw, py + appbar_h], fill=COLOR_WHITE)
    draw.line([(px + 2, py + appbar_h), (px + pw - 2, py + appbar_h)], fill=(230, 234, 231), width=2)
    draw_status_bar(draw, px, py, pw, ui, is_ipad=is_ipad, dark_header=False)

    pad_x = int(42 * ui)
    cx = px + pad_x
    cw = pw - pad_x * 2
    by = py + int(92 * ui)
    draw.ellipse([cx, by, cx + int(58 * ui), by + int(58 * ui)], fill=(243, 246, 243), outline=(230, 234, 231), width=2)
    draw_vector_icon(draw, "arrow_left", cx + int(29 * ui), by + int(29 * ui), int(24 * ui), COLOR_CHARCOAL)
    draw.text((cx + int(78 * ui), by + int(12 * ui)), "Bills & Services", font=get_font(int(28 * ui), bold=True), fill=COLOR_CHARCOAL)

    # Top Network Picker Card
    net_y = py + appbar_h + int(30 * ui)
    draw.rounded_rectangle([cx, net_y, cx + cw, net_y + int(220 * ui)], radius=int(28 * ui), fill=COLOR_WHITE, outline=COLOR_LIGHT_BORDER, width=2)
    draw.text((cx + int(30 * ui), net_y + int(24 * ui)), "SELECT NETWORK FOR AIRTIME & DATA", font=get_font(int(17 * ui), bold=True), fill=COLOR_GRAY_TEXT)

    nets = [("MTN", (255, 204, 0), (16, 22, 20)), ("Airtel", (235, 87, 87), COLOR_WHITE), ("Glo", (86, 184, 75), (6, 33, 15)), ("9mobile", (15, 78, 52), COLOR_WHITE)]
    nw = (cw - int(96 * ui)) // 4
    for i, (n_name, bg, fg) in enumerate(nets):
        nx = cx + int(24 * ui) + i * (nw + int(16 * ui))
        ny = net_y + int(68 * ui)
        draw.rounded_rectangle([nx, ny, nx + nw, ny + int(120 * ui)], radius=int(22 * ui), fill=bg)
        f_n = get_font(int(22 * ui), bold=True)
        draw.text((nx + (nw - draw.textlength(n_name, font=f_n)) // 2, ny + int(44 * ui)), n_name, font=f_n, fill=fg)

    # Utility Categories
    uy = net_y + int(252 * ui)
    draw.text((cx, uy), "All utility categories", font=get_font(int(25 * ui), bold=True), fill=COLOR_CHARCOAL)

    utils = [
        ("bolt", "Electricity Token", "IKEDC, EKEDC, AEDC, IBEDC", "Instant token", (217, 119, 6)),
        ("tv", "Cable TV", "DStv, GOtv, StarTimes", "Zero fee", (124, 58, 237)),
        ("globe", "Internet & Fiber", "Spectranet, Smile, Swift", "Auto-renew", (13, 148, 136)),
        ("receipt", "Bill Requests", "Split or request bill payment", "2 pending", COLOR_GREEN_ICON),
    ]
    for i, (ic_name, title, sub, badge, ic_col) in enumerate(utils):
        cy = uy + int(48 * ui) + i * int(146 * ui)
        draw.rounded_rectangle([cx, cy, cx + cw, cy + int(126 * ui)], radius=int(26 * ui), fill=COLOR_WHITE, outline=COLOR_LIGHT_BORDER, width=2)
        draw.rounded_rectangle([cx + int(24 * ui), cy + int(26 * ui), cx + int(98 * ui), cy + int(100 * ui)], radius=int(22 * ui), fill=COLOR_SOFT_GREEN)
        draw_vector_icon(draw, ic_name, cx + int(61 * ui), cy + int(63 * ui), int(34 * ui), ic_col)
        draw.text((cx + int(120 * ui), cy + int(28 * ui)), title, font=get_font(int(24 * ui), bold=True), fill=COLOR_CHARCOAL)
        draw.text((cx + int(120 * ui), cy + int(68 * ui)), sub, font=get_font(int(18 * ui)), fill=COLOR_GRAY_TEXT)

        f_bg = get_font(int(17 * ui), bold=True)
        bw = draw.textlength(badge, font=f_bg) + int(32 * ui)
        draw.rounded_rectangle([cx + cw - bw - int(24 * ui), cy + int(42 * ui), cx + cw - int(24 * ui), cy + int(84 * ui)], radius=int(14 * ui), fill=COLOR_SOFT_GREEN)
        draw.text((cx + cw - bw - int(8 * ui), cy + int(51 * ui)), badge, font=f_bg, fill=COLOR_GREEN_ICON)

    draw_bottom_nav_bar(draw, px, py, pw, ph, ui, active_idx=0)
    draw_home_indicator(draw, px, py, pw, ph, ui, dark_bg=False)
    return img


def main():
    print("Generating Revamped App Store Screenshots (matching Full Revamp v36 UI)...")
    screens = [
        ("1_home_wallet", render_screen_1),
        ("2_instant_transfers", render_screen_2),
        ("3_voice_alerts", render_screen_3),
        ("4_offline_radar", render_screen_4),
        ("5_bills_and_airtime", render_screen_5),
    ]

    downloads_target = r"C:\Users\johna\Downloads\streetpay_screenshots"
    can_copy_downloads = os.path.exists(r"C:\Users\johna\Downloads")
    if can_copy_downloads:
        os.makedirs(downloads_target, exist_ok=True)

    for size_name, (w, h) in SIZES.items():
        out_dir = os.path.join("screenshots", size_name)
        os.makedirs(out_dir, exist_ok=True)
        dl_size_dir = os.path.join(downloads_target, size_name) if can_copy_downloads else None
        if dl_size_dir:
            os.makedirs(dl_size_dir, exist_ok=True)

        print(f"\nRendering for {size_name} ({w}x{h}):")
        for filename, renderer in screens:
            out_path = os.path.join(out_dir, f"{filename}.png")
            img = renderer(w, h)
            img.save(out_path, format="PNG", optimize=True)
            print(f"  -> {out_path} ({os.path.getsize(out_path) // 1024} KB)")
            if dl_size_dir:
                img.save(os.path.join(dl_size_dir, f"{filename}.png"), format="PNG", optimize=True)

    print(f"\nGenerated {len(SIZES) * len(screens)} App Store screenshots across {len(SIZES)} device sizes!")


if __name__ == '__main__':
    main()
