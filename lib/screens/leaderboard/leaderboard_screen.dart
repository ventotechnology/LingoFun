import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_progress_provider.dart';
import '../../theme/app_colors.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userXp = context.watch<GameProgressProvider>().totalXp;

    final List<({String name, int xp, String avatar, bool isUser})> players = [
      (name: 'Mateo S.', xp: 420, avatar: '🦊', isUser: false),
      (name: 'Sofia R.', xp: 380, avatar: '🦉', isUser: false),
      (name: 'Lucas G.', xp: 310, avatar: '🐯', isUser: false),
      (name: 'You', xp: userXp, avatar: '😎', isUser: true),
      (name: 'Emma W.', xp: 190, avatar: '🐼', isUser: false),
      (name: 'Carlos M.', xp: 140, avatar: '🦁', isUser: false),
      (name: 'Hana K.', xp: 95, avatar: '🐰', isUser: false),
      (name: 'Liam T.', xp: 60, avatar: '🐻', isUser: false),
    ];

    // Sort by XP descending
    players.sort((a, b) => b.xp.compareTo(a.xp));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.military_tech_rounded, color: AppColors.yellowDark, size: 28),
            SizedBox(width: 8),
            Text(
              'Diamond League',
              style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.textDark),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Icon(Icons.timer_outlined, color: AppColors.textMuted, size: 18),
                SizedBox(width: 4),
                Text(
                  '3d left',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: players.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.greyBorder),
        itemBuilder: (context, index) {
          final p = players[index];
          final rank = index + 1;

          Color rankColor = AppColors.textMuted;
          if (rank == 1) rankColor = AppColors.yellowDark;
          if (rank == 2) rankColor = AppColors.greyDark;
          if (rank == 3) rankColor = AppColors.orangeDark;

          return Container(
            color: p.isUser ? AppColors.greenBg.withValues(alpha: 0.5) : Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              children: [
                // Rank number
                SizedBox(
                  width: 32,
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: rankColor,
                    ),
                  ),
                ),
                // Avatar emoji
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: p.isUser ? AppColors.green : AppColors.greyBorder,
                      width: 2,
                    ),
                  ),
                  child: Text(p.avatar, style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 14),
                // Name
                Expanded(
                  child: Text(
                    p.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: p.isUser ? FontWeight.w900 : FontWeight.w700,
                      color: p.isUser ? AppColors.greenDark : AppColors.textDark,
                    ),
                  ),
                ),
                // XP
                Row(
                  children: [
                    const Icon(Icons.bolt_rounded, color: AppColors.yellowDark, size: 18),
                    const SizedBox(width: 2),
                    Text(
                      '${p.xp} XP',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
