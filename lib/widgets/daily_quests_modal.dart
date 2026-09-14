import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_progress_provider.dart';
import '../providers/quests_provider.dart';
import '../theme/app_colors.dart';
import 'duo_3d_button.dart';
import 'duo_progress_bar.dart';

class DailyQuestsModal extends StatelessWidget {
  const DailyQuestsModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const DailyQuestsModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questsProv = context.watch<QuestsProvider>();
    final gameProgress = context.watch<GameProgressProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.stars_rounded, color: AppColors.yellowDark, size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Daily Quests',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textDark,
                  ),
                ),
                const Spacer(),
                Text(
                  'Resets in 12h',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            ...questsProv.quests.map((quest) {
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.greyBorder, width: 2),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: quest.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(quest.icon, color: quest.color, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quest.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            quest.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DuoProgressBar(
                            progress: quest.progressRatio,
                            height: 10,
                            fillColor: quest.color,
                            fillDarkColor: quest.color,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (quest.isClaimed)
                      const Chip(
                        label: Text('CLAIMED', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        backgroundColor: AppColors.greyLight,
                      )
                    else if (quest.isCompleted)
                      SizedBox(
                        width: 90,
                        height: 38,
                        child: Duo3DButton(
                          text: '+${quest.gemReward} 💎',
                          variant: DuoButtonVariant.gold,
                          height: 36,
                          fontSize: 12,
                          onPressed: () {
                            questsProv.claimReward(quest.id, gameProgress);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('🎉 Quest completed! +${quest.gemReward} Gems!'),
                                backgroundColor: AppColors.blue,
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Text(
                        '${quest.currentProgress}/${quest.targetProgress}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
