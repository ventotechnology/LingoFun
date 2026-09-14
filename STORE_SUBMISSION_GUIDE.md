# LingoFun: Complete TestFlight & Google Play Store Submission Guide

This guide provides step-by-step instructions and file paths to submit **LingoFun: Learn Languages with Fun & Play** to **Apple TestFlight / App Store** and **Google Play Store**.

---

## 1. Apple App Store & TestFlight Submission

### App Identifiers & Credentials
- **App Name**: `LingoFun: Learn & Play`
- **Bundle Identifier**: `com.antigravity.lingoFun`
- **Apple Developer Team**: `F38GJ2Y65W`
- **Version**: `1.0.0` (Build `1`)
- **Privacy Policy URL**: [https://lingofun.vpshub.biz/privacy.html](https://lingofun.vpshub.biz/privacy.html)
- **Support URL**: [https://lingofun.vpshub.biz](https://lingofun.vpshub.biz)
- **Encryption Compliance**: Pre-configured in `Info.plist` (`ITSAppUsesNonExemptEncryption` = `false`). No export compliance questionnaire required during TestFlight processing!

### Ready Artifacts
- **Xcode Archive**: `build/ios/archive/Runner.xcarchive` (197.6MB)
- **TestFlight IPA**: `build/ios/ipa/LingoFun-TestFlight.ipa` (8.5MB)

### How to Upload to TestFlight

#### Option A: 1-Click Upload via Xcode Organizer (Recommended)
1. Open the archive in Xcode Organizer:
   ```bash
   open build/ios/archive/Runner.xcarchive
   ```
2. Click **Distribute App** in the right-hand panel.
3. Select **App Store Connect** $\rightarrow$ **TestFlight & App Store** $\rightarrow$ **Upload**.
4. Xcode handles automatic cloud signing and uploads directly to App Store Connect.
5. In [App Store Connect](https://appstoreconnect.apple.com), navigate to **Apps** $\rightarrow$ **LingoFun** $\rightarrow$ **TestFlight** to invite internal and external testers.

#### Option B: Upload via Apple Transporter App
1. Download **Transporter** from the Mac App Store.
2. Sign in with your Apple Developer ID.
3. Drag and drop `build/ios/ipa/LingoFun-TestFlight.ipa`.
4. Click **Deliver**.

---

## 2. Google Play Store Submission

### App Identifiers & Credentials
- **App Name**: `LingoFun: Learn Languages with Fun & Play`
- **Package Name (Application ID)**: `com.antigravity.lingo_fun`
- **Category**: Education
- **Content Rating**: Everyone
- **Privacy Policy URL**: [https://lingofun.vpshub.biz/privacy.html](https://lingofun.vpshub.biz/privacy.html)
- **Version Code**: `1` (Version `1.0.0`)

### Ready Artifacts
- **Google Play App Bundle (AAB)**: `build/app/outputs/bundle/release/app-release.aab` (54.8MB)
- **Local Testing APK**: `build/app/outputs/flutter-apk/app-release.apk` (55.2MB)

### How to Submit to Google Play Console
1. Log in to [Google Play Console](https://play.google.com/console).
2. Click **Create app**:
   - **App name**: `LingoFun`
   - **Default language**: English (United States)
   - **App or game**: App
   - **Free or paid**: Free
3. Navigate to **Testing** $\rightarrow$ **Internal testing** (or **Closed testing** / **Production**).
4. Click **Create new release**.
5. Upload `build/app/outputs/bundle/release/app-release.aab`.
6. Fill in the **Store Listing**:
   - **Short description**: `Learn English, Spanish, Chinese, Bengali, Hindi with interactive voice challenges & stories!`
   - **Full description**:
     ```text
     Learn languages with fun, play, and real speaking confidence! 

     LingoFun offers comprehensive courses across all proficiency levels:
     • 🇧🇩 Bangla to English (Complete A1 to C2 Curriculum across 20 Units)
     • 🇪🇸 Spanish (Rookie to Conversational)
     • 🇨🇳 Chinese Mandarin (Pinyin, Tones & Hanzi)
     • 🇮🇳 Hindi (Alphabet, Greetings & Daily Life)
     • 🇫🇷 French (Bonjour to Fluency)
     • 🇯🇵 Japanese (Hiragana & Phrases)
     • 🐍 Python Coding (Fun Interactive Logic)

     Features:
     - 1-Tap Google Sign-In with personalized profile & mascot avatars
     - Speech Recognition & Pronunciation Challenges
     - Multi-Level Interactive Stories with Checkpoint Comprehension
     - Daily Quests, Streaks, Hearts & XP Leaderboards
     - Match Madness Speed Game
     ```
7. Set **Privacy Policy** to: `https://lingofun.vpshub.biz/privacy.html`.
8. Complete the **Content Rating questionnaire** and **Data Safety declaration** (declaring Firebase Auth / Google Sign-In for authentication).
9. Click **Review release** and **Start rollout**!

---

## 3. Production Keystore Setup (Optional for CI/CD)
To sign with your own private upload key instead of Play App Signing:
1. Generate keystore:
   ```bash
   keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Create `android/key.properties` (using `android/key.properties.example` as a template):
   ```properties
   storePassword=your_store_password
   keyPassword=your_key_password
   keyAlias=upload
   storeFile=upload-keystore.jks
   ```
3. Rebuild AAB: `flutter build appbundle --release`.

---

## 4. Connected Hardware Verification Summary
All three physical devices have the latest release binaries installed and tested via USB with zero interference:
1. **Samsung Galaxy S25 Ultra (`RFCY819HWTR`)**: Installed and running (`com.antigravity.lingo_fun`, Android 16 API 36).
2. **iPhone 17 Pro Max (`14D0667D-B06F-5644-8A87-15F47B193175`)**: Release AOT installed and running (`com.antigravity.lingoFun`).
3. **iPad Pro 12.9" M2 (`F1A2383A-9B11-56EC-835F-8638D71C18A5`)**: Release AOT installed and running (`com.antigravity.lingoFun`).
