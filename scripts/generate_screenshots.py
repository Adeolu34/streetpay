import os
import sys
import math
from PIL import Image, ImageDraw, ImageFont

# Target resolutions for App Store Connect
SIZES = {
    '6.7_inch': (1290, 2796),       # iPhone 16 Pro Max / 15 Pro Max / 14 Pro Max
    '6.5_inch': (1242, 2688),       # iPhone 11 Pro Max / XS Max
    '6.3_inch': (1206, 2622),       # iPhone 16 Pro
    '6.1_inch': (1179, 2556),       # iPhone 16 / 15 / 15 Pro / 14 Pro
    'ipad_13_inch': (2064, 2752),   # iPad Pro 13-inch (M4) / iPad Air 13-inch
    'ipad_12_9_inch': (2048, 2732), # iPad Pro 12.9-inch (3rd-6th gen)
}

# Brand Colors
COLOR_BG_TOP = (7, 23, 17)        # Darkest forest green #071711
COLOR_BG_BOTTOM = (11, 32, 24)    # Deep forest green #0B2018
COLOR_EMERALD = (86, 184, 75)     # #56B84B
COLOR_MINT = (127, 212, 114)      # #7FD472
COLOR_CARD_DARK = (18, 54, 42)    # #12362A
COLOR_CARD_BORDER = (34, 81, 58)  # #22513A
COLOR_TEXT_WHITE = (255, 255, 255)
COLOR_TEXT_MUTED = (143, 179, 160) # #8FB3A0
COLOR_TEXT_SUB = (165, 195, 180)
COLOR_ACCENT_YELLOW = (255, 204, 0)
COLOR_ACCENT_RED = (235, 87, 87)
COLOR_ACCENT_BLUE = (47, 128, 237)

def get_font(size, bold=False):
    """Load system font with cross-platform fallbacks (Windows, macOS, Linux)."""
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
    """Draw a smooth vertical gradient."""
    for y in range(height):
        factor = y / height
        r = int(color1[0] * (1 - factor) + color2[0] * factor)
        g = int(color1[1] * (1 - factor) + color2[1] * factor)
        b = int(color1[2] * (1 - factor) + color2[2] * factor)
        draw.line([(0, y), (width, y)], fill=(r, g, b))

