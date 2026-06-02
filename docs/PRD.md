# PRD: QRSafe

## 1. Project Identity

**Name:** QRSafe

**Description:** An iOS app to scan QR codes and check if they are safe, protecting users from scams and malicious links

**Primary Language:** Swift

**Tech Stack Summary:**
- Language: Swift 5.9+
- UI Framework: SwiftUI
- Platform: iOS 16+
- Build System: Xcode 15+, SPM
- Key Frameworks: AVFoundation, Vision
- Version Control: Git (GitHub)

## 2. Vision

Create a simple, user-friendly app that protects non-tech-savvy users (especially elderly) from QR code scams by providing instant safety analysis of scanned codes.

## 3. Goals

1. **Protect Users**: Detect malicious URLs, phishing attempts, and suspicious QR codes before users click
2. **Simple UX**: One-tap scanning with clear, color-coded safety results (green/yellow/red)
3. **Global Reach**: Support 6 languages (English, Portuguese BR, Spanish, Japanese, French, Korean)

## 4. Non-Goals

### What QRSafe Does NOT Do:

- **QR Code Generation**: This app only SCANS and ANALYZES QR codes, it does NOT create them
- **User Accounts/Login**: No authentication required; all data is local
- **Cloud Sync**: Scan history stays on device only
- **Deep Web Scanning**: Only surface-level URL analysis, not full website content scanning
- **VPN/Proxy Services**: Does not provide network protection beyond URL analysis
- **Desktop/Web App**: iOS only, no macOS, Android, or web versions planned initially
- **Enterprise Features**: No team management, MDM integration, or admin dashboards
- **Real-time Protection**: Only scans when user initiates, not background monitoring

## 5. Architecture Overview

### Module Map

```
┌─────────────────────────────────────────────────────────────┐
│                         App Layer                            │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────┐    │
│  │ Scanner  │ │ Result   │ │ History  │ │   Settings   │    │
│  │  View    │ │  View    │ │  View    │ │    View      │    │
│  └────┬─────┘ └────┬─────┘ └────┬─────┘ └──────┬───────┘    │
│       │            │            │              │             │
├───────┼────────────┼────────────┼──────────────┼─────────────┤
│       │      ViewModel Layer    │              │             │
│  ┌────┴─────┐ ┌────┴─────┐ ┌────┴─────┐ ┌─────┴──────┐      │
│  │ Scanner  │ │ Result   │ │ History  │ │  Settings  │      │
│  │ViewModel │ │ViewModel │ │ViewModel │ │  ViewModel │      │
│  └────┬─────┘ └────┬─────┘ └────┬─────┘ └─────┬──────┘      │
│       │            │            │              │             │
├───────┼────────────┼────────────┼──────────────┼─────────────┤
│       │        Service Layer    │              │             │
│  ┌────┴──────────────┴──────────┴──────────────┴───────┐    │
│  │                                                       │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐   │    │
│  │  │   Camera    │  │   Safety    │  │    Scan     │   │    │
│  │  │   Service   │  │  Analyzer   │  │   Storage   │   │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘   │    │
│  │                                                       │    │
│  │  ┌─────────────┐                                      │    │
│  │  │    URL      │                                      │    │
│  │  │   Parser    │                                      │    │
│  │  └─────────────┘                                      │    │
│  │                                                       │    │
│  └───────────────────────────────────────────────────────┘   │
│                                                               │
├───────────────────────────────────────────────────────────────┤
│                      External Frameworks                      │
│  ┌─────────────┐  ┌─────────────┐                            │
│  │ AVFoundation│  │   Vision    │                            │
│  └─────────────┘  └─────────────┘                            │
└───────────────────────────────────────────────────────────────┘
```

### Core Components

**Camera Service**
- Purpose: Capture camera feed and detect QR codes using AVFoundation
- Complexity: Medium
- Dependencies: AVFoundation, Vision

**Safety Analyzer**
- Purpose: Analyze URLs for phishing patterns, suspicious domains, and security threats
- Complexity: High
- Dependencies: URL Parser, local threat database

**URL Parser**
- Purpose: Extract and normalize URLs from scanned QR payloads
- Complexity: Low
- Dependencies: Foundation

**Scan Storage**
- Purpose: Persist scan history locally using SwiftData
- Complexity: Low
- Dependencies: SwiftData

