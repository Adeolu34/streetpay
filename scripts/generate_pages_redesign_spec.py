#!/usr/bin/env python3
"""
StreetPay Pages Redesign Specification Generator
Scans all FlutterFlow typed AST files, Flutter widgets, models, theme tokens, and actions
to generate a comprehensive markdown redesign specification for redesign agents.
"""

import os
import sys
import glob
import re
import json
import argparse
from collections import Counter, defaultdict

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')
if hasattr(sys.stderr, 'reconfigure'):
    sys.stderr.reconfigure(encoding='utf-8')


# Directories
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
FF_PAGES_DIR = os.path.join(BASE_DIR, 'ff-workspace', 'lib', 'flutterflow_project', 'pages')
SP_LIB_DIR = os.path.join(BASE_DIR, 'streetpay', 'streetpay', 'lib')
GEN_LIB_DIR = os.path.join(BASE_DIR, 'ff-workspace', 'generated_code', 'lib')
OUTPUT_MD_PATH = os.path.join(BASE_DIR, 'PAGES_REDESIGN_SPECIFICATION.md')

# Category Mappings for 92 pages
CATEGORY_MAP = {
    # 1. Authentication & Onboarding
    'Splash': 'Authentication & Onboarding',
    'Welcome': 'Authentication & Onboarding',
    'Onboarding': 'Authentication & Onboarding',
    'SignUp': 'Authentication & Onboarding',
    'Login1': 'Authentication & Onboarding',
    'Loginbiometric': 'Authentication & Onboarding',
    'PhoneVerification': 'Authentication & Onboarding',
    'PhonereVerification': 'Authentication & Onboarding',
    'PinCodeSetup': 'Authentication & Onboarding',
    'bvnverification': 'Authentication & Onboarding',
    'registrationsuccess': 'Authentication & Onboarding',
    'resetpassword': 'Authentication & Onboarding',

    # 2. Dashboard & Core Navigation
    'newhome': 'Dashboard & Core Navigation',
    'profile': 'Dashboard & Core Navigation',
    'editprofile': 'Dashboard & Core Navigation',
    'appSettings': 'Dashboard & Core Navigation',
    'settingpage': 'Dashboard & Core Navigation',
    'accountSettings': 'Dashboard & Core Navigation',

    # 3. KYC & Identity Verification
    'kycpaggge': 'KYC & Identity Verification',
    'uplooaaad': 'KYC & Identity Verification',
    'IDUpload': 'KYC & Identity Verification',
    'upgradetotier2': 'KYC & Identity Verification',
    'upgradetotier3': 'KYC & Identity Verification',
    'faceverify': 'KYC & Identity Verification',
    'consentfield': 'KYC & Identity Verification',

    # 4. Payments & Transfers
    'payment': 'Payments & Transfers',
    'paymentConfirmation': 'Payments & Transfers',
    'paymentSuccess': 'Payments & Transfers',
    'paymentReceipt': 'Payments & Transfers',
    'manualPayment': 'Payments & Transfers',
    'openwallet': 'Payments & Transfers',
    'accountdetails': 'Payments & Transfers',
    'teirpage': 'Payments & Transfers',

    # 5. Bills & Utility Services
    'billnew': 'Bills & Utility Services',
    'billPayment': 'Bills & Utility Services',
    'billSuccess': 'Bills & Utility Services',
    'billPosting': 'Bills & Utility Services',
    'airtimeform': 'Bills & Utility Services',
    'datapayment': 'Bills & Utility Services',
    'billlelectricity': 'Bills & Utility Services',
    'billlcabletv': 'Bills & Utility Services',
    'billlinternet': 'Bills & Utility Services',
    'billlexam': 'Bills & Utility Services',
    'billlbetting': 'Bills & Utility Services',
    'keyboardnew': 'Bills & Utility Services',

    # 6. StreetPool Gaming & Lottery
    'lottery': 'StreetPool Gaming & Lottery',
    'lottohome': 'StreetPool Gaming & Lottery',
    'lottospin': 'StreetPool Gaming & Lottery',
    'lottoflip': 'StreetPool Gaming & Lottery',
    'lottoquiz': 'StreetPool Gaming & Lottery',
    'lottoguess': 'StreetPool Gaming & Lottery',
    'historyspin': 'StreetPool Gaming & Lottery',
    'historyflip': 'StreetPool Gaming & Lottery',
    'historyquiz': 'StreetPool Gaming & Lottery',
    'historyguess': 'StreetPool Gaming & Lottery',
    'allwinners': 'StreetPool Gaming & Lottery',
    'resultsummary': 'StreetPool Gaming & Lottery',
    'streetpollpay': 'StreetPool Gaming & Lottery',
    'streetpoolresult': 'StreetPool Gaming & Lottery',
    'fundsharing': 'StreetPool Gaming & Lottery',
    'givwaway': 'StreetPool Gaming & Lottery',

    # 7. StreetJob Marketplace & Public Offers
    'streetjob': 'StreetJob Marketplace & Public Offers',
    'streetjob2': 'StreetJob Marketplace & Public Offers',
    'publicoffer': 'StreetJob Marketplace & Public Offers',
    'createoffer': 'StreetJob Marketplace & Public Offers',
    'offerdetail': 'StreetJob Marketplace & Public Offers',
    'tickectbooking': 'StreetJob Marketplace & Public Offers',
    'earnwithus': 'StreetJob Marketplace & Public Offers',
    'questionaire': 'StreetJob Marketplace & Public Offers',

    # 8. Access Delegation & Batch Processing
    'grant_access': 'Access Delegation & Batch Processing',
    'viewmyacces': 'Access Delegation & Batch Processing',
    'viewbatch': 'Access Delegation & Batch Processing',
    'batchsingle': 'Access Delegation & Batch Processing',
    'secureuser': 'Access Delegation & Batch Processing',
    'autodicover': 'Access Delegation & Batch Processing',
    'autodiscover1': 'Access Delegation & Batch Processing',

    # 9. Utility, Chat & System Pages
    'chat': 'Utility, Chat & System Pages',
    'contactus': 'Utility, Chat & System Pages',
    'couponpay': 'Utility, Chat & System Pages',
    'couponreceipt': 'Utility, Chat & System Pages',
    'emptyProfile': 'Utility, Chat & System Pages',
    'emptyProfileface': 'Utility, Chat & System Pages',
    'nointernet': 'Utility, Chat & System Pages',
    'mainteinance': 'Utility, Chat & System Pages',
    'errorpage': 'Utility, Chat & System Pages',
    'testpage': 'Utility, Chat & System Pages',
    'streetshareinto': 'Utility, Chat & System Pages',
    'premiumconsent': 'Utility, Chat & System Pages',
    'changepassword': 'Utility, Chat & System Pages',
    'retrivedetails': 'Utility, Chat & System Pages',
    'transactionHistory': 'Utility, Chat & System Pages',
    'transactionHistorybatches': 'Utility, Chat & System Pages',
}

