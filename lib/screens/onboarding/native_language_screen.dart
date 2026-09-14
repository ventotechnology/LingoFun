import 'package:flutter/material.dart';
import '../../services/audio_feedback_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/duo_3d_button.dart';
import '../../widgets/duo_progress_bar.dart';
import '../../widgets/lingo_mascot.dart';
import 'target_language_screen.dart';

class NativeLanguageScreen extends StatefulWidget {
  final bool isGooglePostAuth;

  const NativeLanguageScreen({super.key, this.isGooglePostAuth = false});

  @override
  State<NativeLanguageScreen> createState() => _NativeLanguageScreenState();
}

class _NativeLanguageScreenState extends State<NativeLanguageScreen> {
  String? _selectedLanguageCode;

  final List<({String code, String flag, String name, String nativeName})> _languages = const [
    (code: 'bn', flag: '🇧🇩', name: 'Bengali', nativeName: 'বাংলা (আমি বাংলা বলি)'),
    (code: 'en', flag: '🇬🇧', name: 'English', nativeName: 'English (I speak English)'),
    (code: 'es', flag: '🇪🇸', name: 'Spanish', nativeName: 'Español (Hablo español)'),
    (code: 'hi', flag: '🇮🇳', name: 'Hindi', nativeName: 'हिन्दी (मैं हिन्दी बोलता/बोलती हूँ)'),
    (code: 'zh', flag: '🇨🇳', name: 'Chinese', nativeName: '中文 (我说中文)'),
    (code: 'fr', flag: '🇫🇷', name: 'French', nativeName: 'Français (Je parle français)'),
    (code: 'ja', flag: '🇯🇵', name: 'Japanese', nativeName: '日本語 (日本語を話します)'),
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
        title: const DuoProgressBar(progress: 0.25),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: [
                  const SizedBox(height: 8),
                  const Center(
                    child: LingoMascot(
                      size: 85,
                      mood: MascotMood.happy,
                      speechBubbleText: 'What language do you speak?',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Which language do you speak best?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'We will customize your learning explanations accordingly.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),

                  ...List.generate(_languages.length, (index) {
                    final item = _languages[index];
                    final isSelected = _selectedLanguageCode == item.code;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
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
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.greyBorder, width: 1.5),
                            ),
                            child: Center(
                              child: Text(item.flag, style: const TextStyle(fontSize: 24)),
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: isSelected ? AppColors.greenDark : AppColors.textDark,
                            ),
                          ),
                          subtitle: Text(
                            item.nativeName,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle_rounded, color: AppColors.green, size: 24)
                              : null,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          onTap: () {
                            AudioFeedbackService.playClick();
                            setState(() {
                              _selectedLanguageCode = item.code;
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
                  onPressed: _selectedLanguageCode != null
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => TargetLanguageScreen(
                                nativeLanguageCode: _selectedLanguageCode!,
                                isGooglePostAuth: widget.isGooglePostAuth,
                              ),
                            ),
                          );
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
