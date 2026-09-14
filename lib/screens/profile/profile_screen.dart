import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/auth_user.dart';
import '../../models/mascot_outfit.dart';
import '../../providers/auth_provider.dart';
import '../../providers/game_progress_provider.dart';
import '../../services/curriculum_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/duo_mascot.dart';
import '../../widgets/duo_progress_bar.dart';
import '../onboarding/native_language_screen.dart';
import '../onboarding/welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<GameProgressProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final activeCourse = CurriculumData.getCourse(progress.activeCourseId);
    final outfit = MascotOutfit.getById(progress.equippedOutfitId);

    final nativeLang = NativeLanguage.supportedLanguages.firstWhere(
      (l) => l.code == (user?.nativeLanguageCode ?? 'en'),
      orElse: () => NativeLanguage.supportedLanguages.first,
    );

    final displayName = (user != null && user.displayName.isNotEmpty)
        ? user.displayName
        : 'Polyglot Master';
    final emailText = (user != null && user.email != null && user.email!.isNotEmpty)
        ? user.email!
        : 'Guest Learner';
    final authBadge = user?.authMethod == 'google'
        ? 'Google'
        : user?.authMethod == 'email'
            ? '✉️ Email'
            : '👤 Guest';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.textDark),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textMuted),
            onPressed: () {
              _showSettingsModal(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Profile Header
          Row(
            children: [
              Container(
                width: 76,
                height: 76,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.green, width: 3),
                ),
                child: Text(
                  (user != null && user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                      ? user.avatarUrl!
                      : '😎',
                  style: const TextStyle(fontSize: 40),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$emailText • $authBadge',
                      style: const TextStyle(fontSize: 13, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          '${activeCourse.flag} ${activeCourse.title}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.blueDark),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.blueLight.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '🗣️ ${nativeLang.nativeName}',
                            style: const TextStyle(
                              color: AppColors.blueDark,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.orange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '⏱️ ${user?.dailyGoalMinutes ?? 15}m/day',
                            style: const TextStyle(
                              color: AppColors.orangeDark,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.greenLight.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${outfit.emoji} ${outfit.name}',
                            style: const TextStyle(
                              color: AppColors.greenDark,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Statistics Grid
          const Text(
            'STATISTICS',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textMuted, letterSpacing: 0.8),
          ),
          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.1,
            children: [
              _StatTile(
                icon: Icons.local_fire_department_rounded,
                color: AppColors.orange,
                value: '${progress.streak}',
                label: 'Day Streak',
              ),
              _StatTile(
                icon: Icons.bolt_rounded,
                color: AppColors.yellowDark,
                value: '${progress.totalXp}',
                label: 'Total XP',
              ),
              _StatTile(
                icon: Icons.military_tech_rounded,
                color: AppColors.blue,
                value: 'Diamond',
                label: 'Current League',
              ),
              _StatTile(
                icon: Icons.favorite_rounded,
                color: AppColors.red,
                value: '${progress.hearts}/5',
                label: 'Hearts',
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Mascot Message
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.greyBorder, width: 2),
            ),
            child: Row(
              children: [
                DuoMascot(
                  size: 60,
                  mood: MascotMood.happy,
                  outfitId: progress.equippedOutfitId,
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'Practice a few minutes every day to build a habit that sticks forever!',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Achievements
          const Text(
            'ACHIEVEMENTS',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textMuted, letterSpacing: 0.8),
          ),
          const SizedBox(height: 12),

          _AchievementTile(
            title: 'Wildfire',
            description: 'Reach a 7-day streak',
            currentProgress: progress.streak,
            maxProgress: 7,
            icon: Icons.local_fire_department_rounded,
            color: AppColors.orange,
          ),
          const SizedBox(height: 12),

          _AchievementTile(
            title: 'Sage',
            description: 'Earn 100 XP total',
            currentProgress: progress.totalXp,
            maxProgress: 100,
            icon: Icons.bolt_rounded,
            color: AppColors.yellowDark,
          ),
          const SizedBox(height: 12),

          _AchievementTile(
            title: 'Pathfinder',
            description: 'Complete 3 lessons',
            currentProgress: progress.completedLessonIds.length,
            maxProgress: 3,
            icon: Icons.star_rounded,
            color: AppColors.green,
          ),
        ],
      ),
    );
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Consumer<GameProgressProvider>(
          builder: (context, progress, child) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      secondary: Icon(
                        progress.isSoundEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                        color: progress.isSoundEnabled ? AppColors.greenDark : AppColors.textMuted,
                      ),
                      title: const Text('Sound Effects & Chimes', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Play chimes and procedural audio during lessons'),
                      value: progress.isSoundEnabled,
                      activeThumbColor: AppColors.green,
                      onChanged: (val) {
                        progress.toggleSound();
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.language_rounded, color: AppColors.blueDark),
                      title: const Text('Spoken & Target Languages', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Change your native tongue or pick a new course'),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                      onTap: () {
                        Navigator.pop(ctx);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const NativeLanguageScreen()),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout_rounded, color: AppColors.orange),
                      title: const Text('Sign Out / Switch Account', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.orangeDark)),
                      subtitle: const Text('Sign in with Google, email, or switch profile'),
                      onTap: () async {
                        Navigator.pop(ctx);
                        await context.read<AuthProvider>().signOut();
                        if (!context.mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                          (route) => false,
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.restart_alt_rounded, color: AppColors.red),
                      title: const Text('Reset All Progress', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.red)),
                      subtitle: const Text('Clears completed lessons, XP, streak & outfits'),
                      onTap: () {
                        context.read<GameProgressProvider>().resetAllProgress();
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Progress reset to defaults.')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatTile({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyBorder, width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.textDark),
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final String title;
  final String description;
  final int currentProgress;
  final int maxProgress;
  final IconData icon;
  final Color color;

  const _AchievementTile({
    required this.title,
    required this.description,
    required this.currentProgress,
    required this.maxProgress,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = (currentProgress / maxProgress).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyBorder, width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                const SizedBox(height: 8),
                DuoProgressBar(
                  progress: ratio,
                  height: 10,
                  fillColor: color,
                  fillDarkColor: color,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$currentProgress/$maxProgress',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
