import os
import sys
import math
import textwrap
from PIL import Image, ImageDraw, ImageFont, ImageFilter, ImageOps, ImageEnhance

# Paths
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCREENSHOTS_DIR = os.path.join(BASE_DIR, "screenshots", "6.7_inch")
HEADERS_DIR = os.path.join(BASE_DIR, "screenshots", "headers")
os.makedirs(HEADERS_DIR, exist_ok=True)

LOGO_PATH = os.path.join(BASE_DIR, "streetpay", "assets", "images", "Streetpay1.png")
AI_BG_PATH = r"C:\Users\johna\.gemini\antigravity\brain\3783b462-3133-4539-a713-8a4aa039eb23\fintech_appstore_banner_bg_1795640383985.jpg"

# High-converting fintech color palette
BG_DARK_1 = (5, 12, 9)             # #050C09
BG_DARK_2 = (9, 24, 18)            # #091812
BG_DARK_3 = (13, 38, 27)           # #0D261B

EMERALD_NEON = (0, 230, 118)       # #00E676
EMERALD_PRIMARY = (15, 157, 88)    # #0F9D58
EMERALD_MINT = (127, 212, 114)     # #7FD472
MINT_ACCENT = (127, 212, 114)      # #7FD472
EMERALD_CARD_BG = (16, 42, 31)     # #102A1F
EMERALD_BORDER = (40, 95, 68)      # #285F44

TEXT_WHITE = (255, 255, 255)
TEXT_PALE_MINT = (210, 245, 225)
TEXT_MUTED = (155, 188, 170)
TEXT_DIM = (110, 140, 125)

def get_font(size, bold=False):
    candidates = [
        "C:/Windows/Fonts/segoeuib.ttf" if bold else "C:/Windows/Fonts/segoeui.ttf",
        "C:/Windows/Fonts/arialbd.ttf" if bold else "C:/Windows/Fonts/arial.ttf",
        "/System/Library/Fonts/SFPro-Bold.ttf" if bold else "/System/Library/Fonts/SFPro-Regular.ttf",
        "/Library/Fonts/Arial Bold.ttf" if bold else "/Library/Fonts/Arial.ttf",
    ]
    for path in candidates:
        if os.path.exists(path):
            try:
                return ImageFont.truetype(path, size)
            except Exception:
                continue
    return ImageFont.load_default()

def draw_horizontal_gradient(width, height, color1, color2):
    """Generate a 2D smooth gradient with ambient light."""
    base = Image.new('RGB', (width, height), color1)
    draw = ImageDraw.Draw(base)
    for x in range(0, width, 4):
        factor = x / width
        r = int(color1[0] * (1 - factor) + color2[0] * factor)
        g = int(color1[1] * (1 - factor) + color2[1] * factor)
        b = int(color1[2] * (1 - factor) + color2[2] * factor)
        draw.rectangle([x, 0, x + 4, height], fill=(r, g, b))
    return base

