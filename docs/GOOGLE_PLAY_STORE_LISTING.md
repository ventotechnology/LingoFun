# LingoFun: Learn & Play — Google Play Store Listing Specification & Assets

This document defines the official Google Play Store listing metadata, promotional copy, visual asset specifications, reviewer instructions, and compliance declarations for **LingoFun** (`com.antigravity.lingo_fun`), published under the developer organization **Walletmix Limited** (Google Play Developer Account: `bloodsoft24@gmail.com`, Organization ID: `6545277404615473931`).

---

## 1. Store Listing Metadata

| Field | Specification | Configured Value |
| :--- | :--- | :--- |
| **App Name** | Max 30 characters | `LingoFun: Learn & Play` |
| **Short Description** | Max 80 characters | `Gamified language learning: Bangla, English, Japanese, French, Chinese & Hindi!` |
| **Primary Category** | Google Play Category | `Education` |
| **Secondary Category** | Sub-category | `Educational Games` / `Language Learning` |
| **Tags** | Discoverability Tags | `Language Learning`, `English for Bangla`, `Gamified Learning`, `Vocabulary Builder`, `Speech Practice` |
| **Target Audience** | Target Age Group | `Ages 13 and up`, `Everyone` (IARC / PEGI 3 / USK 0) |
| **Contains Ads** | Play Policy | **No** (Zero third-party advertisement SDKs) |
| **Developer Email** | Support Contact | `bloodsoft24@gmail.com` |
| **Organization Name** | Publisher Name | `Walletmix Limited` |
| **Official Website** | Web App / Portal | `https://lingofun.vpshub.biz` |
| **Privacy Policy URL** | Mandatory Policy | `https://lingofun.vpshub.biz/privacy` |
| **Terms of Service** | Terms URL | `https://lingofun.vpshub.biz/terms` |

---

## 2. Store Copy & Promotional Descriptions

### Short Description (79 / 80 Characters)
> `Gamified language learning: Bangla, English, Japanese, French, Chinese & Hindi!`

---

### Full Description (< 4000 Characters)
```text
Master new languages naturally with LingoFun: Learn & Play — the gamified, bite-sized language learning platform crafted for modern polyglots!

Whether you are a native Bangla speaker mastering English, or eager to learn Japanese, French, Chinese (Mandarin), Hindi, or Spanish, LingoFun combines interactive lessons, speech pronunciation, engaging quizzes, and real-time streak tracking to make fluency fun and effortless.

WHY CHOOSE LINGOFUN?

★ COMPREHENSIVE CURRICULUM FOR BANGLA SPEAKERS
Master English step-by-step from zero to advanced fluency with localized explanations, cultural context, and everyday conversational English:
• Fundamentals & Phonics (বর্ণমালা ও উচ্চারণ)
• Daily Life & Travel Phrases (দৈনন্দিন কথোপকথন)
• Work & Professional Vocabulary (অফিস ও ক্যারিয়ার ইংরেজি)
• Complete Grammar & Sentence Structure (সহজ নিয়মে ব্যাকরণ)

★ GLOBAL MULTI-LANGUAGE EXPANSION
Learn the world's most spoken languages with curated, interactive tracks:
• English (Complete Beginner to Advanced)
• Japanese (Hiragana, Katakana, Essential Kanji, Everyday Phrases)
• French (Pronunciation, Romance Vocabulary, Travel Dialogues)
• Chinese Mandarin (Pinyin, Tones, Core Vocabulary & Characters)
• Hindi (Devanagari Basics, Practical Conversational Fluency)
• Spanish (Practical Essentials & Latin American Spanish)

★ INTERACTIVE & GAMIFIED LEARNING
• Daily Streaks & XP: Keep momentum going every single day.
• Smart Quizzes & Flashcards: Test your listening, reading, and vocabulary retention.
• Audio Pronunciation: Hear native-accented voice synthesis for every word and sentence.
• Milestone Rewards & Badges: Level up your profile from Rookie Learner to Polyglot Master.

★ ZERO GUEST MODE & SECURE CLOUD SYNC
Every learner maintains a verified profile via Google Sign-In or secure Email/Password authentication. Your learning progress, XP, streak history, and completed modules sync seamlessly across Android, iOS, and Web.

★ SAFE, CLEAN & AD-FREE
Zero intrusive third-party ads, zero tracking spam. Just pure, focused language learning engineered with Google Flutter, Firebase Authentication, and Cloud synchronization.

Download LingoFun today and start your journey to bilingual or multilingual fluency!
```

---

## 3. Store Visual Asset Specifications

All required graphics are prepared in `releases/play-assets/`:

| Asset Type | Dimensions | Format | File Location |
| :--- | :--- | :--- | :--- |
| **App Icon** | 512 x 512 px | 32-bit PNG (with alpha, < 1 MB) | `releases/play-assets/app_icon_512x512.png` |
| **Feature Graphic** | 1024 x 500 px | 24-bit PNG / JPG (no alpha, < 15 MB) | `releases/play-assets/feature_graphic_1024x500.png` / `feature_graphic_1024x500.jpg` |
| **Phone Screenshots** | 1440 x 3120 px / 1080 x 2340 px | JPG / PNG (16:9 or 9:16) | `releases/play-assets/screenshots/` |

---

## 4. Release Binary Information

| Release Track | File Name | Version | Build | Size |
| :--- | :--- | :--- | :--- | :--- |
| **Google Play (Production / Testing)** | `LingoFun-v1.0.0+2-release.aab` | `1.0.0` | `2` | ~52 MB |
| **Direct APK (Direct QA / Testing)** | `LingoFun-v1.0.0+2-release.apk` | `1.0.0` | `2` | ~53 MB |
| **Signing Keystore** | `android/app/upload-keystore.jks` | Alias: `upload` | Config: `android/key.properties` | Verified |