def draw_glowing_circle(img, center, radius, color, max_alpha=50):
    """Draw a soft glowing radial circle."""
    overlay = Image.new('RGBA', img.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    cx, cy = center
    steps = 25
    for i in range(steps, 0, -1):
        r = int(radius * (i / steps))
        alpha = int(max_alpha * (1 - (i / steps)))
        draw.ellipse([cx - r, cy - r, cx + r, cy + r], fill=(color[0], color[1], color[2], alpha))
    img.paste(Image.alpha_composite(img.convert('RGBA'), overlay).convert('RGB'))

def draw_device_frame(draw, phone_box, corner_radius=64):
    """Draw realistic iPhone titanium chassis with screen border."""
    px, py, pw, ph = phone_box
    # Outer dark chassis
    draw.rounded_rectangle([px - 14, py - 14, px + pw + 14, py + ph + 14], radius=corner_radius + 10, fill=(30, 36, 32), outline=(50, 62, 54), width=3)
    # Inner metallic bezel
    draw.rounded_rectangle([px - 4, py - 4, px + pw + 4, py + ph + 4], radius=corner_radius + 2, fill=(10, 12, 11), outline=(22, 28, 24), width=2)
    # Screen canvas
    draw.rounded_rectangle([px, py, px + pw, py + ph], radius=corner_radius, fill=(11, 32, 24))

def draw_status_bar_and_island(draw, px, py, pw):
    """Draw iPhone status bar (9:41, icons) and Dynamic Island."""
    font_time = get_font(26, bold=True)
    # Time
    draw.text((px + 56, py + 34), "9:41", font=font_time, fill=(255, 255, 255))
    
    # Dynamic Island pill
    island_w, island_h = 190, 48
    island_x = px + (pw - island_w) // 2
    draw.rounded_rectangle([island_x, py + 26, island_x + island_w, py + 26 + island_h], radius=24, fill=(0, 0, 0))
    # Island camera dot
    draw.ellipse([island_x + island_w - 38, py + 38, island_x + island_w - 18, py + 58], fill=(12, 16, 24))
    
    # Status Icons (Signal, Wifi, Battery)
    rx = px + pw - 120
    # Signal bars
    for i in range(4):
        draw.rectangle([rx + i * 8, py + 48 - (i * 4), rx + i * 8 + 5, py + 48], fill=(255, 255, 255))
    # Wifi icon (arcs simplified)
    draw.text((rx + 40, py + 34), "WiFi", font=get_font(16, bold=True), fill=(255, 255, 255))
    # Battery pill
    draw.rounded_rectangle([rx + 82, py + 36, rx + 120, py + 52], radius=4, outline=(255, 255, 255), width=2)
    draw.rounded_rectangle([rx + 85, py + 39, rx + 116, py + 49], radius=2, fill=(255, 255, 255))
    draw.rectangle([rx + 120, py + 41, rx + 122, py + 47], fill=(255, 255, 255))

def draw_home_indicator(draw, px, py, pw, ph):
    """Draw iOS bottom home indicator."""
    bar_w, bar_h = 240, 7
    bar_x = px + (pw - bar_w) // 2
    bar_y = py + ph - 24
    draw.rounded_rectangle([bar_x, bar_y, bar_x + bar_w, bar_y + bar_h], radius=4, fill=(255, 255, 255, 200))

# ==========================================
# SCREEN 1: Home Dashboard & Digital Wallet
# ==========================================
def render_screen_1(w, h):
    img = Image.new('RGB', (w, h), COLOR_BG_TOP)
    draw = ImageDraw.Draw(img)
    draw_vertical_gradient(draw, w, h, COLOR_BG_TOP, (13, 38, 28))
    draw_glowing_circle(img, (w // 2, 850), 550, COLOR_EMERALD, max_alpha=40)
    
    scale = min(w / 1290.0, h / 2796.0)
    
    # Top Marketing Banner
    font_tag = get_font(int(24 * scale), bold=True)
    font_title = get_font(int(64 * scale), bold=True)
    font_sub = get_font(int(32 * scale), bold=False)
    
    # Category Pill
    tag_text = "STREETPAY 9PSB · SMART BANKING"
    draw.rounded_rectangle([(w - 460 * scale) // 2, 130 * scale, (w + 460 * scale) // 2, 185 * scale], radius=int(28 * scale), fill=(18, 54, 40), outline=COLOR_CARD_BORDER, width=2)
    draw.text(((w - 410 * scale) // 2, 142 * scale), tag_text, font=font_tag, fill=COLOR_MINT)
    
    # Headline
    title_text = "Your Everyday Digital Wallet"
    draw.text(((w - draw.textlength(title_text, font=font_title)) // 2, 215 * scale), title_text, font=font_title, fill=COLOR_TEXT_WHITE)
    
    # Subtitle
    sub_text = "Instant transfers, balance tracking & StreetBox audio alerts"
    draw.text(((w - draw.textlength(sub_text, font=font_sub)) // 2, 305 * scale), sub_text, font=font_sub, fill=COLOR_TEXT_SUB)
    
    # Phone Frame
    pw, ph = int(1060 * scale), int(2260 * scale)
    px, py = (w - pw) // 2, int(410 * scale)
    draw_device_frame(draw, (px, py, pw, ph), corner_radius=int(60 * scale))
    draw_status_bar_and_island(draw, px, py, pw)
    
    # App User Bar inside Screen
    content_y = py + int(110 * scale)
    # User Avatar
    draw.ellipse([px + 50 * scale, content_y, px + 120 * scale, content_y + 70 * scale], fill=(29, 67, 49), outline=COLOR_EMERALD, width=2)
    draw.text((px + 68 * scale, content_y + 18 * scale), "AO", font=get_font(int(26 * scale), bold=True), fill=COLOR_MINT)
    # User Info
    draw.text((px + 140 * scale, content_y + 6 * scale), "Akinwole Oluleye", font=get_font(int(26 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    draw.text((px + 140 * scale, content_y + 40 * scale), "9PSB StreetPay · Tier 3 Verified ★", font=get_font(int(19 * scale), bold=False), fill=COLOR_MINT)
    # Action pills (StreetBox soundbox + Settings)
    draw.rounded_rectangle([px + pw - 170 * scale, content_y + 12 * scale, px + pw - 50 * scale, content_y + 58 * scale], radius=int(22 * scale), fill=(86, 184, 75, 80), outline=COLOR_EMERALD, width=2)
    draw.text((px + pw - 152 * scale, content_y + 22 * scale), "🔊 Active", font=get_font(int(18 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    
    # Wallet Balance Card
    card_y = content_y + int(100 * scale)
    card_w = pw - int(100 * scale)
    card_h = int(480 * scale)
    cx = px + int(50 * scale)
    draw.rounded_rectangle([cx, card_y, cx + card_w, card_y + card_h], radius=int(40 * scale), fill=COLOR_CARD_DARK, outline=COLOR_CARD_BORDER, width=2)
    
    draw.text((cx + 40 * scale, card_y + 36 * scale), "AVAILABLE BALANCE", font=get_font(int(20 * scale), bold=True), fill=COLOR_TEXT_MUTED)
    draw.text((cx + card_w - 80 * scale, card_y + 32 * scale), "👁️", font=get_font(int(24 * scale)), fill=COLOR_TEXT_MUTED)
    draw.text((cx + 40 * scale, card_y + 80 * scale), "₦125,450.00", font=get_font(int(62 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    
    # Ledger breakdown pill
    draw.rounded_rectangle([cx + 40 * scale, card_y + 180 * scale, cx + card_w - 40 * scale, card_y + 246 * scale], radius=int(18 * scale), fill=(255, 255, 255, 20))
    draw.text((cx + 60 * scale, card_y + 198 * scale), "Ledger: ₦130,450.00  •  ₦5,000.00 held in reserve", font=get_font(int(19 * scale), bold=True), fill=COLOR_TEXT_MUTED)
    
    # Account Number Pill
    draw.text((cx + 40 * scale, card_y + 280 * scale), "StreetPay · 9PSB  1023456789", font=get_font(int(22 * scale), bold=True), fill=(207, 227, 214))
    draw.rounded_rectangle([cx + card_w - 150 * scale, card_y + 270 * scale, cx + card_w - 40 * scale, card_y + 316 * scale], radius=int(12 * scale), fill=(86, 184, 75, 60))
    draw.text((cx + card_w - 128 * scale, card_y + 280 * scale), "Copy", font=get_font(int(19 * scale), bold=True), fill=COLOR_MINT)
    
    # Action Buttons (Add Money & Send)
    btn_y = card_y + int(350 * scale)
    btn_w = (card_w - int(100 * scale)) // 2
    # Add Money
    draw.rounded_rectangle([cx + 36 * scale, btn_y, cx + 36 * scale + btn_w, btn_y + int(84 * scale)], radius=int(22 * scale), fill=COLOR_EMERALD)
    draw.text((cx + 80 * scale, btn_y + 24 * scale), "+ Add Money", font=get_font(int(25 * scale), bold=True), fill=(6, 33, 15))
    # Send Money
    draw.rounded_rectangle([cx + 56 * scale + btn_w, btn_y, cx + 56 * scale + btn_w * 2, btn_y + int(84 * scale)], radius=int(22 * scale), fill=(21, 58, 43), outline=COLOR_CARD_BORDER, width=2)
    draw.text((cx + 115 * scale + btn_w, btn_y + 24 * scale), "↑ Send", font=get_font(int(25 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    
    # Discover Nearby Banner
    disc_y = card_y + card_h + int(36 * scale)
    draw.rounded_rectangle([cx, disc_y, cx + card_w, disc_y + int(140 * scale)], radius=int(32 * scale), fill=(255, 255, 255), outline=(214, 234, 216), width=2)
    draw.rounded_rectangle([cx + 24 * scale, disc_y + 24 * scale, cx + 116 * scale, disc_y + 116 * scale], radius=int(24 * scale), fill=(237, 247, 238))
    draw.text((cx + 46 * scale, disc_y + 44 * scale), "📡", font=get_font(int(36 * scale)))
    draw.text((cx + 140 * scale, disc_y + 36 * scale), "Discover Nearby Devices", font=get_font(int(26 * scale), bold=True), fill=(16, 22, 20))
    draw.text((cx + 140 * scale, disc_y + 78 * scale), "Find merchants & vendors around you to pay", font=get_font(int(20 * scale), bold=False), fill=(110, 122, 114))
    
    # Quick Services Grid Title & Pills
    grid_y = disc_y + int(180 * scale)
    draw.text((cx, grid_y), "Quick services", font=get_font(int(28 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    
    services = [("Transfer", "💸"), ("Airtime", "📱"), ("Data", "🌐"), ("Bill Pay", "🧾")]
    col_w = (card_w - int(45 * scale)) // 4
    for i, (name, icon) in enumerate(services):
        sx = cx + i * (col_w + int(15 * scale))
        sy = grid_y + int(46 * scale)
        draw.rounded_rectangle([sx, sy, sx + col_w, sy + int(150 * scale)], radius=int(24 * scale), fill=(18, 48, 36), outline=COLOR_CARD_BORDER, width=2)
        draw.text((sx + (col_w - 36 * scale) // 2, sy + 30 * scale), icon, font=get_font(int(34 * scale)))
        draw.text((sx + (col_w - draw.textlength(name, font=get_font(int(19 * scale), bold=True))) // 2, sy + 94 * scale), name, font=get_font(int(19 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    
    # Recent Activity Preview
    act_y = grid_y + int(240 * scale)
    draw.text((cx, act_y), "Recent activity", font=get_font(int(28 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    
    # Activity Card 1
    a1_y = act_y + int(46 * scale)
    draw.rounded_rectangle([cx, a1_y, cx + card_w, a1_y + int(130 * scale)], radius=int(24 * scale), fill=(16, 42, 32), outline=COLOR_CARD_BORDER, width=1)
    draw.ellipse([cx + 24 * scale, a1_y + 24 * scale, cx + 104 * scale, a1_y + 104 * scale], fill=(86, 184, 75, 40))
    draw.text((cx + 46 * scale, a1_y + 44 * scale), "↓", font=get_font(int(36 * scale), bold=True), fill=COLOR_MINT)
    draw.text((cx + 126 * scale, a1_y + 32 * scale), "Kemi Adebayo", font=get_font(int(25 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    draw.text((cx + 126 * scale, a1_y + 70 * scale), "Transfer In · Today, 09:14 AM", font=get_font(int(19 * scale)), fill=COLOR_TEXT_MUTED)
    draw.text((cx + card_w - 180 * scale, a1_y + 45 * scale), "+₦15,000", font=get_font(int(28 * scale), bold=True), fill=COLOR_MINT)
    
    # Activity Card 2
    a2_y = a1_y + int(146 * scale)
    draw.rounded_rectangle([cx, a2_y, cx + card_w, a2_y + int(130 * scale)], radius=int(24 * scale), fill=(16, 42, 32), outline=COLOR_CARD_BORDER, width=1)
    draw.ellipse([cx + 24 * scale, a2_y + 24 * scale, cx + 104 * scale, a2_y + 104 * scale], fill=(255, 204, 0, 40))
    draw.text((cx + 46 * scale, a2_y + 44 * scale), "📱", font=get_font(int(32 * scale)))
    draw.text((cx + 126 * scale, a2_y + 32 * scale), "MTN Virtual TopUp", font=get_font(int(25 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    draw.text((cx + 126 * scale, a2_y + 70 * scale), "Airtime Purchase · Yesterday", font=get_font(int(19 * scale)), fill=COLOR_TEXT_MUTED)
    draw.text((cx + card_w - 160 * scale, a2_y + 45 * scale), "-₦2,000", font=get_font(int(28 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    
    draw_home_indicator(draw, px, py, pw, ph)
    return img

# ==========================================
# SCREEN 2: Instant Bank Transfers
# ==========================================
def render_screen_2(w, h):
    img = Image.new('RGB', (w, h), COLOR_BG_TOP)
    draw = ImageDraw.Draw(img)
    draw_vertical_gradient(draw, w, h, COLOR_BG_TOP, (14, 40, 30))
    draw_glowing_circle(img, (w // 2, 850), 550, COLOR_EMERALD, max_alpha=40)
    scale = min(w / 1290.0, h / 2796.0)
    
    font_tag = get_font(int(24 * scale), bold=True)
    font_title = get_font(int(64 * scale), bold=True)
    font_sub = get_font(int(32 * scale), bold=False)
    
    tag_text = "INSTANT TRANSFERS · ALL NIGERIAN BANKS"
    draw.rounded_rectangle([(w - 530 * scale) // 2, 130 * scale, (w + 530 * scale) // 2, 185 * scale], radius=int(28 * scale), fill=(18, 54, 40), outline=COLOR_CARD_BORDER, width=2)
    draw.text(((w - 480 * scale) // 2, 142 * scale), tag_text, font=font_tag, fill=COLOR_MINT)
    
    title_text = "Send Money in Seconds"
    draw.text(((w - draw.textlength(title_text, font=font_title)) // 2, 215 * scale), title_text, font=font_title, fill=COLOR_TEXT_WHITE)
    
    sub_text = "Direct bank transfer with verified recipient names & instant receipts"
    draw.text(((w - draw.textlength(sub_text, font=font_sub)) // 2, 305 * scale), sub_text, font=font_sub, fill=COLOR_TEXT_SUB)
    
    pw, ph = int(1060 * scale), int(2260 * scale)
    px, py = (w - pw) // 2, int(410 * scale)
    draw_device_frame(draw, (px, py, pw, ph), corner_radius=int(60 * scale))
    draw_status_bar_and_island(draw, px, py, pw)
    
    # App Header inside Screen
    content_y = py + int(110 * scale)
    draw.text((px + 50 * scale, content_y + 10 * scale), "←", font=get_font(int(36 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    draw.text((px + 120 * scale, content_y + 12 * scale), "Send Money", font=get_font(int(32 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    
    cx = px + int(50 * scale)
    card_w = pw - int(100 * scale)
    
    # Recipient Input Box
    rec_y = content_y + int(80 * scale)
    draw.rounded_rectangle([cx, rec_y, cx + card_w, rec_y + int(240 * scale)], radius=int(32 * scale), fill=COLOR_CARD_DARK, outline=COLOR_CARD_BORDER, width=2)
    draw.text((cx + 36 * scale, rec_y + 28 * scale), "SELECT BANK", font=get_font(int(18 * scale), bold=True), fill=COLOR_TEXT_MUTED)
    draw.text((cx + 36 * scale, rec_y + 60 * scale), "Access Bank", font=get_font(int(28 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    
    draw.line([(cx + 36 * scale, rec_y + 115 * scale), (cx + card_w - 36 * scale, rec_y + 115 * scale)], fill=COLOR_CARD_BORDER, width=1)
    
    draw.text((cx + 36 * scale, rec_y + 130 * scale), "ACCOUNT NUMBER", font=get_font(int(18 * scale), bold=True), fill=COLOR_TEXT_MUTED)
    draw.text((cx + 36 * scale, rec_y + 165 * scale), "0123456789", font=get_font(int(32 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    
    # Verified Beneficiary Pill
    draw.rounded_rectangle([cx + 36 * scale, rec_y + 270 * scale, cx + card_w - 36 * scale, rec_y + 340 * scale], radius=int(18 * scale), fill=(86, 184, 75, 40), outline=COLOR_EMERALD, width=1)
    draw.text((cx + 56 * scale, rec_y + 292 * scale), "✓ Verified: AKINWOLE OLULEYE", font=get_font(int(22 * scale), bold=True), fill=COLOR_MINT)
    
    # Amount Input Box
    amt_y = rec_y + int(370 * scale)
    draw.rounded_rectangle([cx, amt_y, cx + card_w, amt_y + int(200 * scale)], radius=int(32 * scale), fill=COLOR_CARD_DARK, outline=COLOR_CARD_BORDER, width=2)
    draw.text((cx + 36 * scale, amt_y + 28 * scale), "AMOUNT TO SEND", font=get_font(int(18 * scale), bold=True), fill=COLOR_TEXT_MUTED)
    draw.text((cx + 36 * scale, amt_y + 70 * scale), "₦25,000.00", font=get_font(int(60 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    draw.text((cx + 36 * scale, amt_y + 150 * scale), "Available balance: ₦125,450.00", font=get_font(int(18 * scale)), fill=COLOR_TEXT_MUTED)
    
    # Anti-Duplicate Security Badge
    sec_y = amt_y + int(230 * scale)
    draw.rounded_rectangle([cx, sec_y, cx + card_w, sec_y + int(80 * scale)], radius=int(20 * scale), fill=(16, 42, 32), outline=COLOR_CARD_BORDER, width=1)
    draw.text((cx + 30 * scale, sec_y + 26 * scale), "🔒 Protected by StreetPay 30s Anti-Duplicate Lock", font=get_font(int(20 * scale), bold=True), fill=COLOR_MINT)
    
    # Floating Success Receipt Card
    recp_y = sec_y + int(115 * scale)
    recp_h = int(680 * scale)
    draw.rounded_rectangle([cx, recp_y, cx + card_w, recp_y + recp_h], radius=int(36 * scale), fill=(14, 46, 34), outline=COLOR_EMERALD, width=3)
    
    # Success Icon
    draw.ellipse([cx + (card_w - 90 * scale) // 2, recp_y + 40 * scale, cx + (card_w + 90 * scale) // 2, recp_y + 130 * scale], fill=COLOR_EMERALD)
    draw.text((cx + (card_w - 38 * scale) // 2, recp_y + 55 * scale), "✓", font=get_font(int(54 * scale), bold=True), fill=(6, 33, 15))
    
    draw.text((cx + (card_w - draw.textlength("Transfer Successful!", font=get_font(int(36 * scale), bold=True))) // 2, recp_y + 150 * scale), "Transfer Successful!", font=get_font(int(36 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    draw.text((cx + (card_w - draw.textlength("₦25,000.00", font=get_font(int(56 * scale), bold=True))) // 2, recp_y + 210 * scale), "₦25,000.00", font=get_font(int(56 * scale), bold=True), fill=COLOR_MINT)
    
    details = [
        ("Recipient", "AKINWOLE OLULEYE"),
        ("Bank", "Access Bank · 0123456789"),
        ("Date & Time", "25 Nov 2026, 09:41 AM"),
        ("Transaction Ref", "SP-TXN-202611-984321"),
    ]
    dy = recp_y + int(310 * scale)
    for label, val in details:
        draw.text((cx + 40 * scale, dy), label, font=get_font(int(19 * scale)), fill=COLOR_TEXT_MUTED)
        draw.text((cx + card_w - 40 * scale - draw.textlength(val, font=get_font(int(20 * scale), bold=True)), dy), val, font=get_font(int(20 * scale), bold=True), fill=COLOR_TEXT_WHITE)
        dy += int(52 * scale)
    
    # Share Receipt Button
    share_y = recp_y + int(560 * scale)
    draw.rounded_rectangle([cx + 40 * scale, share_y, cx + card_w - 40 * scale, share_y + int(80 * scale)], radius=int(24 * scale), fill=COLOR_EMERALD)
    draw.text((cx + (card_w - draw.textlength("Share Official Receipt", font=get_font(int(24 * scale), bold=True))) // 2, share_y + 24 * scale), "Share Official Receipt", font=get_font(int(24 * scale), bold=True), fill=(6, 33, 15))
    
    draw_home_indicator(draw, px, py, pw, ph)
    return img

# ==========================================
# SCREEN 3: StreetBox™ Voice Alerts
# ==========================================
def render_screen_3(w, h):
    img = Image.new('RGB', (w, h), COLOR_BG_TOP)
    draw = ImageDraw.Draw(img)
    draw_vertical_gradient(draw, w, h, COLOR_BG_TOP, (12, 36, 26))
    draw_glowing_circle(img, (w // 2, 950), 600, COLOR_EMERALD, max_alpha=50)
    scale = min(w / 1290.0, h / 2796.0)
    
    font_tag = get_font(int(24 * scale), bold=True)
    font_title = get_font(int(64 * scale), bold=True)
    font_sub = get_font(int(32 * scale), bold=False)
    
    tag_text = "STREETBOX™ · MERCHANT SOUNDBOX"
    draw.rounded_rectangle([(w - 490 * scale) // 2, 130 * scale, (w + 490 * scale) // 2, 185 * scale], radius=int(28 * scale), fill=(18, 54, 40), outline=COLOR_CARD_BORDER, width=2)
    draw.text(((w - 440 * scale) // 2, 142 * scale), tag_text, font=font_tag, fill=COLOR_MINT)
    
    title_text = "Loud Voice Alerts for Payments"
    draw.text(((w - draw.textlength(title_text, font=font_title)) // 2, 215 * scale), title_text, font=font_title, fill=COLOR_TEXT_WHITE)
    
    sub_text = "Instant loud payment announcements — never get scammed by fake alerts"
    draw.text(((w - draw.textlength(sub_text, font=font_sub)) // 2, 305 * scale), sub_text, font=font_sub, fill=COLOR_TEXT_SUB)
    
    pw, ph = int(1060 * scale), int(2260 * scale)
    px, py = (w - pw) // 2, int(410 * scale)
    draw_device_frame(draw, (px, py, pw, ph), corner_radius=int(60 * scale))
    draw_status_bar_and_island(draw, px, py, pw)
    
    content_y = py + int(110 * scale)
    draw.text((px + 50 * scale, content_y + 10 * scale), "StreetBox™ Audio Alert", font=get_font(int(32 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    
    cx = px + int(50 * scale)
    card_w = pw - int(100 * scale)
    
    # Soundbox Visual Canvas
    spk_y = content_y + int(80 * scale)
    spk_h = int(620 * scale)
    draw.rounded_rectangle([cx, spk_y, cx + card_w, spk_y + spk_h], radius=int(40 * scale), fill=COLOR_CARD_DARK, outline=COLOR_EMERALD, width=3)
    
    # Radiating acoustic waves
    scx, scy = cx + card_w // 2, spk_y + int(240 * scale)
    for r in [220, 170, 120, 80]:
        draw.ellipse([scx - r * scale, scy - r * scale, scx + r * scale, scy + r * scale], outline=(86, 184, 75, 90), width=int(3 * scale))
    
    # Speaker Icon Emblem
    draw.ellipse([scx - 60 * scale, scy - 60 * scale, scx + 60 * scale, scy + 60 * scale], fill=COLOR_EMERALD)
    draw.text((scx - 30 * scale, scy - 32 * scale), "🔊", font=get_font(int(54 * scale)))
    
    # Status Banner
    draw.rounded_rectangle([scx - 160 * scale, spk_y + int(420 * scale), scx + 160 * scale, spk_y + int(480 * scale)], radius=int(22 * scale), fill=(86, 184, 75, 40), outline=COLOR_MINT, width=2)
    draw.text((scx - 130 * scale, spk_y + int(435 * scale)), "● StreetBox Audio ACTIVE", font=get_font(int(20 * scale), bold=True), fill=COLOR_MINT)
    
    # Spoken Announcement Bubble
    spk_text = '"StreetPay! Payment received: ₦15,000 from Emmanuel Adeyemi"'
    draw.rounded_rectangle([cx + 30 * scale, spk_y + int(510 * scale), cx + card_w - 30 * scale, spk_y + int(590 * scale)], radius=int(20 * scale), fill=(10, 28, 20), outline=COLOR_CARD_BORDER, width=1)
    draw.text((cx + 50 * scale, spk_y + int(534 * scale)), spk_text, font=get_font(int(20 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    
    # Merchant Features Box
    feat_y = spk_y + spk_h + int(40 * scale)
    features = [
        ("🔊 Loud Voice Alerts", "Hear payments instantly even in crowded, noisy markets"),
        ("🛡️ Zero Fake Transfer Scams", "Money is verified and settled directly in your wallet"),
        ("⚡ Works in Offline Radar", "Announces BLE payments automatically on connection"),
    ]
    for title, desc in features:
        draw.rounded_rectangle([cx, feat_y, cx + card_w, feat_y + int(150 * scale)], radius=int(26 * scale), fill=(16, 42, 32), outline=COLOR_CARD_BORDER, width=1)
        draw.text((cx + 36 * scale, feat_y + 28 * scale), title, font=get_font(int(24 * scale), bold=True), fill=COLOR_MINT)
        draw.text((cx + 36 * scale, feat_y + 75 * scale), desc, font=get_font(int(20 * scale)), fill=COLOR_TEXT_MUTED)
        feat_y += int(175 * scale)
        
    draw_home_indicator(draw, px, py, pw, ph)
    return img

# ==========================================
# SCREEN 4: Pay Nearby Vendors (BLE Radar)
# ==========================================
def render_screen_4(w, h):
    img = Image.new('RGB', (w, h), COLOR_BG_TOP)
    draw = ImageDraw.Draw(img)
    draw_vertical_gradient(draw, w, h, COLOR_BG_TOP, (14, 38, 28))
    draw_glowing_circle(img, (w // 2, 850), 550, COLOR_EMERALD, max_alpha=40)
    scale = min(w / 1290.0, h / 2796.0)
    
    font_tag = get_font(int(24 * scale), bold=True)
    font_title = get_font(int(64 * scale), bold=True)
    font_sub = get_font(int(32 * scale), bold=False)
    
    tag_text = "OFFLINE DISCOVERY · BLE RADAR"
    draw.rounded_rectangle([(w - 460 * scale) // 2, 130 * scale, (w + 460 * scale) // 2, 185 * scale], radius=int(28 * scale), fill=(18, 54, 40), outline=COLOR_CARD_BORDER, width=2)
    draw.text(((w - 410 * scale) // 2, 142 * scale), tag_text, font=font_tag, fill=COLOR_MINT)
    
    title_text = "Pay Nearby Without Internet"
    draw.text(((w - draw.textlength(title_text, font=font_title)) // 2, 215 * scale), title_text, font=font_title, fill=COLOR_TEXT_WHITE)
    
    sub_text = "Discover nearby merchants & vendors with smart peer-to-peer radar"
    draw.text(((w - draw.textlength(sub_text, font=font_sub)) // 2, 305 * scale), sub_text, font=font_sub, fill=COLOR_TEXT_SUB)
    
    pw, ph = int(1060 * scale), int(2260 * scale)
    px, py = (w - pw) // 2, int(410 * scale)
    draw_device_frame(draw, (px, py, pw, ph), corner_radius=int(60 * scale))
    draw_status_bar_and_island(draw, px, py, pw)
    
    content_y = py + int(110 * scale)
    draw.text((px + 50 * scale, content_y + 10 * scale), "Discover Nearby", font=get_font(int(32 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    
    cx = px + int(50 * scale)
    card_w = pw - int(100 * scale)
    
    # Radar Scanner Visual
    rad_y = content_y + int(80 * scale)
    rad_h = int(620 * scale)
    draw.rounded_rectangle([cx, rad_y, cx + card_w, rad_y + rad_h], radius=int(40 * scale), fill=COLOR_CARD_DARK, outline=COLOR_CARD_BORDER, width=2)
    
    rcx, rcy = cx + card_w // 2, rad_y + int(280 * scale)
    # Concentric radar rings
    for r in [220, 160, 100, 40]:
        draw.ellipse([rcx - r * scale, rcy - r * scale, rcx + r * scale, rcy + r * scale], outline=(86, 184, 75, 70), width=int(2 * scale))
        
    # Center user beacon
    draw.ellipse([rcx - 24 * scale, rcy - 24 * scale, rcx + 24 * scale, rcy + 24 * scale], fill=COLOR_EMERALD)
    
    # Radar detected vendor blips
    blips = [
        (rcx - 110 * scale, rcy - 80 * scale, "Mama Ngozi"),
        (rcx + 130 * scale, rcy - 40 * scale, "Kemi Fashion"),
        (rcx - 60 * scale, rcy + 130 * scale, "Bolu POS"),
    ]
    for bx, by, name in blips:
        draw.ellipse([bx - 14 * scale, by - 14 * scale, bx + 14 * scale, by + 14 * scale], fill=COLOR_ACCENT_YELLOW)
        draw.rounded_rectangle([bx - 60 * scale, by - 44 * scale, bx + 60 * scale, by - 18 * scale], radius=int(8 * scale), fill=(0, 0, 0, 180))
        draw.text((bx - 50 * scale, by - 40 * scale), name, font=get_font(int(14 * scale), bold=True), fill=COLOR_TEXT_WHITE)
        
    draw.text((rcx - 170 * scale, rad_y + int(550 * scale)), "Scanning for StreetPay vendors nearby...", font=get_font(int(20 * scale)), fill=COLOR_MINT)
    
    # Detected Merchant List Cards
    list_y = rad_y + rad_h + int(40 * scale)
    merchants = [
        ("Mama Ngozi Provisions", "Grocery & Drinks · 2.4m away", "🏪"),
        ("Kemi Fashion Hub", "Boutique & Accessories · 5.1m away", "👗"),
        ("Bolu Express POS", "Cash & Settlement · 8.0m away", "💳"),
    ]
    for name, sub, icon in merchants:
        draw.rounded_rectangle([cx, list_y, cx + card_w, list_y + int(150 * scale)], radius=int(28 * scale), fill=(16, 42, 32), outline=COLOR_CARD_BORDER, width=1)
        draw.rounded_rectangle([cx + 24 * scale, list_y + 24 * scale, cx + 116 * scale, list_y + 116 * scale], radius=int(20 * scale), fill=(237, 247, 238, 40))
        draw.text((cx + 46 * scale, list_y + 40 * scale), icon, font=get_font(int(36 * scale)))
        draw.text((cx + 140 * scale, list_y + 36 * scale), name, font=get_font(int(24 * scale), bold=True), fill=COLOR_TEXT_WHITE)
        draw.text((cx + 140 * scale, list_y + 78 * scale), sub, font=get_font(int(19 * scale)), fill=COLOR_TEXT_MUTED)
        # Pay Button
        draw.rounded_rectangle([cx + card_w - 160 * scale, list_y + 45 * scale, cx + card_w - 30 * scale, list_y + 105 * scale], radius=int(18 * scale), fill=COLOR_EMERALD)
        draw.text((cx + card_w - 130 * scale, list_y + 60 * scale), "Pay ₦", font=get_font(int(22 * scale), bold=True), fill=(6, 33, 15))
        list_y += int(175 * scale)
        
    draw_home_indicator(draw, px, py, pw, ph)
    return img

# ==========================================
# SCREEN 5: Bills, Airtime & Utility
# ==========================================
def render_screen_5(w, h):
    img = Image.new('RGB', (w, h), COLOR_BG_TOP)
    draw = ImageDraw.Draw(img)
    draw_vertical_gradient(draw, w, h, COLOR_BG_TOP, (14, 38, 28))
    draw_glowing_circle(img, (w // 2, 850), 550, COLOR_EMERALD, max_alpha=40)
    scale = min(w / 1290.0, h / 2796.0)
    
    font_tag = get_font(int(24 * scale), bold=True)
    font_title = get_font(int(64 * scale), bold=True)
    font_sub = get_font(int(32 * scale), bold=False)
    
    tag_text = "AIRTIME · DATA · BILL PAYMENTS"
    draw.rounded_rectangle([(w - 460 * scale) // 2, 130 * scale, (w + 460 * scale) // 2, 185 * scale], radius=int(28 * scale), fill=(18, 54, 40), outline=COLOR_CARD_BORDER, width=2)
    draw.text(((w - 410 * scale) // 2, 142 * scale), tag_text, font=font_tag, fill=COLOR_MINT)
    
    title_text = "Recharge Airtime & Pay Bills"
    draw.text(((w - draw.textlength(title_text, font=font_title)) // 2, 215 * scale), title_text, font=font_title, fill=COLOR_TEXT_WHITE)
    
    sub_text = "Instant top-ups for MTN, Airtel, Glo, 9mobile, Electricity & Cable TV"
    draw.text(((w - draw.textlength(sub_text, font=font_sub)) // 2, 305 * scale), sub_text, font=font_sub, fill=COLOR_TEXT_SUB)
    
    pw, ph = int(1060 * scale), int(2260 * scale)
    px, py = (w - pw) // 2, int(410 * scale)
    draw_device_frame(draw, (px, py, pw, ph), corner_radius=int(60 * scale))
    draw_status_bar_and_island(draw, px, py, pw)
    
    content_y = py + int(110 * scale)
    draw.text((px + 50 * scale, content_y + 10 * scale), "Bills & Services", font=get_font(int(32 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    
    cx = px + int(50 * scale)
    card_w = pw - int(100 * scale)
    
    # Telecom Carrier Chips
    car_y = content_y + int(80 * scale)
    carriers = [("MTN", (255, 204, 0), (0, 0, 0)), ("Airtel", (235, 87, 87), (255, 255, 255)), ("Glo", (46, 175, 75), (255, 255, 255)), ("9mobile", (0, 115, 68), (255, 255, 255))]
    cw = (card_w - int(45 * scale)) // 4
    for i, (cname, bg, fg) in enumerate(carriers):
        c_x = cx + i * (cw + int(15 * scale))
        draw.rounded_rectangle([c_x, car_y, c_x + cw, car_y + int(110 * scale)], radius=int(22 * scale), fill=bg)
        draw.text((c_x + (cw - draw.textlength(cname, font=get_font(int(24 * scale), bold=True))) // 2, car_y + 40 * scale), cname, font=get_font(int(24 * scale), bold=True), fill=fg)
        
    # Phone Input Card
    phone_y = car_y + int(140 * scale)
    draw.rounded_rectangle([cx, phone_y, cx + card_w, phone_y + int(240 * scale)], radius=int(32 * scale), fill=COLOR_CARD_DARK, outline=COLOR_CARD_BORDER, width=2)
    draw.text((cx + 36 * scale, phone_y + 28 * scale), "PHONE NUMBER", font=get_font(int(18 * scale), bold=True), fill=COLOR_TEXT_MUTED)
    draw.text((cx + 36 * scale, phone_y + 65 * scale), "0803 123 4567", font=get_font(int(34 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    
    # Quick Amount Pills
    draw.line([(cx + 36 * scale, phone_y + 125 * scale), (cx + card_w - 36 * scale, phone_y + 125 * scale)], fill=COLOR_CARD_BORDER, width=1)
    draw.text((cx + 36 * scale, phone_y + 140 * scale), "QUICK AMOUNT", font=get_font(int(18 * scale), bold=True), fill=COLOR_TEXT_MUTED)
    
    amounts = ["₦500", "₦1,000", "₦2,000", "₦5,000"]
    aw = (card_w - int(105 * scale)) // 4
    for i, amt in enumerate(amounts):
        ax = cx + 36 * scale + i * (aw + int(10 * scale))
        selected = (i == 2) # Highlight ₦2,000
        draw.rounded_rectangle([ax, phone_y + 175 * scale, ax + aw, phone_y + 225 * scale], radius=int(14 * scale), fill=COLOR_EMERALD if selected else (14, 40, 30), outline=COLOR_EMERALD if selected else COLOR_CARD_BORDER, width=1)
        draw.text((ax + (aw - draw.textlength(amt, font=get_font(int(18 * scale), bold=True))) // 2, phone_y + 188 * scale), amt, font=get_font(int(18 * scale), bold=True), fill=(6, 33, 15) if selected else COLOR_TEXT_WHITE)
        
    # Cashback Reward Banner
    cash_y = phone_y + int(270 * scale)
    draw.rounded_rectangle([cx, cash_y, cx + card_w, cash_y + int(90 * scale)], radius=int(22 * scale), fill=(86, 184, 75, 40), outline=COLOR_EMERALD, width=1)
    draw.text((cx + 30 * scale, cash_y + 32 * scale), "⚡ Instant Cashback: Earn up to 2% cashback on every top-up", font=get_font(int(20 * scale), bold=True), fill=COLOR_MINT)
    
    # Utilities Categories (Electricity & Cable)
    util_y = cash_y + int(120 * scale)
    draw.text((cx, util_y), "Other bill categories", font=get_font(int(26 * scale), bold=True), fill=COLOR_TEXT_WHITE)
    
    utils = [
        ("💡 Electricity Token", "Prepaid & Postpaid (IKEDC, EKEDC, AEDC)", "Zero surcharge"),
        ("📺 Cable TV Subscription", "Instant renewal for DStv, GOtv, StarTimes", "Instant active"),
        ("🌐 Fiber & Broadband", "Spectranet, Smile, Swift Internet bundles", "Auto-recharge"),
    ]
    uy = util_y + int(45 * scale)
    for title, desc, tag in utils:
        draw.rounded_rectangle([cx, uy, cx + card_w, uy + int(140 * scale)], radius=int(26 * scale), fill=(16, 42, 32), outline=COLOR_CARD_BORDER, width=1)
        draw.text((cx + 36 * scale, uy + 26 * scale), title, font=get_font(int(24 * scale), bold=True), fill=COLOR_TEXT_WHITE)
        draw.text((cx + 36 * scale, uy + 75 * scale), desc, font=get_font(int(19 * scale)), fill=COLOR_TEXT_MUTED)
        draw.rounded_rectangle([cx + card_w - 180 * scale, uy + 45 * scale, cx + card_w - 30 * scale, uy + 95 * scale], radius=int(14 * scale), fill=(86, 184, 75, 30))
        draw.text((cx + card_w - 170 * scale, uy + 58 * scale), tag, font=get_font(int(16 * scale), bold=True), fill=COLOR_MINT)
        uy += int(160 * scale)
        
    draw_home_indicator(draw, px, py, pw, ph)
    return img

def main():
    print("Generating Apple App Store Screenshots...")
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
            print(f"  -> Rendering {filename}...")
            img = renderer(w, h)
            img.save(out_path, format="PNG", optimize=True)
            print(f"     Saved to {out_path} ({os.path.getsize(out_path) // 1024} KB)")
            if dl_size_dir:
                dl_path = os.path.join(dl_size_dir, f"{filename}.png")
                img.save(dl_path, format="PNG", optimize=True)
                
    total_screens = len(SIZES) * len(screens)
    print(f"\nAll {total_screens} App Store screenshots ({len(screens)} screens across {len(SIZES)} device formats) generated successfully!")
    if can_copy_downloads:
        print(f"Screenshots also copied directly to: {downloads_target}")

if __name__ == '__main__':
    main()
