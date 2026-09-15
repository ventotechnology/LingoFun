import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/lesson.dart';
import '../../providers/game_progress_provider.dart';
import '../../services/curriculum_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/daily_quests_modal.dart';
import '../../widgets/duo_3d_button.dart';
import '../../widgets/duo_top_bar.dart';
import '../lesson/lesson_session_screen.dart';
import '../match_madness/match_madness_screen.dart';

class LessonMapScreen extends StatelessWidget {
  const LessonMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activeCourseId = context.watch<GameProgressProvider>().activeCourseId;
    final currentUnits = CurriculumData.getUnitsForCourse(activeCourseId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: DuoTopBar(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_quests',
        onPressed: () => DailyQuestsModal.show(context),
        backgroundColor: AppColors.yellow,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.stars_rounded, size: 24),
        label: const Text(
          'QUESTS',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.8),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: currentUnits.length,
        itemBuilder: (context, unitIndex) {
          final unit = currentUnits[unitIndex];
          return _UnitSection(unit: unit, unitIndex: unitIndex);
        },
      ),
    );
  }
}

class _UnitSection extends StatelessWidget {
  final Unit unit;
  final int unitIndex;

  const _UnitSection({
    required this.unit,
    required this.unitIndex,
  });

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<GameProgressProvider>();

    return Column(
      children: [
        if (unit.levelTitle != null)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  unit.themeColor.withValues(alpha: 0.15),
                  Colors.amber.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: unit.themeColor.withValues(alpha: 0.35),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                if (unit.levelBadge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    margin: const EdgeInsets.only(right: 14),
                    decoration: BoxDecoration(
                      color: unit.themeColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: unit.themeColor.withValues(alpha: 0.4),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      unit.levelBadge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PROFICIENCY MILESTONE',
                        style: TextStyle(
                          color: unit.themeColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        unit.levelTitle!,
                        style: const TextStyle(
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.stars_rounded,
                  color: Colors.amber,
                  size: 28,
                ),
              ],
            ),
          ),
        // Unit Banner Header
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: unit.themeColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: unit.themeColor.withValues(alpha: 0.5),
                offset: const Offset(0, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UNIT ${unit.unitNumber}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      unit.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      unit.description,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Guidebook Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),

        // Winding S-Curve Path Nodes
        ...List.generate(unit.lessons.length, (lessonIndex) {
          final lesson = unit.lessons[lessonIndex];
          final isCompleted = progress.isLessonCompleted(lesson.id);
          final isUnlocked = progress.isLessonUnlocked(lesson.id);
          final isCurrent = isUnlocked && !isCompleted;

          // Calculate S-curve sinusoidal horizontal offset
          final globalIndex = unitIndex * 4 + lessonIndex;
          final xOffset = math.sin(globalIndex * 1.1) * 75.0;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Transform.translate(
              offset: Offset(xOffset, 0),
              child: _MapNodeWidget(
                lesson: lesson,
                isCompleted: isCompleted,
                isUnlocked: isUnlocked,
                isCurrent: isCurrent,
                themeColor: unit.themeColor,
                onTap: isUnlocked
                    ? () => _showLessonModal(context, lesson, isCompleted)
                    : null,
              ),
            ),
          );
        }),

        // Unit Treasure Chest Reward
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: _TreasureChestNode(
            onClaim: () {
              context.read<GameProgressProvider>().gainGems(20);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🎉 Bonus Chest claimed! +20 Gems!'),
                  backgroundColor: AppColors.blue,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showLessonModal(BuildContext context, Lesson lesson, bool isCompleted) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: unit.themeColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(lesson.icon, color: unit.themeColor, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lesson.description,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.bolt_rounded, color: AppColors.yellow, size: 24),
                    const SizedBox(width: 4),
                    Text(
                      '+${lesson.xpReward} XP',
                      style: const TextStyle(
                        color: AppColors.yellowDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    if (isCompleted)
                      const Chip(
                        avatar: Icon(Icons.check_circle_rounded, color: AppColors.green, size: 18),
                        label: Text('Completed', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.greenDark)),
                        backgroundColor: AppColors.greenBg,
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Duo3DButton(
                  text: isCompleted ? 'PRACTICE (+${lesson.xpReward} XP)' : 'START (+${lesson.xpReward} XP)',
                  variant: isCompleted ? DuoButtonVariant.gold : DuoButtonVariant.primary,
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LessonSessionScreen(lesson: lesson),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MapNodeWidget extends StatelessWidget {
  final Lesson lesson;
  final bool isCompleted;
  final bool isUnlocked;
  final bool isCurrent;
  final Color themeColor;
  final VoidCallback? onTap;

  const _MapNodeWidget({
    required this.lesson,
    required this.isCompleted,
    required this.isUnlocked,
    required this.isCurrent,
    required this.themeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color nodeColor = AppColors.grey;
    Color bevelColor = AppColors.greyDark;
    IconData nodeIcon = Icons.lock_rounded;
    Color iconColor = AppColors.textSubtle;

    if (isCompleted) {
      nodeColor = AppColors.yellow;
      bevelColor = AppColors.yellowDark;
      nodeIcon = Icons.star_rounded;
      iconColor = Colors.white;
    } else if (isUnlocked) {
      nodeColor = themeColor;
      bevelColor = Color.alphaBlend(Colors.black.withValues(alpha: 0.2), themeColor);
      nodeIcon = lesson.icon;
      iconColor = Colors.white;
    }

    const double size = 68.0;
    const double bevelDepth = 7.0;

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Floating "START" Bubble for active current stage
          if (isCurrent)
            Positioned(
              top: -36,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.greyBorder, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.greyBorder,
                      offset: Offset(0, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: const Text(
                  'START',
                  style: TextStyle(
                    color: AppColors.greenDark,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),

          // 3D Circular Node
          GestureDetector(
            onTap: onTap,
            child: SizedBox(
              width: size,
              height: size + bevelDepth,
              child: Stack(
                children: [
                  // Bottom bevel shadow
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: bevelColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Top Face
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: nodeColor,
                        shape: BoxShape.circle,
                        border: isCurrent
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                      ),
                      child: Icon(
                        nodeIcon,
                        color: iconColor,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TreasureChestNode extends StatelessWidget {
  final VoidCallback onClaim;

  const _TreasureChestNode({required this.onClaim});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClaim,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.yellowDark, width: 3),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.yellowDark,
                  offset: Offset(0, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Icon(
              Icons.inventory_2_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'BONUS CHEST',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.yellowDark,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
