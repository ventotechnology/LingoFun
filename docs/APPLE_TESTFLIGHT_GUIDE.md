# LingoFun — Apple TestFlight Submission & Distribution Guide

This guide details the distribution instructions for submitting **LingoFun** (`com.antigravity.lingoFun`) to Apple TestFlight under developer account **`bloodsoft@outlook.com`** (Team ID: **`F38GJ2Y65W`**).

---

## 1. App Store & TestFlight Identity

| Setting | Value |
| :--- | :--- |
| **App Name** | `LingoFun: Learn & Play` |
| **Bundle Identifier** | `com.antigravity.lingoFun` |
| **Version** | `1.0.0` |
| **Build Number** | `2` |
| **Development Team** | `F38GJ2Y65W` (Humayun Kabir) |
| **Apple Developer Account** | `bloodsoft@outlook.com` |
| **Deployment Target** | iOS 15.0+ (iPhone & iPad Universal) |
| **Xcode Archive** | `build/ios/archive/Runner.xcarchive` (200.0 MB) |
| **App Store IPA** | `releases/LingoFun-v1.0.0+2-release.ipa` (25.8 MB) |
| **Asset Validation Status** | **100% Passed** (Zero placeholder warnings, 1024x1024 3D Mascot AppIcon, opaque PNG, no alpha, custom launch images) |

---

## 2. Submission Methods to TestFlight

### Method A: Direct 1-Click Upload via Xcode Organizer (Recommended)
Because Xcode on this Mac is already authenticated with `bloodsoft@outlook.com` and Team `F38GJ2Y65W`:
1. Open the archive in Xcode Organizer:
   ```bash
   open build/ios/archive/Runner.xcarchive
   ```
2. In the Organizer window:
   - Select build **`1.0.0 (2)`** of **`Runner`**.
   - Click the blue **"Distribute App"** button on the right panel.
   - Choose **"Custom"** or **"TestFlight & App Store"** $\rightarrow$ Click **Distribute**.
   - Select **"Upload"** $\rightarrow$ Ensure Team **Humayun Kabir (`F38GJ2Y65W`)** is selected.
   - Keep "Automatically manage signing" checked.
   - Click **Next** $\rightarrow$ Click **Upload**.
3. Xcode transmits the binary directly to App Store Connect. Once processing completes (~5-10 minutes), the build appears under the **TestFlight** tab in App Store Connect.

---

### Method B: Upload via Apple Transporter App
1. Launch **Transporter** on macOS.
2. Sign in with developer Apple ID: `bloodsoft@outlook.com`.
3. Drag and drop:
   `releases/LingoFun-v1.0.0+2-release.ipa`
4. Click **"Deliver"**. Transporter validates and uploads the build to TestFlight.

---

### Method C: Command Line via `xcrun altool`
If using an App Store Connect App-Specific Password or API Key:
```bash
xcrun altool --upload-app \
  -f "releases/LingoFun-v1.0.0+2-release.ipa" \
  -t ios \
  -u "bloodsoft@outlook.com" \
  -p "@keychain:ALTOOL_PASSWORD"
```

---

## 3. Post-Upload TestFlight Verification
1. Open [App Store Connect](https://appstoreconnect.apple.com/apps).
2. Select **LingoFun** $\rightarrow$ Navigate to **TestFlight**.
3. When Build `1.0.0 (2)` finishes processing:
   - Under **Internal Testing**, add testers from your developer team.
   - Testers receive an instant notification in the TestFlight iOS app on connected devices (iPhone 17 Pro Max, iPad Pro M2).
   - Tap **Install** or **Update** in TestFlight to begin testing.
