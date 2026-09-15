import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/game_progress_provider.dart';
import '../../services/leaderboard_service.dart';
import '../../theme/app_colors.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final LeaderboardService _leaderboardService = LeaderboardService();

  @override
  void initState() {
    super.initState();
    // Sync current user's XP to Firestore whenever they open the leaderboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userXp = context.read<GameProgressProvider>().totalXp;
      final user = FirebaseAuth.instance.currentUser;
      final name = user?.displayName ?? user?.email?.split('@')[0] ?? 'You';
      _leaderboardService.updateUserXp(userXp, name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userXp = context.watch<GameProgressProvider>().totalXp;
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    final List<Map<String, dynamic>> fallbackPlayers = [
      {'name': 'Mateo S.', 'xp': 420, 'avatar': '🦊', 'uid': 'mock1'},
      {'name': 'Sofia R.', 'xp': 380, 'avatar': '🦉', 'uid': 'mock2'},
      {'name': 'Lucas G.', 'xp': 310, 'avatar': '🐯', 'uid': 'mock3'},
      {'name': 'You', 'xp': userXp, 'avatar': '😎', 'uid': currentUserUid ?? 'mock_you'},
      {'name': 'Emma W.', 'xp': 190, 'avatar': '🐼', 'uid': 'mock4'},
      {'name': 'Carlos M.', 'xp': 140, 'avatar': '🦁', 'uid': 'mock5'},
      {'name': 'Hana K.', 'xp': 95, 'avatar': '🐰', 'uid': 'mock6'},
      {'name': 'Liam T.', 'xp': 60, 'avatar': '🐻', 'uid': 'mock7'},
    ];

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
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _leaderboardService.getTopPlayers(),
        builder: (context, snapshot) {
          List<Map<String, dynamic>> players = [];
          
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            // Fallback to mock data if Firestore is not set up or errors
            players = List.from(fallbackPlayers);
          } else {
            players = snapshot.data!;
            // Ensure the current user is at least in the list with their local XP if Firestore is delayed
            if (!players.any((p) => p['uid'] == currentUserUid)) {
              players.add({
                'name': 'You',
                'xp': userXp,
                'avatar': '😎',
                'uid': currentUserUid ?? 'mock_you'
              });
            }
          }

          // Sort by XP descending
          players.sort((a, b) => (b['xp'] as int).compareTo(a['xp'] as int));

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: players.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.greyBorder),
            itemBuilder: (context, index) {
              final p = players[index];
              final rank = index + 1;
              final isUser = p['uid'] == currentUserUid || p['uid'] == 'mock_you';
              final avatar = p['avatar'] ?? (isUser ? '😎' : '👤');
              final name = p['name'] ?? 'Unknown';
              final xp = p['xp'] ?? 0;

              Color rankColor = AppColors.textMuted;
              if (rank == 1) rankColor = AppColors.yellowDark;
              if (rank == 2) rankColor = AppColors.greyDark;
              if (rank == 3) rankColor = AppColors.orangeDark;

              return Container(
                color: isUser ? AppColors.greenBg.withValues(alpha: 0.5) : Colors.transparent,
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
                          color: isUser ? AppColors.green : AppColors.greyBorder,
                          width: 2,
                        ),
                      ),
                      child: Text(avatar, style: const TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: 14),
                    // Name
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isUser ? FontWeight.w900 : FontWeight.w700,
                          color: isUser ? AppColors.greenDark : AppColors.textDark,
                        ),
                      ),
                    ),
                    // XP
                    Row(
                      children: [
                        const Icon(Icons.bolt_rounded, color: AppColors.yellowDark, size: 18),
                        const SizedBox(width: 2),
                        Text(
                          '$xp XP',
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
          );
        },
      ),
    );
  }
}
