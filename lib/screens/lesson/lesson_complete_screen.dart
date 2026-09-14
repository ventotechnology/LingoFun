import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/lesson.dart';
import '../../providers/game_progress_provider.dart';
import '../../providers/quests_provider.dart';
import '../../services/audio_feedback_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/duo_3d_button.dart';
import '../../widgets/duo_mascot.dart';

class LessonCompleteScreen extends StatefulWidget {
  final Lesson lesson;
  final int accuracy;
  final int xpEarned;

  const LessonCompleteScreen({
    super.key,
    required this.lesson,
    required this.accuracy,
    required this.xpEarned,
  });

  @override
  State<LessonCompleteScreen> createState() => _LessonCompleteScreenState();
}

class _LessonCompleteScreenState extends State<LessonCompleteScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
    AudioFeedbackService.playComplete();

    // Commit progress to state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProgressProvider>().completeLesson(
            widget.lesson.id,
            widget.xpEarned,
          );
      context.read<QuestsProvider>().onLessonFinished(
            xpEarned: widget.xpEarned,
            accuracy: widget.accuracy,
          );
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final streak = context.watch<GameProgressProvider>().streak;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Confetti explosion from top center
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2, // downwards
              maxBlastForce: 6,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 25,
              gravity: 0.2,
              colors: const [
                AppColors.green,
                AppColors.blue,
                AppColors.yellow,
                AppColors.orange,
                AppColors.purple,
                AppColors.red,
              ],
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const Spacer(flex: 1),

                  // Mascot Celebrating
                  const DuoMascot(
                    size: 130,
                    mood: MascotMood.celebrating,
                    speechBubbleText: 'You did it! Incredible!',
                  ),
                  const SizedBox(height: 20),

                  // Heading
                  const Text(
                    'Lesson Complete!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.greenDark,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You crushed "${widget.lesson.title}"!',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Spacer(flex: 1),

                  // 3 Stat Cards Row
                  Row(
                    children: [
                      // Total XP Card
                      Expanded(
                        child: _StatCard(
                          title: 'TOTAL XP',
                          value: '+${widget.xpEarned}',
                          icon: Icons.bolt_rounded,
                          color: AppColors.yellow,
                          textColor: AppColors.yellowDark,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Accuracy Card
                      Expanded(
                        child: _StatCard(
                          title: 'ACCURACY',
                          value: '${widget.accuracy}%',
                          icon: Icons.gps_fixed_rounded,
                          color: AppColors.blue,
                          textColor: AppColors.blueDark,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Streak Card
                      Expanded(
                        child: _StatCard(
                          title: 'STREAK',
                          value: '$streak',
                          icon: Icons.local_fire_department_rounded,
                          color: AppColors.orange,
                          textColor: AppColors.orangeDark,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(flex: 2),

                  // 3D Continue Button
                  Duo3DButton(
                    text: 'CONTINUE',
                    variant: DuoButtonVariant.primary,
                    height: 54,
                    fontSize: 18,
                    onPressed: () {
                      Navigator.pop(context); // returns to lesson map
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color textColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            offset: const Offset(0, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
