import 'streak_modal.dart';
import 'hearts_modal.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_progress_provider.dart';
import '../services/curriculum_data.dart';
import '../theme/app_colors.dart';

class DuoTopBar extends StatelessWidget {
  final VoidCallback? onFlagTap;
  final VoidCallback? onStreakTap;
  final VoidCallback? onGemsTap;
  final VoidCallback? onHeartsTap;

  const DuoTopBar({
    super.key,
    this.onFlagTap,
    this.onStreakTap,
    this.onGemsTap,
    this.onHeartsTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<GameProgressProvider>();
    final activeCourse = CurriculumData.getCourse(progress.activeCourseId);

    return SafeArea(
      bottom: false,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: AppColors.greyBorder, width: 2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Active Course Flag
            InkWell(
              onTap: onFlagTap ?? () => _showCourseModal(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.greyBorder, width: 1.5),
                ),
                child: Row(
                  children: [
                    Text(activeCourse.flag, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),

            // Streak Flame
            InkWell(
              onTap: onStreakTap ?? () => StreakModal.show(context),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded,
                        color: AppColors.orange, size: 24),
                    const SizedBox(width: 4),
                    Text(
                      '${progress.streak}',
                      style: const TextStyle(
                        color: AppColors.orange,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Gems / Lingots
            InkWell(
              onTap: onGemsTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.diamond_rounded,
                        color: AppColors.blue, size: 22),
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
            ),

            // Hearts / Lives
            InkWell(
              onTap: onHeartsTap ?? () => HeartsModal.show(context),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.favorite_rounded,
                        color: AppColors.red, size: 24),
                    const SizedBox(width: 4),
                    Text(
                      '${progress.hearts}',
                      style: const TextStyle(
                        color: AppColors.red,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCourseModal(BuildContext context) {
    final gameProgress = context.read<GameProgressProvider>();
    final activeId = gameProgress.activeCourseId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.78,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.greyBorder,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Language Courses',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.greyBorder),

              // Courses Scrollable List
              Flexible(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shrinkWrap: true,
                  children: CurriculumData.courses.values.map((course) {
                    final isSelected = course.id == activeId;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.greenBg.withValues(alpha: 0.3)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? AppColors.green : AppColors.greyBorder,
                          width: 2,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.greyBorder, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              course.flag,
                              style: const TextStyle(fontSize: 26),
                            ),
                          ),
                        ),
                        title: Text(
                          course.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: isSelected ? AppColors.greenText : AppColors.textDark,
                          ),
                        ),
                        subtitle: Text(
                          course.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                        trailing: isSelected
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'ACTIVE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.greyDark,
                              ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        onTap: () {
                          gameProgress.switchCourse(course.id);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Switched to ${course.title}!'),
                              backgroundColor: AppColors.green,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
