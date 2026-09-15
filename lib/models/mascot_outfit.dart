import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MascotOutfit {
  final String id;
  final String name;
  final String description;
  final int costGems;
  final String emoji;
  final Color themeColor;

  const MascotOutfit({
    required this.id,
    required this.name,
    required this.description,
    required this.costGems,
    required this.emoji,
    required this.themeColor,
  });

  static const MascotOutfit classic = MascotOutfit(
    id: 'classic',
    name: 'Classic Parrot',
    description: 'The iconic colorful parrot you know and love.',
    costGems: 0,
    emoji: '🦉',
    themeColor: AppColors.green,
  );

  static const MascotOutfit beret = MascotOutfit(
    id: 'beret',
    name: 'French Artist Beret',
    description: 'Chic Parisian artist beret with a stylish French tilt.',
    costGems: 100,
    emoji: '🎨',
    themeColor: AppColors.red,
  );

  static const MascotOutfit samurai = MascotOutfit(
    id: 'samurai',
    name: 'Samurai Headband',
    description: 'Warrior headband with the rising sun for dedicated learners.',
    costGems: 150,
    emoji: '⚔️',
    themeColor: AppColors.orange,
  );

  static const MascotOutfit coder = MascotOutfit(
    id: 'coder',
    name: 'Hacker Hoodie & Glasses',
    description: 'Matrix-green glasses and hoodie for late-night coders.',
    costGems: 200,
    emoji: '💻',
    themeColor: AppColors.blueDark,
  );

  static const MascotOutfit crown = MascotOutfit(
    id: 'crown',
    name: 'Royal Golden Crown',
    description: 'Pure gold crown studded with sparkling rubies.',
    costGems: 300,
    emoji: '👑',
    themeColor: AppColors.yellowDark,
  );

  static const List<MascotOutfit> allOutfits = [
    classic,
    beret,
    samurai,
    coder,
    crown,
  ];

  static MascotOutfit getById(String id) {
    return allOutfits.firstWhere(
      (o) => o.id == id,
      orElse: () => classic,
    );
  }
}
