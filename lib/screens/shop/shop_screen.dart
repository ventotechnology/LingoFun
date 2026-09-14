import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/mascot_outfit.dart';
import '../../providers/game_progress_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/duo_3d_button.dart';
import '../../widgets/duo_mascot.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<GameProgressProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Shop',
          style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.textDark),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.diamond_rounded, color: AppColors.blue, size: 24),
                const SizedBox(width: 4),
                Text(
                  '${progress.gems}',
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Super Pass Promotional Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1CB0F6), Color(0xFFCE82FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFA553DF),
                  offset: Offset(0, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SUPER DUOLINGO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Unlimited hearts, personalized practice, and zero interruptions.',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          const Text(
            'HEARTS & STREAKS',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 16),

          // Refill Hearts Card
          _ShopItemCard(
            title: 'Refill Hearts',
            description: 'Restore your hearts to max (5/5) so you can keep playing!',
            icon: Icons.favorite_rounded,
            iconColor: AppColors.red,
            cost: 100,
            canBuy: progress.gems >= 100 && progress.hearts < 5,
            buttonText: progress.hearts >= 5 ? 'FULL' : '100 GEMS',
            onBuy: () {
              final ok = context.read<GameProgressProvider>().buyHeartRefill();
              if (ok) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('❤️ Hearts fully refilled!'), backgroundColor: AppColors.green),
                );
              }
            },
          ),
          const SizedBox(height: 16),

          // Streak Freeze Card
          _ShopItemCard(
            title: 'Streak Freeze',
            description: 'Streak Freeze protects your streak if you miss a day of practice.',
            icon: Icons.ac_unit_rounded,
            iconColor: AppColors.blue,
            cost: 150,
            canBuy: progress.gems >= 150,
            buttonText: '150 GEMS',
            badge: '${progress.streakFreezeCount} EQUIPPED',
            onBuy: () {
              final ok = context.read<GameProgressProvider>().buyStreakFreeze();
              if (ok) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('❄️ Streak Freeze equipped!'), backgroundColor: AppColors.blue),
                );
              }
            },
          ),
          const SizedBox(height: 16),

          // Double or Nothing Card
          _ShopItemCard(
            title: 'Double or Nothing',
            description: 'Wager 50 Gems to win 100 Gems by keeping a 7-day streak.',
            icon: Icons.stars_rounded,
            iconColor: AppColors.yellowDark,
            cost: 50,
            canBuy: progress.gems >= 50,
            buttonText: '50 GEMS',
            onBuy: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🌟 Double or Nothing wager activated!'), backgroundColor: AppColors.yellowDark),
              );
            },
          ),
          const SizedBox(height: 28),

          // DUO'S WARDROBE SECTION
          const Text(
            "DUO'S WARDROBE",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Dress up Duo with unlockable hats and custom skins!',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),

          ...MascotOutfit.allOutfits.map((outfit) {
            final isEquipped = progress.equippedOutfitId == outfit.id;
            final isUnlocked = progress.isOutfitUnlocked(outfit.id);
            final canAfford = progress.gems >= outfit.costGems;

            String btnText;
            DuoButtonVariant variant;
            VoidCallback? action;

            if (isEquipped) {
              btnText = 'EQUIPPED';
              variant = DuoButtonVariant.neutral;
              action = null;
            } else if (isUnlocked) {
              btnText = 'EQUIP';
              variant = DuoButtonVariant.secondary;
              action = () {
                context.read<GameProgressProvider>().equipOutfit(outfit.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✨ Equipped ${outfit.name}!'),
                    backgroundColor: AppColors.blue,
                  ),
                );
              };
            } else {
              btnText = '${outfit.costGems} GEMS';
              variant = canAfford ? DuoButtonVariant.gold : DuoButtonVariant.neutral;
              action = canAfford
                  ? () {
                      final ok = context.read<GameProgressProvider>().buyOutfit(outfit);
                      if (ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${outfit.emoji} Unlocked & equipped ${outfit.name}!'),
                            backgroundColor: AppColors.green,
                          ),
                        );
                      }
                    }
                  : null;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _OutfitCard(
                outfit: outfit,
                isEquipped: isEquipped,
                isUnlocked: isUnlocked,
                buttonText: btnText,
                buttonVariant: variant,
                onPressed: action,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _OutfitCard extends StatelessWidget {
  final MascotOutfit outfit;
  final bool isEquipped;
  final bool isUnlocked;
  final String buttonText;
  final DuoButtonVariant buttonVariant;
  final VoidCallback? onPressed;

  const _OutfitCard({
    required this.outfit,
    required this.isEquipped,
    required this.isUnlocked,
    required this.buttonText,
    required this.buttonVariant,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isEquipped ? AppColors.green : AppColors.greyBorder,
          width: isEquipped ? 2.5 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isEquipped ? AppColors.greenDark : AppColors.greyBorder,
            offset: const Offset(0, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: outfit.themeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: DuoMascot(
              size: 58,
              mood: MascotMood.happy,
              outfitId: outfit.id,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${outfit.emoji} ${outfit.name}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    if (isEquipped)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.greenLight.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'ACTIVE',
                          style: TextStyle(
                            color: AppColors.greenDark,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  outfit.description,
                  style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 150,
                  height: 40,
                  child: Duo3DButton(
                    text: buttonText,
                    variant: buttonVariant,
                    height: 38,
                    fontSize: 12,
                    onPressed: onPressed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopItemCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final int cost;
  final bool canBuy;
  final String buttonText;
  final String? badge;
  final VoidCallback onBuy;

  const _ShopItemCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.cost,
    required this.canBuy,
    required this.buttonText,
    this.badge,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textDark),
                      ),
                    ),
                    if (badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.blueBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(color: AppColors.blueDark, fontSize: 11, fontWeight: FontWeight.w800),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 150,
                  height: 42,
                  child: Duo3DButton(
                    text: buttonText,
                    variant: canBuy ? DuoButtonVariant.gold : DuoButtonVariant.neutral,
                    height: 40,
                    fontSize: 13,
                    onPressed: canBuy ? onBuy : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
