# StreetPay Mobile App: Comprehensive Pages Redesign Specification

> **Generated for Redesign Agents & UI/UX Engineers**  
> **Project:** `streetpay-zrgrzq` | **Total Pages:** 92 | **Environment:** FlutterFlow AI & Flutter Web/Mobile  
> **Workspace Base:** `c:/Users/johna/Downloads/streetpay/`

---

## Table of Contents
1. [Executive Summary & App Architecture](#1-executive-summary--app-architecture)
2. [Design System Tokens & Global Guidelines](#2-design-system-tokens--global-guidelines)
3. [Redesign Agent Playbook & Safety Rules](#3-redesign-agent-playbook--safety-rules)
4. [Master Pages Directory & Quick Reference Matrix](#4-master-pages-directory--quick-reference-matrix)
5. [Deep-Dive Page Redesign Specifications](#5-deep-dive-page-redesign-specifications)
   - [Module 1: Authentication & Onboarding](#module-1-authentication-onboarding)
   - [Module 2: Dashboard & Core Navigation](#module-2-dashboard-core-navigation)
   - [Module 3: KYC & Identity Verification](#module-3-kyc-identity-verification)
   - [Module 4: Payments & Transfers](#module-4-payments-transfers)
   - [Module 5: Bills & Utility Services](#module-5-bills-utility-services)
   - [Module 6: StreetPool Gaming & Lottery](#module-6-streetpool-gaming-lottery)
   - [Module 7: StreetJob Marketplace & Public Offers](#module-7-streetjob-marketplace-public-offers)
   - [Module 8: Access Delegation & Batch Processing](#module-8-access-delegation-batch-processing)
   - [Module 9: Utility, Chat & System Pages](#module-9-utility-chat-system-pages)

---

## 1. Executive Summary & App Architecture

StreetPay is a comprehensive mobile fintech, digital wallet, VAS bills payment, community gig (StreetJob), and social gamification (StreetPool) application built with **FlutterFlow**. This specification provides an automated, complete inventory of all **92 application screens**, detailing their widget structures, state models, interactive form inputs, backend API dependencies, and bespoke UI redesign plans.

### Architectural Breakdown by Functional Cluster
| # | Functional Module | Page Count | Primary Purpose |
|---|---|---|---|
| 1 | **Authentication & Onboarding** | 12 | Entry point, authentication, KYC pre-flight, and security credentials setup. |
| 2 | **Dashboard & Core Navigation** | 4 | Primary user hub, account balances, main action tiles, profile settings, and application preferences. |
| 3 | **KYC & Identity Verification** | 7 | Tier 1 to Tier 3 compliance, face verification, ID uploads, and address proof validation. |
| 4 | **Payments & Transfers** | 4 | Peer-to-peer wallet transfers, manual bank payouts, receipts, and payment confirmations. |
| 5 | **Bills & Utility Services** | 9 | VAS services including Airtime, Data, Electricity, Cable TV, Internet, Betting, and Exams. |
| 6 | **StreetPool Gaming & Lottery** | 16 | Social reward mechanisms, lottery spin/flip/quiz games, prize pools, and winner feeds. |
| 7 | **StreetJob Marketplace & Public Offers** | 8 | Community gig marketplace, coupon offers, ticket reservations, and earning programs. |
| 8 | **Access Delegation & Batch Processing** | 7 | Sub-account authorization, multi-party access delegations, and batch payroll/disbursements. |
| 9 | **Utility, Chat & System Pages** | 25 | Live customer support chat, empty states, network error fallbacks, maintenance, and transaction logs. |

---

## 2. Design System Tokens & Global Guidelines

The redesign agent should systematically align all pages to the following unified design tokens:

### Color Palette Tokens
| Token Name | Light Theme Hex | Dark Theme Hex | Usage Guidance |
|---|---|---|---|
| `primary` | `#0A2540` (Deep Navy) | `#4B39EF` / `#6366F1` (Indigo) | Primary CTA buttons, active state indicators, key headers. |
| `secondary` | `#39D2C0` (Teal) | `#39D2C0` (Teal) | Accents, success highlights, secondary action badges. |
| `tertiary` | `#EE8B60` (Coral) | `#EE8B60` (Coral) | Gamification highlights, alert tags, promos. |
| `alternate` | `#E0E3E7` (Soft Gray) | `#262D34` (Dark Charcoal) | Card borders, subtle divider lines, input field borders. |
| `primaryBackground` | `#F1F4F8` (Off-white) | `#1A1F24` (Deep Night) | Root screen scaffold background. |
| `secondaryBackground`| `#FFFFFF` (Pure White) | `#101213` (Dark Surface) | Elevated cards, bottom sheets, form input backgrounds. |
| `primaryText` | `#14181B` (Near Black) | `#FFFFFF` (Pure White) | Headings, primary titles, heavy numbers. |
| `secondaryText` | `#57636C` (Muted Slate) | `#95A1AC` (Light Slate) | Subtitles, helper text, timestamps, labels. |
| `success` | `#249689` (Emerald) | `#39D2C0` (Vibrant Teal) | Success toasts, verified badges, credit inflow. |
| `error` | `#FF5963` (Coral Red) | `#FF5963` (Coral Red) | Validation errors, failed transactions, debit outflow. |

### Typography Hierarchy
- **Font Family**: Google Fonts (`Inter` or `Outfit` for headings, `Plus Jakarta Sans` for body text).
- **`displaySmall`**: 36sp, Bold (700) — Hero balances, onboarding splash titles.
- **`headlineMedium`**: 24sp, SemiBold (600) — Page titles, modal headers.
- **`titleMedium`**: 18sp, Medium (500) — Card section headings, prominent list titles.
- **`bodyMedium`**: 14sp, Regular (400) — General body copy, form labels.
- **`bodySmall`**: 12sp, Regular (400) — Subtitles, captions, metadata badges.

### Spacing, Corner Radii & Elevation Grid
- **Spacing Units**: Strict 4pt/8pt grid (8dp, 12dp, 16dp, 20dp, 24dp, 32dp).
- **Card Border Radii**: Standardize cards to `16.0` dp, buttons to `12.0` dp, dialogs/sheets to `24.0` dp.
- **Elevation & Shadows**: Soft blur (blurRadius: 12dp, offset: (0, 4), color: `rgba(0,0,0,0.05)`). Avoid harsh black drop shadows.
- **Touch Target Size**: Minimum 48dp height for all interactive chips, buttons, and input fields.

---

## 3. Redesign Agent Playbook & Safety Rules

When modifying or redesigning pages, follow this rigorous protocol:

### 1. Fast-Lane Patch vs. DSL Edit Decision Matrix
| Change Type | Recommended Tool | Rationale |
|---|---|---|
| **Color, Font, Spacing, Border Radius tweak** | `flutterflow_ai__patch` | Lands remotely in ~30s without compiling the whole AST. |
| **Visibility toggle / Opacity change** | `flutterflow_ai__patch` | Fast property mutation on existing widget key. |
| **Restructuring widget tree (e.g. Row to Column)** | `dsl/edit.dart` via `flutterflow ai run` | Required when changing node hierarchy or children count. |
| **Adding new widgets or actions** | `dsl/edit.dart` via `flutterflow ai run` | Required to wire new action triggers or parameters. |

### 2. Mandatory Safety Rules for Agents
1. **Never mutate Scaffold keys**: The FlutterFlow router and typed SDK rely on exact keys (e.g. `Scaffold_7khkxn3r`).
2. **Preserve Model Controllers**: Never delete or rename form controllers (`*TextController`, `*FocusNode`) in the widget tree, or the corresponding `*Model` will throw build errors.
3. **Preserve Action Output Variables**: Invocations of APIs (`streetauth`, `getaccountbalance`) write to typed model variables (`_model.streetaut`). Retain these triggers.
4. **Zero validate-first overhead**: Do not run `flutterflow ai validate` before `flutterflow ai run`. `run` already validates and only commits if clean.

---

## 4. Master Pages Directory & Quick Reference Matrix

| # | Page Name | FF Scaffold Key | Route | Module | Widgets | Forms / APIs |
|---|---|---|---|---|---|---|
| 1 | **`AccountSettings`** | `Scaffold_82igl7bp` | `/accountSettings` | Utility, Chat & System Pages | 11 | Display/Nav |
| 2 | **`accountdetails`** | `Scaffold_fh940xdq` | `/accountdetails` | Payments & Transfers | 55 | 1 APIs |
| 3 | **`airtimeform`** | `Scaffold_yduy0sb6` | `/airtimeform` | Bills & Utility Services | 20 | 2 inputs, 2 APIs |
| 4 | **`allwinners`** | `Scaffold_39hlvw73` | `/allwinners` | StreetPool Gaming & Lottery | 37 | 2 APIs |
| 5 | **`AppSettings`** | `Scaffold_7xiev2sa` | `/appSettings` | Utility, Chat & System Pages | 8 | 1 APIs |
| 6 | **`autodicover`** | `Scaffold_oju5fvj1` | `/autodicover` | Access Delegation & Batch Processing | 1 | Display/Nav |
| 7 | **`autodiscover1`** | `Scaffold_b89emkjk` | `/autodiscover1` | Access Delegation & Batch Processing | 6 | Display/Nav |
| 8 | **`batchsingle`** | `Scaffold_c49686h8` | `/batchsingle` | Access Delegation & Batch Processing | 25 | Display/Nav |
| 9 | **`BillPayment`** | `Scaffold_ut0mmr1a` | `/billPayment` | Utility, Chat & System Pages | 15 | 2 inputs, 4 APIs |
| 10 | **`BillPosting`** | `Scaffold_ihwe1lss` | `/billPosting` | Utility, Chat & System Pages | 15 | 3 inputs, 2 APIs |
| 11 | **`BillSuccess`** | `Scaffold_lwwg8ip8` | `/billSuccess` | Utility, Chat & System Pages | 8 | Display/Nav |
| 12 | **`billlbetting`** | `Scaffold_yn0d6x8k` | `/billlbetting` | Bills & Utility Services | 23 | 3 inputs, 9 APIs |
| 13 | **`billlcabletv`** | `Scaffold_nksj3w6q` | `/billlcabletv` | Bills & Utility Services | 24 | 3 inputs, 7 APIs |
| 14 | **`billlelectricity`** | `Scaffold_s910w8x6` | `/billlelectricity` | Bills & Utility Services | 25 | 4 inputs, 9 APIs |
| 15 | **`billlexam`** | `Scaffold_vfzofwai` | `/billlexam` | Bills & Utility Services | 25 | 5 inputs, 9 APIs |
| 16 | **`billlinternet`** | `Scaffold_7t84hf5j` | `/billlinternet` | Bills & Utility Services | 23 | 3 inputs, 7 APIs |
| 17 | **`billnew`** | `Scaffold_yod83oxc` | `/billnew` | Bills & Utility Services | 30 | 5 APIs |
| 18 | **`bvnverification`** | `Scaffold_5f6mk7fd` | `/bvnverification` | Authentication & Onboarding | 8 | 1 inputs |
| 19 | **`changepassword`** | `Scaffold_f5ucflsa` | `/changepassword` | Utility, Chat & System Pages | 16 | 2 inputs, 2 APIs |
| 20 | **`chat`** | `Scaffold_id8tg8p6` | `/chat` | Utility, Chat & System Pages | 3 | Display/Nav |
| 21 | **`consentfield`** | `Scaffold_qroxffjc` | `/consentfield` | KYC & Identity Verification | 15 | 2 APIs |
| 22 | **`contactus`** | `Scaffold_ng9llmq6` | `/contactus` | Utility, Chat & System Pages | 40 | Display/Nav |
| 23 | **`couponpay`** | `Scaffold_8o6n264m` | `/couponpay` | Utility, Chat & System Pages | 54 | 1 inputs, 1 APIs |
| 24 | **`couponreceipt`** | `Scaffold_rdzyreog` | `/couponreceipt` | Utility, Chat & System Pages | 26 | Display/Nav |
| 25 | **`createoffer`** | `Scaffold_8cwmnle9` | `/createoffer` | StreetJob Marketplace & Public Offers | 54 | 8 inputs, 4 APIs |
| 26 | **`datapayment`** | `Scaffold_7gr1je8z` | `/datapayment` | Bills & Utility Services | 184 | 1 inputs, 3 APIs |
| 27 | **`earnwithus`** | `Scaffold_rz2l8a1g` | `/earnwithus` | StreetJob Marketplace & Public Offers | 111 | 1 inputs, 8 APIs |
| 28 | **`editprofile`** | `Scaffold_qutx8khf` | `/editprofile` | Dashboard & Core Navigation | 29 | 3 inputs, 1 APIs |
| 29 | **`EmptyProfile`** | `Scaffold_vi3w48ol` | `/emptyProfile` | Utility, Chat & System Pages | 15 | 2 inputs, 10 APIs |
| 30 | **`EmptyProfileface`** | `Scaffold_qdfkrt4z` | `/emptyProfileface` | Utility, Chat & System Pages | 15 | 2 inputs, 10 APIs |
| 31 | **`errorpage`** | `Scaffold_0vib6l00` | `/errorpage` | Utility, Chat & System Pages | 10 | Display/Nav |
| 32 | **`faceverify`** | `Scaffold_g98kwvl4` | `/faceverify` | KYC & Identity Verification | 11 | 1 APIs |
| 33 | **`fundsharing`** | `Scaffold_2va0jv9y` | `/fundsharing` | StreetPool Gaming & Lottery | 46 | Display/Nav |
| 34 | **`givwaway`** | `Scaffold_dbv7cnmo` | `/givwaway` | StreetPool Gaming & Lottery | 69 | 3 inputs, 3 APIs |
| 35 | **`grant_access`** | `Scaffold_mwqkfzgu` | `/grantAccess` | Access Delegation & Batch Processing | 30 | 4 APIs |
| 36 | **`historyflip`** | `Scaffold_h6bfv1rq` | `/historyflip` | StreetPool Gaming & Lottery | 54 | 2 APIs |
| 37 | **`historyguess`** | `Scaffold_2nrgm69s` | `/historyguess` | StreetPool Gaming & Lottery | 53 | 2 APIs |
| 38 | **`historyquiz`** | `Scaffold_l5jsyxnd` | `/historyquiz` | StreetPool Gaming & Lottery | 58 | 2 APIs |
| 39 | **`historyspin`** | `Scaffold_ahvvyngz` | `/historyspin` | StreetPool Gaming & Lottery | 53 | 2 APIs |
| 40 | **`IDUpload`** | `Scaffold_wtkmarkj` | `/idupload` | KYC & Identity Verification | 27 | Display/Nav |
| 41 | **`keyboardnew`** | `Scaffold_f18ugym1` | `/keyboardnew` | Bills & Utility Services | 39 | Display/Nav |
| 42 | **`kycpaggge`** | `Scaffold_7khkxn3r` | `/kycpaggge` | KYC & Identity Verification | 174 | 6 inputs, 5 APIs |
| 43 | **`Login1`** | `Scaffold_jn8lilyl` | `/login1` | Authentication & Onboarding | 22 | 2 inputs, 3 APIs |
| 44 | **`Loginbiometric`** | `Scaffold_4nbb39wi` | `/loginbiometric` | Authentication & Onboarding | 24 | 1 inputs, 4 APIs |
| 45 | **`lottery`** | `Scaffold_vm67oeiv` | `/lottery` | StreetPool Gaming & Lottery | 49 | 7 APIs |
| 46 | **`lottoflip`** | `Scaffold_whiv7k96` | `/lottoflip` | StreetPool Gaming & Lottery | 24 | 5 APIs |
| 47 | **`lottoguess`** | `Scaffold_cawrntdl` | `/lottoguess` | StreetPool Gaming & Lottery | 34 | 3 APIs |
| 48 | **`lottohome`** | `Scaffold_0wa4fcll` | `/lottohome` | StreetPool Gaming & Lottery | 45 | Display/Nav |
| 49 | **`lottoquiz`** | `Scaffold_9r63u1ue` | `/lottoquiz` | StreetPool Gaming & Lottery | 52 | 2 APIs |
| 50 | **`lottospin`** | `Scaffold_rg56nxmm` | `/lottospin` | StreetPool Gaming & Lottery | 17 | 3 APIs |
| 51 | **`mainteinance`** | `Scaffold_lntjr40l` | `/mainteinance` | Utility, Chat & System Pages | 23 | Display/Nav |
| 52 | **`ManualPayment`** | `Scaffold_xapkpyhx` | `/manualPayment` | Utility, Chat & System Pages | 26 | 4 inputs, 6 APIs |
| 53 | **`newhome`** | `Scaffold_46jy1b4u` | `/newhome` | Dashboard & Core Navigation | 106 | 1 inputs, 10 APIs |
| 54 | **`nointernet`** | `Scaffold_yk7fei9x` | `/nointernet` | Utility, Chat & System Pages | 22 | Display/Nav |
| 55 | **`offerdetail`** | `Scaffold_0qjw5reg` | `/offerdetail` | StreetJob Marketplace & Public Offers | 6 | Display/Nav |
| 56 | **`Onboarding`** | `Scaffold_x4apvzmh` | `/onboarding1` | Authentication & Onboarding | 12 | 2 APIs |
| 57 | **`openwallet`** | `Scaffold_otuk2urm` | `/openwallet` | Payments & Transfers | 24 | 5 inputs, 7 APIs |
| 58 | **`Payment`** | `Scaffold_d3q2v8u6` | `/payment` | Payments & Transfers | 16 | 2 inputs, 2 APIs |
| 59 | **`PaymentConfirmation`** | `Scaffold_3xj8ff4w` | `/paymentConfirmation` | Utility, Chat & System Pages | 25 | 12 APIs |
| 60 | **`PaymentReceipt`** | `Scaffold_un349561` | `/paymentReceipt` | Utility, Chat & System Pages | 22 | Display/Nav |
| 61 | **`PaymentSuccess`** | `Scaffold_pg90z7hy` | `/paymentSuccess` | Utility, Chat & System Pages | 10 | Display/Nav |
| 62 | **`PhoneVerification`** | `Scaffold_qwgto7x1` | `/phoneVerification` | Authentication & Onboarding | 12 | 1 inputs, 2 APIs |
| 63 | **`PhonereVerification`** | `Scaffold_n9g3i55h` | `/phonereVerification` | Authentication & Onboarding | 12 | 1 inputs, 4 APIs |
| 64 | **`PinCodeSetup`** | `Scaffold_ou0gynt5` | `/pinCodeSetup` | Authentication & Onboarding | 5 | 1 inputs, 1 APIs |
| 65 | **`premiumconsent`** | `Scaffold_tik5eri8` | `/premiumconsent` | Utility, Chat & System Pages | 24 | 1 inputs |
| 66 | **`Profile`** | `Scaffold_r303r6y1` | `/profile` | Dashboard & Core Navigation | 21 | 2 APIs |
| 67 | **`publicoffer`** | `Scaffold_6zbqqv80` | `/publicoffer` | StreetJob Marketplace & Public Offers | 80 | 1 inputs, 7 APIs |
| 68 | **`Questionaire`** | `Scaffold_8gokuo0e` | `/questionaire` | StreetJob Marketplace & Public Offers | 17 | 3 inputs, 2 APIs |
| 69 | **`registrationsuccess`** | `Scaffold_wwqy131q` | `/registrationsuccess` | Authentication & Onboarding | 36 | Display/Nav |
| 70 | **`resetpassword`** | `Scaffold_sx4f6tei` | `/resetpassword` | Authentication & Onboarding | 38 | 6 inputs, 7 APIs |
| 71 | **`resultsummary`** | `Scaffold_yt9l0n27` | `/resultsummary` | StreetPool Gaming & Lottery | 77 | Display/Nav |
| 72 | **`retrivedetails`** | `Scaffold_f62ldnaa` | `/retrivedetails` | Utility, Chat & System Pages | 16 | 1 inputs |
| 73 | **`secureuser`** | `Scaffold_4lpap9os` | `/secureuser` | Access Delegation & Batch Processing | 47 | 1 inputs, 5 APIs |
| 74 | **`settingpage`** | `Scaffold_5ps4zyqh` | `/settingpage` | Dashboard & Core Navigation | 59 | 1 APIs |
| 75 | **`SignUp`** | `Scaffold_ycxxojz5` | `/signUp` | Authentication & Onboarding | 20 | Display/Nav |
| 76 | **`Splash`** | `Scaffold_931vwhyr` | `/splash_screen` | Authentication & Onboarding | 12 | Display/Nav |
| 77 | **`streetjob`** | `Scaffold_qig9lu90` | `/streetjob` | StreetJob Marketplace & Public Offers | 104 | 1 inputs |
| 78 | **`streetjob2`** | `Scaffold_03vevgdq` | `/streetjob2` | StreetJob Marketplace & Public Offers | 25 | 1 inputs, 2 APIs |
| 79 | **`streetpollpay`** | `Scaffold_s3u0s3zv` | `/streetpollpay` | StreetPool Gaming & Lottery | 32 | 3 APIs |
| 80 | **`streetpoolresult`** | `Scaffold_ryvv6t7l` | `/streetpoolresult` | StreetPool Gaming & Lottery | 39 | Display/Nav |
| 81 | **`streetshareinto`** | `Scaffold_kcu18aiy` | `/streetshareinto` | Utility, Chat & System Pages | 53 | Display/Nav |
| 82 | **`teirpage`** | `Scaffold_hht11j40` | `/teirpage` | Payments & Transfers | 92 | 3 APIs |
| 83 | **`testpage`** | `Scaffold_r3p3f58v` | `/testpage` | Utility, Chat & System Pages | 10 | Display/Nav |
| 84 | **`tickectbooking`** | `Scaffold_k85nksxr` | `/tickectbooking` | StreetJob Marketplace & Public Offers | 40 | 2 inputs |
| 85 | **`TransactionHistory`** | `Scaffold_gzy55p1j` | `/transactionHistory` | Utility, Chat & System Pages | 34 | 2 APIs |
| 86 | **`TransactionHistorybatches`** | `Scaffold_7swwi1o0` | `/transactionHistorybatches` | Utility, Chat & System Pages | 18 | 1 APIs |
| 87 | **`upgradetotier2`** | `Scaffold_hzn66n9r` | `/upgradetotier2` | KYC & Identity Verification | 42 | 8 inputs, 6 APIs |
| 88 | **`upgradetotier3`** | `Scaffold_smy7lrxt` | `/upgradetotier3` | KYC & Identity Verification | 21 | 2 inputs, 3 APIs |
| 89 | **`uplooaaad`** | `Scaffold_oqvux2uh` | `/uplooaaad` | KYC & Identity Verification | 80 | Display/Nav |
| 90 | **`viewbatch`** | `Scaffold_kl48ff6y` | `/viewbatch` | Access Delegation & Batch Processing | 27 | Display/Nav |
| 91 | **`viewmyacces`** | `Scaffold_xrcu0fqv` | `/viewmyacces` | Access Delegation & Batch Processing | 25 | 2 APIs |
| 92 | **`Welcome`** | `Scaffold_jjaut9bu` | `/welcome` | Authentication & Onboarding | 37 | Display/Nav |

---

## 5. Deep-Dive Page Redesign Specifications

### Module 1: Authentication & Onboarding
> *Entry point, authentication, KYC pre-flight, and security credentials setup. (12 screens)*

#### `bvnverification` Screen
- **FlutterFlow Key**: `Scaffold_5f6mk7fd`
- **Route Path**: `/bvnverification`
- **Typed SDK File**: [`bvnverification.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/bvnverification.dart)
- **Flutter Source**: [`bvnverification_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/bvnverification/bvnverification_widget.dart)
- **Flutter Model**: [`bvnverification_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/bvnverification/bvnverification_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Enter OTP code", "We sent you an OTP code", "to your phone number: "
- Module context: Core component of Authentication & Onboarding.

**2. Layout & Widget Architecture:**
- Total Widgets: **8** nodes (4 Text, 1 Scaffold, 1 Column, 1 Row, 1 PinCode).

**3. State & Integrations:**
- Form Input Controllers (1): `pinCodeController`
- Page State Variables: `error` (String)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Dense vertical stack with potential keyboard overlap on smaller devices.
  - Lack of inline credential validation feedback before button submission.
  - Primary CTA button may blend into background if contrast tokens are uncurated.
- **Recommended Modern UI Treatment**:
  - Modern card grouping: Wrap credentials in a clean 16dp radius elevated card with subtle border `alternate`.
  - Touch ergonomics: Minimum 52dp height for all text fields and primary submit button.
  - Visual hierarchy: Emphasize 28sp headline with Inter/Outfit typography, followed by a muted subtitle1.
  - Security cues: Add subtle padlock or biometric iconography to reassure users during credential input.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Button border radius to 12dp or 16dp (`borderRadius: 16`).
  - Input field fill colors using `secondaryBackground` token.
  - Update primary button font weight to SemiBold (600) and fontSize to 16.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_5f6mk7fd`.
  - Preserve all 1 TextEditingController bindings: `pinCodeController`.

---

#### `Login1` Screen
- **FlutterFlow Key**: `Scaffold_jn8lilyl`
- **Route Path**: `/login1`
- **Typed SDK File**: [`login1.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/login1.dart)
- **Flutter Source**: [`login1_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/login1/login1_widget.dart)
- **Flutter Model**: [`login1_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/login1/login1_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Welcome Back", "Let\"
- Module context: Core component of Authentication & Onboarding.

**2. Layout & Widget Architecture:**
- Total Widgets: **22** nodes (5 Container, 4 RichTextSpan, 3 Column, 2 Text, 2 TextField).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (2): `emailAddressTextController`, `passwordTextController`
- Backend API Requests: `streetauth` (Button), `ispincodevalid` (Button), `gettempid` (Button)
- Custom Actions: `getdeviceid` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Dense vertical stack with potential keyboard overlap on smaller devices.
  - Lack of inline credential validation feedback before button submission.
  - Primary CTA button may blend into background if contrast tokens are uncurated.
- **Recommended Modern UI Treatment**:
  - Modern card grouping: Wrap credentials in a clean 16dp radius elevated card with subtle border `alternate`.
  - Touch ergonomics: Minimum 52dp height for all text fields and primary submit button.
  - Visual hierarchy: Emphasize 28sp headline with Inter/Outfit typography, followed by a muted subtitle1.
  - Security cues: Add subtle padlock or biometric iconography to reassure users during credential input.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Button border radius to 12dp or 16dp (`borderRadius: 16`).
  - Input field fill colors using `secondaryBackground` token.
  - Update primary button font weight to SemiBold (600) and fontSize to 16.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_jn8lilyl`.
  - Preserve all 2 TextEditingController bindings: `emailAddressTextController`, `passwordTextController`.
  - Retain Backend API action chains for: `streetauth`, `ispincodevalid`, `gettempid`.
  - Preserve Custom Action invocations: `getdeviceid`.

---

#### `Loginbiometric` Screen
- **FlutterFlow Key**: `Scaffold_4nbb39wi`
- **Route Path**: `/loginbiometric`
- **Typed SDK File**: [`loginbiometric.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/loginbiometric.dart)
- **Flutter Source**: [`loginbiometric_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/loginbiometric/loginbiometric_widget.dart)
- **Flutter Model**: [`loginbiometric_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/loginbiometric/loginbiometric_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Failed to authenticate", "Welcome Back"
- Module context: Core component of Authentication & Onboarding.

**2. Layout & Widget Architecture:**
- Total Widgets: **24** nodes (6 RichTextSpan, 4 Container, 3 Column, 3 RichText, 2 Row).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (1): `passwordTextController`
- Backend API Requests: `returntierprofile` (Loginbiometric), `ispincodevalid` (Button), `locationdetect` (Button), `locationdetect` (Button)
- Custom Actions: `getdeviceid` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Dense vertical stack with potential keyboard overlap on smaller devices.
  - Lack of inline credential validation feedback before button submission.
  - Primary CTA button may blend into background if contrast tokens are uncurated.
- **Recommended Modern UI Treatment**:
  - Modern card grouping: Wrap credentials in a clean 16dp radius elevated card with subtle border `alternate`.
  - Touch ergonomics: Minimum 52dp height for all text fields and primary submit button.
  - Visual hierarchy: Emphasize 28sp headline with Inter/Outfit typography, followed by a muted subtitle1.
  - Security cues: Add subtle padlock or biometric iconography to reassure users during credential input.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Button border radius to 12dp or 16dp (`borderRadius: 16`).
  - Input field fill colors using `secondaryBackground` token.
  - Update primary button font weight to SemiBold (600) and fontSize to 16.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_4nbb39wi`.
  - Preserve all 1 TextEditingController bindings: `passwordTextController`.
  - Retain Backend API action chains for: `returntierprofile`, `ispincodevalid`, `locationdetect`.
  - Preserve Custom Action invocations: `getdeviceid`.

---

#### `Onboarding` Screen
- **FlutterFlow Key**: `Scaffold_x4apvzmh`
- **Route Path**: `/onboarding1`
- **Typed SDK File**: [`onboarding.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/onboarding.dart)
- **Flutter Source**: [`onboarding_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/onboarding/onboarding_widget.dart)
- **Flutter Model**: [`onboarding_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/onboarding/onboarding_model.dart)

**1. Functional Role & User Flow:**
- Module context: Core component of Authentication & Onboarding.

**2. Layout & Widget Architecture:**
- Total Widgets: **12** nodes (3 PlaceholderWidget, 3 Container, 2 Row, 1 Scaffold, 1 Column).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `streetauth` (Button), `getUPDATE` (Button)
- Custom Actions: `getappversion` (Button), `getdeviceid` (Button), `getdeviceid` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Dense vertical stack with potential keyboard overlap on smaller devices.
  - Lack of inline credential validation feedback before button submission.
  - Primary CTA button may blend into background if contrast tokens are uncurated.
- **Recommended Modern UI Treatment**:
  - Modern card grouping: Wrap credentials in a clean 16dp radius elevated card with subtle border `alternate`.
  - Touch ergonomics: Minimum 52dp height for all text fields and primary submit button.
  - Visual hierarchy: Emphasize 28sp headline with Inter/Outfit typography, followed by a muted subtitle1.
  - Security cues: Add subtle padlock or biometric iconography to reassure users during credential input.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Button border radius to 12dp or 16dp (`borderRadius: 16`).
  - Input field fill colors using `secondaryBackground` token.
  - Update primary button font weight to SemiBold (600) and fontSize to 16.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_x4apvzmh`.
  - Retain Backend API action chains for: `streetauth`, `getUPDATE`.
  - Preserve Custom Action invocations: `getappversion`, `getdeviceid`, `getdeviceid`.

---

#### `PhoneVerification` Screen
- **FlutterFlow Key**: `Scaffold_qwgto7x1`
- **Route Path**: `/phoneVerification`
- **Typed SDK File**: [`phone_verification.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/phone_verification.dart)
- **Flutter Source**: [`phone_verification_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/phone_verification/phone_verification_widget.dart)
- **Flutter Model**: [`phone_verification_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/phone_verification/phone_verification_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Enter OTP code", "We sent you an OTP code", "to your phone number: ", "Resend OTP "
- Module context: Core component of Authentication & Onboarding.

**2. Layout & Widget Architecture:**
- Total Widgets: **12** nodes (6 Text, 2 Row, 1 Scaffold, 1 Column, 1 PinCode).
- Registered Action Triggers: `ON_PINCODE_COMPLETE`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (1): `pinCodeController`
- Backend API Requests: `verifyphone` (PinCode), `getotpfromphone` (Text)
- Page State Variables: `error` (String)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Dense vertical stack with potential keyboard overlap on smaller devices.
  - Lack of inline credential validation feedback before button submission.
  - Primary CTA button may blend into background if contrast tokens are uncurated.
- **Recommended Modern UI Treatment**:
  - Modern card grouping: Wrap credentials in a clean 16dp radius elevated card with subtle border `alternate`.
  - Touch ergonomics: Minimum 52dp height for all text fields and primary submit button.
  - Visual hierarchy: Emphasize 28sp headline with Inter/Outfit typography, followed by a muted subtitle1.
  - Security cues: Add subtle padlock or biometric iconography to reassure users during credential input.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Button border radius to 12dp or 16dp (`borderRadius: 16`).
  - Input field fill colors using `secondaryBackground` token.
  - Update primary button font weight to SemiBold (600) and fontSize to 16.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_qwgto7x1`.
  - Preserve all 1 TextEditingController bindings: `pinCodeController`.
  - Retain Backend API action chains for: `verifyphone`, `getotpfromphone`.

---

#### `PhonereVerification` Screen
- **FlutterFlow Key**: `Scaffold_n9g3i55h`
- **Route Path**: `/phonereVerification`
- **Typed SDK File**: [`phonere_verification.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/phonere_verification.dart)
- **Flutter Source**: [`phonere_verification_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/phonere_verification/phonere_verification_widget.dart)
- **Flutter Model**: [`phonere_verification_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/phonere_verification/phonere_verification_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Enter OTP code", "We sent you an OTP code", "to your phone number: ", "Invalid OTP"
- Module context: Core component of Authentication & Onboarding.

**2. Layout & Widget Architecture:**
- Total Widgets: **12** nodes (6 Text, 2 Row, 1 Scaffold, 1 Column, 1 PinCode).
- Registered Action Triggers: `ON_PINCODE_COMPLETE`, `ON_TAP`, `ON_FOCUS_CHANGE`.

**3. State & Integrations:**
- Form Input Controllers (1): `pinCodeController`
- Backend API Requests: `streetauth` (PinCode), `reverifyotp` (PinCode), `returntierprofile` (PinCode), `getotpfromphone` (Text)
- Page State Variables: `error` (String)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Dense vertical stack with potential keyboard overlap on smaller devices.
  - Lack of inline credential validation feedback before button submission.
  - Primary CTA button may blend into background if contrast tokens are uncurated.
- **Recommended Modern UI Treatment**:
  - Modern card grouping: Wrap credentials in a clean 16dp radius elevated card with subtle border `alternate`.
  - Touch ergonomics: Minimum 52dp height for all text fields and primary submit button.
  - Visual hierarchy: Emphasize 28sp headline with Inter/Outfit typography, followed by a muted subtitle1.
  - Security cues: Add subtle padlock or biometric iconography to reassure users during credential input.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Button border radius to 12dp or 16dp (`borderRadius: 16`).
  - Input field fill colors using `secondaryBackground` token.
  - Update primary button font weight to SemiBold (600) and fontSize to 16.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_n9g3i55h`.
  - Preserve all 1 TextEditingController bindings: `pinCodeController`.
  - Retain Backend API action chains for: `streetauth`, `reverifyotp`, `returntierprofile`.

---

#### `PinCodeSetup` Screen
- **FlutterFlow Key**: `Scaffold_ou0gynt5`
- **Route Path**: `/pinCodeSetup`
- **Typed SDK File**: [`pin_code_setup.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/pin_code_setup.dart)
- **Flutter Source**: [`pin_code_setup_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/pin_code_setup/pin_code_setup_widget.dart)
- **Flutter Model**: [`pin_code_setup_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/pin_code_setup/pin_code_setup_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Set Pin Code", "Please set your own 5 digits pin code"
- Module context: Core component of Authentication & Onboarding.

**2. Layout & Widget Architecture:**
- Total Widgets: **5** nodes (2 Text, 1 Scaffold, 1 Column, 1 PinCode).
- Registered Action Triggers: `ON_PINCODE_COMPLETE`.

**3. State & Integrations:**
- Form Input Controllers (1): `pinCodeController`
- Backend API Requests: `setpincode` (PinCode)
- Page State Variables: `profileOpeningRequest` (JSON)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Dense vertical stack with potential keyboard overlap on smaller devices.
  - Lack of inline credential validation feedback before button submission.
  - Primary CTA button may blend into background if contrast tokens are uncurated.
- **Recommended Modern UI Treatment**:
  - Modern card grouping: Wrap credentials in a clean 16dp radius elevated card with subtle border `alternate`.
  - Touch ergonomics: Minimum 52dp height for all text fields and primary submit button.
  - Visual hierarchy: Emphasize 28sp headline with Inter/Outfit typography, followed by a muted subtitle1.
  - Security cues: Add subtle padlock or biometric iconography to reassure users during credential input.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Button border radius to 12dp or 16dp (`borderRadius: 16`).
  - Input field fill colors using `secondaryBackground` token.
  - Update primary button font weight to SemiBold (600) and fontSize to 16.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_ou0gynt5`.
  - Preserve all 1 TextEditingController bindings: `pinCodeController`.
  - Retain Backend API action chains for: `setpincode`.

---

#### `registrationsuccess` Screen
- **FlutterFlow Key**: `Scaffold_wwqy131q`
- **Route Path**: `/registrationsuccess`
- **Typed SDK File**: [`registrationsuccess.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/registrationsuccess.dart)
- **Flutter Source**: [`registrationsuccess_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/registrationsuccess/registrationsuccess_widget.dart)
- **Flutter Model**: [`registrationsuccess_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/registrationsuccess/registrationsuccess_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Fast · Simple · Secure", "Registration Successful!", "Finish setting up"
- Module context: Core component of Authentication & Onboarding.

**2. Layout & Widget Architecture:**
- Total Widgets: **36** nodes (17 Container, 9 Column, 4 Text, 2 Image, 1 Scaffold).
- Embedded Sub-components: `StepItem`, `Button`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Dense vertical stack with potential keyboard overlap on smaller devices.
  - Lack of inline credential validation feedback before button submission.
  - Primary CTA button may blend into background if contrast tokens are uncurated.
- **Recommended Modern UI Treatment**:
  - Modern card grouping: Wrap credentials in a clean 16dp radius elevated card with subtle border `alternate`.
  - Touch ergonomics: Minimum 52dp height for all text fields and primary submit button.
  - Visual hierarchy: Emphasize 28sp headline with Inter/Outfit typography, followed by a muted subtitle1.
  - Security cues: Add subtle padlock or biometric iconography to reassure users during credential input.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Button border radius to 12dp or 16dp (`borderRadius: 16`).
  - Input field fill colors using `secondaryBackground` token.
  - Update primary button font weight to SemiBold (600) and fontSize to 16.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_wwqy131q`.

---

#### `resetpassword` Screen
- **FlutterFlow Key**: `Scaffold_sx4f6tei`
- **Route Path**: `/resetpassword`
- **Typed SDK File**: [`resetpassword.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/resetpassword.dart)
- **Flutter Source**: [`resetpassword_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/account/resetpassword/resetpassword_widget.dart)
- **Flutter Model**: [`resetpassword_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/account/resetpassword/resetpassword_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Reset Password", "Enter your date of birth", "Invalid date of birth", "Security Question:"
- Module context: Core component of Authentication & Onboarding.

**2. Layout & Widget Architecture:**
- Total Widgets: **38** nodes (7 Column, 5 TextField, 4 Container, 4 DropDown, 4 RichTextSpan).
- Registered Action Triggers: `ON_PINCODE_COMPLETE`, `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (6): `phonenoTextController`, `textController2`, `textController3`, `pinCodeController`, `textController4`, `textController5`
- Backend API Requests: `streetauth` (resetpassword), `getsecretquestions` (resetpassword), `returntierprofile` (Button), `verifysecretquestion` (Button), `getotpfromphone` (RichText), `reverifyotp` (PinCode), `resetpincode` (Button)
- Page State Variables: `optuse` (Boolean)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Dense vertical stack with potential keyboard overlap on smaller devices.
  - Lack of inline credential validation feedback before button submission.
  - Primary CTA button may blend into background if contrast tokens are uncurated.
- **Recommended Modern UI Treatment**:
  - Modern card grouping: Wrap credentials in a clean 16dp radius elevated card with subtle border `alternate`.
  - Touch ergonomics: Minimum 52dp height for all text fields and primary submit button.
  - Visual hierarchy: Emphasize 28sp headline with Inter/Outfit typography, followed by a muted subtitle1.
  - Security cues: Add subtle padlock or biometric iconography to reassure users during credential input.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Button border radius to 12dp or 16dp (`borderRadius: 16`).
  - Input field fill colors using `secondaryBackground` token.
  - Update primary button font weight to SemiBold (600) and fontSize to 16.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_sx4f6tei`.
  - Preserve all 6 TextEditingController bindings: `phonenoTextController`, `textController2`, `textController3`, `pinCodeController`.
  - Retain Backend API action chains for: `streetauth`, `getsecretquestions`, `returntierprofile`.

---

#### `SignUp` Screen
- **FlutterFlow Key**: `Scaffold_ycxxojz5`
- **Route Path**: `/signUp`
- **Typed SDK File**: [`sign_up.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/sign_up.dart)
- **Flutter Source**: [`sign_up_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/sign_up/sign_up_widget.dart)
- **Flutter Model**: [`sign_up_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/sign_up/sign_up_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "StreetPay", "Seamless Cashless Payments", "Select what you are registering with", "Already have an account? Sign in..."
- Module context: Core component of Authentication & Onboarding.

**2. Layout & Widget Architecture:**
- Total Widgets: **20** nodes (7 Text, 3 Column, 3 Container, 1 Scaffold, 1 Card).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Dense vertical stack with potential keyboard overlap on smaller devices.
  - Lack of inline credential validation feedback before button submission.
  - Primary CTA button may blend into background if contrast tokens are uncurated.
- **Recommended Modern UI Treatment**:
  - Modern card grouping: Wrap credentials in a clean 16dp radius elevated card with subtle border `alternate`.
  - Touch ergonomics: Minimum 52dp height for all text fields and primary submit button.
  - Visual hierarchy: Emphasize 28sp headline with Inter/Outfit typography, followed by a muted subtitle1.
  - Security cues: Add subtle padlock or biometric iconography to reassure users during credential input.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Button border radius to 12dp or 16dp (`borderRadius: 16`).
  - Input field fill colors using `secondaryBackground` token.
  - Update primary button font weight to SemiBold (600) and fontSize to 16.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_ycxxojz5`.

---

#### `Splash` Screen
- **FlutterFlow Key**: `Scaffold_931vwhyr`
- **Route Path**: `/splash_screen`
- **Typed SDK File**: [`splash.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/splash.dart)
- **Flutter Source**: [`splash_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/splash/splash_widget.dart)
- **Flutter Model**: [`splash_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/splash/splash_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "StreetPay", "Seamless Cashless Payments", "Secured by StreetPay"
- Module context: Core component of Authentication & Onboarding.

**2. Layout & Widget Architecture:**
- Total Widgets: **12** nodes (5 Row, 3 Text, 2 Column, 1 Scaffold, 1 Container).
- Registered Action Triggers: `ON_INIT_STATE`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Dense vertical stack with potential keyboard overlap on smaller devices.
  - Lack of inline credential validation feedback before button submission.
  - Primary CTA button may blend into background if contrast tokens are uncurated.
- **Recommended Modern UI Treatment**:
  - Modern card grouping: Wrap credentials in a clean 16dp radius elevated card with subtle border `alternate`.
  - Touch ergonomics: Minimum 52dp height for all text fields and primary submit button.
  - Visual hierarchy: Emphasize 28sp headline with Inter/Outfit typography, followed by a muted subtitle1.
  - Security cues: Add subtle padlock or biometric iconography to reassure users during credential input.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Button border radius to 12dp or 16dp (`borderRadius: 16`).
  - Input field fill colors using `secondaryBackground` token.
  - Update primary button font weight to SemiBold (600) and fontSize to 16.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_931vwhyr`.

---

#### `Welcome` Screen
- **FlutterFlow Key**: `Scaffold_jjaut9bu`
- **Route Path**: `/welcome`
- **Typed SDK File**: [`welcome.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/welcome.dart)
- **Flutter Source**: [`welcome_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/welcome/welcome_widget.dart)
- **Flutter Model**: [`welcome_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/welcome/welcome_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Fast · Simple · Secure", "Enter Your Details", "We\"
- Module context: Core component of Authentication & Onboarding.

**2. Layout & Widget Architecture:**
- Total Widgets: **37** nodes (21 Container, 4 Column, 4 Text, 3 Row, 1 Scaffold).
- Embedded Sub-components: `Button`, `IconButton`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Dense vertical stack with potential keyboard overlap on smaller devices.
  - Lack of inline credential validation feedback before button submission.
  - Primary CTA button may blend into background if contrast tokens are uncurated.
- **Recommended Modern UI Treatment**:
  - Modern card grouping: Wrap credentials in a clean 16dp radius elevated card with subtle border `alternate`.
  - Touch ergonomics: Minimum 52dp height for all text fields and primary submit button.
  - Visual hierarchy: Emphasize 28sp headline with Inter/Outfit typography, followed by a muted subtitle1.
  - Security cues: Add subtle padlock or biometric iconography to reassure users during credential input.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Button border radius to 12dp or 16dp (`borderRadius: 16`).
  - Input field fill colors using `secondaryBackground` token.
  - Update primary button font weight to SemiBold (600) and fontSize to 16.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_jjaut9bu`.

---

### Module 2: Dashboard & Core Navigation
> *Primary user hub, account balances, main action tiles, profile settings, and application preferences. (4 screens)*

#### `editprofile` Screen
- **FlutterFlow Key**: `Scaffold_qutx8khf`
- **Route Path**: `/editprofile`
- **Typed SDK File**: [`editprofile.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/editprofile.dart)
- **Flutter Source**: [`editprofile_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/editprofile/editprofile_widget.dart)
- **Flutter Model**: [`editprofile_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/editprofile/editprofile_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Edit Profile", "Email Address", "Next of Kin", "Next of Kin Phone Number"
- Module context: Core component of Dashboard & Core Navigation.

**2. Layout & Widget Architecture:**
- Total Widgets: **29** nodes (8 Text, 8 Column, 3 TextField, 3 Container, 2 Button).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (3): `textController1`, `textController2`, `textController3`
- Backend API Requests: `returntierprofile` (editprofile)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High cognitive load with numerous competing action cards and balance cards.
  - Inconsistent card paddings and varying border radii across home components.
  - Absence of skeleton loaders during initial balance and news queries.
- **Recommended Modern UI Treatment**:
  - Hero Wallet Card: Modern gradient background (`primary` to `accent1`) with high-contrast white balance text, quick deposit/send chips, and eye toggle for balance privacy.
  - Quick Action Grid: Clean 4-column icon-text grid for high-frequency actions (Airtime, Bills, Transfer, StreetPool).
  - Transaction Activity: Elevated section card with subtle divider lines and status color badges (success green / error red).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set uniform card border radii (16dp) on all action containers.
  - Align typography tokens to `titleMedium` for section headers and `bodySmall` for captions.
  - Ensure `elevation` on cards is subtle (2dp to 4dp) with soft shadow color.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_qutx8khf`.
  - Preserve all 3 TextEditingController bindings: `textController1`, `textController2`, `textController3`.
  - Retain Backend API action chains for: `returntierprofile`.

---

#### `newhome` Screen
- **FlutterFlow Key**: `Scaffold_46jy1b4u`
- **Route Path**: `/newhome`
- **Typed SDK File**: [`newhome.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/newhome.dart)
- **Flutter Source**: [`newhome_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/newhome/newhome_widget.dart)
- **Flutter Model**: [`newhome_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/newhome/newhome_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Anti - Kidnap", "Quick Access", "Fund Account", "Airtime"
- Module context: Core component of Dashboard & Core Navigation.

**2. Layout & Widget Architecture:**
- Total Widgets: **106** nodes (26 Container, 23 Column, 18 Text, 13 Icon, 8 Row).
- Registered Action Triggers: `ON_PULL_TO_REFRESH`, `ON_TAP`, `ON_TEXTFIELD_CHANGE`, `ON_INIT_STATE`, `ON_VERTICAL_DRAG_DOWN`.

**3. State & Integrations:**
- Form Input Controllers (1): `textController`
- Backend API Requests: `getaccountbalance` (newhome), `getwinners` (newhome), `getnew` (newhome), `getaccountbalance` (newhome), `locationdetect` (newhome), `locationdetect` (IconButton), `locationdetect` (Button), `locationdetect` (Button), `getaccountbalance` (Column), `retriveaccountfromwalletid` (TextField)
- Custom Actions: `getlocationpermission` (newhome), `getlocationpermission` (IconButton)
- Page State Variables: `balance` (String), `locations` (String), `rebuild` (String)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High cognitive load with numerous competing action cards and balance cards.
  - Inconsistent card paddings and varying border radii across home components.
  - Absence of skeleton loaders during initial balance and news queries.
- **Recommended Modern UI Treatment**:
  - Hero Wallet Card: Modern gradient background (`primary` to `accent1`) with high-contrast white balance text, quick deposit/send chips, and eye toggle for balance privacy.
  - Quick Action Grid: Clean 4-column icon-text grid for high-frequency actions (Airtime, Bills, Transfer, StreetPool).
  - Transaction Activity: Elevated section card with subtle divider lines and status color badges (success green / error red).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set uniform card border radii (16dp) on all action containers.
  - Align typography tokens to `titleMedium` for section headers and `bodySmall` for captions.
  - Ensure `elevation` on cards is subtle (2dp to 4dp) with soft shadow color.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_46jy1b4u`.
  - Preserve all 1 TextEditingController bindings: `textController`.
  - Retain Backend API action chains for: `getaccountbalance`, `getwinners`, `getnew`.
  - Preserve Custom Action invocations: `getlocationpermission`, `getlocationpermission`.

---

#### `Profile` Screen
- **FlutterFlow Key**: `Scaffold_r303r6y1`
- **Route Path**: `/profile`
- **Typed SDK File**: [`profile.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/profile.dart)
- **Flutter Source**: [`profile_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/profile/profile/profile_widget.dart)
- **Flutter Model**: [`profile_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/profile/profile/profile_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "My Profile", "Tier ${FFAppState().tier}", "Personal Details"
- Module context: Core component of Dashboard & Core Navigation.

**2. Layout & Widget Architecture:**
- Total Widgets: **21** nodes (5 Container, 5 Text, 3 Column, 3 Button, 1 Scaffold).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `wallet enquiry` (Profile), `upgradestatus` (Profile)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High cognitive load with numerous competing action cards and balance cards.
  - Inconsistent card paddings and varying border radii across home components.
  - Absence of skeleton loaders during initial balance and news queries.
- **Recommended Modern UI Treatment**:
  - Hero Wallet Card: Modern gradient background (`primary` to `accent1`) with high-contrast white balance text, quick deposit/send chips, and eye toggle for balance privacy.
  - Quick Action Grid: Clean 4-column icon-text grid for high-frequency actions (Airtime, Bills, Transfer, StreetPool).
  - Transaction Activity: Elevated section card with subtle divider lines and status color badges (success green / error red).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set uniform card border radii (16dp) on all action containers.
  - Align typography tokens to `titleMedium` for section headers and `bodySmall` for captions.
  - Ensure `elevation` on cards is subtle (2dp to 4dp) with soft shadow color.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_r303r6y1`.
  - Retain Backend API action chains for: `wallet enquiry`, `upgradestatus`.

---

#### `settingpage` Screen
- **FlutterFlow Key**: `Scaffold_5ps4zyqh`
- **Route Path**: `/settingpage`
- **Typed SDK File**: [`settingpage.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/settingpage.dart)
- **Flutter Source**: [`settingpage_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/settingpage/settingpage_widget.dart)
- **Flutter Model**: [`settingpage_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/settingpage/settingpage_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Settings", "Tier ${FFAppState().tier}", "Account", "Edit Profile"
- Module context: Core component of Dashboard & Core Navigation.

**2. Layout & Widget Architecture:**
- Total Widgets: **59** nodes (15 Row, 12 Text, 11 Icon, 10 Container, 6 Column).
- Registered Action Triggers: `ON_TOGGLE_ON`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `getCONTACT` (Row)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High cognitive load with numerous competing action cards and balance cards.
  - Inconsistent card paddings and varying border radii across home components.
  - Absence of skeleton loaders during initial balance and news queries.
- **Recommended Modern UI Treatment**:
  - Hero Wallet Card: Modern gradient background (`primary` to `accent1`) with high-contrast white balance text, quick deposit/send chips, and eye toggle for balance privacy.
  - Quick Action Grid: Clean 4-column icon-text grid for high-frequency actions (Airtime, Bills, Transfer, StreetPool).
  - Transaction Activity: Elevated section card with subtle divider lines and status color badges (success green / error red).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set uniform card border radii (16dp) on all action containers.
  - Align typography tokens to `titleMedium` for section headers and `bodySmall` for captions.
  - Ensure `elevation` on cards is subtle (2dp to 4dp) with soft shadow color.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_5ps4zyqh`.
  - Retain Backend API action chains for: `getCONTACT`.

---

### Module 3: KYC & Identity Verification
> *Tier 1 to Tier 3 compliance, face verification, ID uploads, and address proof validation. (7 screens)*

#### `consentfield` Screen
- **FlutterFlow Key**: `Scaffold_qroxffjc`
- **Route Path**: `/consentfield`
- **Typed SDK File**: [`consentfield.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/consentfield.dart)
- **Flutter Source**: [`consentfield_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/consentfield/consentfield_widget.dart)
- **Flutter Model**: [`consentfield_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/consentfield/consentfield_model.dart)

**1. Functional Role & User Flow:**
- Module context: Core component of KYC & Identity Verification.

**2. Layout & Widget Architecture:**
- Total Widgets: **15** nodes (5 Text, 4 Column, 2 RichTextSpan, 2 Button, 1 Scaffold).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `streetauth` (Button), `checkregisration` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Complex multi-step requirements presented without clear visual stepper progress.
  - Camera/Upload feedback lacks distinct pending, preview, or success states.
  - Proof of address generator action needs clear instructions and high visibility.
- **Recommended Modern UI Treatment**:
  - Visual Verification Stepper: Header horizontal progress tracker (Step 1: ID -> Step 2: Address -> Step 3: Face).
  - Document Upload Zone: Dashed border container with clear cloud upload icon, allowed formats (JPEG/PNG), and file size limits.
  - Visit Feedback Form: Ensure the '⚡ Generate Proof of Address' button is prominently featured with high-contrast accent.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set upload container border style to dashed/subtle border.
  - Ensure submit button uses `primary` background and white text.
  - Badge color tokens for 'Verified' (success) and 'Pending' (warning).
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_qroxffjc`.
  - Retain Backend API action chains for: `streetauth`, `checkregisration`.

---

#### `faceverify` Screen
- **FlutterFlow Key**: `Scaffold_g98kwvl4`
- **Route Path**: `/faceverify`
- **Typed SDK File**: [`faceverify.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/faceverify.dart)
- **Flutter Source**: [`faceverify_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/faceverify/faceverify_widget.dart)
- **Flutter Model**: [`faceverify_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/faceverify/faceverify_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "FACE VERIFICATION", "VERIFY YOUR FACE"
- Module context: Core component of KYC & Identity Verification.

**2. Layout & Widget Architecture:**
- Total Widgets: **11** nodes (2 Text, 2 Button, 1 Scaffold, 1 AppBar, 1 IconButton).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `faceverify` (Button)
- Page State Variables: `hasupload` (Boolean), `images` (UploadedFile)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Complex multi-step requirements presented without clear visual stepper progress.
  - Camera/Upload feedback lacks distinct pending, preview, or success states.
  - Proof of address generator action needs clear instructions and high visibility.
- **Recommended Modern UI Treatment**:
  - Visual Verification Stepper: Header horizontal progress tracker (Step 1: ID -> Step 2: Address -> Step 3: Face).
  - Document Upload Zone: Dashed border container with clear cloud upload icon, allowed formats (JPEG/PNG), and file size limits.
  - Visit Feedback Form: Ensure the '⚡ Generate Proof of Address' button is prominently featured with high-contrast accent.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set upload container border style to dashed/subtle border.
  - Ensure submit button uses `primary` background and white text.
  - Badge color tokens for 'Verified' (success) and 'Pending' (warning).
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_g98kwvl4`.
  - Retain Backend API action chains for: `faceverify`.

---

#### `IDUpload` Screen
- **FlutterFlow Key**: `Scaffold_wtkmarkj`
- **Route Path**: `/idupload`
- **Typed SDK File**: [`idupload.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/idupload.dart)

**1. Functional Role & User Flow:**
- Module context: Core component of KYC & Identity Verification.

**2. Layout & Widget Architecture:**
- Total Widgets: **27** nodes (12 Container, 7 Column, 3 Text, 1 Scaffold, 1 Row).
- Embedded Sub-components: `IconButton`, `TextField`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Complex multi-step requirements presented without clear visual stepper progress.
  - Camera/Upload feedback lacks distinct pending, preview, or success states.
  - Proof of address generator action needs clear instructions and high visibility.
- **Recommended Modern UI Treatment**:
  - Visual Verification Stepper: Header horizontal progress tracker (Step 1: ID -> Step 2: Address -> Step 3: Face).
  - Document Upload Zone: Dashed border container with clear cloud upload icon, allowed formats (JPEG/PNG), and file size limits.
  - Visit Feedback Form: Ensure the '⚡ Generate Proof of Address' button is prominently featured with high-contrast accent.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set upload container border style to dashed/subtle border.
  - Ensure submit button uses `primary` background and white text.
  - Badge color tokens for 'Verified' (success) and 'Pending' (warning).
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_wtkmarkj`.

---

#### `kycpaggge` Screen
- **FlutterFlow Key**: `Scaffold_7khkxn3r`
- **Route Path**: `/kycpaggge`
- **Typed SDK File**: [`kycpaggge.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/kycpaggge.dart)
- **Flutter Source**: [`kycpaggge_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/kycpaggge/kycpaggge_widget.dart)
- **Flutter Model**: [`kycpaggge_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/kycpaggge/kycpaggge_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Account Upgrade", "Upgrade to Tier", "Personal Information", "ID Type"
- Module context: Core component of KYC & Identity Verification.

**2. Layout & Widget Architecture:**
- Total Widgets: **174** nodes (52 Text, 32 Container, 27 Column, 25 Row, 14 Icon).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (6): `textController1`, `textController2`, `textController3`, `textController4`, `textController5`, `textController6`
- Backend API Requests: `getallstates` (kycpaggge), `wallet enquiry` (Button), `returntierprofile` (Button), `upgradetoteirtwo` (Button), `upgradetoteirtwo` (Button)
- Custom Actions: `newCustomAction2` (Button), `newCustomAction2` (Button), `newCustomAction2` (Button), `newCustomAction2` (Button), `newCustomAction2` (Button)
- Page State Variables: `ispep` (Boolean), `personaltoggle` (Boolean), `residentialtoggle` (Boolean), `uploadtoggle` (Boolean)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Complex multi-step requirements presented without clear visual stepper progress.
  - Camera/Upload feedback lacks distinct pending, preview, or success states.
  - Proof of address generator action needs clear instructions and high visibility.
- **Recommended Modern UI Treatment**:
  - Visual Verification Stepper: Header horizontal progress tracker (Step 1: ID -> Step 2: Address -> Step 3: Face).
  - Document Upload Zone: Dashed border container with clear cloud upload icon, allowed formats (JPEG/PNG), and file size limits.
  - Visit Feedback Form: Ensure the '⚡ Generate Proof of Address' button is prominently featured with high-contrast accent.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set upload container border style to dashed/subtle border.
  - Ensure submit button uses `primary` background and white text.
  - Badge color tokens for 'Verified' (success) and 'Pending' (warning).
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_7khkxn3r`.
  - Preserve all 6 TextEditingController bindings: `textController1`, `textController2`, `textController3`, `textController4`.
  - Retain Backend API action chains for: `getallstates`, `wallet enquiry`, `returntierprofile`.
  - Preserve Custom Action invocations: `newCustomAction2`, `newCustomAction2`, `newCustomAction2`.

---

#### `upgradetotier2` Screen
- **FlutterFlow Key**: `Scaffold_hzn66n9r`
- **Route Path**: `/upgradetotier2`
- **Typed SDK File**: [`upgradetotier2.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/upgradetotier2.dart)
- **Flutter Source**: [`upgradetotier2_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/profile/upgradetotier2/upgradetotier2_widget.dart)
- **Flutter Model**: [`upgradetotier2_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/profile/upgradetotier2/upgradetotier2_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Tier ${FFAppState().tier}", "Personal Details", "Draw your signature in the field below", "NIN or BVN cannot be empty"
- Module context: Core component of KYC & Identity Verification.

**2. Layout & Widget Architecture:**
- Total Widgets: **42** nodes (8 TextField, 6 Button, 5 Column, 5 Container, 4 Text).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (8): `textController1`, `textController2`, `textController3`, `textController4`, `textController5`, `textController6`, `textController7`, `textController8`
- Backend API Requests: `getallstates` (upgradetotier2), `bsptoken` (upgradetotier2), `wallet enquiry` (Button), `returntierprofile` (Button), `upgradetoteirtwo` (Button), `upgradetotierthree` (Button)
- Custom Actions: `newCustomAction2` (Button), `newCustomAction2` (Button), `newCustomAction2` (Button), `newCustomAction2` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Complex multi-step requirements presented without clear visual stepper progress.
  - Camera/Upload feedback lacks distinct pending, preview, or success states.
  - Proof of address generator action needs clear instructions and high visibility.
- **Recommended Modern UI Treatment**:
  - Visual Verification Stepper: Header horizontal progress tracker (Step 1: ID -> Step 2: Address -> Step 3: Face).
  - Document Upload Zone: Dashed border container with clear cloud upload icon, allowed formats (JPEG/PNG), and file size limits.
  - Visit Feedback Form: Ensure the '⚡ Generate Proof of Address' button is prominently featured with high-contrast accent.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set upload container border style to dashed/subtle border.
  - Ensure submit button uses `primary` background and white text.
  - Badge color tokens for 'Verified' (success) and 'Pending' (warning).
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_hzn66n9r`.
  - Preserve all 8 TextEditingController bindings: `textController1`, `textController2`, `textController3`, `textController4`.
  - Retain Backend API action chains for: `getallstates`, `bsptoken`, `wallet enquiry`.
  - Preserve Custom Action invocations: `newCustomAction2`, `newCustomAction2`, `newCustomAction2`.

---

#### `upgradetotier3` Screen
- **FlutterFlow Key**: `Scaffold_smy7lrxt`
- **Route Path**: `/upgradetotier3`
- **Typed SDK File**: [`upgradetotier3.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/upgradetotier3.dart)
- **Flutter Source**: [`upgradetotier3_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/profile/upgradetotier3/upgradetotier3_widget.dart)
- **Flutter Model**: [`upgradetotier3_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/profile/upgradetotier3/upgradetotier3_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Tier ${FFAppState().tier}", "Personal Details", "Upload Proof of Residence", "NIN or BVN cannot be empty"
- Module context: Core component of KYC & Identity Verification.

**2. Layout & Widget Architecture:**
- Total Widgets: **21** nodes (5 Column, 4 Text, 2 Row, 2 Container, 2 TextField).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (2): `textController1`, `textController2`
- Backend API Requests: `bsptoken` (upgradetotier3), `returntierprofile` (Button), `upgradetotierthree` (Button)
- Custom Actions: `newCustomAction2` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Complex multi-step requirements presented without clear visual stepper progress.
  - Camera/Upload feedback lacks distinct pending, preview, or success states.
  - Proof of address generator action needs clear instructions and high visibility.
- **Recommended Modern UI Treatment**:
  - Visual Verification Stepper: Header horizontal progress tracker (Step 1: ID -> Step 2: Address -> Step 3: Face).
  - Document Upload Zone: Dashed border container with clear cloud upload icon, allowed formats (JPEG/PNG), and file size limits.
  - Visit Feedback Form: Ensure the '⚡ Generate Proof of Address' button is prominently featured with high-contrast accent.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set upload container border style to dashed/subtle border.
  - Ensure submit button uses `primary` background and white text.
  - Badge color tokens for 'Verified' (success) and 'Pending' (warning).
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_smy7lrxt`.
  - Preserve all 2 TextEditingController bindings: `textController1`, `textController2`.
  - Retain Backend API action chains for: `bsptoken`, `returntierprofile`, `upgradetotierthree`.
  - Preserve Custom Action invocations: `newCustomAction2`.

---

#### `uplooaaad` Screen
- **FlutterFlow Key**: `Scaffold_oqvux2uh`
- **Route Path**: `/uplooaaad`
- **Typed SDK File**: [`uplooaaad.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/uplooaaad.dart)
- **Flutter Source**: [`uplooaaad_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/uplooaaad/uplooaaad_widget.dart)
- **Flutter Model**: [`uplooaaad_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/uplooaaad/uplooaaad_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "KYC Verification", "Upload Required Documents", "National ID", "Front & back sides"
- Module context: Core component of KYC & Identity Verification.

**2. Layout & Widget Architecture:**
- Total Widgets: **80** nodes (21 Text, 20 Container, 14 Icon, 9 Column, 8 Row).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Complex multi-step requirements presented without clear visual stepper progress.
  - Camera/Upload feedback lacks distinct pending, preview, or success states.
  - Proof of address generator action needs clear instructions and high visibility.
- **Recommended Modern UI Treatment**:
  - Visual Verification Stepper: Header horizontal progress tracker (Step 1: ID -> Step 2: Address -> Step 3: Face).
  - Document Upload Zone: Dashed border container with clear cloud upload icon, allowed formats (JPEG/PNG), and file size limits.
  - Visit Feedback Form: Ensure the '⚡ Generate Proof of Address' button is prominently featured with high-contrast accent.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set upload container border style to dashed/subtle border.
  - Ensure submit button uses `primary` background and white text.
  - Badge color tokens for 'Verified' (success) and 'Pending' (warning).
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_oqvux2uh`.

---

### Module 4: Payments & Transfers
> *Peer-to-peer wallet transfers, manual bank payouts, receipts, and payment confirmations. (4 screens)*

#### `accountdetails` Screen
- **FlutterFlow Key**: `Scaffold_fh940xdq`
- **Route Path**: `/accountdetails`
- **Typed SDK File**: [`accountdetails.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/accountdetails.dart)
- **Flutter Source**: [`accountdetails_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/accountdetails/accountdetails_widget.dart)
- **Flutter Model**: [`accountdetails_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/accountdetails/accountdetails_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Account Details", "Instruction", "Account Information", "Name"
- Module context: Core component of Payments & Transfers.

**2. Layout & Widget Architecture:**
- Total Widgets: **55** nodes (20 Text, 9 Column, 9 Container, 8 Row, 3 Icon).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `wallet enquiry` (accountdetails)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Amount input lack large prominent fintech formatting (e.g. ₦ symbol + 32sp bold numbers).
  - Confirmation screen needs explicit fee breakdown, beneficiary bank icon, and security pin confirmation.
  - Receipt layout needs clean receipt styling with share/download FAB.
- **Recommended Modern UI Treatment**:
  - Fintech Amount Field: Large centered hero currency input with auto-formatting.
  - Beneficiary Card: Quick-select avatar chips with bank initials and verified green tick.
  - Receipt Ticket: Stylized receipt card with dashed tear-off line and instant WhatsApp/PDF share CTA.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Change receipt card background to `secondaryBackground` with 20dp rounded corners.
  - Format currency text styles with `displaySmall` or `headlineMedium`.
  - Set button height to 50dp with full width.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_fh940xdq`.
  - Retain Backend API action chains for: `wallet enquiry`.

---

#### `openwallet` Screen
- **FlutterFlow Key**: `Scaffold_otuk2urm`
- **Route Path**: `/openwallet`
- **Typed SDK File**: [`openwallet.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/openwallet.dart)
- **Flutter Source**: [`openwallet_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/openwallet/openwallet_widget.dart)
- **Flutter Model**: [`openwallet_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/openwallet/openwallet_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Create account ", "Enter your date of birth", "Select a valid gender"
- Module context: Core component of Payments & Transfers.

**2. Layout & Widget Architecture:**
- Total Widgets: **24** nodes (5 TextField, 4 Text, 4 Row, 4 DropDown, 2 Column).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (5): `textController1`, `textController2`, `textController3`, `textController4`, `textController5`
- Backend API Requests: `streetauth` (Button), `wassopen` (Button), `insertintotierone` (Button), `createNewId` (Button), `openwallet` (Button), `insertintotierone` (Button), `createNewId` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Amount input lack large prominent fintech formatting (e.g. ₦ symbol + 32sp bold numbers).
  - Confirmation screen needs explicit fee breakdown, beneficiary bank icon, and security pin confirmation.
  - Receipt layout needs clean receipt styling with share/download FAB.
- **Recommended Modern UI Treatment**:
  - Fintech Amount Field: Large centered hero currency input with auto-formatting.
  - Beneficiary Card: Quick-select avatar chips with bank initials and verified green tick.
  - Receipt Ticket: Stylized receipt card with dashed tear-off line and instant WhatsApp/PDF share CTA.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Change receipt card background to `secondaryBackground` with 20dp rounded corners.
  - Format currency text styles with `displaySmall` or `headlineMedium`.
  - Set button height to 50dp with full width.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_otuk2urm`.
  - Preserve all 5 TextEditingController bindings: `textController1`, `textController2`, `textController3`, `textController4`.
  - Retain Backend API action chains for: `streetauth`, `wassopen`, `insertintotierone`.

---

#### `Payment` Screen
- **FlutterFlow Key**: `Scaffold_d3q2v8u6`
- **Route Path**: `/payment`
- **Typed SDK File**: [`payment.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/payment.dart)
- **Flutter Source**: [`payment_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/payments/payment/payment_widget.dart)
- **Flutter Model**: [`payment_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/payments/payment/payment_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Payment", "WALLET BALANCE", "SENDER", "RECEIVER"
- Module context: Core component of Payments & Transfers.

**2. Layout & Widget Architecture:**
- Total Widgets: **16** nodes (5 Text, 3 Column, 2 Container, 2 TextField, 1 Scaffold).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (2): `textController1`, `textController2`
- Backend API Requests: `streetauth` (Button), `returntierprofile` (Button)
- Custom Actions: `generatetransref` (Button), `generateseesionid` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Amount input lack large prominent fintech formatting (e.g. ₦ symbol + 32sp bold numbers).
  - Confirmation screen needs explicit fee breakdown, beneficiary bank icon, and security pin confirmation.
  - Receipt layout needs clean receipt styling with share/download FAB.
- **Recommended Modern UI Treatment**:
  - Fintech Amount Field: Large centered hero currency input with auto-formatting.
  - Beneficiary Card: Quick-select avatar chips with bank initials and verified green tick.
  - Receipt Ticket: Stylized receipt card with dashed tear-off line and instant WhatsApp/PDF share CTA.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Change receipt card background to `secondaryBackground` with 20dp rounded corners.
  - Format currency text styles with `displaySmall` or `headlineMedium`.
  - Set button height to 50dp with full width.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_d3q2v8u6`.
  - Preserve all 2 TextEditingController bindings: `textController1`, `textController2`.
  - Retain Backend API action chains for: `streetauth`, `returntierprofile`.
  - Preserve Custom Action invocations: `generatetransref`, `generateseesionid`.

---

#### `teirpage` Screen
- **FlutterFlow Key**: `Scaffold_hht11j40`
- **Route Path**: `/teirpage`
- **Typed SDK File**: [`teirpage.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/teirpage.dart)
- **Flutter Source**: [`teirpage_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/teirpage/teirpage_widget.dart)
- **Flutter Model**: [`teirpage_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/teirpage/teirpage_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Choose Your Tier", "Basic", "Current tier", "Balance limit ₦50,000"
- Module context: Core component of Payments & Transfers.

**2. Layout & Widget Architecture:**
- Total Widgets: **92** nodes (25 Text, 22 Row, 16 Column, 15 Icon, 5 Container).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `wallet enquiry` (teirpage), `upgradestatus` (teirpage), `upgradestatus` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Amount input lack large prominent fintech formatting (e.g. ₦ symbol + 32sp bold numbers).
  - Confirmation screen needs explicit fee breakdown, beneficiary bank icon, and security pin confirmation.
  - Receipt layout needs clean receipt styling with share/download FAB.
- **Recommended Modern UI Treatment**:
  - Fintech Amount Field: Large centered hero currency input with auto-formatting.
  - Beneficiary Card: Quick-select avatar chips with bank initials and verified green tick.
  - Receipt Ticket: Stylized receipt card with dashed tear-off line and instant WhatsApp/PDF share CTA.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Change receipt card background to `secondaryBackground` with 20dp rounded corners.
  - Format currency text styles with `displaySmall` or `headlineMedium`.
  - Set button height to 50dp with full width.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_hht11j40`.
  - Retain Backend API action chains for: `wallet enquiry`, `upgradestatus`, `upgradestatus`.

---

### Module 5: Bills & Utility Services
> *VAS services including Airtime, Data, Electricity, Cable TV, Internet, Betting, and Exams. (9 screens)*

#### `airtimeform` Screen
- **FlutterFlow Key**: `Scaffold_yduy0sb6`
- **Route Path**: `/airtimeform`
- **Typed SDK File**: [`airtimeform.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/airtimeform.dart)
- **Flutter Source**: [`airtimeform_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/airtimeform/airtimeform_widget.dart)
- **Flutter Model**: [`airtimeform_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/airtimeform/airtimeform_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Buy Airtime", "Enter a valid phone number", "Enter a valiad amount"
- Module context: Core component of Bills & Utility Services.

**2. Layout & Widget Architecture:**
- Total Widgets: **20** nodes (4 Column, 3 Container, 3 Image, 2 TextField, 1 Scaffold).
- Registered Action Triggers: `ON_TEXTFIELD_CHANGE`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (2): `textController1`, `textController2`
- Backend API Requests: `streetauth` (TextField), `getnetwork` (TextField)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Biller selection dropdowns can be cramped on small screens.
  - Meter number / smartcard validation feedback should be immediate before proceeding to payment.
  - Frequent billers list lacks quick-recharge one-tap actions.
- **Recommended Modern UI Treatment**:
  - Biller Logo Grid: Grid of recognizable telco/disco logos with crisp border highlights when selected.
  - Package Selection Pills: Horizontal scrolling chips for quick denomination selection (₦500, ₦1,000, ₦2,000, ₦5,000).
  - Validation Card: Auto-fetch customer name upon meter input and show in an info alert box.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set plan pill container background to active/inactive token colors.
  - Ensure biller selection card has 12dp radius and 1dp border.
  - Typography consistency on denomination text.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_yduy0sb6`.
  - Preserve all 2 TextEditingController bindings: `textController1`, `textController2`.
  - Retain Backend API action chains for: `streetauth`, `getnetwork`.

---

#### `billlbetting` Screen
- **FlutterFlow Key**: `Scaffold_yn0d6x8k`
- **Route Path**: `/billlbetting`
- **Typed SDK File**: [`billlbetting.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/billlbetting.dart)
- **Flutter Source**: [`billlbetting_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/billlbetting/billlbetting_widget.dart)
- **Flutter Model**: [`billlbetting_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/billlbetting/billlbetting_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Pay for Betting", "Biller Information", "Biller Input", "Payment Successful"
- Module context: Core component of Bills & Utility Services.

**2. Layout & Widget Architecture:**
- Total Widgets: **23** nodes (5 Column, 5 Container, 4 Text, 3 TextField, 2 IconButton).
- Registered Action Triggers: `ON_TEXTFIELD_SUBMIT`, `ON_FORM_WIDGET_SELECTED`, `ON_TAP`, `ON_TEXTFIELD_CHANGE`, `ON_INIT_STATE`.

**3. State & Integrations:**
- Form Input Controllers (3): `textController1`, `textController2`, `textController3`
- Backend API Requests: `billercategory` (billlbetting), `getbillerinput` (DropDown), `validateddatainput` (TextField), `validateddatainput` (Button), `wallet enquiry` (Button), `gettransactiontoken` (Button), `initaitebillpayment` (Button), `logtransaction` (Button), `logtransaction` (Button)
- Custom Actions: `generatetransref` (Button), `getdeviceid` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Biller selection dropdowns can be cramped on small screens.
  - Meter number / smartcard validation feedback should be immediate before proceeding to payment.
  - Frequent billers list lacks quick-recharge one-tap actions.
- **Recommended Modern UI Treatment**:
  - Biller Logo Grid: Grid of recognizable telco/disco logos with crisp border highlights when selected.
  - Package Selection Pills: Horizontal scrolling chips for quick denomination selection (₦500, ₦1,000, ₦2,000, ₦5,000).
  - Validation Card: Auto-fetch customer name upon meter input and show in an info alert box.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set plan pill container background to active/inactive token colors.
  - Ensure biller selection card has 12dp radius and 1dp border.
  - Typography consistency on denomination text.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_yn0d6x8k`.
  - Preserve all 3 TextEditingController bindings: `textController1`, `textController2`, `textController3`.
  - Retain Backend API action chains for: `billercategory`, `getbillerinput`, `validateddatainput`.
  - Preserve Custom Action invocations: `generatetransref`, `getdeviceid`.

---

#### `billlcabletv` Screen
- **FlutterFlow Key**: `Scaffold_nksj3w6q`
- **Route Path**: `/billlcabletv`
- **Typed SDK File**: [`billlcabletv.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/billlcabletv.dart)
- **Flutter Source**: [`billlcabletv_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/billlcabletv/billlcabletv_widget.dart)
- **Flutter Model**: [`billlcabletv_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/billlcabletv/billlcabletv_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Pay for Cable TV", "Biller Information", "Biller Input", "Payment Successful"
- Module context: Core component of Bills & Utility Services.

**2. Layout & Widget Architecture:**
- Total Widgets: **24** nodes (5 Column, 5 Container, 4 Text, 3 TextField, 2 IconButton).
- Registered Action Triggers: `ON_TEXTFIELD_SUBMIT`, `ON_FORM_WIDGET_SELECTED`, `ON_TAP`, `ON_TEXTFIELD_CHANGE`, `ON_INIT_STATE`.

**3. State & Integrations:**
- Form Input Controllers (3): `textController1`, `textController2`, `textController3`
- Backend API Requests: `billercategory` (billlcabletv), `getbillerinput` (DropDown), `validateddatainput` (DropDown), `gettransactiontoken` (Button), `initaitebillpayment` (Button), `logtransaction` (Button), `logtransaction` (Button)
- Custom Actions: `generatetransref` (Button), `getdeviceid` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Biller selection dropdowns can be cramped on small screens.
  - Meter number / smartcard validation feedback should be immediate before proceeding to payment.
  - Frequent billers list lacks quick-recharge one-tap actions.
- **Recommended Modern UI Treatment**:
  - Biller Logo Grid: Grid of recognizable telco/disco logos with crisp border highlights when selected.
  - Package Selection Pills: Horizontal scrolling chips for quick denomination selection (₦500, ₦1,000, ₦2,000, ₦5,000).
  - Validation Card: Auto-fetch customer name upon meter input and show in an info alert box.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set plan pill container background to active/inactive token colors.
  - Ensure biller selection card has 12dp radius and 1dp border.
  - Typography consistency on denomination text.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_nksj3w6q`.
  - Preserve all 3 TextEditingController bindings: `textController1`, `textController2`, `textController3`.
  - Retain Backend API action chains for: `billercategory`, `getbillerinput`, `validateddatainput`.
  - Preserve Custom Action invocations: `generatetransref`, `getdeviceid`.

---

#### `billlelectricity` Screen
- **FlutterFlow Key**: `Scaffold_s910w8x6`
- **Route Path**: `/billlelectricity`
- **Typed SDK File**: [`billlelectricity.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/billlelectricity.dart)
- **Flutter Source**: [`billlelectricity_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/billlelectricity/billlelectricity_widget.dart)
- **Flutter Model**: [`billlelectricity_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/billlelectricity/billlelectricity_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Pay for Electricity", "Biller Information", "Biller Input", "Amount must be greater than N350"
- Module context: Core component of Bills & Utility Services.

**2. Layout & Widget Architecture:**
- Total Widgets: **25** nodes (5 Column, 5 Container, 4 Text, 4 TextField, 2 IconButton).
- Registered Action Triggers: `ON_TEXTFIELD_SUBMIT`, `ON_INIT_STATE`, `ON_FORM_WIDGET_SELECTED`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (4): `textController1`, `textController2`, `textController3`, `textController4`
- Backend API Requests: `billercategory` (billlelectricity), `getbillerinput` (DropDown), `validateddatainput` (DropDown), `wallet enquiry` (Button), `validateddatainput` (Button), `gettransactiontoken` (Button), `initaitebillpayment` (Button), `logtransaction` (Button), `logtransaction` (Button)
- Custom Actions: `generatetransref` (Button), `getdeviceid` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Biller selection dropdowns can be cramped on small screens.
  - Meter number / smartcard validation feedback should be immediate before proceeding to payment.
  - Frequent billers list lacks quick-recharge one-tap actions.
- **Recommended Modern UI Treatment**:
  - Biller Logo Grid: Grid of recognizable telco/disco logos with crisp border highlights when selected.
  - Package Selection Pills: Horizontal scrolling chips for quick denomination selection (₦500, ₦1,000, ₦2,000, ₦5,000).
  - Validation Card: Auto-fetch customer name upon meter input and show in an info alert box.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set plan pill container background to active/inactive token colors.
  - Ensure biller selection card has 12dp radius and 1dp border.
  - Typography consistency on denomination text.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_s910w8x6`.
  - Preserve all 4 TextEditingController bindings: `textController1`, `textController2`, `textController3`, `textController4`.
  - Retain Backend API action chains for: `billercategory`, `getbillerinput`, `validateddatainput`.
  - Preserve Custom Action invocations: `generatetransref`, `getdeviceid`.

---

#### `billlexam` Screen
- **FlutterFlow Key**: `Scaffold_vfzofwai`
- **Route Path**: `/billlexam`
- **Typed SDK File**: [`billlexam.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/billlexam.dart)
- **Flutter Source**: [`billlexam_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/billlexam/billlexam_widget.dart)
- **Flutter Model**: [`billlexam_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/billlexam/billlexam_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Pay for Exam", "Biller Information", "Biller Input", "Payment Successful"
- Module context: Core component of Bills & Utility Services.

**2. Layout & Widget Architecture:**
- Total Widgets: **25** nodes (5 Column, 5 Container, 5 TextField, 3 Text, 2 IconButton).
- Registered Action Triggers: `ON_TEXTFIELD_SUBMIT`, `ON_INIT_STATE`, `ON_FORM_WIDGET_SELECTED`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (5): `textController1`, `textController2`, `textController3`, `textController4`, `textController5`
- Backend API Requests: `billercategory` (billlexam), `getbillerinput` (DropDown), `validateddatainput` (Button), `wallet enquiry` (Button), `gettransactiontoken` (Button), `initaitebillpayment` (Button), `logtransaction` (Button), `logtransaction` (Button), `validateddatainput` (Button)
- Custom Actions: `generatetransref` (Button), `getdeviceid` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Biller selection dropdowns can be cramped on small screens.
  - Meter number / smartcard validation feedback should be immediate before proceeding to payment.
  - Frequent billers list lacks quick-recharge one-tap actions.
- **Recommended Modern UI Treatment**:
  - Biller Logo Grid: Grid of recognizable telco/disco logos with crisp border highlights when selected.
  - Package Selection Pills: Horizontal scrolling chips for quick denomination selection (₦500, ₦1,000, ₦2,000, ₦5,000).
  - Validation Card: Auto-fetch customer name upon meter input and show in an info alert box.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set plan pill container background to active/inactive token colors.
  - Ensure biller selection card has 12dp radius and 1dp border.
  - Typography consistency on denomination text.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_vfzofwai`.
  - Preserve all 5 TextEditingController bindings: `textController1`, `textController2`, `textController3`, `textController4`.
  - Retain Backend API action chains for: `billercategory`, `getbillerinput`, `validateddatainput`.
  - Preserve Custom Action invocations: `generatetransref`, `getdeviceid`.

---

#### `billlinternet` Screen
- **FlutterFlow Key**: `Scaffold_7t84hf5j`
- **Route Path**: `/billlinternet`
- **Typed SDK File**: [`billlinternet.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/billlinternet.dart)
- **Flutter Source**: [`billlinternet_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/billlinternet/billlinternet_widget.dart)
- **Flutter Model**: [`billlinternet_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/billlinternet/billlinternet_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Pay for Internet", "Biller Information", "Biller Input", "Payment Successful"
- Module context: Core component of Bills & Utility Services.

**2. Layout & Widget Architecture:**
- Total Widgets: **23** nodes (5 Column, 5 Container, 3 Text, 3 TextField, 2 IconButton).
- Registered Action Triggers: `ON_TEXTFIELD_SUBMIT`, `ON_INIT_STATE`, `ON_FORM_WIDGET_SELECTED`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (3): `textController1`, `textController2`, `textController3`
- Backend API Requests: `billercategory` (billlinternet), `getbillerinput` (DropDown), `validateddatainput` (Button), `gettransactiontoken` (Button), `initaitebillpayment` (Button), `logtransaction` (Button), `logtransaction` (Button)
- Custom Actions: `generatetransref` (Button), `getdeviceid` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Biller selection dropdowns can be cramped on small screens.
  - Meter number / smartcard validation feedback should be immediate before proceeding to payment.
  - Frequent billers list lacks quick-recharge one-tap actions.
- **Recommended Modern UI Treatment**:
  - Biller Logo Grid: Grid of recognizable telco/disco logos with crisp border highlights when selected.
  - Package Selection Pills: Horizontal scrolling chips for quick denomination selection (₦500, ₦1,000, ₦2,000, ₦5,000).
  - Validation Card: Auto-fetch customer name upon meter input and show in an info alert box.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set plan pill container background to active/inactive token colors.
  - Ensure biller selection card has 12dp radius and 1dp border.
  - Typography consistency on denomination text.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_7t84hf5j`.
  - Preserve all 3 TextEditingController bindings: `textController1`, `textController2`, `textController3`.
  - Retain Backend API action chains for: `billercategory`, `getbillerinput`, `validateddatainput`.
  - Preserve Custom Action invocations: `generatetransref`, `getdeviceid`.

---

#### `billnew` Screen
- **FlutterFlow Key**: `Scaffold_yod83oxc`
- **Route Path**: `/billnew`
- **Typed SDK File**: [`billnew.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/billnew.dart)
- **Flutter Source**: [`billnew_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/billnew/billnew_widget.dart)
- **Flutter Model**: [`billnew_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/billnew/billnew_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Bill Management", "When a user pins you, you\", "Payers who Pinned me"
- Module context: Core component of Bills & Utility Services.

**2. Layout & Widget Architecture:**
- Total Widgets: **30** nodes (8 Column, 8 Container, 2 Text, 2 Row, 2 Tab).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `streetauth` (billnew), `getpinlist` (billnew), `getreceivedbill` (billnew), `getsentbills` (billnew), `getaccountno` (BillCard)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Biller selection dropdowns can be cramped on small screens.
  - Meter number / smartcard validation feedback should be immediate before proceeding to payment.
  - Frequent billers list lacks quick-recharge one-tap actions.
- **Recommended Modern UI Treatment**:
  - Biller Logo Grid: Grid of recognizable telco/disco logos with crisp border highlights when selected.
  - Package Selection Pills: Horizontal scrolling chips for quick denomination selection (₦500, ₦1,000, ₦2,000, ₦5,000).
  - Validation Card: Auto-fetch customer name upon meter input and show in an info alert box.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set plan pill container background to active/inactive token colors.
  - Ensure biller selection card has 12dp radius and 1dp border.
  - Typography consistency on denomination text.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_yod83oxc`.
  - Retain Backend API action chains for: `streetauth`, `getpinlist`, `getreceivedbill`.

---

#### `datapayment` Screen
- **FlutterFlow Key**: `Scaffold_7gr1je8z`
- **Route Path**: `/datapayment`
- **Typed SDK File**: [`datapayment.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/datapayment.dart)
- **Flutter Source**: [`datapayment_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/datapayment/datapayment_widget.dart)
- **Flutter Model**: [`datapayment_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/datapayment/datapayment_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Buy Data"
- Module context: Core component of Bills & Utility Services.

**2. Layout & Widget Architecture:**
- Total Widgets: **184** nodes (64 Text, 31 Column, 23 Container, 21 GridView, 21 Card).
- Registered Action Triggers: `ON_TEXTFIELD_CHANGE`, `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (1): `textController`
- Backend API Requests: `streetauth` (datapayment), `getdataplan` (TextField), `getnetwork` (TextField)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Biller selection dropdowns can be cramped on small screens.
  - Meter number / smartcard validation feedback should be immediate before proceeding to payment.
  - Frequent billers list lacks quick-recharge one-tap actions.
- **Recommended Modern UI Treatment**:
  - Biller Logo Grid: Grid of recognizable telco/disco logos with crisp border highlights when selected.
  - Package Selection Pills: Horizontal scrolling chips for quick denomination selection (₦500, ₦1,000, ₦2,000, ₦5,000).
  - Validation Card: Auto-fetch customer name upon meter input and show in an info alert box.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set plan pill container background to active/inactive token colors.
  - Ensure biller selection card has 12dp radius and 1dp border.
  - Typography consistency on denomination text.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_7gr1je8z`.
  - Preserve all 1 TextEditingController bindings: `textController`.
  - Retain Backend API action chains for: `streetauth`, `getdataplan`, `getnetwork`.

---

#### `keyboardnew` Screen
- **FlutterFlow Key**: `Scaffold_f18ugym1`
- **Route Path**: `/keyboardnew`
- **Typed SDK File**: [`keyboardnew.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/keyboardnew.dart)
- **Flutter Source**: [`keyboardnew_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetpos/keyboardnew/keyboardnew_widget.dart)
- **Flutter Model**: [`keyboardnew_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetpos/keyboardnew/keyboardnew_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Enter Amount"
- Module context: Core component of Bills & Utility Services.

**2. Layout & Widget Architecture:**
- Total Widgets: **39** nodes (14 Container, 13 Text, 5 Row, 2 Column, 2 Icon).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Page State Variables: `numbers` (List<String>)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Biller selection dropdowns can be cramped on small screens.
  - Meter number / smartcard validation feedback should be immediate before proceeding to payment.
  - Frequent billers list lacks quick-recharge one-tap actions.
- **Recommended Modern UI Treatment**:
  - Biller Logo Grid: Grid of recognizable telco/disco logos with crisp border highlights when selected.
  - Package Selection Pills: Horizontal scrolling chips for quick denomination selection (₦500, ₦1,000, ₦2,000, ₦5,000).
  - Validation Card: Auto-fetch customer name upon meter input and show in an info alert box.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set plan pill container background to active/inactive token colors.
  - Ensure biller selection card has 12dp radius and 1dp border.
  - Typography consistency on denomination text.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_f18ugym1`.

---

### Module 6: StreetPool Gaming & Lottery
> *Social reward mechanisms, lottery spin/flip/quiz games, prize pools, and winner feeds. (16 screens)*

#### `allwinners` Screen
- **FlutterFlow Key**: `Scaffold_39hlvw73`
- **Route Path**: `/allwinners`
- **Typed SDK File**: [`allwinners.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/allwinners.dart)
- **Flutter Source**: [`allwinners_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/allwinners/allwinners_widget.dart)
- **Flutter Model**: [`allwinners_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/allwinners/allwinners_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Winners", "Select Lottery Plan", "Daily Draw Winners"
- Module context: Core component of StreetPool Gaming & Lottery.

**2. Layout & Widget Architecture:**
- Total Widgets: **37** nodes (10 Text, 10 Column, 8 Container, 5 Row, 1 Scaffold).
- Registered Action Triggers: `ON_INIT_STATE`.

**3. State & Integrations:**
- Backend API Requests: `streetauth` (allwinners), `getallwinners` (allwinners)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High visual clutter with games, prize pools, and live winning tickers competing for attention.
  - Spin wheel / flip cards need fluid animations and clear win/loss state modals.
  - Rules and entry fees are sometimes buried below the fold.
- **Recommended Modern UI Treatment**:
  - Gamified Dark Card Theme: Rich dark gradient surface (`#111827` to `#1F2937`) with neon gold/amber accents for prize amounts.
  - Jackpot Counter: Animated rolling ticker showing active prize pool in real-time.
  - Live Winner Marquee: Smooth horizontal scrolling pill showing recent winner phone numbers and payouts.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Update gaming card borders with amber/gold accent token.
  - Boost jackpot text to bold 24sp with glowing shadow.
  - Button CTA: Gradient fill with high vibrancy.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_39hlvw73`.
  - Retain Backend API action chains for: `streetauth`, `getallwinners`.

---

#### `fundsharing` Screen
- **FlutterFlow Key**: `Scaffold_2va0jv9y`
- **Route Path**: `/fundsharing`
- **Typed SDK File**: [`fundsharing.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/fundsharing.dart)
- **Flutter Source**: [`fundsharing_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetpool/fundsharing/fundsharing_widget.dart)
- **Flutter Model**: [`fundsharing_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetpool/fundsharing/fundsharing_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "StreetShare", "Total Balance", "Active Shares", "Fixed amount to join"
- Module context: Core component of StreetPool Gaming & Lottery.

**2. Layout & Widget Architecture:**
- Total Widgets: **46** nodes (14 Text, 11 Column, 7 Row, 5 Container, 5 Icon).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High visual clutter with games, prize pools, and live winning tickers competing for attention.
  - Spin wheel / flip cards need fluid animations and clear win/loss state modals.
  - Rules and entry fees are sometimes buried below the fold.
- **Recommended Modern UI Treatment**:
  - Gamified Dark Card Theme: Rich dark gradient surface (`#111827` to `#1F2937`) with neon gold/amber accents for prize amounts.
  - Jackpot Counter: Animated rolling ticker showing active prize pool in real-time.
  - Live Winner Marquee: Smooth horizontal scrolling pill showing recent winner phone numbers and payouts.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Update gaming card borders with amber/gold accent token.
  - Boost jackpot text to bold 24sp with glowing shadow.
  - Button CTA: Gradient fill with high vibrancy.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_2va0jv9y`.

---

#### `givwaway` Screen
- **FlutterFlow Key**: `Scaffold_dbv7cnmo`
- **Route Path**: `/givwaway`
- **Typed SDK File**: [`givwaway.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/givwaway.dart)
- **Flutter Source**: [`givwaway_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/giveaway/givwaway/givwaway_widget.dart)
- **Flutter Model**: [`givwaway_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/giveaway/givwaway/givwaway_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Gift Vault", "🎁 Gift Vault", "Unlock.  Deposit.  Claim Your Gift.", "Available Gifts"
- Module context: Core component of StreetPool Gaming & Lottery.

**2. Layout & Widget Architecture:**
- Total Widgets: **69** nodes (20 Text, 15 Container, 13 Column, 9 Row, 3 Button).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (3): `textController1`, `textController2`, `textController3`
- Backend API Requests: `gettransactiontoken` (Button), `debitwallet` (Button), `StoreGift` (Button)
- Custom Actions: `getdeviceid` (Button), `generatetransref` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High visual clutter with games, prize pools, and live winning tickers competing for attention.
  - Spin wheel / flip cards need fluid animations and clear win/loss state modals.
  - Rules and entry fees are sometimes buried below the fold.
- **Recommended Modern UI Treatment**:
  - Gamified Dark Card Theme: Rich dark gradient surface (`#111827` to `#1F2937`) with neon gold/amber accents for prize amounts.
  - Jackpot Counter: Animated rolling ticker showing active prize pool in real-time.
  - Live Winner Marquee: Smooth horizontal scrolling pill showing recent winner phone numbers and payouts.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Update gaming card borders with amber/gold accent token.
  - Boost jackpot text to bold 24sp with glowing shadow.
  - Button CTA: Gradient fill with high vibrancy.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_dbv7cnmo`.
  - Preserve all 3 TextEditingController bindings: `textController1`, `textController2`, `textController3`.
  - Retain Backend API action chains for: `gettransactiontoken`, `debitwallet`, `StoreGift`.
  - Preserve Custom Action invocations: `getdeviceid`, `generatetransref`.

---

#### `historyflip` Screen
- **FlutterFlow Key**: `Scaffold_h6bfv1rq`
- **Route Path**: `/historyflip`
- **Typed SDK File**: [`historyflip.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/historyflip.dart)
- **Flutter Source**: [`historyflip_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/historyflip/historyflip_widget.dart)
- **Flutter Model**: [`historyflip_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/historyflip/historyflip_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Game History", "Total Games", "Total Wins", "Win Rate"
- Module context: Core component of StreetPool Gaming & Lottery.

**2. Layout & Widget Architecture:**
- Total Widgets: **54** nodes (18 Text, 11 Column, 11 Container, 7 Row, 1 Scaffold).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `streetauth` (historyflip), `gethistoryflip` (historyflip)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High visual clutter with games, prize pools, and live winning tickers competing for attention.
  - Spin wheel / flip cards need fluid animations and clear win/loss state modals.
  - Rules and entry fees are sometimes buried below the fold.
- **Recommended Modern UI Treatment**:
  - Gamified Dark Card Theme: Rich dark gradient surface (`#111827` to `#1F2937`) with neon gold/amber accents for prize amounts.
  - Jackpot Counter: Animated rolling ticker showing active prize pool in real-time.
  - Live Winner Marquee: Smooth horizontal scrolling pill showing recent winner phone numbers and payouts.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Update gaming card borders with amber/gold accent token.
  - Boost jackpot text to bold 24sp with glowing shadow.
  - Button CTA: Gradient fill with high vibrancy.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_h6bfv1rq`.
  - Retain Backend API action chains for: `streetauth`, `gethistoryflip`.

---

#### `historyguess` Screen
- **FlutterFlow Key**: `Scaffold_2nrgm69s`
- **Route Path**: `/historyguess`
- **Typed SDK File**: [`historyguess.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/historyguess.dart)
- **Flutter Source**: [`historyguess_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/historyguess/historyguess_widget.dart)
- **Flutter Model**: [`historyguess_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/historyguess/historyguess_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Game History", "Total Games", "Total Wins", "Win Rate"
- Module context: Core component of StreetPool Gaming & Lottery.

**2. Layout & Widget Architecture:**
- Total Widgets: **53** nodes (17 Text, 11 Column, 10 Container, 7 Row, 1 Scaffold).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `streetauth` (historyguess), `getlottohistory` (historyguess)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High visual clutter with games, prize pools, and live winning tickers competing for attention.
  - Spin wheel / flip cards need fluid animations and clear win/loss state modals.
  - Rules and entry fees are sometimes buried below the fold.
- **Recommended Modern UI Treatment**:
  - Gamified Dark Card Theme: Rich dark gradient surface (`#111827` to `#1F2937`) with neon gold/amber accents for prize amounts.
  - Jackpot Counter: Animated rolling ticker showing active prize pool in real-time.
  - Live Winner Marquee: Smooth horizontal scrolling pill showing recent winner phone numbers and payouts.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Update gaming card borders with amber/gold accent token.
  - Boost jackpot text to bold 24sp with glowing shadow.
  - Button CTA: Gradient fill with high vibrancy.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_2nrgm69s`.
  - Retain Backend API action chains for: `streetauth`, `getlottohistory`.

---

#### `historyquiz` Screen
- **FlutterFlow Key**: `Scaffold_l5jsyxnd`
- **Route Path**: `/historyquiz`
- **Typed SDK File**: [`historyquiz.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/historyquiz.dart)
- **Flutter Source**: [`historyquiz_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/historyquiz/historyquiz_widget.dart)
- **Flutter Model**: [`historyquiz_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/historyquiz/historyquiz_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Game History", "Total Games", "Total Wins", "Win Rate"
- Module context: Core component of StreetPool Gaming & Lottery.

**2. Layout & Widget Architecture:**
- Total Widgets: **58** nodes (18 Text, 13 Column, 10 Container, 9 Row, 1 Scaffold).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `streetauth` (historyquiz), `gethistoryquiz` (historyquiz)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High visual clutter with games, prize pools, and live winning tickers competing for attention.
  - Spin wheel / flip cards need fluid animations and clear win/loss state modals.
  - Rules and entry fees are sometimes buried below the fold.
- **Recommended Modern UI Treatment**:
  - Gamified Dark Card Theme: Rich dark gradient surface (`#111827` to `#1F2937`) with neon gold/amber accents for prize amounts.
  - Jackpot Counter: Animated rolling ticker showing active prize pool in real-time.
  - Live Winner Marquee: Smooth horizontal scrolling pill showing recent winner phone numbers and payouts.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Update gaming card borders with amber/gold accent token.
  - Boost jackpot text to bold 24sp with glowing shadow.
  - Button CTA: Gradient fill with high vibrancy.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_l5jsyxnd`.
  - Retain Backend API action chains for: `streetauth`, `gethistoryquiz`.

---

#### `historyspin` Screen
- **FlutterFlow Key**: `Scaffold_ahvvyngz`
- **Route Path**: `/historyspin`
- **Typed SDK File**: [`historyspin.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/historyspin.dart)
- **Flutter Source**: [`historyspin_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/historyspin/historyspin_widget.dart)
- **Flutter Model**: [`historyspin_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/historyspin/historyspin_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Game History", "Total Games", "Total Wins", "Win Rate"
- Module context: Core component of StreetPool Gaming & Lottery.

**2. Layout & Widget Architecture:**
- Total Widgets: **53** nodes (17 Text, 11 Column, 10 Container, 7 Row, 1 Scaffold).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `streetauth` (historyspin), `getlottohistory` (historyspin)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High visual clutter with games, prize pools, and live winning tickers competing for attention.
  - Spin wheel / flip cards need fluid animations and clear win/loss state modals.
  - Rules and entry fees are sometimes buried below the fold.
- **Recommended Modern UI Treatment**:
  - Gamified Dark Card Theme: Rich dark gradient surface (`#111827` to `#1F2937`) with neon gold/amber accents for prize amounts.
  - Jackpot Counter: Animated rolling ticker showing active prize pool in real-time.
  - Live Winner Marquee: Smooth horizontal scrolling pill showing recent winner phone numbers and payouts.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Update gaming card borders with amber/gold accent token.
  - Boost jackpot text to bold 24sp with glowing shadow.
  - Button CTA: Gradient fill with high vibrancy.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_ahvvyngz`.
  - Retain Backend API action chains for: `streetauth`, `getlottohistory`.

---

#### `lottery` Screen
- **FlutterFlow Key**: `Scaffold_vm67oeiv`
- **Route Path**: `/lottery`
- **Typed SDK File**: [`lottery.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/lottery.dart)
- **Flutter Source**: [`lottery_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/lottery/lottery_widget.dart)
- **Flutter Model**: [`lottery_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/lottery/lottery_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Street ${widget!.gametype}", "Lucky ${widget!.gametype}", "Try your luck today!", "Available Lottery Plans"
- Module context: Core component of StreetPool Gaming & Lottery.

**2. Layout & Widget Architecture:**
- Total Widgets: **49** nodes (19 Container, 11 Text, 5 Column, 4 Row, 4 Button).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `streetauth` (lottery), `getwinners` (lottery), `getlottoplans` (lottery), `debitwallet` (Button), `debitwallet` (Button), `debitwallet` (Button), `debitwallet` (Button)
- Custom Actions: `generatetransref` (Button), `generatetransref` (Button), `generatetransref` (Button), `generatetransref` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High visual clutter with games, prize pools, and live winning tickers competing for attention.
  - Spin wheel / flip cards need fluid animations and clear win/loss state modals.
  - Rules and entry fees are sometimes buried below the fold.
- **Recommended Modern UI Treatment**:
  - Gamified Dark Card Theme: Rich dark gradient surface (`#111827` to `#1F2937`) with neon gold/amber accents for prize amounts.
  - Jackpot Counter: Animated rolling ticker showing active prize pool in real-time.
  - Live Winner Marquee: Smooth horizontal scrolling pill showing recent winner phone numbers and payouts.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Update gaming card borders with amber/gold accent token.
  - Boost jackpot text to bold 24sp with glowing shadow.
  - Button CTA: Gradient fill with high vibrancy.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_vm67oeiv`.
  - Retain Backend API action chains for: `streetauth`, `getwinners`, `getlottoplans`.
  - Preserve Custom Action invocations: `generatetransref`, `generatetransref`, `generatetransref`.

---

#### `lottoflip` Screen
- **FlutterFlow Key**: `Scaffold_whiv7k96`
- **Route Path**: `/lottoflip`
- **Typed SDK File**: [`lottoflip.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/lottoflip.dart)
- **Flutter Source**: [`lottoflip_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/lottoflip/lottoflip_widget.dart)
- **Flutter Model**: [`lottoflip_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/lottoflip/lottoflip_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Lucky Flip", "Flip a card to reveal your lucky number!", "Your Result", "Game Rules:"
- Module context: Core component of StreetPool Gaming & Lottery.

**2. Layout & Widget Architecture:**
- Total Widgets: **24** nodes (8 Text, 4 Column, 4 Button, 3 Container, 1 Scaffold).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `streetauth` (lottoflip), `getlottonumber` (Button), `getlottonumber` (Button), `getlottonumber` (Button), `playsum` (Button)
- Custom Actions: `buttondisable` (Button), `buttondisable` (Button), `buttondisable` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High visual clutter with games, prize pools, and live winning tickers competing for attention.
  - Spin wheel / flip cards need fluid animations and clear win/loss state modals.
  - Rules and entry fees are sometimes buried below the fold.
- **Recommended Modern UI Treatment**:
  - Gamified Dark Card Theme: Rich dark gradient surface (`#111827` to `#1F2937`) with neon gold/amber accents for prize amounts.
  - Jackpot Counter: Animated rolling ticker showing active prize pool in real-time.
  - Live Winner Marquee: Smooth horizontal scrolling pill showing recent winner phone numbers and payouts.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Update gaming card borders with amber/gold accent token.
  - Boost jackpot text to bold 24sp with glowing shadow.
  - Button CTA: Gradient fill with high vibrancy.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_whiv7k96`.
  - Retain Backend API action chains for: `streetauth`, `getlottonumber`, `getlottonumber`.
  - Preserve Custom Action invocations: `buttondisable`, `buttondisable`, `buttondisable`.

---

#### `lottoguess` Screen
- **FlutterFlow Key**: `Scaffold_cawrntdl`
- **Route Path**: `/lottoguess`
- **Typed SDK File**: [`lottoguess.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/lottoguess.dart)
- **Flutter Source**: [`lottoguess_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/lottoguess/lottoguess_widget.dart)
- **Flutter Model**: [`lottoguess_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/lottoguess/lottoguess_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Payment", "Selected Plan", "Premium Plan", "daily subscription"
- Module context: Core component of StreetPool Gaming & Lottery.

**2. Layout & Widget Architecture:**
- Total Widgets: **34** nodes (9 Text, 9 Container, 5 Column, 3 Row, 2 Button).
- Registered Action Triggers: `ON_FORM_WIDGET_SELECTED`, `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `streetauth` (lottoguess), `getlottocode` (lottoguess), `lottopay` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High visual clutter with games, prize pools, and live winning tickers competing for attention.
  - Spin wheel / flip cards need fluid animations and clear win/loss state modals.
  - Rules and entry fees are sometimes buried below the fold.
- **Recommended Modern UI Treatment**:
  - Gamified Dark Card Theme: Rich dark gradient surface (`#111827` to `#1F2937`) with neon gold/amber accents for prize amounts.
  - Jackpot Counter: Animated rolling ticker showing active prize pool in real-time.
  - Live Winner Marquee: Smooth horizontal scrolling pill showing recent winner phone numbers and payouts.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Update gaming card borders with amber/gold accent token.
  - Boost jackpot text to bold 24sp with glowing shadow.
  - Button CTA: Gradient fill with high vibrancy.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_cawrntdl`.
  - Retain Backend API action chains for: `streetauth`, `getlottocode`, `lottopay`.

---

#### `lottohome` Screen
- **FlutterFlow Key**: `Scaffold_0wa4fcll`
- **Route Path**: `/lottohome`
- **Typed SDK File**: [`lottohome.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/lottohome.dart)
- **Flutter Source**: [`lottohome_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/lottohome/lottohome_widget.dart)
- **Flutter Model**: [`lottohome_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/lottohome/lottohome_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "STREET GAMES", "Popular Games", "Street Quiz", "Press and win"
- Module context: Core component of StreetPool Gaming & Lottery.

**2. Layout & Widget Architecture:**
- Total Widgets: **45** nodes (7 Column, 7 Container, 6 Text, 5 Stack, 5 Row).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High visual clutter with games, prize pools, and live winning tickers competing for attention.
  - Spin wheel / flip cards need fluid animations and clear win/loss state modals.
  - Rules and entry fees are sometimes buried below the fold.
- **Recommended Modern UI Treatment**:
  - Gamified Dark Card Theme: Rich dark gradient surface (`#111827` to `#1F2937`) with neon gold/amber accents for prize amounts.
  - Jackpot Counter: Animated rolling ticker showing active prize pool in real-time.
  - Live Winner Marquee: Smooth horizontal scrolling pill showing recent winner phone numbers and payouts.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Update gaming card borders with amber/gold accent token.
  - Boost jackpot text to bold 24sp with glowing shadow.
  - Button CTA: Gradient fill with high vibrancy.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_0wa4fcll`.

---

#### `lottoquiz` Screen
- **FlutterFlow Key**: `Scaffold_9r63u1ue`
- **Route Path**: `/lottoquiz`
- **Typed SDK File**: [`lottoquiz.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/lottoquiz.dart)
- **Flutter Source**: [`lottoquiz_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/lottoquiz/lottoquiz_widget.dart)
- **Flutter Model**: [`lottoquiz_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/lottoquiz/lottoquiz_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "STREET QUIZ", "Answer correctly to earn bonus tickets!", "Correct !!!"
- Module context: Core component of StreetPool Gaming & Lottery.

**2. Layout & Widget Architecture:**
- Total Widgets: **52** nodes (18 Text, 17 Container, 7 Row, 6 Column, 1 Scaffold).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `streetauth` (lottoquiz), `getlottoquestion` (lottoquiz)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High visual clutter with games, prize pools, and live winning tickers competing for attention.
  - Spin wheel / flip cards need fluid animations and clear win/loss state modals.
  - Rules and entry fees are sometimes buried below the fold.
- **Recommended Modern UI Treatment**:
  - Gamified Dark Card Theme: Rich dark gradient surface (`#111827` to `#1F2937`) with neon gold/amber accents for prize amounts.
  - Jackpot Counter: Animated rolling ticker showing active prize pool in real-time.
  - Live Winner Marquee: Smooth horizontal scrolling pill showing recent winner phone numbers and payouts.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Update gaming card borders with amber/gold accent token.
  - Boost jackpot text to bold 24sp with glowing shadow.
  - Button CTA: Gradient fill with high vibrancy.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_9r63u1ue`.
  - Retain Backend API action chains for: `streetauth`, `getlottoquestion`.

---

#### `lottospin` Screen
- **FlutterFlow Key**: `Scaffold_rg56nxmm`
- **Route Path**: `/lottospin`
- **Typed SDK File**: [`lottospin.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/lottospin.dart)
- **Flutter Source**: [`lottospin_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/lottospin/lottospin_widget.dart)
- **Flutter Model**: [`lottospin_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/lottospin/lottospin_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Spin & Win", "Make your prediction and try your luck!", "Select Your Prediction", "Your Prediction:"
- Module context: Core component of StreetPool Gaming & Lottery.

**2. Layout & Widget Architecture:**
- Total Widgets: **17** nodes (5 Text, 3 Column, 3 Container, 1 Scaffold, 1 AppBar).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `streetauth` (lottospin), `getangles` (lottospin), `playangle` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High visual clutter with games, prize pools, and live winning tickers competing for attention.
  - Spin wheel / flip cards need fluid animations and clear win/loss state modals.
  - Rules and entry fees are sometimes buried below the fold.
- **Recommended Modern UI Treatment**:
  - Gamified Dark Card Theme: Rich dark gradient surface (`#111827` to `#1F2937`) with neon gold/amber accents for prize amounts.
  - Jackpot Counter: Animated rolling ticker showing active prize pool in real-time.
  - Live Winner Marquee: Smooth horizontal scrolling pill showing recent winner phone numbers and payouts.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Update gaming card borders with amber/gold accent token.
  - Boost jackpot text to bold 24sp with glowing shadow.
  - Button CTA: Gradient fill with high vibrancy.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_rg56nxmm`.
  - Retain Backend API action chains for: `streetauth`, `getangles`, `playangle`.

---

#### `resultsummary` Screen
- **FlutterFlow Key**: `Scaffold_yt9l0n27`
- **Route Path**: `/resultsummary`
- **Typed SDK File**: [`resultsummary.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/resultsummary.dart)
- **Flutter Source**: [`resultsummary_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/resultsummary/resultsummary_widget.dart)
- **Flutter Model**: [`resultsummary_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/lotto/resultsummary/resultsummary_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Quiz Results", "Congratulations!", "You\", "Correct"
- Module context: Core component of StreetPool Gaming & Lottery.

**2. Layout & Widget Architecture:**
- Total Widgets: **77** nodes (29 Text, 13 Row, 12 Column, 9 Container, 9 Icon).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High visual clutter with games, prize pools, and live winning tickers competing for attention.
  - Spin wheel / flip cards need fluid animations and clear win/loss state modals.
  - Rules and entry fees are sometimes buried below the fold.
- **Recommended Modern UI Treatment**:
  - Gamified Dark Card Theme: Rich dark gradient surface (`#111827` to `#1F2937`) with neon gold/amber accents for prize amounts.
  - Jackpot Counter: Animated rolling ticker showing active prize pool in real-time.
  - Live Winner Marquee: Smooth horizontal scrolling pill showing recent winner phone numbers and payouts.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Update gaming card borders with amber/gold accent token.
  - Boost jackpot text to bold 24sp with glowing shadow.
  - Button CTA: Gradient fill with high vibrancy.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_yt9l0n27`.

---

#### `streetpollpay` Screen
- **FlutterFlow Key**: `Scaffold_s3u0s3zv`
- **Route Path**: `/streetpollpay`
- **Typed SDK File**: [`streetpollpay.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/streetpollpay.dart)
- **Flutter Source**: [`streetpollpay_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetpool/streetpollpay/streetpollpay_widget.dart)
- **Flutter Model**: [`streetpollpay_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetpool/streetpollpay/streetpollpay_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Join StreetShare", "Join Amount: ₦${widget!.amount}", "PARTICIPANTS", "POOL STATUS"
- Module context: Core component of StreetPool Gaming & Lottery.

**2. Layout & Widget Architecture:**
- Total Widgets: **32** nodes (12 Text, 7 Column, 5 Container, 3 Row, 1 Scaffold).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `gettransactiontoken` (Button), `debitwallet` (Button), `StreetSHStore` (Button)
- Custom Actions: `generatetransref` (Button), `getdeviceid` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High visual clutter with games, prize pools, and live winning tickers competing for attention.
  - Spin wheel / flip cards need fluid animations and clear win/loss state modals.
  - Rules and entry fees are sometimes buried below the fold.
- **Recommended Modern UI Treatment**:
  - Gamified Dark Card Theme: Rich dark gradient surface (`#111827` to `#1F2937`) with neon gold/amber accents for prize amounts.
  - Jackpot Counter: Animated rolling ticker showing active prize pool in real-time.
  - Live Winner Marquee: Smooth horizontal scrolling pill showing recent winner phone numbers and payouts.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Update gaming card borders with amber/gold accent token.
  - Boost jackpot text to bold 24sp with glowing shadow.
  - Button CTA: Gradient fill with high vibrancy.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_s3u0s3zv`.
  - Retain Backend API action chains for: `gettransactiontoken`, `debitwallet`, `StreetSHStore`.
  - Preserve Custom Action invocations: `generatetransref`, `getdeviceid`.

---

#### `streetpoolresult` Screen
- **FlutterFlow Key**: `Scaffold_ryvv6t7l`
- **Route Path**: `/streetpoolresult`
- **Typed SDK File**: [`streetpoolresult.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/streetpoolresult.dart)
- **Flutter Source**: [`streetpoolresult_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetpool/streetpoolresult/streetpoolresult_widget.dart)
- **Flutter Model**: [`streetpoolresult_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetpool/streetpoolresult/streetpoolresult_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "StreetShare Results", "Total Collected", "Participants", "Per Person"
- Module context: Core component of StreetPool Gaming & Lottery.

**2. Layout & Widget Architecture:**
- Total Widgets: **39** nodes (14 Text, 8 Column, 7 Container, 5 Row, 2 Divider).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - High visual clutter with games, prize pools, and live winning tickers competing for attention.
  - Spin wheel / flip cards need fluid animations and clear win/loss state modals.
  - Rules and entry fees are sometimes buried below the fold.
- **Recommended Modern UI Treatment**:
  - Gamified Dark Card Theme: Rich dark gradient surface (`#111827` to `#1F2937`) with neon gold/amber accents for prize amounts.
  - Jackpot Counter: Animated rolling ticker showing active prize pool in real-time.
  - Live Winner Marquee: Smooth horizontal scrolling pill showing recent winner phone numbers and payouts.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Update gaming card borders with amber/gold accent token.
  - Boost jackpot text to bold 24sp with glowing shadow.
  - Button CTA: Gradient fill with high vibrancy.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_ryvv6t7l`.

---

### Module 7: StreetJob Marketplace & Public Offers
> *Community gig marketplace, coupon offers, ticket reservations, and earning programs. (8 screens)*

#### `createoffer` Screen
- **FlutterFlow Key**: `Scaffold_8cwmnle9`
- **Route Path**: `/createoffer`
- **Typed SDK File**: [`createoffer.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/createoffer.dart)
- **Flutter Source**: [`createoffer_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/publicoffer/createoffer/createoffer_widget.dart)
- **Flutter Model**: [`createoffer_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/publicoffer/createoffer/createoffer_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Create Public Offer", "Create an attractive offer", "Enter company name", "Enter Office Address"
- Module context: Core component of StreetJob Marketplace & Public Offers.

**2. Layout & Widget Architecture:**
- Total Widgets: **54** nodes (15 Text, 15 Column, 8 TextField, 4 Row, 4 Button).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (8): `textController1`, `textController2`, `textController3`, `textController4`, `textController5`, `textController6`, `textController7`, `textController8`
- Backend API Requests: `getoffercharges` (Button), `gettransactiontoken` (Button), `debitwallet` (Button), `addoffer` (Button)
- Custom Actions: `generatetransref` (Button), `getdeviceid` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Job listings lack concise metadata badges (Payout, Duration, Spots Available).
  - Offer creation flow needs structured form steps rather than a single long scroll.
- **Recommended Modern UI Treatment**:
  - Marketplace Listing Card: Elevated card featuring gig title, company/user avatar, reward tag, and time remaining pill.
  - Filter Chips: Sticky horizontal filter bar (All, Micro-tasks, Surveys, Deliveries, Offers).
  - Application Modal: Clean slide-up bottom sheet with instant 'Accept Job' slider.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Reward badge background to light emerald/green with dark green text.
  - Card border radius to 16dp with subtle border.
  - Action button: Full-width modern pill button.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_8cwmnle9`.
  - Preserve all 8 TextEditingController bindings: `textController1`, `textController2`, `textController3`, `textController4`.
  - Retain Backend API action chains for: `getoffercharges`, `gettransactiontoken`, `debitwallet`.
  - Preserve Custom Action invocations: `generatetransref`, `getdeviceid`.

---

#### `earnwithus` Screen
- **FlutterFlow Key**: `Scaffold_rz2l8a1g`
- **Route Path**: `/earnwithus`
- **Typed SDK File**: [`earnwithus.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/earnwithus.dart)
- **Flutter Source**: [`earnwithus_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/earnwithus/earnwithus_widget.dart)
- **Flutter Model**: [`earnwithus_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/earnwithus/earnwithus_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Cash points", "Earn with us", "Earn on all transaction and referral", "Transaction Count"
- Module context: Core component of StreetJob Marketplace & Public Offers.

**2. Layout & Widget Architecture:**
- Total Widgets: **111** nodes (32 Text, 22 Column, 19 Row, 10 Container, 10 Button).
- Registered Action Triggers: `ON_TAB_CHANGE`, `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (1): `textController`
- Backend API Requests: `getpoints` (earnwithus), `getcashbackall` (earnwithus), `geturl` (Button), `savewhatsapp` (Button), `getpoints` (Button), `getcashback` (Button), `getcashback` (Button), `getcashbackall` (Button)
- Page State Variables: `allwinner` (Boolean), `cashbacksearch` (List<JSON>), `cashbackss` (List<JSON>), `issearch` (Boolean), `issearchcash` (Boolean), `mycash` (Boolean), `myycash` (List<JSON>), `pointse` (List<JSON>)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Job listings lack concise metadata badges (Payout, Duration, Spots Available).
  - Offer creation flow needs structured form steps rather than a single long scroll.
- **Recommended Modern UI Treatment**:
  - Marketplace Listing Card: Elevated card featuring gig title, company/user avatar, reward tag, and time remaining pill.
  - Filter Chips: Sticky horizontal filter bar (All, Micro-tasks, Surveys, Deliveries, Offers).
  - Application Modal: Clean slide-up bottom sheet with instant 'Accept Job' slider.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Reward badge background to light emerald/green with dark green text.
  - Card border radius to 16dp with subtle border.
  - Action button: Full-width modern pill button.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_rz2l8a1g`.
  - Preserve all 1 TextEditingController bindings: `textController`.
  - Retain Backend API action chains for: `getpoints`, `getcashbackall`, `geturl`.

---

#### `offerdetail` Screen
- **FlutterFlow Key**: `Scaffold_0qjw5reg`
- **Route Path**: `/offerdetail`
- **Typed SDK File**: [`offerdetail.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/offerdetail.dart)
- **Flutter Source**: [`offerdetail_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/publicoffer/offerdetail/offerdetail_widget.dart)
- **Flutter Model**: [`offerdetail_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/publicoffer/offerdetail/offerdetail_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Offer detail"
- Module context: Core component of StreetJob Marketplace & Public Offers.

**2. Layout & Widget Architecture:**
- Total Widgets: **6** nodes (1 Scaffold, 1 AppBar, 1 IconButton, 1 Text, 1 Column).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Job listings lack concise metadata badges (Payout, Duration, Spots Available).
  - Offer creation flow needs structured form steps rather than a single long scroll.
- **Recommended Modern UI Treatment**:
  - Marketplace Listing Card: Elevated card featuring gig title, company/user avatar, reward tag, and time remaining pill.
  - Filter Chips: Sticky horizontal filter bar (All, Micro-tasks, Surveys, Deliveries, Offers).
  - Application Modal: Clean slide-up bottom sheet with instant 'Accept Job' slider.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Reward badge background to light emerald/green with dark green text.
  - Card border radius to 16dp with subtle border.
  - Action button: Full-width modern pill button.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_0qjw5reg`.

---

#### `publicoffer` Screen
- **FlutterFlow Key**: `Scaffold_6zbqqv80`
- **Route Path**: `/publicoffer`
- **Typed SDK File**: [`publicoffer.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/publicoffer.dart)
- **Flutter Source**: [`publicoffer_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/publicoffer/publicoffer/publicoffer_widget.dart)
- **Flutter Model**: [`publicoffer_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/publicoffer/publicoffer/publicoffer_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Public Offers", "Public Offers In Your Area", "Clear filter ", "******* "
- Module context: Core component of StreetJob Marketplace & Public Offers.

**2. Layout & Widget Architecture:**
- Total Widgets: **80** nodes (25 Text, 17 Row, 13 Column, 8 Container, 8 Icon).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (1): `textController`
- Backend API Requests: `getoffercharges` (Container), `gettransactiontoken` (Container), `debitwallet` (Container), `getoffercharges` (Container), `gettransactiontoken` (Container), `debitwallet` (Container), `enableoffer` (switchss)
- Custom Actions: `getdeviceid` (Container), `generatetransref` (Container), `getdeviceid` (Container), `generatetransref` (Container)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Job listings lack concise metadata badges (Payout, Duration, Spots Available).
  - Offer creation flow needs structured form steps rather than a single long scroll.
- **Recommended Modern UI Treatment**:
  - Marketplace Listing Card: Elevated card featuring gig title, company/user avatar, reward tag, and time remaining pill.
  - Filter Chips: Sticky horizontal filter bar (All, Micro-tasks, Surveys, Deliveries, Offers).
  - Application Modal: Clean slide-up bottom sheet with instant 'Accept Job' slider.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Reward badge background to light emerald/green with dark green text.
  - Card border radius to 16dp with subtle border.
  - Action button: Full-width modern pill button.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_6zbqqv80`.
  - Preserve all 1 TextEditingController bindings: `textController`.
  - Retain Backend API action chains for: `getoffercharges`, `gettransactiontoken`, `debitwallet`.
  - Preserve Custom Action invocations: `getdeviceid`, `generatetransref`, `getdeviceid`.

---

#### `Questionaire` Screen
- **FlutterFlow Key**: `Scaffold_8gokuo0e`
- **Route Path**: `/questionaire`
- **Typed SDK File**: [`questionaire.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/questionaire.dart)
- **Flutter Source**: [`questionaire_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/questionaire/questionaire_widget.dart)
- **Flutter Model**: [`questionaire_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/questionaire/questionaire_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Secret Question", "Referred by (optional)", "Only one word is allowed"
- Module context: Core component of StreetJob Marketplace & Public Offers.

**2. Layout & Widget Architecture:**
- Total Widgets: **17** nodes (4 Column, 3 Text, 3 TextField, 1 Scaffold, 1 AppBar).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (3): `textController1`, `textController2`, `textController3`
- Backend API Requests: `streetauth` (Button), `postquestions` (Button)
- Custom Actions: `isValidSingleWord` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Job listings lack concise metadata badges (Payout, Duration, Spots Available).
  - Offer creation flow needs structured form steps rather than a single long scroll.
- **Recommended Modern UI Treatment**:
  - Marketplace Listing Card: Elevated card featuring gig title, company/user avatar, reward tag, and time remaining pill.
  - Filter Chips: Sticky horizontal filter bar (All, Micro-tasks, Surveys, Deliveries, Offers).
  - Application Modal: Clean slide-up bottom sheet with instant 'Accept Job' slider.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Reward badge background to light emerald/green with dark green text.
  - Card border radius to 16dp with subtle border.
  - Action button: Full-width modern pill button.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_8gokuo0e`.
  - Preserve all 3 TextEditingController bindings: `textController1`, `textController2`, `textController3`.
  - Retain Backend API action chains for: `streetauth`, `postquestions`.
  - Preserve Custom Action invocations: `isValidSingleWord`.

---

#### `streetjob` Screen
- **FlutterFlow Key**: `Scaffold_qig9lu90`
- **Route Path**: `/streetjob`
- **Typed SDK File**: [`streetjob.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/streetjob.dart)
- **Flutter Source**: [`streetjob_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/streetjob/streetjob_widget.dart)
- **Flutter Model**: [`streetjob_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/streetjob/streetjob_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Street Job Hub", "Find Top Talent", "Browse Categories", "Development"
- Module context: Core component of StreetJob Marketplace & Public Offers.

**2. Layout & Widget Architecture:**
- Total Widgets: **104** nodes (33 Container, 30 Text, 14 Column, 13 Row, 6 Icon).

**3. State & Integrations:**
- Form Input Controllers (1): `textController`

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Job listings lack concise metadata badges (Payout, Duration, Spots Available).
  - Offer creation flow needs structured form steps rather than a single long scroll.
- **Recommended Modern UI Treatment**:
  - Marketplace Listing Card: Elevated card featuring gig title, company/user avatar, reward tag, and time remaining pill.
  - Filter Chips: Sticky horizontal filter bar (All, Micro-tasks, Surveys, Deliveries, Offers).
  - Application Modal: Clean slide-up bottom sheet with instant 'Accept Job' slider.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Reward badge background to light emerald/green with dark green text.
  - Card border radius to 16dp with subtle border.
  - Action button: Full-width modern pill button.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_qig9lu90`.
  - Preserve all 1 TextEditingController bindings: `textController`.

---

#### `streetjob2` Screen
- **FlutterFlow Key**: `Scaffold_03vevgdq`
- **Route Path**: `/streetjob2`
- **Typed SDK File**: [`streetjob2.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/streetjob2.dart)
- **Flutter Source**: [`streetjob2_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/streetjob2/streetjob2_widget.dart)
- **Flutter Model**: [`streetjob2_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetjob/streetjob2/streetjob2_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Street Job", "People Near You"
- Module context: Core component of StreetJob Marketplace & Public Offers.

**2. Layout & Widget Architecture:**
- Total Widgets: **25** nodes (6 Container, 5 Row, 5 Text, 4 Column, 1 Scaffold).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (1): `textController`
- Backend API Requests: `searchbycategory` (streetjob2), `retrievejobprofile` (streetjob2)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Job listings lack concise metadata badges (Payout, Duration, Spots Available).
  - Offer creation flow needs structured form steps rather than a single long scroll.
- **Recommended Modern UI Treatment**:
  - Marketplace Listing Card: Elevated card featuring gig title, company/user avatar, reward tag, and time remaining pill.
  - Filter Chips: Sticky horizontal filter bar (All, Micro-tasks, Surveys, Deliveries, Offers).
  - Application Modal: Clean slide-up bottom sheet with instant 'Accept Job' slider.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Reward badge background to light emerald/green with dark green text.
  - Card border radius to 16dp with subtle border.
  - Action button: Full-width modern pill button.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_03vevgdq`.
  - Preserve all 1 TextEditingController bindings: `textController`.
  - Retain Backend API action chains for: `searchbycategory`, `retrievejobprofile`.

---

#### `tickectbooking` Screen
- **FlutterFlow Key**: `Scaffold_k85nksxr`
- **Route Path**: `/tickectbooking`
- **Typed SDK File**: [`tickectbooking.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/tickectbooking.dart)
- **Flutter Source**: [`tickectbooking_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/tickectbooking/tickectbooking_widget.dart)
- **Flutter Model**: [`tickectbooking_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/tickectbooking/tickectbooking_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Talk to us", "Need assistance?", "Create Support Ticket", "Recent Tickets"
- Module context: Core component of StreetJob Marketplace & Public Offers.

**2. Layout & Widget Architecture:**
- Total Widgets: **40** nodes (11 Text, 7 Container, 5 Column, 4 Row, 3 Button).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (2): `textController1`, `textController2`

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Job listings lack concise metadata badges (Payout, Duration, Spots Available).
  - Offer creation flow needs structured form steps rather than a single long scroll.
- **Recommended Modern UI Treatment**:
  - Marketplace Listing Card: Elevated card featuring gig title, company/user avatar, reward tag, and time remaining pill.
  - Filter Chips: Sticky horizontal filter bar (All, Micro-tasks, Surveys, Deliveries, Offers).
  - Application Modal: Clean slide-up bottom sheet with instant 'Accept Job' slider.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Reward badge background to light emerald/green with dark green text.
  - Card border radius to 16dp with subtle border.
  - Action button: Full-width modern pill button.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_k85nksxr`.
  - Preserve all 2 TextEditingController bindings: `textController1`, `textController2`.

---

### Module 8: Access Delegation & Batch Processing
> *Sub-account authorization, multi-party access delegations, and batch payroll/disbursements. (7 screens)*

#### `autodicover` Screen
- **FlutterFlow Key**: `Scaffold_oju5fvj1`
- **Route Path**: `/autodicover`
- **Typed SDK File**: [`autodicover.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/autodicover.dart)
- **Flutter Source**: [`autodicover_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/components/autodicover_widget.dart)
- **Flutter Model**: [`autodicover_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/components/autodicover_model.dart)

**1. Functional Role & User Flow:**
- Module context: Core component of Access Delegation & Batch Processing.

**2. Layout & Widget Architecture:**
- Total Widgets: **1** nodes (1 Container).

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Multi-row batch tables can cause horizontal overflow on mobile screens.
  - Delegated permissions lack granular toggle switches and expiration indicators.
- **Recommended Modern UI Treatment**:
  - Batch Summary Card: Header card displaying Total Count, Total Sum, Success Rate, and Status badge.
  - Responsive Mobile Table: Replace rigid tables with expandable card list items on viewports < 600px.
  - Permission Checklist: Switch tiles with descriptive subtitles and clear 'Revoke Access' destructive button.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Status chips: Green for Approved, Yellow for Pending, Red for Rejected.
  - Card container padding to 16dp uniform.
  - Monospace font for batch transaction reference numbers.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_oju5fvj1`.

---

#### `autodiscover1` Screen
- **FlutterFlow Key**: `Scaffold_b89emkjk`
- **Route Path**: `/autodiscover1`
- **Typed SDK File**: [`autodiscover1.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/autodiscover1.dart)
- **Flutter Source**: [`autodiscover1_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/autodiscover1/autodiscover1_widget.dart)
- **Flutter Model**: [`autodiscover1_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/autodiscover1/autodiscover1_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Nearby Discovery"
- Module context: Core component of Access Delegation & Batch Processing.

**2. Layout & Widget Architecture:**
- Total Widgets: **6** nodes (1 Scaffold, 1 AppBar, 1 IconButton, 1 Text, 1 Column).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Multi-row batch tables can cause horizontal overflow on mobile screens.
  - Delegated permissions lack granular toggle switches and expiration indicators.
- **Recommended Modern UI Treatment**:
  - Batch Summary Card: Header card displaying Total Count, Total Sum, Success Rate, and Status badge.
  - Responsive Mobile Table: Replace rigid tables with expandable card list items on viewports < 600px.
  - Permission Checklist: Switch tiles with descriptive subtitles and clear 'Revoke Access' destructive button.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Status chips: Green for Approved, Yellow for Pending, Red for Rejected.
  - Card container padding to 16dp uniform.
  - Monospace font for batch transaction reference numbers.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_b89emkjk`.

---

#### `batchsingle` Screen
- **FlutterFlow Key**: `Scaffold_c49686h8`
- **Route Path**: `/batchsingle`
- **Typed SDK File**: [`batchsingle.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/batchsingle.dart)
- **Flutter Source**: [`batchsingle_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/batchtransaction/batchsingle/batchsingle_widget.dart)
- **Flutter Model**: [`batchsingle_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/batchtransaction/batchsingle/batchsingle_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Batch View", "17 Transactions", "Hello World", "₦ 22,000,000"
- Module context: Core component of Access Delegation & Batch Processing.

**2. Layout & Widget Architecture:**
- Total Widgets: **25** nodes (8 Text, 6 Row, 3 Column, 2 Icon, 1 Scaffold).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Multi-row batch tables can cause horizontal overflow on mobile screens.
  - Delegated permissions lack granular toggle switches and expiration indicators.
- **Recommended Modern UI Treatment**:
  - Batch Summary Card: Header card displaying Total Count, Total Sum, Success Rate, and Status badge.
  - Responsive Mobile Table: Replace rigid tables with expandable card list items on viewports < 600px.
  - Permission Checklist: Switch tiles with descriptive subtitles and clear 'Revoke Access' destructive button.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Status chips: Green for Approved, Yellow for Pending, Red for Rejected.
  - Card container padding to 16dp uniform.
  - Monospace font for batch transaction reference numbers.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_c49686h8`.

---

#### `grant_access` Screen
- **FlutterFlow Key**: `Scaffold_mwqkfzgu`
- **Route Path**: `/grantAccess`
- **Typed SDK File**: [`grant_access.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/grant_access.dart)
- **Flutter Source**: [`grant_access_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/access/grant_access/grant_access_widget.dart)
- **Flutter Model**: [`grant_access_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/access/grant_access/grant_access_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Access Granted by Me", "Username", "Guest Phone", "Unable to revoke access try again"
- Module context: Core component of Access Delegation & Batch Processing.

**2. Layout & Widget Architecture:**
- Total Widgets: **30** nodes (6 Text, 6 Container, 3 Column, 3 PlaceholderWidget, 3 DataTableHeader).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `streetauth` (grant_access), `listguestprofile` (grant_access), `listhostprofile` (grant_access), `revokeguest` (Icon)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Multi-row batch tables can cause horizontal overflow on mobile screens.
  - Delegated permissions lack granular toggle switches and expiration indicators.
- **Recommended Modern UI Treatment**:
  - Batch Summary Card: Header card displaying Total Count, Total Sum, Success Rate, and Status badge.
  - Responsive Mobile Table: Replace rigid tables with expandable card list items on viewports < 600px.
  - Permission Checklist: Switch tiles with descriptive subtitles and clear 'Revoke Access' destructive button.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Status chips: Green for Approved, Yellow for Pending, Red for Rejected.
  - Card container padding to 16dp uniform.
  - Monospace font for batch transaction reference numbers.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_mwqkfzgu`.
  - Retain Backend API action chains for: `streetauth`, `listguestprofile`, `listhostprofile`.

---

#### `secureuser` Screen
- **FlutterFlow Key**: `Scaffold_4lpap9os`
- **Route Path**: `/secureuser`
- **Typed SDK File**: [`secureuser.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/secureuser.dart)
- **Flutter Source**: [`secureuser_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetsecure/secureuser/secureuser_widget.dart)
- **Flutter Model**: [`secureuser_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetsecure/secureuser/secureuser_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Connections", "Be a Smart Visitor", "Search Result", "Connection History"
- Module context: Core component of Access Delegation & Batch Processing.

**2. Layout & Widget Architecture:**
- Total Widgets: **47** nodes (14 Column, 11 Container, 9 Text, 2 Tab, 2 PlaceholderWidget).
- Registered Action Triggers: `ON_TEXTFIELD_CHANGE`, `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (1): `textController`
- Backend API Requests: `streetauth` (secureuser), `getrequestlist` (secureuser), `getsecurehistory` (secureuser), `locationdetect` (FloatingActionButton), `retriveaccountfromwalletid` (TextField)
- Custom Actions: `getlocationpermission` (FloatingActionButton), `checkJsonList` (Container)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Multi-row batch tables can cause horizontal overflow on mobile screens.
  - Delegated permissions lack granular toggle switches and expiration indicators.
- **Recommended Modern UI Treatment**:
  - Batch Summary Card: Header card displaying Total Count, Total Sum, Success Rate, and Status badge.
  - Responsive Mobile Table: Replace rigid tables with expandable card list items on viewports < 600px.
  - Permission Checklist: Switch tiles with descriptive subtitles and clear 'Revoke Access' destructive button.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Status chips: Green for Approved, Yellow for Pending, Red for Rejected.
  - Card container padding to 16dp uniform.
  - Monospace font for batch transaction reference numbers.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_4lpap9os`.
  - Preserve all 1 TextEditingController bindings: `textController`.
  - Retain Backend API action chains for: `streetauth`, `getrequestlist`, `getsecurehistory`.
  - Preserve Custom Action invocations: `getlocationpermission`, `checkJsonList`.

---

#### `viewbatch` Screen
- **FlutterFlow Key**: `Scaffold_kl48ff6y`
- **Route Path**: `/viewbatch`
- **Typed SDK File**: [`viewbatch.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/viewbatch.dart)
- **Flutter Source**: [`viewbatch_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/batchtransaction/viewbatch/viewbatch_widget.dart)
- **Flutter Model**: [`viewbatch_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/batchtransaction/viewbatch/viewbatch_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Batch list", "ALL BATCHES", "Set Date", "Hello World"
- Module context: Core component of Access Delegation & Batch Processing.

**2. Layout & Widget Architecture:**
- Total Widgets: **27** nodes (10 Text, 6 Row, 3 Column, 2 Icon, 1 Scaffold).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Multi-row batch tables can cause horizontal overflow on mobile screens.
  - Delegated permissions lack granular toggle switches and expiration indicators.
- **Recommended Modern UI Treatment**:
  - Batch Summary Card: Header card displaying Total Count, Total Sum, Success Rate, and Status badge.
  - Responsive Mobile Table: Replace rigid tables with expandable card list items on viewports < 600px.
  - Permission Checklist: Switch tiles with descriptive subtitles and clear 'Revoke Access' destructive button.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Status chips: Green for Approved, Yellow for Pending, Red for Rejected.
  - Card container padding to 16dp uniform.
  - Monospace font for batch transaction reference numbers.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_kl48ff6y`.

---

#### `viewmyacces` Screen
- **FlutterFlow Key**: `Scaffold_xrcu0fqv`
- **Route Path**: `/viewmyacces`
- **Typed SDK File**: [`viewmyacces.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/viewmyacces.dart)
- **Flutter Source**: [`viewmyacces_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/access/viewmyacces/viewmyacces_widget.dart)
- **Flutter Model**: [`viewmyacces_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/access/viewmyacces/viewmyacces_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Access Granted by Hosts", "Username", "Host Phone", "View"
- Module context: Core component of Access Delegation & Batch Processing.

**2. Layout & Widget Architecture:**
- Total Widgets: **25** nodes (7 Text, 4 Container, 3 PlaceholderWidget, 3 DataTableHeader, 2 Column).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `listhostprofile` (viewmyacces), `returntierprofile` (Text)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Multi-row batch tables can cause horizontal overflow on mobile screens.
  - Delegated permissions lack granular toggle switches and expiration indicators.
- **Recommended Modern UI Treatment**:
  - Batch Summary Card: Header card displaying Total Count, Total Sum, Success Rate, and Status badge.
  - Responsive Mobile Table: Replace rigid tables with expandable card list items on viewports < 600px.
  - Permission Checklist: Switch tiles with descriptive subtitles and clear 'Revoke Access' destructive button.
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Status chips: Green for Approved, Yellow for Pending, Red for Rejected.
  - Card container padding to 16dp uniform.
  - Monospace font for batch transaction reference numbers.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_xrcu0fqv`.
  - Retain Backend API action chains for: `listhostprofile`, `returntierprofile`.

---

### Module 9: Utility, Chat & System Pages
> *Live customer support chat, empty states, network error fallbacks, maintenance, and transaction logs. (25 screens)*

#### `AccountSettings` Screen
- **FlutterFlow Key**: `Scaffold_82igl7bp`
- **Route Path**: `/accountSettings`
- **Typed SDK File**: [`account_settings.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/account_settings.dart)
- **Flutter Source**: [`account_settings_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/settings/account_settings/account_settings_widget.dart)
- **Flutter Model**: [`account_settings_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/settings/account_settings/account_settings_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Account Settings", "Accounts Linked To Your BVN", "My Accounts"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **11** nodes (5 Text, 1 Scaffold, 1 AppBar, 1 IconButton, 1 Column).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_82igl7bp`.

---

#### `AppSettings` Screen
- **FlutterFlow Key**: `Scaffold_7xiev2sa`
- **Route Path**: `/appSettings`
- **Typed SDK File**: [`app_settings.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/app_settings.dart)
- **Flutter Source**: [`app_settings_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/app_settings/app_settings_widget.dart)
- **Flutter Model**: [`app_settings_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/app_settings/app_settings_model.dart)

**1. Functional Role & User Flow:**
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **8** nodes (5 Container, 1 Scaffold, 1 Stack, 1 Column).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `wallet enquiry` (AppSettings)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_7xiev2sa`.
  - Retain Backend API action chains for: `wallet enquiry`.

---

#### `BillPayment` Screen
- **FlutterFlow Key**: `Scaffold_ut0mmr1a`
- **Route Path**: `/billPayment`
- **Typed SDK File**: [`bill_payment.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/bill_payment.dart)
- **Flutter Source**: [`bill_payment_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/bill_payment/bill_payment_widget.dart)
- **Flutter Model**: [`bill_payment_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/bill_payment/bill_payment_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Pay a Bill", "RECEIVER", "Bill Successfully Ignore"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **15** nodes (2 Text, 2 Container, 2 Column, 2 TextField, 2 Button).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (2): `textController1`, `textController2`
- Backend API Requests: `streetauth` (BillPayment), `getaccountno` (BillPayment), `wallet enquiry` (BillPayment), `ignorebill` (Button)
- Custom Actions: `generatetransref` (Button), `generateseesionid` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_ut0mmr1a`.
  - Preserve all 2 TextEditingController bindings: `textController1`, `textController2`.
  - Retain Backend API action chains for: `streetauth`, `getaccountno`, `wallet enquiry`.
  - Preserve Custom Action invocations: `generatetransref`, `generateseesionid`.

---

#### `BillPosting` Screen
- **FlutterFlow Key**: `Scaffold_ihwe1lss`
- **Route Path**: `/billPosting`
- **Typed SDK File**: [`bill_posting.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/bill_posting.dart)
- **Flutter Source**: [`bill_posting_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/bill_posting/bill_posting_widget.dart)
- **Flutter Model**: [`bill_posting_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/bill_posting/bill_posting_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Post a Bill", "RECEIVER", "Description is required"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **15** nodes (3 TextField, 2 Text, 2 Container, 2 Column, 1 Scaffold).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (3): `textController1`, `textController2`, `textController3`
- Backend API Requests: `streetauth` (Button), `postbill` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_ihwe1lss`.
  - Preserve all 3 TextEditingController bindings: `textController1`, `textController2`, `textController3`.
  - Retain Backend API action chains for: `streetauth`, `postbill`.

---

#### `BillSuccess` Screen
- **FlutterFlow Key**: `Scaffold_lwwg8ip8`
- **Route Path**: `/billSuccess`
- **Typed SDK File**: [`bill_success.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/bill_success.dart)
- **Flutter Source**: [`bill_success_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/bill_success/bill_success_widget.dart)
- **Flutter Model**: [`bill_success_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/bills/bill_success/bill_success_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Your bill has been successfully posted"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **8** nodes (2 Column, 2 Spacer, 1 Scaffold, 1 Icon, 1 Text).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_lwwg8ip8`.

---

#### `changepassword` Screen
- **FlutterFlow Key**: `Scaffold_f5ucflsa`
- **Route Path**: `/changepassword`
- **Typed SDK File**: [`changepassword.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/changepassword.dart)
- **Flutter Source**: [`changepassword_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/changepassword/changepassword_widget.dart)
- **Flutter Model**: [`changepassword_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/changepassword/changepassword_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Security", "Change Password", "New Password", "Confirm New Password"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **16** nodes (5 Column, 4 Text, 2 TextField, 1 Scaffold, 1 AppBar).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (2): `textController1`, `textController2`
- Backend API Requests: `resetpincode` (Button), `getquestion` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_f5ucflsa`.
  - Preserve all 2 TextEditingController bindings: `textController1`, `textController2`.
  - Retain Backend API action chains for: `resetpincode`, `getquestion`.

---

#### `chat` Screen
- **FlutterFlow Key**: `Scaffold_id8tg8p6`
- **Route Path**: `/chat`
- **Typed SDK File**: [`chat.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/chat.dart)
- **Flutter Source**: [`chat_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/chat/chat_widget.dart)
- **Flutter Model**: [`chat_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/chat/chat_model.dart)

**1. Functional Role & User Flow:**
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **3** nodes (1 Scaffold, 1 Column, 1 WebView).

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_id8tg8p6`.

---

#### `contactus` Screen
- **FlutterFlow Key**: `Scaffold_ng9llmq6`
- **Route Path**: `/contactus`
- **Typed SDK File**: [`contactus.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/contactus.dart)
- **Flutter Source**: [`contactus_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/contactus/contactus_widget.dart)
- **Flutter Model**: [`contactus_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/contactus/contactus_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Contact Us", "Get in Touch", "We\", "Email Address"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **40** nodes (14 Text, 7 Column, 6 Container, 5 Row, 3 IconButton).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_ng9llmq6`.

---

#### `couponpay` Screen
- **FlutterFlow Key**: `Scaffold_8o6n264m`
- **Route Path**: `/couponpay`
- **Typed SDK File**: [`couponpay.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/couponpay.dart)
- **Flutter Source**: [`couponpay_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/couponpay/couponpay_widget.dart)
- **Flutter Model**: [`couponpay_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/couponpay/couponpay_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Fund Sharing", "Available Balance", "₦${FFAppState().avalbal}", "Claim a Code"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **54** nodes (16 Text, 10 Row, 9 Column, 8 Container, 2 IconButton).
- Registered Action Triggers: `ON_TEXTFIELD_CHANGE`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (1): `textController`
- Backend API Requests: `checkcuponcode` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_8o6n264m`.
  - Preserve all 1 TextEditingController bindings: `textController`.
  - Retain Backend API action chains for: `checkcuponcode`.

---

#### `couponreceipt` Screen
- **FlutterFlow Key**: `Scaffold_rdzyreog`
- **Route Path**: `/couponreceipt`
- **Typed SDK File**: [`couponreceipt.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/couponreceipt.dart)
- **Flutter Source**: [`couponreceipt_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/couponreceipt/couponreceipt_widget.dart)
- **Flutter Model**: [`couponreceipt_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/couponreceipt/couponreceipt_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Success!", "Your claim of #500 was successful", "Claim ID", "#CL-78945612"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **26** nodes (10 Text, 4 Column, 4 Container, 4 Row, 2 Button).

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_rdzyreog`.

---

#### `EmptyProfile` Screen
- **FlutterFlow Key**: `Scaffold_vi3w48ol`
- **Route Path**: `/emptyProfile`
- **Typed SDK File**: [`empty_profile.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/empty_profile.dart)
- **Flutter Source**: [`empty_profile_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/profile/empty_profile/empty_profile_widget.dart)
- **Flutter Model**: [`empty_profile_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/profile/empty_profile/empty_profile_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Tier 0", "Personal Details", "Only one word is allowed"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **15** nodes (3 Column, 3 Text, 2 Container, 2 TextField, 1 Scaffold).
- Registered Action Triggers: `ON_TEXTFIELD_CHANGE`, `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (2): `textController1`, `textController2`
- Backend API Requests: `streetauth` (EmptyProfile), `streetauth` (Button), `bvnlookup` (Button), `wassopen` (Button), `insertintotierone` (Button), `createNewId` (Button), `GetNINDetails` (Button), `openwallet` (Button), `insertintotierone` (Button), `createNewId` (Button)
- Custom Actions: `isValidSingleWord` (TextField)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_vi3w48ol`.
  - Preserve all 2 TextEditingController bindings: `textController1`, `textController2`.
  - Retain Backend API action chains for: `streetauth`, `streetauth`, `bvnlookup`.
  - Preserve Custom Action invocations: `isValidSingleWord`.

---

#### `EmptyProfileface` Screen
- **FlutterFlow Key**: `Scaffold_qdfkrt4z`
- **Route Path**: `/emptyProfileface`
- **Typed SDK File**: [`empty_profileface.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/empty_profileface.dart)
- **Flutter Source**: [`empty_profileface_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/profile/empty_profileface/empty_profileface_widget.dart)
- **Flutter Model**: [`empty_profileface_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/profile/empty_profileface/empty_profileface_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Tier 0", "Personal Details", "Only one word is allowed"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **15** nodes (3 Column, 3 Text, 2 Container, 2 TextField, 1 Scaffold).
- Registered Action Triggers: `ON_TEXTFIELD_CHANGE`, `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (2): `textController1`, `textController2`
- Backend API Requests: `streetauth` (EmptyProfileface), `streetauth` (Button), `faceverify` (Button), `wassopen` (Button), `insertintotierone` (Button), `createNewId` (Button), `faceverify` (Button), `openwallet` (Button), `insertintotierone` (Button), `createNewId` (Button)
- Custom Actions: `isValidSingleWord` (TextField), `newCustomAction2` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_qdfkrt4z`.
  - Preserve all 2 TextEditingController bindings: `textController1`, `textController2`.
  - Retain Backend API action chains for: `streetauth`, `streetauth`, `faceverify`.
  - Preserve Custom Action invocations: `isValidSingleWord`, `newCustomAction2`.

---

#### `errorpage` Screen
- **FlutterFlow Key**: `Scaffold_0vib6l00`
- **Route Path**: `/errorpage`
- **Typed SDK File**: [`errorpage.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/errorpage.dart)
- **Flutter Source**: [`errorpage_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/publicoffer/errorpage/errorpage_widget.dart)
- **Flutter Model**: [`errorpage_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/publicoffer/errorpage/errorpage_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Oops!", "Something went wrong"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **10** nodes (3 Text, 2 Column, 2 Container, 1 Scaffold, 1 Image).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_0vib6l00`.

---

#### `mainteinance` Screen
- **FlutterFlow Key**: `Scaffold_lntjr40l`
- **Route Path**: `/mainteinance`
- **Typed SDK File**: [`mainteinance.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/mainteinance.dart)
- **Flutter Source**: [`mainteinance_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/mainteinance/mainteinance_widget.dart)
- **Flutter Model**: [`mainteinance_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/mainteinance/mainteinance_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Under Maintenance", "We\", "Status", "System Maintenance"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **23** nodes (8 Text, 5 Column, 3 Container, 2 Row, 2 Icon).

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_lntjr40l`.

---

#### `ManualPayment` Screen
- **FlutterFlow Key**: `Scaffold_xapkpyhx`
- **Route Path**: `/manualPayment`
- **Typed SDK File**: [`manual_payment.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/manual_payment.dart)
- **Flutter Source**: [`manual_payment_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/manual_payment/manual_payment_widget.dart)
- **Flutter Model**: [`manual_payment_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/manual_payment/manual_payment_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Payment", "WALLET BALANCE", "SENDER", "RECEIVER"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **26** nodes (5 Text, 4 Container, 4 Column, 4 TextField, 2 IconButton).
- Registered Action Triggers: `ON_FORM_WIDGET_SELECTED`, `ON_TEXTFIELD_CHANGE`, `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (4): `textController1`, `textController2`, `textController3`, `textController4`
- Backend API Requests: `get bank list` (ManualPayment), `getaccountbalance` (ManualPayment), `getreceipent` (ChoiceChips), `getreceipent` (DropDown), `getreceipent` (IconButton), `returntierprofile` (Button)
- Custom Actions: `smartBankEnquiry` (TextField), `generatetransref` (Button), `generateseesionid` (Button)
- Page State Variables: `accountname` (String), `bankcode` (String), `bottoncolor` (Color), `index` (Integer), `manuel` (Boolean), `retry` (Boolean)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_xapkpyhx`.
  - Preserve all 4 TextEditingController bindings: `textController1`, `textController2`, `textController3`, `textController4`.
  - Retain Backend API action chains for: `get bank list`, `getaccountbalance`, `getreceipent`.
  - Preserve Custom Action invocations: `smartBankEnquiry`, `generatetransref`, `generateseesionid`.

---

#### `nointernet` Screen
- **FlutterFlow Key**: `Scaffold_yk7fei9x`
- **Route Path**: `/nointernet`
- **Typed SDK File**: [`nointernet.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/nointernet.dart)
- **Flutter Source**: [`nointernet_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/nointernet/nointernet_widget.dart)
- **Flutter Model**: [`nointernet_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/nointernet/nointernet_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "No Internet Connection", "Wi-Fi", "Not Connected", "Mobile Data"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **22** nodes (7 Text, 5 Column, 3 Container, 2 Row, 2 Icon).

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_yk7fei9x`.

---

#### `PaymentConfirmation` Screen
- **FlutterFlow Key**: `Scaffold_3xj8ff4w`
- **Route Path**: `/paymentConfirmation`
- **Typed SDK File**: [`payment_confirmation.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/payment_confirmation.dart)
- **Flutter Source**: [`payment_confirmation_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/payments/payment_confirmation/payment_confirmation_widget.dart)
- **Flutter Model**: [`payment_confirmation_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/payments/payment_confirmation/payment_confirmation_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Payment Confirmation", "Pinned Successfully", "Pin Payee", "Insufficient balance"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **25** nodes (14 Container, 2 Text, 2 Column, 1 Scaffold, 1 AppBar).
- Registered Action Triggers: `ON_TOGGLE_ON`, `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `streetauth` (PaymentConfirmation), `getphonen` (PaymentConfirmation), `getphonen` (PaymentConfirmation), `getpinnedphones` (PaymentConfirmation), `streetauth` (Checkbox), `getphonen` (Checkbox), `getphonen` (Checkbox), `insertpindata` (Checkbox), `returntierprofile` (Button), `wallet enquiry` (Button), `other bank transfer` (Button), `sendmail` (Button)
- Custom Actions: `generatetransref` (Button), `generateseesionid` (Button)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_3xj8ff4w`.
  - Retain Backend API action chains for: `streetauth`, `getphonen`, `getphonen`.
  - Preserve Custom Action invocations: `generatetransref`, `generateseesionid`.

---

#### `PaymentReceipt` Screen
- **FlutterFlow Key**: `Scaffold_un349561`
- **Route Path**: `/paymentReceipt`
- **Typed SDK File**: [`payment_receipt.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/payment_receipt.dart)
- **Flutter Source**: [`payment_receipt_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/payments/payment_receipt/payment_receipt_widget.dart)
- **Flutter Model**: [`payment_receipt_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/payments/payment_receipt/payment_receipt_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "PAYMENT DETAILS"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **22** nodes (8 Container, 4 Button, 3 Column, 2 Divider, 2 Spacer).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_un349561`.

---

#### `PaymentSuccess` Screen
- **FlutterFlow Key**: `Scaffold_pg90z7hy`
- **Route Path**: `/paymentSuccess`
- **Typed SDK File**: [`payment_success.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/payment_success.dart)
- **Flutter Source**: [`payment_success_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/payments/payment_success/payment_success_widget.dart)
- **Flutter Model**: [`payment_success_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/payments/payment_success/payment_success_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Your payment was successful"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **10** nodes (3 Column, 2 Spacer, 2 Button, 1 Scaffold, 1 Icon).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_pg90z7hy`.

---

#### `premiumconsent` Screen
- **FlutterFlow Key**: `Scaffold_tik5eri8`
- **Route Path**: `/premiumconsent`
- **Typed SDK File**: [`premiumconsent.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/premiumconsent.dart)
- **Flutter Source**: [`premiumconsent_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/premiumconsent/premiumconsent_widget.dart)
- **Flutter Model**: [`premiumconsent_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/onboarding/premiumconsent/premiumconsent_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Reset Password", "Premium Account Unlock", "Select Verification Method", "Service Fee: ₦150"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **24** nodes (8 Text, 7 Column, 1 Scaffold, 1 AppBar, 1 IconButton).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (1): `textController`

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_tik5eri8`.
  - Preserve all 1 TextEditingController bindings: `textController`.

---

#### `retrivedetails` Screen
- **FlutterFlow Key**: `Scaffold_f62ldnaa`
- **Route Path**: `/retrivedetails`
- **Typed SDK File**: [`retrivedetails.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/retrivedetails.dart)
- **Flutter Source**: [`retrivedetails_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/retrivedetails/retrivedetails_widget.dart)
- **Flutter Model**: [`retrivedetails_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/retrivedetails/retrivedetails_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Enter Your Code", "Please enter the code for payment below"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **16** nodes (4 RichTextSpan, 2 Column, 2 Text, 1 Scaffold, 1 AppBar).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Form Input Controllers (1): `textController`

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_f62ldnaa`.
  - Preserve all 1 TextEditingController bindings: `textController`.

---

#### `streetshareinto` Screen
- **FlutterFlow Key**: `Scaffold_kcu18aiy`
- **Route Path**: `/streetshareinto`
- **Typed SDK File**: [`streetshareinto.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/streetshareinto.dart)
- **Flutter Source**: [`streetshareinto_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetpool/streetshareinto/streetshareinto_widget.dart)
- **Flutter Model**: [`streetshareinto_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/streetpool/streetshareinto/streetshareinto_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "StreetShare", "Share. Earn. Repeat.", "Social & Interactive", "Instant Rewards"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **53** nodes (19 Text, 13 Column, 8 Container, 6 Row, 3 Icon).
- Registered Action Triggers: `ON_TAP`.

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_kcu18aiy`.

---

#### `testpage` Screen
- **FlutterFlow Key**: `Scaffold_r3p3f58v`
- **Route Path**: `/testpage`
- **Typed SDK File**: [`testpage.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/testpage.dart)
- **Flutter Source**: [`testpage_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/testpage/testpage_widget.dart)
- **Flutter Model**: [`testpage_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/testpage/testpage_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Welcome to Our App", "Key Features:", "• Clean and readable typography", "• Responsive text layout"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **10** nodes (7 Text, 1 Scaffold, 1 Column, 1 Container).

**3. State & Integrations:**
- Pure display / navigation screen with no direct form state.

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_r3p3f58v`.

---

#### `TransactionHistory` Screen
- **FlutterFlow Key**: `Scaffold_gzy55p1j`
- **Route Path**: `/transactionHistory`
- **Typed SDK File**: [`transaction_history.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/transaction_history.dart)
- **Flutter Source**: [`transaction_history_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/account/transaction_history/transaction_history_widget.dart)
- **Flutter Model**: [`transaction_history_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/account/transaction_history/transaction_history_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Transaction History", "Transactions", "Date must be within 30  days"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **34** nodes (12 Container, 10 Column, 3 Row, 3 Button, 2 Text).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `wallethistory` (TransactionHistory), `wallethistory` (TransactionHistory)
- Page State Variables: `istrue` (Boolean)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_gzy55p1j`.
  - Retain Backend API action chains for: `wallethistory`, `wallethistory`.

---

#### `TransactionHistorybatches` Screen
- **FlutterFlow Key**: `Scaffold_7swwi1o0`
- **Route Path**: `/transactionHistorybatches`
- **Typed SDK File**: [`transaction_historybatches.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/lib/flutterflow_project/pages/transaction_historybatches.dart)
- **Flutter Source**: [`transaction_historybatches_widget.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/account/transaction_historybatches/transaction_historybatches_widget.dart)
- **Flutter Model**: [`transaction_historybatches_model.dart`](file:///C:/Users/johna/Downloads/streetpay/ff-workspace/generated_code/lib/pages/account/transaction_historybatches/transaction_historybatches_model.dart)

**1. Functional Role & User Flow:**
- Prominent on-screen labels: "Transaction History - Guest", "Host- ${widget!.accountname}", "Transactions"
- Module context: Core component of Utility, Chat & System Pages.

**2. Layout & Widget Architecture:**
- Total Widgets: **18** nodes (5 Container, 4 Text, 4 Column, 1 Scaffold, 1 AppBar).
- Registered Action Triggers: `ON_INIT_STATE`, `ON_TAP`.

**3. State & Integrations:**
- Backend API Requests: `wallethistory` (TransactionHistorybatches)

**4. Redesign Agent Implementation Blueprint:**
- **Current UX Limitations**:
  - Chat interface needs smooth auto-scroll to bottom upon new message.
  - Error pages should provide friendly guidance and an instant retry button rather than technical jargon.
- **Recommended Modern UI Treatment**:
  - Modern Chat Bubble: Rounded message bubbles (18dp with 4dp corner for speech point) with distinct user/agent colors.
  - State Illustrations: Friendly SVG / Rive illustration for 'No Internet' or 'Maintenance' with single primary action.
  - Transaction History: Segmented control (All, Inflow, Outflow) with clean grouped date headers (Today, Yesterday, Older).
- **Fast-Lane Patch Candidates (`flutterflow_ai__patch`)**:
  - Set chat incoming bubble color to `secondaryBackground` and outgoing to `primary`.
  - Update retry button to modern outline or filled button with 12dp radius.
- **Safety Constraints**:
  - Do NOT rename or remove Scaffold key `Scaffold_7swwi1o0`.
  - Retain Backend API action chains for: `wallethistory`.

---
