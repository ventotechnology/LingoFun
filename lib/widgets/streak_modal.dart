import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_progress_provider.dart';
import '../theme/app_colors.dart';
import 'duo_3d_button.dart';

class StreakModal {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => const _StreakModalContent(),
    );
  }
}

class _StreakModalContent extends StatelessWidget {
  const _StreakModalContent();

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<GameProgressProvider>();
    final streak = progress.streak;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_fire_department_rounded, size: 80, color: AppColors.orange),
            const SizedBox(height: 12),
            Text(
              '$streak Day Streak!',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.orangeDark),
            ),
            const SizedBox(height: 8),
            const Text(
              'Practice every day so your streak won\'t reset!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textMuted),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDay('M', true),
                _buildDay('T', true),
                _buildDay('W', true),
                _buildDay('T', true),
                _buildDay('F', true),
                _buildDay('S', true),
                _buildDay('S', false),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: Duo3DButton(
                text: 'CONTINUE',
                variant: DuoButtonVariant.primary,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDay(String day, bool isActive) {
    return Column(
      children: [
        Text(day, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMuted)),
        const SizedBox(height: 8),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.orange : AppColors.surface,
          ),
          child: Icon(
            Icons.local_fire_department_rounded,
            size: 20,
            color: isActive ? Colors.white : AppColors.greyBorder,
          ),
        ),
      ],
    );
  }
}
