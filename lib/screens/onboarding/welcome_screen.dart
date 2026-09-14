import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/duo_3d_button.dart';
import '../../widgets/lingo_mascot.dart';
import 'login_screen.dart';
import 'native_language_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    try {
      final success = await auth.signInWithGoogle();
      if (!context.mounted) return;
      if (success) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const NativeLanguageScreen(isGooglePostAuth: true),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In failed: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 24),
                child: IntrinsicHeight(
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
                                  'LingoFunLearn',
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
                            size: 135,
                            mood: MascotMood.happy,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Learn Languages\nwith Fun & Play!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textDark,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'বাংলা, English, Spanish, Chinese, Hindi & more with voice speaking challenges and interactive stories.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
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
                  // 1-Tap Google Sign-In
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => _handleGoogleSignIn(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.textDark,
                        elevation: 2,
                        shadowColor: Colors.black.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: AppColors.greyBorder, width: 2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            alignment: Alignment.center,
                            child: const Text(
                              'G',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF4285F4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'CONTINUE WITH GOOGLE',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 0.3),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Create Profile Flow
                  Duo3DButton(
                    text: 'CREATE PROFILE',
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
                  const SizedBox(height: 12),

                  // Returning Account Sign-In
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
  },
),
),
);
}
}
