import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_progress_provider.dart';
import '../theme/app_colors.dart';
import 'duo_3d_button.dart';

class HeartsModal {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => const _HeartsModalContent(),
    );
  }
}

class _HeartsModalContent extends StatelessWidget {
  const _HeartsModalContent();

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<GameProgressProvider>();
    final hearts = progress.hearts;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite_rounded, size: 80, color: AppColors.red),
            const SizedBox(height: 12),
            Text(
              '$hearts Hearts',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.redDark),
            ),
            const SizedBox(height: 8),
            const Text(
              'Keep practicing to learn! You lose a heart if you make a mistake in a lesson.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.textMuted),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: Duo3DButton(
                text: 'PRACTICE TO EARN (1 HEART)',
                variant: DuoButtonVariant.primary,
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Navigate to Practice mode
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: Duo3DButton(
                text: 'REFILL (100 GEMS)',
                variant: hearts < 5 ? DuoButtonVariant.gold : DuoButtonVariant.neutral,
                onPressed: hearts < 5 ? () {
                  final bought = context.read<GameProgressProvider>().buyHeartRefill();
                  if (bought) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Hearts Refilled!'), backgroundColor: AppColors.green),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Not enough gems!'), backgroundColor: AppColors.orange),
                    );
                  }
                } : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
