import os
from PIL import Image, ImageDraw, ImageFont, ImageOps

SIZES = {
    '6.9_inch': (1320, 2868),       # iPhone 16 Pro Max / 17 Pro Max
    '6.7_inch': (1290, 2796),       # iPhone 15 Pro Max / 14 Pro Max
    '6.5_inch': (1242, 2688),       # iPhone 11 Pro Max / XS Max
    '6.3_inch': (1206, 2622),       # iPhone 16 Pro / 17 Pro
    '6.1_inch': (1179, 2556),       # iPhone 16 / 15 / 15 Pro / 14 Pro
    'ipad_13_inch': (2064, 2752),   # iPad Pro 13-inch (M4)
    'ipad_12_9_inch': (2048, 2732), # iPad Pro (2nd-6th Gen 12.9")
}

DESKTOP_DIR = r"C:\Users\johna\Desktop"

REAL_SCREENS = [
    (
        "1_home_wallet",
        os.path.join(DESKTOP_DIR, "Screenshot_1795786053.png"),
        "STREETPAY 9PSB · SMART WALLET",
        "Your Everyday Digital Wallet",
        "Instant transfers, nearby discovery & bill management",
        (11, 32, 24),   # top status bar background (#0B2018)
        True,           # dark header status bar
    ),
    (
        "2_bill_requests",
        os.path.join(DESKTOP_DIR, "Screenshot_1795786081.png"),
        "BILL REQUESTS · SPLIT & PAY",
        "Request & Settle Bills Easily",
        "Send bill requests or approve payments with one tap",
        (246, 248, 246), # light top (#F6F8F6)
        False,
    ),
    (
        "3_buy_airtime",
        os.path.join(DESKTOP_DIR, "Screenshot_1795786107.png"),
        "AIRTIME & DATA · ALL NETWORKS",
        "Instant Airtime & Data Top-Up",
        "Recharge MTN, Glo, Airtel & 9mobile directly from wallet",
        (255, 255, 255), # white appbar
        False,
    ),
    (
        "4_discovery_show",
        os.path.join(DESKTOP_DIR, "Screenshot_1795786119.png"),
        "SMART DISCOVERY SHOW",
        "Speak, Get Scored & Win",
        "Interactive voice challenge built right into StreetPay",
        (11, 32, 24),
        True,
    ),
    (
        "5_biometric_security",
        os.path.join(DESKTOP_DIR, "Screenshot_1795783692.png"),
        "BANK-GRADE SECURITY",
        "Protected by Biometric Login",
        "Authorize transfers & sign in securely with Face ID or Touch ID",
        (11, 32, 24),
        True,
    ),
]

COLOR_BG_TOP = (7, 23, 17)
COLOR_CARD_BORDER = (34, 81, 58)
COLOR_MINT = (127, 212, 114)
COLOR_TEXT_WHITE = (255, 255, 255)
COLOR_TEXT_SUB = (165, 195, 180)


