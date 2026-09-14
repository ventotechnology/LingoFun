import 'dart:math';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/duo_3d_button.dart';
import '../../../widgets/duo_mascot.dart';

class FeedbackBottomSheet extends StatelessWidget {
  final bool isCorrect;
  final String? correctAnswerText;
  final VoidCallback onContinue;

  const FeedbackBottomSheet({
    super.key,
    required this.isCorrect,
    this.correctAnswerText,
    required this.onContinue,
  });

  static final List<String> _praisePhrases = [
    'Nicely done!',
    'Great job!',
    'Spot on!',
    'You are doing great!',
    'Amazing!',
    'Keep it up!',
  ];

  @override
  Widget build(BuildContext context) {
    final phrase = _praisePhrases[Random().nextInt(_praisePhrases.length)];

    final bgColor = isCorrect ? AppColors.greenBg : AppColors.redBg;
    final primaryTextColor = isCorrect ? AppColors.greenText : AppColors.redText;
    final iconBgColor = isCorrect ? AppColors.green : AppColors.red;
    final icon = isCorrect ? Icons.check_rounded : Icons.close_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 28),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Circular Status Badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                // Heading
                Expanded(
                  child: Text(
                    isCorrect ? phrase : 'Correct solution:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: primaryTextColor,
                    ),
                  ),
                ),
                // Expressive Mascot Reaction
                DuoMascot(
                  size: 55,
                  mood: isCorrect ? MascotMood.celebrating : MascotMood.crying,
                ),
              ],
            ),

            if (!isCorrect && correctAnswerText != null) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 58),
                child: Text(
                  correctAnswerText!,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.redText,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // 3D Continue Button
            Duo3DButton(
              text: 'CONTINUE',
              variant: isCorrect ? DuoButtonVariant.primary : DuoButtonVariant.danger,
              onPressed: onContinue,
            ),
          ],
        ),
      ),
    );
  }
}
