import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/game_progress_provider.dart';
import '../../services/audio_feedback_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/duo_3d_button.dart';
import '../../widgets/duo_progress_bar.dart';
import '../../widgets/lingo_mascot.dart';
import '../main_navigation_shell.dart';
import 'learning_goal_screen.dart';

class TargetLanguageScreen extends StatefulWidget {
  final String nativeLanguageCode;
  final bool isGooglePostAuth;

  const TargetLanguageScreen({
    super.key,
    required this.nativeLanguageCode,
    this.isGooglePostAuth = false,
  });

  @override
  State<TargetLanguageScreen> createState() => _TargetLanguageScreenState();
}

class _TargetLanguageScreenState extends State<TargetLanguageScreen> {
  String? _selectedCourseId;

  List<({String id, String flag, String title, String subtitle, String tag})> _getCourses() {
    final isBengaliNative = widget.nativeLanguageCode == 'bn';

    if (isBengaliNative) {
      return const [
        (
          id: 'bangla_to_english',
          flag: '🇬🇧',
          title: 'ইংরেজি শিখুন (English)',
          subtitle: 'বাংলা মাধ্যমে সহজে ইংরেজি কথপোকথন ও ব্যাকরণ',
          tag: 'RECOMMENDED ⭐',
        ),
        (
          id: 'spanish',
          flag: '🇪🇸',
          title: 'স্প্যানিশ (Spanish)',
          subtitle: 'বিশ্বের অন্যতম জনপ্রিয় ও রোমান্টিক ভাষা',
          tag: 'POPULAR 🔥',
        ),
        (
          id: 'chinese',
          flag: '🇨🇳',
          title: 'চাইনিজ (Mandarin)',
          subtitle: 'হানজি ক্যারেক্টার ও পিনয়িন উচ্চারণ সহ সহজ শিক্ষা',
          tag: 'GLOBAL 🌏',
        ),
        (
          id: 'hindi',
          flag: '🇮🇳',
          title: 'হিন্দি (Hindi)',
          subtitle: 'দেবনাগরী লিপি ও দৈনন্দিন হিন্দি কথপোকথন',
          tag: 'CULTURAL 🎭',
        ),
        (
          id: 'french',
          flag: '🇫🇷',
          title: 'ফরাসি (French)',
          subtitle: 'প্যারিসের সংস্কৃতি ও সুমধুর ভাষা শিক্ষা',
          tag: 'ROMANTIC 🥐',
        ),
        (
          id: 'japanese',
          flag: '🇯🇵',
          title: 'জাপানি (Japanese)',
          subtitle: 'টোকিওর কথোপকথন ও অ্যানিমে সংস্কৃতি',
          tag: 'TRENDING 🌸',
        ),
        (
          id: 'python',
          flag: '🐍',
          title: 'পাইথন প্রোগ্রামিং (Python Coding)',
          subtitle: 'কোডিং ফান্ডামেন্টালস ও এআই বেসিকস',
          tag: 'TECH & AI 💻',
        ),
      ];
    }

    // Non-Bengali default ordering
    return const [
      (
        id: 'bengali',
        flag: '🇧🇩',
        title: 'Bengali (বাংলা)',
        subtitle: 'Learn Bornomala script, Dhaka culture & everyday phrases',
        tag: 'UNIQUE 🇧🇩',
      ),
      (
        id: 'spanish',
        flag: '🇪🇸',
        title: 'Spanish (Español)',
        subtitle: 'Learn basics, café conversation & vibrant vocabulary',
        tag: 'POPULAR 🔥',
      ),
      (
        id: 'chinese',
        flag: '🇨🇳',
        title: 'Chinese (Mandarin • 中文)',
        subtitle: 'Hanzi characters, pinyin tones & conversational dining',
        tag: 'GLOBAL 🌏',
      ),
      (
        id: 'hindi',
        flag: '🇮🇳',
        title: 'Hindi (हिंदी)',
        subtitle: 'Devanagari script, Namaste greetings & daily life',
        tag: 'CULTURAL 🎭',
      ),
      (
        id: 'french',
        flag: '🇫🇷',
        title: 'French (Français)',
        subtitle: 'Salutations, bakery culture, travel & grammar',
        tag: 'ELEGANT 🥐',
      ),
      (
        id: 'japanese',
        flag: '🇯🇵',
        title: 'Japanese (日本語)',
        subtitle: 'Konnichiwa, matcha culture & essential travel phrases',
        tag: 'TRENDING 🌸',
      ),
      (
        id: 'python',
        flag: '🐍',
        title: 'Python Coding',
        subtitle: 'Interactive computer programming, variables & loops',
        tag: 'TECH & AI 💻',
      ),
      (
        id: 'bangla_to_english',
        flag: '🇬🇧',
        title: 'English for Bengali Speakers',
        subtitle: 'ইংরেজি শিখুন with Bengali instruction',
        tag: 'SPECIAL 🇬🇧',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final courses = _getCourses();
    final isBengali = widget.nativeLanguageCode == 'bn';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const DuoProgressBar(progress: 0.50),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: LingoMascot(
                      size: 85,
                      mood: MascotMood.happy,
                      speechBubbleText: isBengali
                          ? 'আপনি কোন ভাষাটি শিখতে চান?'
                          : 'What would you like to learn?',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isBengali ? 'লক্ষ্য ভাষা নির্বাচন করুন' : 'Choose Your Target Language',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isBengali
                        ? 'আপনি যেকোনো সময় সেটিংস থেকে কোর্স পরিবর্তন করতে পারবেন।'
                        : 'You can switch between courses anytime from the top bar.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),

                  ...List.generate(courses.length, (index) {
                    final item = courses[index];
                    final isSelected = _selectedCourseId == item.id;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.greenBg.withValues(alpha: 0.35)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? AppColors.green : AppColors.greyBorder,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? AppColors.greenDark.withValues(alpha: 0.2)
                                : AppColors.greyBorder.withValues(alpha: 0.5),
                            offset: const Offset(0, 3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.greyBorder, width: 1.5),
                            ),
                            child: Center(
                              child: Text(item.flag, style: const TextStyle(fontSize: 26)),
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected ? AppColors.greenDark : AppColors.textDark,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.green.withValues(alpha: 0.2)
                                      : AppColors.surface,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.tag,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: isSelected ? AppColors.greenDark : AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              item.subtitle,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle_rounded, color: AppColors.green, size: 24)
                              : null,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          onTap: () {
                            AudioFeedbackService.playClick();
                            setState(() {
                              _selectedCourseId = item.id;
                            });
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Bottom Action Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.greyBorder, width: 2)),
              ),
              child: SafeArea(
                top: false,
                child: Duo3DButton(
                  text: 'CONTINUE',
                  variant: DuoButtonVariant.primary,
                  height: 52,
                  onPressed: _selectedCourseId != null
                      ? () async {
                          if (widget.isGooglePostAuth) {
                            final auth = context.read<AuthProvider>();
                            final progress = context.read<GameProgressProvider>();
                            await auth.updatePreferences(
                              nativeLanguage: widget.nativeLanguageCode,
                              targetCourseId: _selectedCourseId!,
                            );
                            progress.switchCourse(_selectedCourseId!);
                            if (!context.mounted) return;
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const MainNavigationShell(),
                              ),
                              (route) => false,
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => LearningGoalScreen(
                                  nativeLanguageCode: widget.nativeLanguageCode,
                                  targetCourseId: _selectedCourseId!,
                                ),
                              ),
                            );
                          }
                        }
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