def draw_radial_glow(canvas, center, radius, color, max_alpha=70):
    """Draw a large diffuse radial glow onto RGBA canvas."""
    cx, cy = center
    x0, y0 = max(0, cx - radius), max(0, cy - radius)
    x1, y1 = min(canvas.width, cx + radius), min(canvas.height, cy + radius)
    gw, gh = x1 - x0, y1 - y0
    if gw <= 0 or gh <= 0:
        return
    
    # Render downscaled then upscale with Gaussian Blur for silky smoothness
    scale = 4
    sw, sh = gw // scale, gh // scale
    glow_small = Image.new('RGBA', (sw, sh), (0, 0, 0, 0))
    gdraw = ImageDraw.Draw(glow_small)
    scx, scy = (cx - x0) // scale, (cy - y0) // scale
    srad = radius // scale
    
    steps = 14
    for i in range(steps, 0, -1):
        r = int(srad * (i / steps))
        alpha = int(max_alpha * (1 - (i / steps)) ** 1.6)
        gdraw.ellipse([scx - r, scy - r, scx + r, scy + r], fill=(color[0], color[1], color[2], alpha))
        
    glow_full = glow_small.resize((gw, gh), Image.Resampling.BICUBIC).filter(ImageFilter.GaussianBlur(radius // 5))
    canvas.alpha_composite(glow_full, (x0, y0))

def draw_cyber_grid(canvas, spacing=160, alpha=16):
    """Draw subtle geometric grid lines giving high-tech fintech atmosphere."""
    overlay = Image.new('RGBA', canvas.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    w, h = canvas.size
    grid_color = (0, 230, 118, alpha)
    for x in range(0, w, spacing):
        draw.line([(x, 0), (x, h)], fill=grid_color, width=1)
    for y in range(0, h, spacing):
        draw.line([(0, y), (w, y)], fill=grid_color, width=1)
    
    # Subtle diagonal accent streaks
    for d in range(-h, w, spacing * 3):
        draw.line([(d, 0), (d + h, h)], fill=(127, 212, 114, int(alpha * 0.4)), width=1)
        
    canvas.alpha_composite(overlay)

def blend_ai_background(canvas, opacity=0.35):
    """Blend the AI-generated luxury fintech background softly into the canvas."""
    if not os.path.exists(AI_BG_PATH):
        return
    try:
        ai_img = Image.open(AI_BG_PATH).convert('RGBA')
        ai_resized = ImageOps.fit(ai_img, canvas.size, method=Image.Resampling.LANCZOS)
        # Apply slight blur to make it atmospheric and not compete with typography
        ai_blurred = ai_resized.filter(ImageFilter.GaussianBlur(12))
        
        # Adjust opacity
        alpha_mask = ai_blurred.split()[3]
        alpha_mask = alpha_mask.point(lambda p: int(p * opacity))
        ai_blurred.putalpha(alpha_mask)
        
        canvas.alpha_composite(ai_blurred)
    except Exception as e:
        print(f"Warning: Failed to blend AI background: {e}")

def create_phone_mockup(screen_path, target_h):
    """
    Wrap screenshot in a titanium iPhone chassis with realistic multi-layer shadow,
    bezels, dynamic island, and glass reflections.
    """
    if not os.path.exists(screen_path):
        print(f"Warning: screenshot not found: {screen_path}")
        return None
    
    screen = Image.open(screen_path).convert('RGBA')
    orig_w, orig_h = screen.size
    aspect = orig_w / orig_h
    target_w = int(target_h * aspect)
    screen = screen.resize((target_w, target_h), Image.Resampling.LANCZOS)
    
    bezel = max(8, int(target_h * 0.015))
    corner_r = int(target_h * 0.052)
    
    phone_w = target_w + bezel * 2
    phone_h = target_h + bezel * 2
    
    phone = Image.new('RGBA', (phone_w, phone_h), (0, 0, 0, 0))
    pdraw = ImageDraw.Draw(phone)
    
    # Outer dark titanium chassis
    pdraw.rounded_rectangle([0, 0, phone_w, phone_h], radius=corner_r + bezel, fill=(24, 32, 28, 255), outline=(56, 76, 64, 255), width=max(3, int(bezel * 0.35)))
    # Inner metallic bezel
    pdraw.rounded_rectangle([bezel // 2, bezel // 2, phone_w - bezel // 2, phone_h - bezel // 2], radius=corner_r + bezel // 2, fill=(10, 14, 12, 255), outline=(20, 26, 22, 255), width=2)
    
    # Mask screen with rounded corners
    screen_mask = Image.new('L', (target_w, target_h), 0)
    sdraw = ImageDraw.Draw(screen_mask)
    sdraw.rounded_rectangle([0, 0, target_w, target_h], radius=corner_r, fill=255)
    
    phone.paste(screen, (bezel, bezel), screen_mask)
    
    # Dynamic Island overlay
    island_w = int(target_w * 0.28)
    island_h = int(target_h * 0.024)
    island_x = (phone_w - island_w) // 2
    island_y = bezel + int(target_h * 0.013)
    pdraw.rounded_rectangle([island_x, island_y, island_x + island_w, island_y + island_h], radius=island_h // 2, fill=(0, 0, 0, 255))
    
    # Glass sheen diagonal reflection
    sheen = Image.new('RGBA', (phone_w, phone_h), (0, 0, 0, 0))
    shdraw = ImageDraw.Draw(sheen)
    shdraw.polygon([(phone_w * 0.15, 0), (phone_w * 0.85, 0), (phone_w * 0.45, phone_h), (phone_w * 0.05, phone_h)], fill=(255, 255, 255, 14))
    sheen = sheen.filter(ImageFilter.GaussianBlur(15))
    phone = Image.alpha_composite(phone, sheen)
    
    # Realistic multi-tiered shadow
    pad_shadow = int(target_h * 0.12)
    shadow_w = phone_w + pad_shadow * 2
    shadow_h = phone_h + pad_shadow * 2
    shadow_canvas = Image.new('RGBA', (shadow_w, shadow_h), (0, 0, 0, 0))
    sdraw = ImageDraw.Draw(shadow_canvas)
    
    # Ambient ground contact shadow
    sdraw.rounded_rectangle([pad_shadow + 10, pad_shadow + 40, pad_shadow + phone_w - 10, pad_shadow + phone_h + 40], radius=corner_r + bezel, fill=(0, 0, 0, 160))
    # Outer diffuse shadow
    sdraw.rounded_rectangle([pad_shadow, pad_shadow + 70, pad_shadow + phone_w, pad_shadow + phone_h + 70], radius=corner_r + bezel, fill=(0, 0, 0, 110))
    
    shadow_canvas = shadow_canvas.filter(ImageFilter.GaussianBlur(radius=int(pad_shadow * 0.38)))
    shadow_canvas.paste(phone, (pad_shadow, pad_shadow), phone)
    
    return shadow_canvas

def create_floating_badge(width, height, icon_text, title, subtitle, accent_color=EMERALD_NEON, scale=1.0):
    """Create a frosted glassmorphic 3D notification pill with drop shadow."""
    pad = int(40 * scale)
    total_w = width + pad * 2
    total_h = height + pad * 2
    
    canvas = Image.new('RGBA', (total_w, total_h), (0, 0, 0, 0))
    sdraw = ImageDraw.Draw(canvas)
    
    r = int(24 * scale)
    # Shadow
    sdraw.rounded_rectangle([pad + 6, pad + 16, pad + width - 6, pad + height + 16], radius=r, fill=(0, 0, 0, 140))
    canvas = canvas.filter(ImageFilter.GaussianBlur(int(14 * scale)))
    
    # Badge body
    badge = Image.new('RGBA', (total_w, total_h), (0, 0, 0, 0))
    bdraw = ImageDraw.Draw(badge)
    
    bdraw.rounded_rectangle([pad, pad, pad + width, pad + height], radius=r, fill=(14, 38, 28, 235), outline=(45, 105, 75, 230), width=max(2, int(3 * scale)))
    
    # Left accent icon circle
    icon_size = int(height * 0.65)
    ix = pad + int(18 * scale)
    iy = pad + (height - icon_size) // 2
    bdraw.ellipse([ix, iy, ix + icon_size, iy + icon_size], fill=(accent_color[0], accent_color[1], accent_color[2], 40), outline=accent_color, width=max(1, int(2 * scale)))
    
    font_icon = get_font(int(28 * scale), bold=True)
    bbox = bdraw.textbbox((0, 0), icon_text, font=font_icon)
    iw = bbox[2] - bbox[0]
    ih = bbox[3] - bbox[1]
    bdraw.text((ix + (icon_size - iw) // 2, iy + (icon_size - ih) // 2 - int(2 * scale)), icon_text, font=font_icon, fill=accent_color)
    
    # Text block
    font_t = get_font(int(24 * scale), bold=True)
    font_s = get_font(int(18 * scale), bold=False)
    
    tx = ix + icon_size + int(16 * scale)
    ty = pad + (height - int(48 * scale)) // 2
    bdraw.text((tx, ty), title, font=font_t, fill=TEXT_WHITE)
    bdraw.text((tx, ty + int(28 * scale)), subtitle, font=font_s, fill=TEXT_MUTED)
    
    canvas.alpha_composite(badge)
    return canvas

# =========================================================================
# BANNER 1: 5244 × 2950 px (App Store Today Tab & Featuring Hero Artwork)
# =========================================================================
def render_header_5244x2950():
    print("Generating 5244 x 2950 App Store Feature Banner...")
    W, H = 5244, 2950
    
    # 1. Base gradient
    base = draw_horizontal_gradient(W, H, BG_DARK_1, BG_DARK_3)
    canvas = base.convert('RGBA')
    
    # 2. Blend AI cinematic background
    blend_ai_background(canvas, opacity=0.38)
    
    # 3. Ambient cyber grid
    draw_cyber_grid(canvas, spacing=140, alpha=15)
    
    # 4. Giant luminous emerald glow blooms
    draw_radial_glow(canvas, (W - 1200, 1300), 1600, EMERALD_PRIMARY, max_alpha=75)
    draw_radial_glow(canvas, (W - 1600, 900), 1100, EMERALD_NEON, max_alpha=55)
    draw_radial_glow(canvas, (900, 700), 1200, (15, 80, 50), max_alpha=50)
    draw_radial_glow(canvas, (W // 2, H - 300), 1400, (10, 50, 32), max_alpha=40)
    
    # 5. Right Side: Multi-Phone Device Stage
    # Phone mockups setup
    phone_home = create_phone_mockup(os.path.join(SCREENSHOTS_DIR, "1_home_wallet.png"), target_h=2050)
    phone_radar = create_phone_mockup(os.path.join(SCREENSHOTS_DIR, "4_offline_radar.png"), target_h=1750)
    phone_transfer = create_phone_mockup(os.path.join(SCREENSHOTS_DIR, "2_instant_transfers.png"), target_h=1750)
    
    # Positioning phones: Radar (Left background), Transfer (Right background), Home (Center Foreground)
    stage_center_x = 3650
    ground_y = 2600
    
    if phone_radar:
        # Left angled back phone
        rx = stage_center_x - 1100
        ry = ground_y - phone_radar.height + 150
        canvas.alpha_composite(phone_radar, (rx, ry))
        
    if phone_transfer:
        # Right angled back phone
        tx = stage_center_x + 220
        ty = ground_y - phone_transfer.height + 150
        canvas.alpha_composite(phone_transfer, (tx, ty))
        
    if phone_home:
        # Hero front phone
        hx = stage_center_x - (phone_home.width // 2)
        hy = ground_y - phone_home.height + 80
        canvas.alpha_composite(phone_home, (hx, hy))
        
    # Floating 3D Notification Badges on Stage
    badge1 = create_floating_badge(width=680, height=130, icon_text="₦", title="₦ 50,000.00 Received", subtitle="Voice Cash Alert Broadcasted · 0s ago", accent_color=EMERALD_NEON, scale=1.4)
    canvas.alpha_composite(badge1, (stage_center_x + 240, 680))
    
    badge2 = create_floating_badge(width=620, height=125, icon_text="📡", title="Offline Radar: 3 Nearby", subtitle="Merchant connected without internet", accent_color=MINT_ACCENT, scale=1.35)
    canvas.alpha_composite(badge2, (stage_center_x - 1200, 1600))
    
    badge3 = create_floating_badge(width=580, height=120, icon_text="🔒", title="Encrypted & CBN Regulated", subtitle="Biometric Face ID · Instant settlement", accent_color=EMERALD_NEON, scale=1.3)
    canvas.alpha_composite(badge3, (stage_center_x - 420, 2220))
    
    # 6. Left Side: Typography & Brand Presentation
    # Draw elements onto canvas
    draw = ImageDraw.Draw(canvas)
    
    left_x = 320
    top_y = 360
    
    # Top Category Pill
    pill_text = "✦  OFFICIAL APPLE APP STORE FEATURING  ·  NEXT-GEN FINTECH"
    font_pill = get_font(38, bold=True)
    pb = draw.textbbox((0, 0), pill_text, font=font_pill)
    pw, ph = pb[2] - pb[0] + 70, pb[3] - pb[1] + 34
    
    pill_img = Image.new('RGBA', (pw, ph), (0, 0, 0, 0))
    pildraw = ImageDraw.Draw(pill_img)
    pildraw.rounded_rectangle([0, 0, pw, ph], radius=ph // 2, fill=(18, 52, 38, 220), outline=(48, 120, 85, 240), width=3)
    pildraw.text((35, (ph - (pb[3] - pb[1])) // 2 - 2), pill_text, font=font_pill, fill=EMERALD_NEON)
    canvas.alpha_composite(pill_img, (left_x, top_y))
    
    # Streetpay Logo & Title Header
    logo_y = top_y + ph + 60
    if os.path.exists(LOGO_PATH):
        logo = Image.open(LOGO_PATH).convert('RGBA')
        logo_size = 240
        logo = logo.resize((logo_size, logo_size), Image.Resampling.LANCZOS)
        
        # Rounded logo background plate with glow
        lplate = Image.new('RGBA', (logo_size + 40, logo_size + 40), (0, 0, 0, 0))
        lpdraw = ImageDraw.Draw(lplate)
        lpdraw.rounded_rectangle([20, 20, logo_size + 20, logo_size + 20], radius=54, fill=(12, 36, 26, 255), outline=(50, 115, 80, 255), width=4)
        lplate.paste(logo, (20, 20), logo)
        
        # Drop shadow for logo
        lshadow = Image.new('RGBA', (logo_size + 80, logo_size + 80), (0, 0, 0, 0))
        lsdraw = ImageDraw.Draw(lshadow)
        lsdraw.rounded_rectangle([30, 45, logo_size + 50, logo_size + 65], radius=54, fill=(0, 0, 0, 160))
        lshadow = lshadow.filter(ImageFilter.GaussianBlur(18))
        lshadow.paste(lplate, (10, 10), lplate)
        
        canvas.alpha_composite(lshadow, (left_x - 10, logo_y - 10))
        title_x = left_x + logo_size + 60
    else:
        title_x = left_x
        
    font_brand = get_font(185, bold=True)
    draw.text((title_x, logo_y + 10), "Streetpay", font=font_brand, fill=TEXT_WHITE)
    
    font_brand_sub = get_font(38, bold=True)
    draw.text((title_x + 8, logo_y + 195), "SMART DIGITAL WALLET & OFFLINE PAYMENTS", font=font_brand_sub, fill=EMERALD_MINT)
    
    # Main Headline
    headline_y = logo_y + 310
    font_headline = get_font(98, bold=True)
    draw.text((left_x, headline_y), "Smarter Payments.", font=font_headline, fill=TEXT_WHITE)
    draw.text((left_x, headline_y + 115), "Even Without Internet.", font=font_headline, fill=EMERALD_NEON)
    
    # Sub-headline paragraph
    sub_y = headline_y + 265
    font_sub = get_font(44, bold=False)
    sub_text = (
        "Send and receive money with zero hidden fees, pay utility bills seamlessly, and receive\n"
        "instant voice cash alerts — completely operational online or 100% offline via local mesh radar."
    )
    for line_idx, line in enumerate(sub_text.split("\n")):
        draw.text((left_x, sub_y + line_idx * 62), line, font=font_sub, fill=TEXT_MUTED)
        
    # Feature Cards Grid (2x2 luxury glass cards)
    cards_y = sub_y + 180
    card_w = 930
    card_h = 240
    card_gap_x = 50
    card_gap_y = 40
    
    features = [
        ("⚡", "Instant ₦ Bank Transfers", "Zero transfer fee · Direct settlement to all Nigerian banks & Streetpay users instantly."),
        ("📡", "Offline Mesh Radar", "Bluetooth & WiFi direct payment discovery. Pay merchants without mobile network."),
        ("🔊", "Live Voice Cash Alerts", "Hear loud, clear spoken payment alerts for every credit, preventing fraud instantly."),
        ("🛡️", "Bank-Grade Protection", "Licensed banking infrastructure, biometric authentication, BVN/NIN verification."),
    ]
    
    for i, (f_icon, f_title, f_desc) in enumerate(features):
        row = i // 2
        col = i % 2
        cx = left_x + col * (card_w + card_gap_x)
        cy = cards_y + row * (card_h + card_gap_y)
        
        card_img = Image.new('RGBA', (card_w + 30, card_h + 30), (0, 0, 0, 0))
        cdraw = ImageDraw.Draw(card_img)
        
        # Soft card shadow
        cdraw.rounded_rectangle([10, 16, card_w + 6, card_h + 16], radius=28, fill=(0, 0, 0, 110))
        card_img = card_img.filter(ImageFilter.GaussianBlur(8))
        
        # Glass card body
        card_body = Image.new('RGBA', (card_w + 30, card_h + 30), (0, 0, 0, 0))
        cbdraw = ImageDraw.Draw(card_body)
        cbdraw.rounded_rectangle([5, 5, card_w + 5, card_h + 5], radius=28, fill=(13, 36, 26, 215), outline=(42, 98, 70, 230), width=3)
        
        # Icon circle
        ic_size = 76
        cbdraw.ellipse([32, 32, 32 + ic_size, 32 + ic_size], fill=(0, 230, 118, 35), outline=EMERALD_NEON, width=2)
        f_ic_font = get_font(36, bold=True)
        ic_bbox = cbdraw.textbbox((0, 0), f_icon, font=f_ic_font)
        iw = ic_bbox[2] - ic_bbox[0]
        ih = ic_bbox[3] - ic_bbox[1]
        cbdraw.text((32 + (ic_size - iw) // 2, 32 + (ic_size - ih) // 2 - 2), f_icon, font=f_ic_font, fill=EMERALD_NEON)
        
        # Card title & desc
        ct_font = get_font(38, bold=True)
        cd_font = get_font(26, bold=False)
        tx = 32 + ic_size + 24
        cbdraw.text((tx, 32), f_title, font=ct_font, fill=TEXT_WHITE)
        
        wrapped_desc = textwrap.wrap(f_desc, width=42)
        for d_idx, d_line in enumerate(wrapped_desc[:2]):
            cbdraw.text((tx, 84 + d_idx * 34), d_line, font=cd_font, fill=TEXT_MUTED)
            
        card_img.alpha_composite(card_body)
        canvas.alpha_composite(card_img, (cx, cy))
        
    # Bottom Trust / App Store Badges
    bottom_y = cards_y + 2 * (card_h + card_gap_y) + 30
    draw.line([(left_x, bottom_y), (left_x + 1910, bottom_y)], fill=(35, 75, 55, 180), width=2)
    
    trust_items = [
        "✓ Designed for iPhone 16 / iOS 17+",
        "✓ 18+ Financial Regulatory Compliant",
        "✓ Multi-Factor Biometric Security",
        "✓ Free on the App Store",
    ]
    font_trust = get_font(32, bold=True)
    for t_idx, item in enumerate(trust_items):
        item_x = left_x + t_idx * 480
        draw.text((item_x, bottom_y + 35), item, font=font_trust, fill=TEXT_PALE_MINT)
        
    # Save 5244 x 2950 Image
    out_path = os.path.join(HEADERS_DIR, "app_store_feature_5244x2950.png")
    final_rgb = canvas.convert('RGB')
    final_rgb.save(out_path, format="PNG", quality=95)
    print(f"Saved 5244 x 2950 banner to: {out_path} ({os.path.getsize(out_path) / 1024 / 1024:.2f} MB)")
    return out_path

# =========================================================================
# BANNER 2: 3840 × 1646 px (Panoramic / Developer Page / Product Hero Header)
# =========================================================================
def render_header_3840x1646():
    print("Generating 3840 x 1646 App Store Panoramic Header...")
    W, H = 3840, 1646
    
    # 1. Base gradient
    base = draw_horizontal_gradient(W, H, BG_DARK_1, BG_DARK_3)
    canvas = base.convert('RGBA')
    
    # 2. Blend AI cinematic background
    blend_ai_background(canvas, opacity=0.35)
    
    # 3. Ambient cyber grid
    draw_cyber_grid(canvas, spacing=120, alpha=14)
    
    # 4. Panoramic radial glow blooms
    draw_radial_glow(canvas, (W - 850, 750), 1200, EMERALD_PRIMARY, max_alpha=75)
    draw_radial_glow(canvas, (W - 1200, 500), 850, EMERALD_NEON, max_alpha=55)
    draw_radial_glow(canvas, (650, 450), 900, (15, 80, 50), max_alpha=45)
    
    # 5. Right Side: Multi-Phone Device Showcase
    # Phone mockups scaled for 1646 height
    phone_home = create_phone_mockup(os.path.join(SCREENSHOTS_DIR, "1_home_wallet.png"), target_h=1280)
    phone_radar = create_phone_mockup(os.path.join(SCREENSHOTS_DIR, "4_offline_radar.png"), target_h=1080)
    phone_transfer = create_phone_mockup(os.path.join(SCREENSHOTS_DIR, "2_instant_transfers.png"), target_h=1080)
    
    stage_center_x = 2760
    ground_y = 1520
    
    if phone_radar:
        # Left angled back phone
        rx = stage_center_x - 720
        ry = ground_y - phone_radar.height + 90
        canvas.alpha_composite(phone_radar, (rx, ry))
        
    if phone_transfer:
        # Right angled back phone
        tx = stage_center_x + 180
        ty = ground_y - phone_transfer.height + 90
        canvas.alpha_composite(phone_transfer, (tx, ty))
        
    if phone_home:
        # Hero front phone
        hx = stage_center_x - (phone_home.width // 2)
        hy = ground_y - phone_home.height + 40
        canvas.alpha_composite(phone_home, (hx, hy))
        
    # Floating Badges for Panoramic Banner
    badge1 = create_floating_badge(width=520, height=105, icon_text="₦", title="₦ 50,000 Received", subtitle="Voice Alert Broadcast Complete", accent_color=EMERALD_NEON, scale=1.0)
    canvas.alpha_composite(badge1, (stage_center_x + 160, 320))
    
    badge2 = create_floating_badge(width=480, height=100, icon_text="📡", title="Offline Radar Active", subtitle="3 nearby merchants found", accent_color=MINT_ACCENT, scale=0.95)
    canvas.alpha_composite(badge2, (stage_center_x - 780, 960))
    
    # 6. Left Side: Typography & Brand Presentation
    draw = ImageDraw.Draw(canvas)
    left_x = 240
    top_y = 200
    
    # Category Pill
    pill_text = "✦  OFFICIAL APP STORE BANNER  ·  SMART FINTECH"
    font_pill = get_font(28, bold=True)
    pb = draw.textbbox((0, 0), pill_text, font=font_pill)
    pw, ph = pb[2] - pb[0] + 50, pb[3] - pb[1] + 26
    
    pill_img = Image.new('RGBA', (pw, ph), (0, 0, 0, 0))
    pildraw = ImageDraw.Draw(pill_img)
    pildraw.rounded_rectangle([0, 0, pw, ph], radius=ph // 2, fill=(18, 52, 38, 220), outline=(48, 120, 85, 240), width=2)
    pildraw.text((25, (ph - (pb[3] - pb[1])) // 2 - 2), pill_text, font=font_pill, fill=EMERALD_NEON)
    canvas.alpha_composite(pill_img, (left_x, top_y))
    
    # Logo + Brand Title
    logo_y = top_y + ph + 45
    logo_size = 140
    if os.path.exists(LOGO_PATH):
        logo = Image.open(LOGO_PATH).convert('RGBA')
        logo = logo.resize((logo_size, logo_size), Image.Resampling.LANCZOS)
        
        lplate = Image.new('RGBA', (logo_size + 30, logo_size + 30), (0, 0, 0, 0))
        lpdraw = ImageDraw.Draw(lplate)
        lpdraw.rounded_rectangle([15, 15, logo_size + 15, logo_size + 15], radius=36, fill=(12, 36, 26, 255), outline=(50, 115, 80, 255), width=3)
        lplate.paste(logo, (15, 15), logo)
        
        lshadow = Image.new('RGBA', (logo_size + 60, logo_size + 60), (0, 0, 0, 0))
        lsdraw = ImageDraw.Draw(lshadow)
        lsdraw.rounded_rectangle([20, 30, logo_size + 40, logo_size + 50], radius=36, fill=(0, 0, 0, 150))
        lshadow = lshadow.filter(ImageFilter.GaussianBlur(12))
        lshadow.paste(lplate, (10, 10), lplate)
        
        canvas.alpha_composite(lshadow, (left_x - 10, logo_y - 10))
        title_x = left_x + logo_size + 40
    else:
        title_x = left_x
        
    font_brand = get_font(120, bold=True)
    draw.text((title_x, logo_y - 5), "Streetpay", font=font_brand, fill=TEXT_WHITE)
    
    font_brand_sub = get_font(26, bold=True)
    draw.text((title_x + 6, logo_y + 115), "SMART DIGITAL WALLET & OFFLINE PAYMENTS", font=font_brand_sub, fill=EMERALD_MINT)
    
    # Main Headline
    headline_y = logo_y + 190
    font_headline = get_font(68, bold=True)
    draw.text((left_x, headline_y), "Instant ₦ Transfers.", font=font_headline, fill=TEXT_WHITE)
    draw.text((left_x, headline_y + 80), "Everywhere · Online & Offline.", font=font_headline, fill=EMERALD_NEON)
    
    # Subtitle
    sub_y = headline_y + 185
    font_sub = get_font(32, bold=False)
    sub_text = (
        "Send money with zero fees, broadcast real-time voice cash alerts, and make\n"
        "offline radar payments without cellular network coverage across Nigeria."
    )
    for line_idx, line in enumerate(sub_text.split("\n")):
        draw.text((left_x, sub_y + line_idx * 44), line, font=font_sub, fill=TEXT_MUTED)
        
    # Feature Pills Row
    pills_y = sub_y + 130
    pills = [
        ("⚡", "0% Transfer Fees"),
        ("📡", "Offline Mesh Radar"),
        ("🔊", "Voice Cash Alerts"),
        ("🛡️", "Bank-Grade Security"),
    ]
    
    cur_px = left_x
    font_p_icon = get_font(24, bold=True)
    font_p_text = get_font(24, bold=True)
    
    for p_ic, p_txt in pills:
        full_txt = f"{p_ic}  {p_txt}"
        tb = draw.textbbox((0, 0), full_txt, font=font_p_text)
        pw = tb[2] - tb[0] + 44
        ph = tb[3] - tb[1] + 24
        
        pill_box = Image.new('RGBA', (pw, ph), (0, 0, 0, 0))
        pbdraw = ImageDraw.Draw(pill_box)
        pbdraw.rounded_rectangle([0, 0, pw, ph], radius=ph // 2, fill=(14, 38, 28, 220), outline=(42, 98, 70, 230), width=2)
        pbdraw.text((22, (ph - (tb[3] - tb[1])) // 2 - 2), full_txt, font=font_p_text, fill=TEXT_WHITE)
        canvas.alpha_composite(pill_box, (cur_px, pills_y))
        cur_px += pw + 22
        
    # Bottom Trust Row
    bottom_y = pills_y + 105
    draw.line([(left_x, bottom_y), (left_x + 1400, bottom_y)], fill=(35, 75, 55, 180), width=2)
    
    trust_items = [
        "✓ Designed for iPhone",
        "✓ 18+ Verified KYC",
        "✓ CBN Regulated Banking",
        "✓ 100% Free",
    ]
    font_trust = get_font(24, bold=True)
    for t_idx, item in enumerate(trust_items):
        item_x = left_x + t_idx * 340
        draw.text((item_x, bottom_y + 26), item, font=font_trust, fill=TEXT_PALE_MINT)
        
    # Save 3840 x 1646 Image
    out_path = os.path.join(HEADERS_DIR, "app_store_banner_3840x1646.png")
    final_rgb = canvas.convert('RGB')
    final_rgb.save(out_path, format="PNG", quality=95)
    print(f"Saved 3840 x 1646 banner to: {out_path} ({os.path.getsize(out_path) / 1024 / 1024:.2f} MB)")
    return out_path

if __name__ == "__main__":
    h1 = render_header_5244x2950()
    h2 = render_header_3840x1646()
    
    # Also copy directly to Downloads if available
    dl_dir = r"C:\Users\johna\Downloads"
    if os.path.exists(dl_dir):
        import shutil
        shutil.copy2(h1, os.path.join(dl_dir, "app_store_feature_5244x2950.png"))
        shutil.copy2(h2, os.path.join(dl_dir, "app_store_banner_3840x1646.png"))
        print(f"Also copied both banners to: {dl_dir}")
        
    print("Done! Both App Store header banners created successfully.")