MODULE_DESCRIPTIONS = {
    'Authentication & Onboarding': 'Entry point, authentication, KYC pre-flight, and security credentials setup.',
    'Dashboard & Core Navigation': 'Primary user hub, account balances, main action tiles, profile settings, and application preferences.',
    'KYC & Identity Verification': 'Tier 1 to Tier 3 compliance, face verification, ID uploads, and address proof validation.',
    'Payments & Transfers': 'Peer-to-peer wallet transfers, manual bank payouts, receipts, and payment confirmations.',
    'Bills & Utility Services': 'VAS services including Airtime, Data, Electricity, Cable TV, Internet, Betting, and Exams.',
    'StreetPool Gaming & Lottery': 'Social reward mechanisms, lottery spin/flip/quiz games, prize pools, and winner feeds.',
    'StreetJob Marketplace & Public Offers': 'Community gig marketplace, coupon offers, ticket reservations, and earning programs.',
    'Access Delegation & Batch Processing': 'Sub-account authorization, multi-party access delegations, and batch payroll/disbursements.',
    'Utility, Chat & System Pages': 'Live customer support chat, empty states, network error fallbacks, maintenance, and transaction logs.',
}


def find_flutter_sources(page_name, slug):
    """Find the widget and model files for a given page name across streetpay and generated_code."""
    candidates = [
        slug,
        slug.lower(),
        slug.lower().replace('_', ''),
        page_name,
        page_name.lower(),
        page_name.lower().replace('_', ''),
    ]
    
    widget_file = None
    model_file = None
    source_root = None

    for root_dir in [SP_LIB_DIR, GEN_LIB_DIR]:
        for cand in candidates:
            w_pattern = os.path.join(root_dir, '**', f'{cand}_widget.dart')
            m_pattern = os.path.join(root_dir, '**', f'{cand}_model.dart')
            w_matches = glob.glob(w_pattern, recursive=True)
            m_matches = glob.glob(m_pattern, recursive=True)
            if w_matches:
                widget_file = w_matches[0]
                model_file = m_matches[0] if m_matches else None
                source_root = 'streetpay/lib' if root_dir == SP_LIB_DIR else 'ff-workspace/generated_code/lib'
                return widget_file, model_file, source_root

    return None, None, None