def get_font(size, bold=False):
    size = max(8, int(size))
    candidates = [
        "C:/Windows/Fonts/segoeuib.ttf" if bold else "C:/Windows/Fonts/segoeui.ttf",
        "C:/Windows/Fonts/arialbd.ttf" if bold else "C:/Windows/Fonts/arial.ttf",
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


def draw_ios_status_overlay(draw, px, py, pw, ph, ui_scale, top_bg, dark_header, is_ipad):
    # Cover Android status bar + punch-hole cleanly
    status_h = int(112 * ui_scale)
    draw.rectangle([px, py, px + pw, py + status_h], fill=top_bg)

    txt_color = (255, 255, 255) if dark_header else (16, 22, 20)
    font_time = get_font(int(24 * ui_scale), bold=True)
    draw.text((px + int(48 * ui_scale), py + int(34 * ui_scale)), "9:41", font=font_time, fill=txt_color)

    if not is_ipad:
        island_w, island_h = int(180 * ui_scale), int(44 * ui_scale)
        island_x = px + (pw - island_w) // 2
        draw.rounded_rectangle(
            [island_x, py + int(26 * ui_scale), island_x + island_w, py + int(26 * ui_scale) + island_h],
            radius=island_h // 2,
            fill=(0, 0, 0),
        )
        draw.ellipse(
            [island_x + island_w - int(36 * ui_scale), py + int(38 * ui_scale), island_x + island_w - int(18 * ui_scale), py + int(56 * ui_scale)],
            fill=(14, 18, 26),
        )

    rx = px + pw - int(135 * ui_scale)
    for i in range(4):
        draw.rectangle(
            [rx + i * int(8 * ui_scale), py + int(48 * ui_scale) - (i * int(4 * ui_scale)), rx + i * int(8 * ui_scale) + int(5 * ui_scale), py + int(48 * ui_scale)],
            fill=txt_color,
        )
    draw.text((rx + int(38 * ui_scale), py + int(34 * ui_scale)), "5G", font=get_font(int(17 * ui_scale), bold=True), fill=txt_color)
    draw.rounded_rectangle([rx + int(75 * ui_scale), py + int(36 * ui_scale), rx + int(112 * ui_scale), py + int(52 * ui_scale)], radius=4, outline=txt_color, width=2)
    draw.rounded_rectangle([rx + int(78 * ui_scale), py + int(39 * ui_scale), rx + int(108 * ui_scale), py + int(49 * ui_scale)], radius=2, fill=txt_color)


def render_framed_real_screenshot(w, h, src_path, tag_text, title_text, sub_text, top_bg, dark_header):
    img = Image.new('RGB', (w, h), COLOR_BG_TOP)
    draw = ImageDraw.Draw(img)
    draw_vertical_gradient(draw, w, h, COLOR_BG_TOP, (13, 38, 28))

    is_ipad = (w / h) > 0.65
    scale = min(w / 2048.0, h / 2732.0) if is_ipad else min(w / 1290.0, h / 2796.0)
    m_scale = (w / 2048.0) * 1.25 if is_ipad else scale

    # Top marketing header
    font_tag = get_font(int(24 * m_scale), bold=True)
    font_title = get_font(int(60 * m_scale), bold=True)
    font_sub = get_font(int(29 * m_scale), bold=False)

    tag_w = draw.textlength(tag_text, font=font_tag) + int(70 * m_scale)
    tag_y = int(105 * m_scale) if is_ipad else int(125 * scale)
    tag_h = int(52 * m_scale)
    draw.rounded_rectangle([(w - tag_w) // 2, tag_y, (w + tag_w) // 2, tag_y + tag_h], radius=tag_h // 2, fill=(18, 54, 40), outline=COLOR_CARD_BORDER, width=2)
    draw.text(((w - draw.textlength(tag_text, font=font_tag)) // 2, tag_y + int(11 * m_scale)), tag_text, font=font_tag, fill=COLOR_MINT)

    title_y = tag_y + tag_h + int(24 * m_scale)
    draw.text(((w - draw.textlength(title_text, font=font_title)) // 2, title_y), title_text, font=font_title, fill=COLOR_TEXT_WHITE)

    sub_y = title_y + int(80 * m_scale)
    draw.text(((w - draw.textlength(sub_text, font=font_sub)) // 2, sub_y), sub_text, font=font_sub, fill=COLOR_TEXT_SUB)

    # Device placement (keep exact real screen aspect ratio!)
    raw = Image.open(src_path).convert('RGB')
    rw, rh = raw.size

    if is_ipad:
        # On iPad canvas, fit tall crisp screen nicely centered with clean side bezel
        ph = int(2140 * scale)
        pw = int(ph * (rw / rh))
        px = (w - pw) // 2
        py = int(440 * scale)
        corner_r = int(46 * scale)
        ui_scale = pw / 1060.0
    else:
        pw = int(1040 * scale)
        ph = int(pw * (rh / rw))
        if py_check := int(410 * scale):
            max_ph = h - py_check - int(85 * scale)
            if ph > max_ph:
                ph = max_ph
                pw = int(ph * (rw / rh))
        px = (w - pw) // 2
        py = int(410 * scale)
        corner_r = int(58 * scale)
        ui_scale = pw / 1060.0

    # Titanium chassis
    draw.rounded_rectangle([px - 14, py - 14, px + pw + 14, py + ph + 14], radius=corner_r + 10, fill=(30, 36, 32), outline=(56, 70, 62), width=3)
    draw.rounded_rectangle([px - 4, py - 4, px + pw + 4, py + ph + 4], radius=corner_r + 2, fill=(10, 12, 11), outline=(22, 28, 24), width=2)

    # Paste real app capture resized with LANCZOS + rounded mask
    resized_raw = raw.resize((pw, ph), Image.Resampling.LANCZOS)
    rdraw = ImageDraw.Draw(resized_raw)
    draw_ios_status_overlay(rdraw, 0, 0, pw, ph, ui_scale, top_bg, dark_header, is_ipad)

    mask = Image.new('L', (pw, ph), 0)
    mdraw = ImageDraw.Draw(mask)
    mdraw.rounded_rectangle([0, 0, pw, ph], radius=corner_r, fill=255)
    img.paste(resized_raw, (px, py), mask)

    return img


def main():
    downloads_target = r"C:\Users\johna\Downloads\streetpay_screenshots"
    os.makedirs(downloads_target, exist_ok=True)

    for size_name, (w, h) in SIZES.items():
        out_dir = os.path.join("screenshots", size_name)
        dl_dir = os.path.join(downloads_target, size_name)
        os.makedirs(out_dir, exist_ok=True)
        os.makedirs(dl_dir, exist_ok=True)
        print(f"Packaging real screenshots for {size_name} ({w}x{h})...")
        for name, src, tag, title, sub, top_bg, dark_hdr in REAL_SCREENS:
            framed = render_framed_real_screenshot(w, h, src, tag, title, sub, top_bg, dark_hdr)
            out_p = os.path.join(out_dir, f"{name}.png")
            dl_p = os.path.join(dl_dir, f"{name}.png")
            framed.save(out_p, format="PNG", optimize=True)
            framed.save(dl_p, format="PNG", optimize=True)
            print(f"  -> {out_p} ({os.path.getsize(out_p) // 1024} KB)")

    print("All 35 real-app App Store screenshots packaged successfully!")


if __name__ == "__main__":
    main()

