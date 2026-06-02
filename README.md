<div align="center">

# QRSafe

**Scan a QR code. Know if it's safe — before you tap.**

QRSafe is a free iOS app that scans QR codes and instantly analyzes the link inside for scams, phishing, and malicious patterns. Built for the people most targeted by QR fraud: non-tech-savvy and elderly users.

[![Platform](https://img.shields.io/badge/platform-iOS%2016%2B-blue)]()
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)]()
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-green)]()
[![License](https://img.shields.io/badge/license-TBD-lightgrey)]()
[![100 Days of Code](https://img.shields.io/badge/%23100DaysOfCode-in%20progress-FF6B6B)]()

</div>

## Why

QR codes are everywhere: menus, parking meters, payment slips - and so are fake ones. 
A scammer swaps a sticker, you scan it, and you're on a phishing page that looks like your bank. 
QRSafe puts one check between the scan and the tap: **green = safe, yellow = be careful, red = danger.** 
No jargon, no accounts, no tracking.

## Features

- **Fast QR scanning** — real-time detection with the camera
- **Safety analysis** — checks the URL against phishing patterns, suspicious domains, and shady link tricks
- **Plain-language verdict** — color-coded result with *why* it's risky, in words anyone can read
- **Local history** — every scan saved on-device, searchable; nothing leaves your phone
- **6 languages** — English, Português (BR), Español, 日本語, Français, 한국어
- **Private by design** — no login, no cloud, no analytics; analysis runs offline

## What it does NOT do

Generate QR codes · require accounts · sync to the cloud · phone home. It only scans and analyzes. ([Non-goals in the PRD](docs/PRD.md).)

## How the safety check works

Each scanned URL runs through a local rule engine — no network call, no data sent anywhere:

| Check | Looks for |
|---|---|
| Protocol | `http://` instead of `https://` |
| Raw IP host | `http://192.168.x.x` instead of a domain |
| URL shorteners | links that hide the real destination |
| Suspicious TLDs | high-abuse top-level domains |
| Subdomain depth | `secure.login.bank.evil.com` tricks |
| Homograph / punycode | look-alike Unicode domains (`аpple.com`) |
| Phishing keywords | `verify`, `login`, brand-in-subdomain |
| Known lists | bundled malicious blacklist + safe whitelist |

Findings are weighted into a score, mapped to **Safe / Warning / Danger**.

## Screenshots

| Scan | Result | History |
|---|---|---|
| _coming soon_ | _coming soon_ | _coming soon_ |


## Tech stack

- **Language:** Swift 5.9+
- **UI:** SwiftUI
- **Platform:** iOS 16+
- **Camera:** AVFoundation
- **Storage:** SwiftData (on-device only)
- **Localization:** String Catalogs
- **Testing:** XCTest, XCUITest
- **CI:** GitHub Actions

## Architecture

MVVM with a pure, testable core

```
View  ──▶  ViewModel  ──▶  Service
(SwiftUI)  (@Observable)   (actor / pure fns)
```

- **CameraService** (`actor`) — capture session + QR detection
- **URLParser** (pure) — extract/normalize the link
- **SafetyAnalyzer** (`actor`) — runs the checks, returns a scored report
- **ScanStorage** (SwiftData) — persists history

Parsing and safety checks are pure functions → easy to unit-test.

## Roadmap

| Milestone | Focus |
|---|---|
| v0.1.0 | Project foundation, design system, components |
| v0.2.0 | QR scanner core |
| v0.3.0 | Safety analysis engine |
| v0.4.0 | Persistence & history |
| v0.5.0 | Localization & polish |
| v0.6.0 | Testing, CI/CD, App Store |

See the [PRD](docs/PRD.md) for the full plan.

## Author

**Carlos Daniel** — [GitHub](https://github.com/CarlosDanielDev)
