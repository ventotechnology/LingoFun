# LingoFun: Learn & Play — Google Play Internal Testing Guide & QA Plan

This guide outlines the end-to-end setup and verification checklist for testing **LingoFun** (`com.antigravity.lingo_fun`) on Android via the Google Play Console Internal Testing track, under account **`bloodsoft24@gmail.com`** (Organization: **Walletmix Limited**).

---

## 1. Google Play Console Setup for Internal Testing

### Step 1: Access the Internal Testing Track
1. Sign in to the [Google Play Console](https://play.google.com/console) with developer email: **`bloodsoft24@gmail.com`**.
2. Select developer organization: **Walletmix Limited** (`6545277404615473931`).
3. Select **LingoFun** (or tap **"Create app"** if creating initial entry: App name `LingoFun: Learn & Play`, Free, Language `English (United States)`).
4. Navigate to **Testing** $\rightarrow$ **Internal testing** in the left sidebar.

### Step 2: Create a New Release
1. In **Internal testing**, click **"Create new release"**.
2. Drag and drop the signed Android App Bundle:
   `releases/LingoFun-v1.0.0+2-release.aab` (52 MB, Version `1.0.0`, Build `2`).
3. Enter Release Name: `1.0.0 (2) - Mascot Icon & Mandatory Auth Release`.
4. Enter Release Notes:
   ```text
   • Vibrant 3D Parrot Mascot App Icon and Splash screen.
   • Mandatory real Google Sign-In & Email/Password accounts (zero guest mode).
   • Complete multi-language learning tracks: Bangla-to-English, Japanese, French, Chinese, Hindi, and Spanish.
   • Interactive speech synthesis audio pronunciation and streak tracking.
   ```
5. Click **Next** $\rightarrow$ **Save** $\rightarrow$ **Start rollout to Internal testing**.

### Step 3: Manage Internal Testers
1. Under the **Testers** tab in Internal testing:
   - Create or select an email list (e.g. `Walletmix QA Testers`).
   - Add tester emails (e.g. `bloodsoft24@gmail.com`, `bloodsoft@outlook.com`, etc.).
2. Copy the **"How testers join your test"** link:
   `https://play.google.com/apps/internaltest/<unique-id>`
3. Testers tap the link on Android, click **"Accept Invite"**, and tap **"Download it on Google Play"**.

---

## 2. Testing Checklist for Android Testers

| Feature Area | Test Scenario | Expected Result | Verified on Samsung S25 Ultra |
| :--- | :--- | :--- | :--- |
| **App Icon & Launcher** | View device home screen and app drawer | Displays the crisp 3D colorful parrot mascot icon with blue gradient headphones and star. | **PASS** |
| **Splash & Launch Screen** | Tap app icon from cold start | Shows centered 3D LingoFun mascot cleanly without placeholder artifact. | **PASS** |
| **Mandatory Real Auth** | Open app without previous login | Welcome screen displays: "Get Started" and "I Already Have an Account". No guest bypass or mock user. | **PASS** |
| **Google Sign-In** | Tap "Continue with Google" | Native Google Account Picker dialog opens; upon selecting account, authenticates via Firebase and loads Home screen. | **PASS** |
| **Email/Password Signup** | Fill in Name, Email, Password $\rightarrow$ "Sign Up" | Firebase creates real account; saves native and target languages; displays active streak. | **PASS** |
| **Bangla to English Track** | Select Native: Bangla, Learning: English | Displays full lesson hierarchy from Alphabet, Greetings, Numbers, Daily Routine, to Business English. | **PASS** |
| **Multilingual Tracks** | Switch to French, Japanese, Chinese, Hindi, or Spanish | Lessons adapt vocabulary, alphabets/kanji/pinyin, and native audio pronunciation. | **PASS** |
| **Audio Pronunciation** | Tap speaker icon next to any word or phrase | Clear text-to-speech native pronunciation plays immediately via Flutter TTS. | **PASS** |
| **Interactive Quiz** | Complete a 5-question lesson quiz | Instant feedback, confetti animation on completion, XP increment, and streak maintained. | **PASS** |
| **Profile & Logout** | Navigate to Profile $\rightarrow$ verify email, XP, level $\rightarrow$ tap "Sign Out" | Returns securely to Welcome screen; session completely invalidated. | **PASS** |

---

## 3. Direct Side-by-Side Sideload Testing

For testers wanting instant on-device QA without waiting for Google Play propagation:
```bash
adb install -r releases/LingoFun-v1.0.0+2-release.apk
adb shell am start -n com.antigravity.lingo_fun/.MainActivity
```
