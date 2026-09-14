import 'package:flutter/material.dart';
import '../models/quest.dart';
import '../theme/app_colors.dart';
import 'game_progress_provider.dart';

class QuestsProvider extends ChangeNotifier {
  List<Quest> _quests = [
    const Quest(
      id: 'quest_xp',
      title: 'Earn 30 XP',
      description: 'Power up your brain by completing lessons today',
      currentProgress: 0,
      targetProgress: 30,
      gemReward: 15,
      icon: Icons.bolt_rounded,
      color: AppColors.yellowDark,
    ),
    const Quest(
      id: 'quest_accuracy',
      title: 'Score 80%+ Accuracy',
      description: 'Show off your accuracy in a lesson session',
      currentProgress: 0,
      targetProgress: 1,
      gemReward: 15,
      icon: Icons.gps_fixed_rounded,
      color: AppColors.blue,
    ),
    const Quest(
      id: 'quest_lessons',
      title: 'Complete 2 Lessons',
      description: 'Reach a study milestone today',
      currentProgress: 0,
      targetProgress: 2,
      gemReward: 20,
      icon: Icons.school_rounded,
      color: AppColors.green,
    ),
  ];

  List<Quest> get quests => List.unmodifiable(_quests);

  void onLessonFinished({required int xpEarned, required int accuracy}) {
    _quests = _quests.map((q) {
      if (q.id == 'quest_xp') {
        return q.copyWith(currentProgress: (q.currentProgress + xpEarned).clamp(0, q.targetProgress));
      } else if (q.id == 'quest_accuracy' && accuracy >= 80) {
        return q.copyWith(currentProgress: 1);
      } else if (q.id == 'quest_lessons') {
        return q.copyWith(currentProgress: (q.currentProgress + 1).clamp(0, q.targetProgress));
      }
      return q;
    }).toList();

    notifyListeners();
  }

  bool claimReward(String questId, GameProgressProvider gameProgress) {
    final index = _quests.indexWhere((q) => q.id == questId);
    if (index == -1) return false;

    final quest = _quests[index];
    if (quest.isCompleted && !quest.isClaimed) {
      _quests[index] = quest.copyWith(isClaimed: true);
      gameProgress.gainGems(quest.gemReward);
      notifyListeners();
      return true;
    }
    return false;
  }
}
