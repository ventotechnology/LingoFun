# LingoFun 🦉✨

**LingoFun** is a production-grade, gamified language learning platform built with Flutter. Inspired by Duolingo, LingoFun makes learning fun and engaging with interactive lessons, speech challenges, character-driven dialogues, and rapid-fire arcade mini-games.

---

## 🌍 Supported Language Curricula (8 Complete Courses)

1. 🇧🇩 **Bangla to English (`bangla_to_english`)**: বাংলা মাধ্যমে সহজে ইংরেজি কথপোকথন ও ব্যাকরণ
2. 🇧🇩 **English to Bengali (`bengali`)**: Learn Bangla script, essentials, and culinary vocabulary
3. 🇨🇳 **Chinese Mandarin (`chinese`)**: Pinyin, Hanzi characters, greetings, and daily essentials
4. 🇮🇳 **Hindi (`hindi`)**: Devanagari script, transliteration, Namaste greetings, and chai culture
5. 🇪🇸 **Spanish (`spanish`)**: Basics, café vocabulary, numbers, animals & colors
6. 🇫🇷 **French (`french`)**: Salutations, bakery, café culture, and everyday travel
7. 🇯🇵 **Japanese (`japanese`)**: Greetings, matcha culture, and essential travel phrases
8. 🐍 **Python Coding (`python`)**: Interactive programming fundamentals, loops, and data structures

---

## 🚀 Key Features

- **Interactive Duolingo Stories Engine**: Character-driven dialogues (Junior, Bea, Oscar, Lin, Vikram, Lily) with native TTS voice playback and mid-story comprehension checkpoints.
- **🎙️ Speech & Pronunciation Challenges**: Real-time animated audio wave equalizer, simulated word-by-word green highlighting, and skip controls.
- **⚡ Match Madness Mini-Game**: 60-second rapid-fire matching grid with dynamic pair replenishment, star tiers, and ascending harmonic pitch audio chimes.
- **Mascot Wardrobe & Gamification**: Custom outfits for Duo, daily quests system, gems economy, streaks, and health hearts.
- **Gym & Mistakes Notebook**: Review and master past incorrect questions to regain hearts.
- **Cross-Platform**: Mobile (iOS, Android), Desktop (macOS, Windows, Linux), and Web.

---

## 🛠️ Tech Stack & Architecture

- **Framework**: Flutter 3.47+ / Dart 3.13+
- **State Management**: Provider (`GameProgressProvider`, `QuestsProvider`)
- **Audio & TTS**: `audioplayers` (synthesized PCM WAV audio) and `flutter_tts`
- **Persistence**: `shared_preferences`
- **Testing**: Comprehensive automated widget and unit tests

---

## 📱 Getting Started

```bash
# Clone the repository
git clone git@github.com:ventotechnology/LingoFun.git
cd LingoFun

# Install dependencies
flutter pub get

# Run tests
flutter test

# Run the app
flutter run
```

---

Developed with ❤️ by **Vento Technology**.