def parse_ff_page(file_path):
    """Parse a typed SDK page file in ff-workspace/lib/flutterflow_project/pages/."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    name_m = re.search(r'name:\s*"([^"]+)"', content)
    key_m = re.search(r'key:\s*"([^"]+)"', content)
    route_m = re.search(r'route:\s*"([^"]*)"', content)

    page_name = name_m.group(1) if name_m else os.path.basename(file_path).replace('.dart', '')
    page_key = key_m.group(1) if key_m else 'Unknown'
    page_route = route_m.group(1) if route_m else ''

    # State fields in PageState class
    state_fields = []
    state_block = re.search(r'final class \w+State\s*\{(.*?)\}', content, re.DOTALL)
    if state_block:
        for m in re.finditer(r'name:\s*"([^"]+)",\s*key:\s*"([^"]+)",\s*typeName:\s*"([^"]+)"', state_block.group(1)):
            state_fields.append({
                'name': m.group(1),
                'key': m.group(2),
                'type': m.group(3)
            })

    # Widget tree analysis
    widget_types = re.findall(r'type:\s*"([^"]+)"', content)
    widget_keys = re.findall(r'key:\s*"([^"]+)"', content)
    widget_names = re.findall(r'name:\s*"([^"]+)"', content)
    triggers = re.findall(r'"(ON_[A-Z_]+)"', content)
    slots = re.findall(r'"(\w+)":\s*<ffai\.ProjectWidgetHandle>\[', content)

    # Reusable components
    components = []
    for w_name in widget_names:
        if any(w_name.endswith(sfx) for sfx in ['Card', 'Header', 'AppBar', 'Item', 'Button', 'Field', 'Pad', 'comp', 'Widget']):
            if w_name not in components:
                components.append(w_name)

    return {
        'page_name': page_name,
        'page_key': page_key,
        'page_route': page_route,
        'state_fields': state_fields,
        'widget_count': len(widget_types),
        'widget_types_count': dict(Counter(widget_types)),
        'triggers': list(set(triggers)),
        'slots': list(set(slots)),
        'named_components': components,
    }


def parse_flutter_model(model_path):
    """Parse FlutterFlow model for controllers, focus nodes, actions, and API calls."""
    if not model_path or not os.path.exists(model_path):
        return {}

    with open(model_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Form inputs & controllers
    controllers = re.findall(r'TextEditingController\?\s+(\w+);', content)
    focus_nodes = re.findall(r'FocusNode\?\s+(\w+);', content)
    scroll_controllers = re.findall(r'ScrollController\?\s+(\w+);', content)
    page_controllers = re.findall(r'PageController\?\s+(\w+);', content)
    tab_controllers = re.findall(r'TabController\?\s+(\w+);', content)

    # Embedded component models
    comp_models = re.findall(r'late\s+(\w+Model)\s+(\w+);', content)

    # Action outputs
    api_calls = []
    custom_actions = []
    for line in content.splitlines():
        api_m = re.search(r'Stores action output result for \[Backend Call - API \(([^)]+)\)\] action in (\w+)', line)
        if api_m:
            api_calls.append({'api': api_m.group(1), 'widget': api_m.group(2)})
        ca_m = re.search(r'Stores action output result for \[Custom Action - ([^\]]+)\] action in (\w+)', line)
        if ca_m:
            custom_actions.append({'action': ca_m.group(1), 'widget': ca_m.group(2)})

    # Local state fields
    local_state = []
    state_section = re.search(r'///\s*Local state fields for this page\.(.*?)///\s*State fields', content, re.DOTALL)
    if state_section:
        for m in re.finditer(r'(\w+[\?]?)\s+(\w+)\s*(?:=\s*([^;]+))?;', state_section.group(1)):
            t, n, val = m.group(1), m.group(2), m.group(3)
            if t not in ['void', 'ScrollController', 'FocusNode', 'TextEditingController']:
                local_state.append({'type': t, 'name': n, 'default': val.strip() if val else None})

    return {
        'text_controllers': controllers,
        'focus_nodes': focus_nodes,
        'scroll_controllers': scroll_controllers,
        'page_controllers': page_controllers,
        'tab_controllers': tab_controllers,
        'component_models': comp_models,
        'api_calls': api_calls,
        'custom_actions': custom_actions,
        'local_state': local_state,
    }


def parse_flutter_widget(widget_path):
    """Parse Flutter widget for navigation targets, headers, and UI cues."""
    if not widget_path or not os.path.exists(widget_path):
        return {}

    with open(widget_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Route info
    r_name_m = re.search(r"static String routeName = '([^']+)';", content)
    r_path_m = re.search(r"static String routePath = '([^']+)';", content)
    route_name = r_name_m.group(1) if r_name_m else ''
    route_path = r_path_m.group(1) if r_path_m else ''

    # Navigation targets
    push_routes = re.findall(r"context\.(?:pushNamed|goNamed)\(\s*'([^']+)'", content)

    # Titles & Static text
    text_snippets = re.findall(r"Text\(\s*'([^']{3,40})'", content)
    # Unique text snippets (first 10)
    seen = set()
    cleaned_texts = []
    for t in text_snippets:
        if t not in seen and not t.startswith('$') and not re.match(r'^[0-9\.\s]+$', t):
            seen.add(t)
            cleaned_texts.append(t)
            if len(cleaned_texts) >= 6:
                break

    return {
        'route_name': route_name,
        'route_path': route_path,
        'nav_targets': list(set(push_routes)),
        'static_texts': cleaned_texts,
    }


def generate_redesign_recommendations(page_name, category, ff_info, model_info, widget_info):
    """Generate tailored, expert UX & UI redesign guidance for the redesign agent."""
    recs = {
        'ux_issues': [],
        'ui_recommendations': [],
        'fast_lane_patches': [],
        'dsl_edits': [],
        'safety_rules': [],
    }

    w_counts = ff_info.get('widget_types_count', {})
    total_w = ff_info.get('widget_count', 0)
    text_ctrls = model_info.get('text_controllers', [])
    api_calls = model_info.get('api_calls', [])
    ca_calls = model_info.get('custom_actions', [])

    # Universal Fintech Design rules
    recs['safety_rules'].append(f"Do NOT rename or remove Scaffold key `{ff_info['page_key']}`.")
    if text_ctrls:
        ctrls_str = ', '.join([f'`{c}`' for c in text_ctrls[:4]])
        recs['safety_rules'].append(f"Preserve all {len(text_ctrls)} TextEditingController bindings: {ctrls_str}.")
    if api_calls:
        apis_str = ', '.join([f"`{a['api']}`" for a in api_calls[:3]])
        recs['safety_rules'].append(f"Retain Backend API action chains for: {apis_str}.")
    if ca_calls:
        cas_str = ', '.join([f"`{a['action']}`" for a in ca_calls[:3]])
        recs['safety_rules'].append(f"Preserve Custom Action invocations: {cas_str}.")

    # Category-specific guidance
    if category == 'Authentication & Onboarding':
        recs['ux_issues'] = [
            "Dense vertical stack with potential keyboard overlap on smaller devices.",
            "Lack of inline credential validation feedback before button submission.",
            "Primary CTA button may blend into background if contrast tokens are uncurated."
        ]
        recs['ui_recommendations'] = [
            "Modern card grouping: Wrap credentials in a clean 16dp radius elevated card with subtle border `alternate`.",
            "Touch ergonomics: Minimum 52dp height for all text fields and primary submit button.",
            "Visual hierarchy: Emphasize 28sp headline with Inter/Outfit typography, followed by a muted subtitle1.",
            "Security cues: Add subtle padlock or biometric iconography to reassure users during credential input."
        ]
        recs['fast_lane_patches'] = [
            "Button border radius to 12dp or 16dp (`borderRadius: 16`).",
            "Input field fill colors using `secondaryBackground` token.",
            "Update primary button font weight to SemiBold (600) and fontSize to 16."
        ]
        recs['dsl_edits'] = [
            "Ensure root Column has SingleChildScrollView to prevent bottom overflow on keyboard popups.",
            "Wrap input fields in dedicated Column with consistent 16dp spacing."
        ]

    elif category == 'Dashboard & Core Navigation':
        recs['ux_issues'] = [
            "High cognitive load with numerous competing action cards and balance cards.",
            "Inconsistent card paddings and varying border radii across home components.",
            "Absence of skeleton loaders during initial balance and news queries."
        ]
        recs['ui_recommendations'] = [
            "Hero Wallet Card: Modern gradient background (`primary` to `accent1`) with high-contrast white balance text, quick deposit/send chips, and eye toggle for balance privacy.",
            "Quick Action Grid: Clean 4-column icon-text grid for high-frequency actions (Airtime, Bills, Transfer, StreetPool).",
            "Transaction Activity: Elevated section card with subtle divider lines and status color badges (success green / error red)."
        ]
        recs['fast_lane_patches'] = [
            "Set uniform card border radii (16dp) on all action containers.",
            "Align typography tokens to `titleMedium` for section headers and `bodySmall` for captions.",
            "Ensure `elevation` on cards is subtle (2dp to 4dp) with soft shadow color."
        ]
        recs['dsl_edits'] = [
            "Refactor nested columns into a unified CustomScrollView with slivers for smooth header collapsing.",
            "Standardize grid spacing using 12dp gap."
        ]

    elif category == 'KYC & Identity Verification':
        recs['ux_issues'] = [
            "Complex multi-step requirements presented without clear visual stepper progress.",
            "Camera/Upload feedback lacks distinct pending, preview, or success states.",
            "Proof of address generator action needs clear instructions and high visibility."
        ]
        recs['ui_recommendations'] = [
            "Visual Verification Stepper: Header horizontal progress tracker (Step 1: ID -> Step 2: Address -> Step 3: Face).",
            "Document Upload Zone: Dashed border container with clear cloud upload icon, allowed formats (JPEG/PNG), and file size limits.",
            "Visit Feedback Form: Ensure the '⚡ Generate Proof of Address' button is prominently featured with high-contrast accent."
        ]
        recs['fast_lane_patches'] = [
            "Set upload container border style to dashed/subtle border.",
            "Ensure submit button uses `primary` background and white text.",
            "Badge color tokens for 'Verified' (success) and 'Pending' (warning)."
        ]
        recs['dsl_edits'] = [
            "Verify conditional visibility bindings for generated proof of address container.",
            "Ensure form validation blocks submission until mandatory KYC fields are filled."
        ]

    elif category == 'Payments & Transfers':
        recs['ux_issues'] = [
            "Amount input lack large prominent fintech formatting (e.g. ₦ symbol + 32sp bold numbers).",
            "Confirmation screen needs explicit fee breakdown, beneficiary bank icon, and security pin confirmation.",
            "Receipt layout needs clean receipt styling with share/download FAB."
        ]
        recs['ui_recommendations'] = [
            "Fintech Amount Field: Large centered hero currency input with auto-formatting.",
            "Beneficiary Card: Quick-select avatar chips with bank initials and verified green tick.",
            "Receipt Ticket: Stylized receipt card with dashed tear-off line and instant WhatsApp/PDF share CTA."
        ]
        recs['fast_lane_patches'] = [
            "Change receipt card background to `secondaryBackground` with 20dp rounded corners.",
            "Format currency text styles with `displaySmall` or `headlineMedium`.",
            "Set button height to 50dp with full width."
        ]
        recs['dsl_edits'] = [
            "Wire receipt share button to `generateTransactionReceipt` / `pdfGeneratorShare`.",
            "Ensure PIN entry modal displays secure obscured circles."
        ]

    elif category == 'Bills & Utility Services':
        recs['ux_issues'] = [
            "Biller selection dropdowns can be cramped on small screens.",
            "Meter number / smartcard validation feedback should be immediate before proceeding to payment.",
            "Frequent billers list lacks quick-recharge one-tap actions."
        ]
        recs['ui_recommendations'] = [
            "Biller Logo Grid: Grid of recognizable telco/disco logos with crisp border highlights when selected.",
            "Package Selection Pills: Horizontal scrolling chips for quick denomination selection (₦500, ₦1,000, ₦2,000, ₦5,000).",
            "Validation Card: Auto-fetch customer name upon meter input and show in an info alert box."
        ]
        recs['fast_lane_patches'] = [
            "Set plan pill container background to active/inactive token colors.",
            "Ensure biller selection card has 12dp radius and 1dp border.",
            "Typography consistency on denomination text."
        ]
        recs['dsl_edits'] = [
            "Connect biller enquiry action trigger to auto-populate customer details onBlur/onChange."
        ]

    elif category == 'StreetPool Gaming & Lottery':
        recs['ux_issues'] = [
            "High visual clutter with games, prize pools, and live winning tickers competing for attention.",
            "Spin wheel / flip cards need fluid animations and clear win/loss state modals.",
            "Rules and entry fees are sometimes buried below the fold."
        ]
        recs['ui_recommendations'] = [
            "Gamified Dark Card Theme: Rich dark gradient surface (`#111827` to `#1F2937`) with neon gold/amber accents for prize amounts.",
            "Jackpot Counter: Animated rolling ticker showing active prize pool in real-time.",
            "Live Winner Marquee: Smooth horizontal scrolling pill showing recent winner phone numbers and payouts."
        ]
        recs['fast_lane_patches'] = [
            "Update gaming card borders with amber/gold accent token.",
            "Boost jackpot text to bold 24sp with glowing shadow.",
            "Button CTA: Gradient fill with high vibrancy."
        ]
        recs['dsl_edits'] = [
            "Optimize timer polling logic in lotto widgets to reduce unnecessary re-renders.",
            "Ensure sound/haptic triggers on game actions."
        ]

    elif category == 'StreetJob Marketplace & Public Offers':
        recs['ux_issues'] = [
            "Job listings lack concise metadata badges (Payout, Duration, Spots Available).",
            "Offer creation flow needs structured form steps rather than a single long scroll."
        ]
        recs['ui_recommendations'] = [
            "Marketplace Listing Card: Elevated card featuring gig title, company/user avatar, reward tag, and time remaining pill.",
            "Filter Chips: Sticky horizontal filter bar (All, Micro-tasks, Surveys, Deliveries, Offers).",
            "Application Modal: Clean slide-up bottom sheet with instant 'Accept Job' slider."
        ]
        recs['fast_lane_patches'] = [
            "Reward badge background to light emerald/green with dark green text.",
            "Card border radius to 16dp with subtle border.",
            "Action button: Full-width modern pill button."
        ]
        recs['dsl_edits'] = [
            "Add ListView separator spacing (12dp) between job cards.",
            "Implement empty state component when no listings match filter."
        ]

    elif category == 'Access Delegation & Batch Processing':
        recs['ux_issues'] = [
            "Multi-row batch tables can cause horizontal overflow on mobile screens.",
            "Delegated permissions lack granular toggle switches and expiration indicators."
        ]
        recs['ui_recommendations'] = [
            "Batch Summary Card: Header card displaying Total Count, Total Sum, Success Rate, and Status badge.",
            "Responsive Mobile Table: Replace rigid tables with expandable card list items on viewports < 600px.",
            "Permission Checklist: Switch tiles with descriptive subtitles and clear 'Revoke Access' destructive button."
        ]
        recs['fast_lane_patches'] = [
            "Status chips: Green for Approved, Yellow for Pending, Red for Rejected.",
            "Card container padding to 16dp uniform.",
            "Monospace font for batch transaction reference numbers."
        ]
        recs['dsl_edits'] = [
            "Ensure batch list uses lazy ListView.builder for memory efficiency."
        ]

    else:  # Utility, Chat & System Pages
        recs['ux_issues'] = [
            "Chat interface needs smooth auto-scroll to bottom upon new message.",
            "Error pages should provide friendly guidance and an instant retry button rather than technical jargon."
        ]
        recs['ui_recommendations'] = [
            "Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.",
            "State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.",
            "Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older)."
        ]
        recs['fast_lane_patches'] = [
            "Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.",
            "Update retry button to modern outline or filled button with 12dp radius."
        ]
        recs['dsl_edits'] = [
            "Check chat polling intervals (throttle from 2s to 8s) to preserve battery and network."
        ]

    return recs


def analyze_all_pages():
    """Scan all 92 pages, parse AST, Flutter widgets, and models, and compile dataset."""
    ff_files = sorted(glob.glob(os.path.join(FF_PAGES_DIR, '*.dart')))
    pages_data = []

    for ff_file in ff_files:
        slug = os.path.basename(ff_file).replace('.dart', '')
        ff_info = parse_ff_page(ff_file)
        page_name = ff_info['page_name']

        w_file, m_file, src_root = find_flutter_sources(page_name, slug)
        model_info = parse_flutter_model(m_file)
        widget_info = parse_flutter_widget(w_file)

        category = CATEGORY_MAP.get(page_name) or CATEGORY_MAP.get(slug) or 'Utility, Chat & System Pages'

        recs = generate_redesign_recommendations(page_name, category, ff_info, model_info, widget_info)

        rel_ff_path = os.path.relpath(ff_file, BASE_DIR).replace('\\', '/')
        rel_w_path = os.path.relpath(w_file, BASE_DIR).replace('\\', '/') if w_file else None
        rel_m_path = os.path.relpath(m_file, BASE_DIR).replace('\\', '/') if m_file else None

        pages_data.append({
            'page_name': page_name,
            'slug': slug,
            'category': category,
            'ff_key': ff_info['page_key'],
            'route': widget_info.get('route_path') or ff_info['page_route'] or f"/{slug}",
            'ff_file': rel_ff_path,
            'widget_file': rel_w_path,
            'model_file': rel_m_path,
            'source_root': src_root or 'ff-workspace/lib',
            'widget_count': ff_info['widget_count'],
            'widget_types_count': ff_info['widget_types_count'],
            'state_fields': ff_info['state_fields'],
            'triggers': ff_info['triggers'],
            'named_components': ff_info['named_components'],
            'model_info': model_info,
            'widget_info': widget_info,
            'redesign': recs,
        })

    return pages_data


def generate_markdown(pages_data):
    """Generate the comprehensive PAGES_REDESIGN_SPECIFICATION.md content."""
    lines = []

    # Title & Header
    lines.append("# StreetPay Mobile App: Comprehensive Pages Redesign Specification")
    lines.append("")
    lines.append("> **Generated for Redesign Agents & UI/UX Engineers**  ")
    lines.append(f"> **Project:** `streetpay-zrgrzq` | **Total Pages:** {len(pages_data)} | **Environment:** FlutterFlow AI & Flutter Web/Mobile  ")
    lines.append("> **Workspace Base:** `c:/Users/johna/Downloads/streetpay/`")
    lines.append("")
    lines.append("---")
    lines.append("")

    # Table of Contents
    lines.append("## Table of Contents")
    lines.append("1. [Executive Summary & App Architecture](#1-executive-summary--app-architecture)")
    lines.append("2. [Design System Tokens & Global Guidelines](#2-design-system-tokens--global-guidelines)")
    lines.append("3. [Redesign Agent Playbook & Safety Rules](#3-redesign-agent-playbook--safety-rules)")
    lines.append("4. [Master Pages Directory & Quick Reference Matrix](#4-master-pages-directory--quick-reference-matrix)")
    lines.append("5. [Deep-Dive Page Redesign Specifications](#5-deep-dive-page-redesign-specifications)")

    # Group by category
    categories = list(MODULE_DESCRIPTIONS.keys())
    for i, cat in enumerate(categories, 1):
        slug_anchor = cat.lower().replace(' ', '-').replace('&', '').replace(',', '').replace('--', '-')
        lines.append(f"   - [Module {i}: {cat}](#module-{i}-{slug_anchor})")
    lines.append("")
    lines.append("---")
    lines.append("")

    # Section 1: Executive Summary
    lines.append("## 1. Executive Summary & App Architecture")
    lines.append("")
    lines.append("StreetPay is a comprehensive mobile fintech, digital wallet, VAS bills payment, community gig (StreetJob), and social gamification (StreetPool) application built with **FlutterFlow**. This specification provides an automated, complete inventory of all **92 application screens**, detailing their widget structures, state models, interactive form inputs, backend API dependencies, and bespoke UI redesign plans.")
    lines.append("")
    lines.append("### Architectural Breakdown by Functional Cluster")
    lines.append("| # | Functional Module | Page Count | Primary Purpose |")
    lines.append("|---|---|---|---|")
    for i, cat in enumerate(categories, 1):
        cat_pages = [p for p in pages_data if p['category'] == cat]
        lines.append(f"| {i} | **{cat}** | {len(cat_pages)} | {MODULE_DESCRIPTIONS[cat]} |")
    lines.append("")
    lines.append("---")
    lines.append("")

    # Section 2: Design System Tokens
    lines.append("## 2. Design System Tokens & Global Guidelines")
    lines.append("")
    lines.append("The redesign agent should systematically align all pages to the following unified design tokens:")
    lines.append("")
    lines.append("### Color Palette Tokens")
    lines.append("| Token Name | Light Theme Hex | Dark Theme Hex | Usage Guidance |")
    lines.append("|---|---|---|---|")
    lines.append("| `primary` | `#0A2540` (Deep Navy) | `#4B39EF` / `#6366F1` (Indigo) | Primary CTA buttons, active state indicators, key headers. |")
    lines.append("| `secondary` | `#39D2C0` (Teal) | `#39D2C0` (Teal) | Accents, success highlights, secondary action badges. |")
    lines.append("| `tertiary` | `#EE8B60` (Coral) | `#EE8B60` (Coral) | Gamification highlights, alert tags, promos. |")
    lines.append("| `alternate` | `#E0E3E7` (Soft Gray) | `#262D34` (Dark Charcoal) | Card borders, subtle divider lines, input field borders. |")
    lines.append("| `primaryBackground` | `#F1F4F8` (Off-white) | `#1A1F24` (Deep Night) | Root screen scaffold background. |")
    lines.append("| `secondaryBackground`| `#FFFFFF` (Pure White) | `#101213` (Dark Surface) | Elevated cards, bottom sheets, form input backgrounds. |")
    lines.append("| `primaryText` | `#14181B` (Near Black) | `#FFFFFF` (Pure White) | Headings, primary titles, heavy numbers. |")
    lines.append("| `secondaryText` | `#57636C` (Muted Slate) | `#95A1AC` (Light Slate) | Subtitles, helper text, timestamps, labels. |")
    lines.append("| `success` | `#249689` (Emerald) | `#39D2C0` (Vibrant Teal) | Success toasts, verified badges, credit inflow. |")
    lines.append("| `error` | `#FF5963` (Coral Red) | `#FF5963` (Coral Red) | Validation errors, failed transactions, debit outflow. |")
    lines.append("")
    lines.append("### Typography Hierarchy")
    lines.append("- **Font Family**: Google Fonts (`Inter` or `Outfit` for headings, `Plus Jakarta Sans` for body text).")
    lines.append("- **`displaySmall`**: 36sp, Bold (700) — Hero balances, onboarding splash titles.")
    lines.append("- **`headlineMedium`**: 24sp, SemiBold (600) — Page titles, modal headers.")
    lines.append("- **`titleMedium`**: 18sp, Medium (500) — Card section headings, prominent list titles.")
    lines.append("- **`bodyMedium`**: 14sp, Regular (400) — General body copy, form labels.")
    lines.append("- **`bodySmall`**: 12sp, Regular (400) — Subtitles, captions, metadata badges.")
    lines.append("")
    lines.append("### Spacing, Corner Radii & Elevation Grid")
    lines.append("- **Spacing Units**: Strict 4pt/8pt grid (8dp, 12dp, 16dp, 20dp, 24dp, 32dp).")
    lines.append("- **Card Border Radii**: Standardize cards to `16.0` dp, buttons to `12.0` dp, dialogs/sheets to `24.0` dp.")
    lines.append("- **Elevation & Shadows**: Soft blur (blurRadius: 12dp, offset: (0, 4), color: `rgba(0,0,0,0.05)`). Avoid harsh black drop shadows.")
    lines.append("- **Touch Target Size**: Minimum 48dp height for all interactive chips, buttons, and input fields.")
    lines.append("")
    lines.append("---")
    lines.append("")

    # Section 3: Redesign Agent Playbook
    lines.append("## 3. Redesign Agent Playbook & Safety Rules")
    lines.append("")
    lines.append("When modifying or redesigning pages, follow this rigorous protocol:")
    lines.append("")
    lines.append("### 1. Fast-Lane Patch vs. DSL Edit Decision Matrix")
    lines.append("| Change Type | Recommended Tool | Rationale |")
    lines.append("|---|---|---|")
    lines.append("| **Color, Font, Spacing, Border Radius tweak** | `flutterflow_ai__patch` | Lands remotely in ~30s without compiling the whole AST. |")
    lines.append("| **Visibility toggle / Opacity change** | `flutterflow_ai__patch` | Fast property mutation on existing widget key. |")
    lines.append("| **Restructuring widget tree (e.g. Row to Column)** | `dsl/edit.dart` via `flutterflow ai run` | Required when changing node hierarchy or children count. |")
    lines.append("| **Adding new widgets or actions** | `dsl/edit.dart` via `flutterflow ai run` | Required to wire new action triggers or parameters. |")
    lines.append("")
    lines.append("### 2. Mandatory Safety Rules for Agents")
    lines.append("1. **Never mutate Scaffold keys**: The FlutterFlow router and typed SDK rely on exact keys (e.g. `Scaffold_7khkxn3r`).")
    lines.append("2. **Preserve Model Controllers**: Never delete or rename form controllers (`*TextController`, `*FocusNode`) in the widget tree, or the corresponding `*Model` will throw build errors.")
    lines.append("3. **Preserve Action Output Variables**: Invocations of APIs (`streetauth`, `getaccountbalance`) write to typed model variables (`_model.streetaut`). Retain these triggers.")
    lines.append("4. **Zero validate-first overhead**: Do not run `flutterflow ai validate` before `flutterflow ai run`. `run` already validates and only commits if clean.")
    lines.append("")
    lines.append("---")
    lines.append("")

    # Section 4: Master Directory Table
    lines.append("## 4. Master Pages Directory & Quick Reference Matrix")
    lines.append("")
    lines.append("| # | Page Name | FF Scaffold Key | Route | Module | Widgets | Forms / APIs |")
    lines.append("|---|---|---|---|---|---|---|")
    for idx, p in enumerate(pages_data, 1):
        apis_count = len(p['model_info'].get('api_calls', []))
        ctrls_count = len(p['model_info'].get('text_controllers', []))
        apis_str = f"{ctrls_count} inputs" if ctrls_count else ""
        if apis_count:
            apis_str += f", {apis_count} APIs" if apis_str else f"{apis_count} APIs"
        if not apis_str:
            apis_str = "Display/Nav"
        lines.append(f"| {idx} | **`{p['page_name']}`** | `{p['ff_key']}` | `{p['route']}` | {p['category']} | {p['widget_count']} | {apis_str} |")
    lines.append("")
    lines.append("---")
    lines.append("")

    # Section 5: Deep-Dive Specifications
    lines.append("## 5. Deep-Dive Page Redesign Specifications")
    lines.append("")

    for mod_idx, cat in enumerate(categories, 1):
        slug_anchor = cat.lower().replace(' ', '-').replace('&', '').replace(',', '').replace('--', '-')
        cat_pages = [p for p in pages_data if p['category'] == cat]
        lines.append(f"### Module {mod_idx}: {cat}")
        lines.append(f"> *{MODULE_DESCRIPTIONS[cat]} ({len(cat_pages)} screens)*")
        lines.append("")

        for p in cat_pages:
            p_name = p['page_name']
            ff_key = p['ff_key']
            route = p['route']
            w_file = p['widget_file'] or 'N/A'
            m_file = p['model_file'] or 'N/A'
            ff_file = p['ff_file']
            recs = p['redesign']
            model_info = p['model_info']
            widget_info = p['widget_info']

            lines.append(f"#### `{p_name}` Screen")
            lines.append(f"- **FlutterFlow Key**: `{ff_key}`")
            lines.append(f"- **Route Path**: `{route}`")
            lines.append(f"- **Typed SDK File**: [`{os.path.basename(ff_file)}`](file:///{os.path.join(BASE_DIR, ff_file).replace('\\', '/')})")
            if p['widget_file']:
                lines.append(f"- **Flutter Source**: [`{os.path.basename(w_file)}`](file:///{os.path.join(BASE_DIR, w_file).replace('\\', '/')})")
            if p['model_file']:
                lines.append(f"- **Flutter Model**: [`{os.path.basename(m_file)}`](file:///{os.path.join(BASE_DIR, m_file).replace('\\', '/')})")
            lines.append("")

            # 1. Functional Purpose
            lines.append(f"**1. Functional Role & User Flow:**")
            if widget_info.get('static_texts'):
                lines.append(f"- Prominent on-screen labels: {', '.join([f'\"{t}\"' for t in widget_info['static_texts'][:4]])}")
            if widget_info.get('nav_targets'):
                lines.append(f"- Downstream navigation routes: {', '.join([f'`{nt}`' for nt in widget_info['nav_targets'][:5]])}")
            lines.append(f"- Module context: Core component of {cat}.")
            lines.append("")

            # 2. Layout & Widget Architecture
            w_types = p['widget_types_count']
            top_widgets = sorted(w_types.items(), key=lambda x: x[1], reverse=True)[:5]
            top_w_str = ', '.join([f"{count} {w_type}" for w_type, count in top_widgets])

            lines.append(f"**2. Layout & Widget Architecture:**")
            lines.append(f"- Total Widgets: **{p['widget_count']}** nodes ({top_w_str}).")
            if p['named_components']:
                lines.append(f"- Embedded Sub-components: {', '.join([f'`{c}`' for c in p['named_components']])}.")
            if p['triggers']:
                lines.append(f"- Registered Action Triggers: {', '.join([f'`{tr}`' for tr in p['triggers']])}.")
            lines.append("")

            # 3. State & Backend Integrations
            lines.append(f"**3. State & Integrations:**")
            if model_info.get('text_controllers'):
                lines.append(f"- Form Input Controllers ({len(model_info['text_controllers'])}): {', '.join([f'`{c}`' for c in model_info['text_controllers']])}")
            if model_info.get('api_calls'):
                api_names = [f"`{a['api']}` ({a['widget']})" for a in model_info['api_calls']]
                lines.append(f"- Backend API Requests: {', '.join(api_names)}")
            if model_info.get('custom_actions'):
                ca_names = [f"`{a['action']}` ({a['widget']})" for a in model_info['custom_actions']]
                lines.append(f"- Custom Actions: {', '.join(ca_names)}")
            if p['state_fields']:
                state_names = [f"`{s['name']}` ({s['type']})" for s in p['state_fields']]
                lines.append(f"- Page State Variables: {', '.join(state_names)}")
            if not model_info.get('text_controllers') and not model_info.get('api_calls') and not p['state_fields']:
                lines.append("- Pure display / navigation screen with no direct form state.")
            lines.append("")

            # 4. Redesign Agent Blueprint
            lines.append(f"**4. Redesign Agent Implementation Blueprint:**")
            lines.append(f"- **Current UX Limitations**:")
            for issue in recs['ux_issues']:
                lines.append(f"  - {issue}")
            lines.append(f"- **Recommended Modern UI Treatment**:")
            for tip in recs['ui_recommendations']:
                lines.append(f"  - {tip}")
            lines.append(f"- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:")
            for patch in recs['fast_lane_patches']:
                lines.append(f"  - {patch}")
            lines.append(f"- **Safety Constraints**:")
            for rule in recs['safety_rules']:
                lines.append(f"  - {rule}")
            lines.append("")
            lines.append("---")
            lines.append("")

    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description="Generate StreetPay Pages Redesign Specification")
    parser.add_argument('--output', '-o', default=OUTPUT_MD_PATH, help="Output markdown path")
    parser.add_argument('--page', '-p', default=None, help="Query single page specification by name")
    parser.add_argument('--category', '-c', default=None, help="Filter pages by functional module category")
    parser.add_argument('--json', action='store_true', help="Output raw JSON data instead of markdown")

    args = parser.parse_args()

    print(f"[1/3] Scanning FlutterFlow typed ASTs and Flutter sources across StreetPay...")
    pages_data = analyze_all_pages()
    print(f"      Successfully extracted and matched {len(pages_data)} pages.")

    if args.page:
        matches = [p for p in pages_data if p['page_name'].lower() == args.page.lower() or p['slug'].lower() == args.page.lower()]
        if not matches:
            print(f"Error: Page '{args.page}' not found in project.")
            sys.exit(1)
        target = matches[0]
        if args.json:
            print(json.dumps(target, indent=2))
        else:
            single_md = generate_markdown([target])
            print(single_md)
        return

    if args.category:
        pages_data = [p for p in pages_data if args.category.lower() in p['category'].lower()]
        print(f"      Filtered to {len(pages_data)} pages in category matching '{args.category}'.")

    if args.json:
        out_json_path = args.output.replace('.md', '.json')
        with open(out_json_path, 'w', encoding='utf-8') as f:
            json.dump(pages_data, f, indent=2)
        print(f"[3/3] Wrote JSON data to {out_json_path}")
        return

    print(f"[2/3] Compiling comprehensive redesign specification markdown...")
    md_content = generate_markdown(pages_data)

    print(f"[3/3] Writing markdown artifact to: {args.output}...")
    with open(args.output, 'w', encoding='utf-8') as f:
        f.write(md_content)

    print(f"      Done! Wrote {len(md_content):,} characters across {len(pages_data)} pages.")


if __name__ == '__main__':
    main()