## 6. Data Flow

### QR Code Scan Flow

```
User Points Camera → Camera Service Detects QR
        ↓
   URL Parser Extracts URL
        ↓
   Safety Analyzer Runs Checks
        ↓
   ┌────┴────┐
   │  Score  │
   └────┬────┘
Safe ↙  Warning  ↘ Danger
  ↓       ↓         ↓
Green    Yellow      Red
Result   Result    Result
        ↓
   Save to History
        ↓
   Show Result UI
```

### Safety Analysis Flow

```
Parsed URL
    ↓
┌───┴───────────────────────────────────────┐
│              Safety Checks                 │
├────────────────────────────────────────────┤
│ 1. Protocol (HTTPS?)                       │
│ 2. Known safe domains whitelist            │
│ 3. Known malicious domains blacklist       │
│ 4. Phishing keyword patterns               │
│ 5. Homograph attack detection              │
│ 6. URL shortener detection                 │
│ 7. IP address instead of domain            │
│ 8. Excessive subdomain depth               │
│ 9. Suspicious TLD analysis                 │
└────────────────────────────────────────────┘
    ↓
Aggregate Findings → Calculate Score → Return Report
```

## 7. Tech Stack

### Languages and Versions
- **Swift:** 5.9+
- **Minimum iOS:** 16.0

### Frameworks and Libraries
- **UI:** SwiftUI
- **Camera:** AVFoundation, AVCaptureMetadataOutput
- **QR Detection:** Built-in via AVFoundation
- **Storage:** SwiftData (or UserDefaults for simple data)
- **Localization:** String Catalogs (Localizable.xcstrings)

### Build Tools
- **Xcode:** 15.0+
- **SPM:** Swift Package Manager for dependencies

### CI/CD Pipeline
- **Provider:** GitHub Actions
- **Test Gate:** `xcodebuild test`
- **Release:** Fastlane to TestFlight

### Test Frameworks
- **Unit Testing:** XCTest
- **UI Testing:** XCUITest
- **Target Coverage:** 80%+

## 8. Current State

### Implementation Status
- **Phase:** Project initialization
- **Code:** Not yet implemented

### Milestones

| Version | Title | Focus |
|---------|-------|-------|
| v0.1.0 | Project Foundation | Xcode setup, design system, UI components |
| v0.2.0 | QR Scanner Core | Camera, QR detection, scanner UI |
| v0.3.0 | Safety Analysis Engine | URL parsing, threat detection, results |
| v0.4.0 | Persistence & History | SwiftData storage, scan history |
| v0.5.0 | Localization & Polish | 6 languages, onboarding, settings |
| v0.6.0 | Testing & Release | Tests, CI/CD, App Store submission |

### Test Coverage Status
- **Coverage:** 0% (not yet implemented)
- **Target:** 80% for services, 70% overall

## 9. Stakeholders

### Target Users
- **Primary:** Non-tech-savvy users, elderly individuals
- **Secondary:** Anyone concerned about QR code safety
- **Tertiary:** Parents wanting to teach kids about online safety

### User Personas

**Maria, 68, Retired Teacher**
- Receives QR codes from friends/family
- Worried about clicking dangerous links
- Needs simple, clear guidance

**Carlos, 35, Small Business Owner**
- Scans many QR codes daily (suppliers, payments)
- Needs quick verification
- Values time and reliable results

## 10. Success Metrics

### Launch Goals (v1.0)
- [ ] App Store approval
- [ ] 1,000 downloads first month
- [ ] 4.0+ star rating
- [ ] <1% crash rate

### Technical Goals
- [ ] <100ms URL analysis time
- [ ] 95%+ phishing detection accuracy
- [ ] 80% test coverage
- [ ] Zero critical security vulnerabilities

## 11. Security Considerations

### Data Privacy
- All scan data stored locally only
- No user tracking
- No PII collected
- Privacy policy clearly states data practices

### Security Analysis
- Pattern matching is local (no URL sent to servers)
- Known malicious domain list bundled with app
- Regular updates to threat patterns via app updates
- No network calls for analysis (offline capable)

### App Store Compliance
- Clear privacy nutrition labels
- No background data collection
- Compliant with App Review guidelines
