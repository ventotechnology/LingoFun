import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/game_progress_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/duo_3d_button.dart';
import '../../widgets/duo_progress_bar.dart';
import '../../widgets/lingo_mascot.dart';
import '../main_navigation_shell.dart';
import 'login_screen.dart';

class QuickSignupScreen extends StatefulWidget {
  final String nativeLanguageCode;
  final String targetCourseId;
  final int dailyGoalMinutes;
  final String learningReason;

  const QuickSignupScreen({
    super.key,
    required this.nativeLanguageCode,
    required this.targetCourseId,
    required this.dailyGoalMinutes,
    required this.learningReason,
  });

  @override
  State<QuickSignupScreen> createState() => _QuickSignupScreenState();
}

class _QuickSignupScreenState extends State<QuickSignupScreen> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    final auth = context.read<AuthProvider>();
    final progress = context.read<GameProgressProvider>();

    await auth.signInWithGoogle(
      nativeLanguage: widget.nativeLanguageCode,
      targetCourseId: widget.targetCourseId,
      dailyGoalMinutes: widget.dailyGoalMinutes,
      learningReason: widget.learningReason,
    );

    progress.switchCourse(widget.targetCourseId);
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavigationShell()),
      (route) => false,
    );
  }

  Future<void> _handleGuestMode() async {
    setState(() => _isLoading = true);
    final auth = context.read<AuthProvider>();
    final progress = context.read<GameProgressProvider>();

    await auth.continueAsGuest(
      nativeLanguage: widget.nativeLanguageCode,
      targetCourseId: widget.targetCourseId,
      dailyGoalMinutes: widget.dailyGoalMinutes,
      learningReason: widget.learningReason,
    );

    progress.switchCourse(widget.targetCourseId);
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavigationShell()),
      (route) => false,
    );
  }

  void _showEmailSignupModal() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sign Up with Email',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textDark),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Full Name',
                hintText: 'e.g. Ayan Rahman',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'name@example.com',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'At least 6 characters',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 20),
            Duo3DButton(
              text: 'CREATE ACCOUNT',
              variant: DuoButtonVariant.primary,
              height: 50,
              onPressed: () async {
                if (emailCtrl.text.isEmpty || passCtrl.text.isEmpty) return;
                Navigator.pop(ctx);
                setState(() => _isLoading = true);

                final auth = context.read<AuthProvider>();
                final progress = context.read<GameProgressProvider>();

                await auth.signupWithEmail(
                  name: nameCtrl.text.isEmpty ? 'Learner' : nameCtrl.text,
                  email: emailCtrl.text,
                  password: passCtrl.text,
                  nativeLanguage: widget.nativeLanguageCode,
                  targetCourseId: widget.targetCourseId,
                  dailyGoalMinutes: widget.dailyGoalMinutes,
                  learningReason: widget.learningReason,
                );

                progress.switchCourse(widget.targetCourseId);
                if (!mounted) return;
                setState(() => _isLoading = false);

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const MainNavigationShell()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

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
        title: const DuoProgressBar(progress: 1.0),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const LingoMascot(
                size: 130,
                mood: MascotMood.celebrating,
                speechBubbleText: "You're all set! Save your profile.",
              ),
              const SizedBox(height: 20),
              const Text(
                'Create Your Profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Save your streaks, earned gems, and sync learning across all your devices.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 28),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                )
              else
                Column(
                  children: [
                    // 1-Tap Google Sign-In Button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _handleGoogleSignIn,
                        borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.greyBorder, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.greyBorder,
                              offset: Offset(0, 4),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Authentic Google G Logo
                            Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  'G',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.red.shade600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'CONTINUE WITH GOOGLE',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                    // Email Sign-Up Button
                    Duo3DButton(
                      text: 'SIGN UP WITH EMAIL',
                      variant: DuoButtonVariant.primary,
                      height: 50,
                      onPressed: _showEmailSignupModal,
                    ),
                    const SizedBox(height: 12),

                    // Guest Mode Button
                    Duo3DButton(
                      text: 'START LEARNING AS GUEST',
                      variant: DuoButtonVariant.outline,
                      height: 50,
                      onPressed: _handleGuestMode,
                    ),
                    const SizedBox(height: 16),

                    // Already have an account?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                          child: const Text(
                            'SIGN IN',
                            style: TextStyle(
                              color: AppColors.blue,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
