import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/duo_3d_button.dart';
import '../../widgets/lingo_mascot.dart';
import 'login_screen.dart';
import 'native_language_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Brand Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.greenBg.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.green, width: 2),
                    ),
                    child: Row(
                      children: const [
                        Text('🦜', style: TextStyle(fontSize: 20)),
                        SizedBox(width: 8),
                        Text(
                          'LingoFun',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.greenDark,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Center Mascot & Hero Content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  LingoMascot(
                    size: 160,
                    mood: MascotMood.happy,
                  ),
                  SizedBox(height: 28),
                  Text(
                    'Learn Languages\nwith Fun & Play!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'বাংলা, English, Spanish, Chinese, Hindi & more with voice speaking challenges and interactive stories.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),

              // Action Buttons
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Duo3DButton(
                    text: 'GET STARTED',
                    variant: DuoButtonVariant.primary,
                    height: 52,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const NativeLanguageScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  Duo3DButton(
                    text: 'I ALREADY HAVE AN ACCOUNT',
                    variant: DuoButtonVariant.outline,
                    height: 50,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
