import 'package:flutter/material.dart';
import '../../services/audio_feedback_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/duo_3d_button.dart';
import '../../widgets/duo_progress_bar.dart';
import '../../widgets/lingo_mascot.dart';
import 'quick_signup_screen.dart';

class LearningGoalScreen extends StatefulWidget {
  final String nativeLanguageCode;
  final String targetCourseId;

  const LearningGoalScreen({
    super.key,
    required this.nativeLanguageCode,
    required this.targetCourseId,
  });

  @override
  State<LearningGoalScreen> createState() => _LearningGoalScreenState();
}

class _LearningGoalScreenState extends State<LearningGoalScreen> {
  String _selectedReason = 'career';
  int _selectedMinutes = 10;

  final List<({String id, String icon, String title, String subtitle})> _reasons = const [
    (id: 'career', icon: '💼', title: 'Career & Professional Growth', subtitle: 'Open global job opportunities'),
    (id: 'travel', icon: '✈️', title: 'Travel & Exploration', subtitle: 'Connect with locals effortlessly'),
    (id: 'brain', icon: '🧠', title: 'Brain Workout & Memory', subtitle: 'Sharpen cognitive focus daily'),
    (id: 'education', icon: '🎓', title: 'Study & Exams', subtitle: 'Excel in academic tests & courses'),
    (id: 'fun', icon: '🎉', title: 'Fun, Friends & Culture', subtitle: 'Enjoy international music & media'),
  ];

  final List<({int minutes, String title, String tag})> _paceOptions = const [
    (minutes: 5, title: 'Casual', tag: '5 min / day (10 XP)'),
    (minutes: 10, title: 'Regular', tag: '10 min / day (20 XP) • RECOMMENDED'),
    (minutes: 15, title: 'Serious', tag: '15 min / day (30 XP)'),
    (minutes: 20, title: 'Intense', tag: '20 min / day (50 XP)'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const DuoProgressBar(progress: 0.75),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: [
                  const Center(
                    child: LingoMascot(
                      size: 85,
                      mood: MascotMood.happy,
                      speechBubbleText: 'Set your pace! Little steps lead to fluency.',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section 1: Reason
                  const Text(
                    'Why are you learning?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(_reasons.length, (index) {
                    final item = _reasons[index];
                    final isSelected = _selectedReason == item.id;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.blueBg : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.blue : AppColors.greyBorder,
                          width: 2,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: ListTile(
                          leading: Text(item.icon, style: const TextStyle(fontSize: 24)),
                          title: Text(
                            item.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: isSelected ? AppColors.blueDark : AppColors.textDark,
                            ),
                          ),
                          subtitle: Text(
                            item.subtitle,
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle_rounded, color: AppColors.blue, size: 22)
                              : null,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          onTap: () {
                            AudioFeedbackService.playClick();
                            setState(() {
                              _selectedReason = item.id;
                            });
                          },
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Section 2: Daily Goal
                  const Text(
                    'Choose a daily commitment',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(_paceOptions.length, (index) {
                    final item = _paceOptions[index];
                    final isSelected = _selectedMinutes == item.minutes;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.greenBg.withValues(alpha: 0.4) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.green : AppColors.greyBorder,
                          width: 2,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: ListTile(
                          leading: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.green : AppColors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${item.minutes}m',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                  color: isSelected ? Colors.white : AppColors.textMuted,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            item.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: isSelected ? AppColors.greenDark : AppColors.textDark,
                            ),
                          ),
                          subtitle: Text(
                            item.tag,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AppColors.greenDark : AppColors.textMuted,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle_rounded, color: AppColors.green, size: 22)
                              : null,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          onTap: () {
                            AudioFeedbackService.playClick();
                            setState(() {
                              _selectedMinutes = item.minutes;
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => QuickSignupScreen(
                          nativeLanguageCode: widget.nativeLanguageCode,
                          targetCourseId: widget.targetCourseId,
                          dailyGoalMinutes: _selectedMinutes,
                          learningReason: _selectedReason,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
