import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/story.dart';
import '../../providers/game_progress_provider.dart';
import '../../services/curriculum_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/duo_mascot.dart';
import '../../widgets/duo_top_bar.dart';
import 'story_player_screen.dart';

class StoriesTabScreen extends StatelessWidget {
  const StoriesTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<GameProgressProvider>();
    final activeCourseId = progress.activeCourseId;
    final activeCourse = CurriculumData.getCourse(activeCourseId);
    final stories = StoriesData.getStoriesForCourse(activeCourseId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: const DuoTopBar(),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Banner Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blue.withValues(alpha: 0.15),
                        AppColors.purple.withValues(alpha: 0.15),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.blue.withValues(alpha: 0.3), width: 2),
                  ),
                  child: Row(
                    children: [
                      const DuoMascot(
                        mood: MascotMood.happy,
                        size: 70,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  activeCourse.flag,
                                  style: const TextStyle(fontSize: 22),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '${activeCourse.title} Stories',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textDark,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Interactive dialogues with voice, checkpoints & rewards!',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Stories List Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Story Library',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.greyBorder, width: 1.5),
                      ),
                      child: Text(
                        '${stories.where((s) => progress.isStoryCompleted(s.id)).length}/${stories.length} Read',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Stories List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, index) {
                    final story = stories[index];
                    final isCompleted = progress.isStoryCompleted(story.id);

                    return _StoryCard(
                      story: story,
                      isCompleted: isCompleted,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => StoryPlayerScreen(story: story),
                          ),
                        );
                      },
                    );
                  },
                  childCount: stories.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final Story story;
  final bool isCompleted;
  final VoidCallback onTap;

  const _StoryCard({
    required this.story,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCompleted ? AppColors.green : AppColors.greyBorder,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isCompleted
                ? AppColors.greenDark.withValues(alpha: 0.25)
                : AppColors.greyBorder.withValues(alpha: 0.6),
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Story Icon
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.greenBg.withValues(alpha: 0.5)
                        : AppColors.blueBg.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCompleted ? AppColors.green : AppColors.blue,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      story.emoji,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Story Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              story.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          if (isCompleted)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.green,
                              size: 20,
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        story.translationTitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Rewards
                      Row(
                        children: [
                          _buildMiniBadge(
                            icon: Icons.bolt_rounded,
                            color: AppColors.yellowDark,
                            label: '+${story.xpReward} XP',
                          ),
                          const SizedBox(width: 8),
                          _buildMiniBadge(
                            icon: Icons.diamond_rounded,
                            color: AppColors.blue,
                            label: '+${story.gemReward} 💎',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.greyDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniBadge({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
