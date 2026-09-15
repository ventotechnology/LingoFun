import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_progress_provider.dart';
import '../../theme/app_colors.dart';
import 'flashcard_quiz_screen.dart';
import 'ai_chat_screen.dart';
import 'speaking_practice_screen.dart';
import '../match_madness/match_madness_screen.dart';
import 'practice_screen.dart'; // We can route to the old screen for Mistakes

class PracticeHubScreen extends StatelessWidget {
  const PracticeHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<GameProgressProvider>();
    final mistakeCount = progress.mistakeExerciseIds.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Practice Hub',
          style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.textDark),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.favorite_rounded, color: AppColors.red, size: 24),
                const SizedBox(width: 4),
                Text(
                  '${progress.hearts}/5',
                  style: const TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildPracticeCard(
              context: context,
              title: 'Mistakes Review',
              subtitle: 'Focus on what you missed',
              icon: Icons.auto_fix_high_rounded,
              color: AppColors.red,
              badgeText: mistakeCount > 0 ? '$mistakeCount' : null,
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PracticeScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildPracticeCard(
              context: context,
              title: 'Smart Flashcards',
              subtitle: 'Learn new vocabulary by difficulty',
              icon: Icons.school_rounded,
              color: AppColors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FlashcardQuizScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildPracticeCard(
              context: context,
              title: 'AI Conversation',
              subtitle: 'Chat freely with your AI tutor',
              icon: Icons.chat_bubble_rounded,
              color: AppColors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AiChatScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildPracticeCard(
              context: context,
              title: 'Speaking Practice',
              subtitle: 'Perfect your pronunciation',
              icon: Icons.mic_rounded,
              color: AppColors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SpeakingPracticeScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _buildPracticeCard(
              context: context,
              title: 'Match Madness',
              subtitle: 'Lightning fast word pairing',
              icon: Icons.bolt_rounded,
              color: const Color(0xFF7C4DFF),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MatchMadnessScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    String? badgeText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: color,
                        ),
                      ),
                      if (badgeText != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            badgeText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greyDark,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: color, size: 32),
          ],
        ),
      ),
    );
  }
}
