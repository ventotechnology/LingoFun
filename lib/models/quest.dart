import 'package:flutter/material.dart';

class Quest {
  final String id;
  final String title;
  final String description;
  final int currentProgress;
  final int targetProgress;
  final int gemReward;
  final IconData icon;
  final Color color;
  final bool isClaimed;

  const Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.currentProgress,
    required this.targetProgress,
    this.gemReward = 15,
    required this.icon,
    required this.color,
    this.isClaimed = false,
  });

  bool get isCompleted => currentProgress >= targetProgress;
  double get progressRatio => (currentProgress / targetProgress).clamp(0.0, 1.0);

  Quest copyWith({
    int? currentProgress,
    bool? isClaimed,
  }) {
    return Quest(
      id: id,
      title: title,
      description: description,
      currentProgress: currentProgress ?? this.currentProgress,
      targetProgress: targetProgress,
      gemReward: gemReward,
      icon: icon,
      color: color,
      isClaimed: isClaimed ?? this.isClaimed,
    );
  }
}
