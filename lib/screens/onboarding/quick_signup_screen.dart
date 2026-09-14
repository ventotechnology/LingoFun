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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedAvatar = '🦜';
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  static const List<Map<String, String>> _avatars = [
    {'emoji': '🦜', 'name': 'Lingo'},
    {'emoji': '🧢', 'name': 'Ayan'},
    {'emoji': '👓', 'name': 'Maya'},
    {'emoji': '🎨', 'name': 'Sophia'},
    {'emoji': '🎧', 'name': 'Kenji'},
    {'emoji': '👨‍🍳', 'name': 'Rafi'},
    {'emoji': '💜', 'name': 'Luna'},
    {'emoji': '🌸', 'name': 'Priya'},
    {'emoji': '🚀', 'name': 'Cosmos'},
    {'emoji': '😎', 'name': 'Champ'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _finishAndEnterApp() {
    final progress = context.read<GameProgressProvider>();
    progress.switchCourse(widget.targetCourseId);
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavigationShell()),
      (route) => false,
    );
  }

  Future<void> _handleProfileCreation() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty) {
      setState(() => _errorMessage = 'Please enter your name.');
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMessage = 'Please enter a valid email address.');
      return;
    }
    if (password.length < 4) {
      setState(() => _errorMessage = 'Password must be at least 4 characters.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final auth = context.read<AuthProvider>();
      await auth.signupWithEmail(
        name: name,
        email: email,
        password: password,
        avatarUrl: _selectedAvatar,
        nativeLanguage: widget.nativeLanguageCode,
        targetCourseId: widget.targetCourseId,
        dailyGoalMinutes: widget.dailyGoalMinutes,
        learningReason: widget.learningReason,
      );

      _finishAndEnterApp();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final auth = context.read<AuthProvider>();
      await auth.signInWithGoogle(
        avatarUrl: _selectedAvatar,
        nativeLanguage: widget.nativeLanguageCode,
        targetCourseId: widget.targetCourseId,
        dailyGoalMinutes: widget.dailyGoalMinutes,
        learningReason: widget.learningReason,
      );

      _finishAndEnterApp();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Google sign-in could not be completed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const DuoProgressBar(progress: 1.0),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Center(
                child: LingoMascot(
                  size: 105,
                  mood: MascotMood.celebrating,
                  speechBubbleText: "You're all set! Save your profile.",
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Create Your Profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Save your streak, earn gems, and sync learning progress across all your devices.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Avatar Selector Label
              const Text(
                'CHOOSE YOUR AVATAR',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMuted,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),

              // Avatar Horizontal Scroll
              SizedBox(
                height: 74,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _avatars.length,
                  separatorBuilder: (_, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final item = _avatars[index];
                    final isSelected = item['emoji'] == _selectedAvatar;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedAvatar = item['emoji']!);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 62,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.green.withValues(alpha: 0.12) : AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.green : AppColors.greyBorder,
                            width: isSelected ? 2.5 : 1.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.green.withValues(alpha: 0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item['emoji']!,
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['name']!,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? AppColors.greenDark : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Error banner if any
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.red.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: AppColors.redDark,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Full Name input
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'e.g. Ayan Rahman',
                  prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.textMuted),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.greyBorder, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.green, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Email input
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'learner@example.com',
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textMuted),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.greyBorder, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.green, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Password input
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'At least 4 characters',
                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textMuted),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textMuted,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.greyBorder, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.green, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Create Profile Button
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(color: AppColors.green),
                  ),
                )
              else ...[
                Duo3DButton(
                  text: 'CREATE PROFILE & START',
                  variant: DuoButtonVariant.primary,
                  height: 52,
                  onPressed: _handleProfileCreation,
                ),
                const SizedBox(height: 16),

                // OR Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.greyBorder, thickness: 1.5)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'OR SIGN UP WITH',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMuted.withValues(alpha: 0.8),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.greyBorder, thickness: 1.5)),
                  ],
                ),
                const SizedBox(height: 14),

                // 1-Tap Google Sign-In Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _handleGoogleSignIn,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.greyBorder, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.greyBorder,
                            offset: Offset(0, 3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(shape: BoxShape.circle),
                            child: const Text(
                              'G',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF4285F4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'CONTINUE WITH GOOGLE',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textDark,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Already have an account?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w600, fontSize: 13),
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
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
