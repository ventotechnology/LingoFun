import 'package:flutter/material.dart';
import '../../../models/exercise.dart';
import '../../../theme/app_colors.dart';

class FillInBlankWidget extends StatelessWidget {
  final FillInBlankExercise exercise;
  final String? selectedAnswer;
  final ValueChanged<String> onSelectAnswer;

  const FillInBlankWidget({
    super.key,
    required this.exercise,
    required this.selectedAnswer,
    required this.onSelectAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prompt
          Text(
            exercise.prompt,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 32),

          // Sentence with Blank Slot Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.greyBorder, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.greyBorder,
                  offset: Offset(0, 3),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  exercise.prefix,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                // Blank Slot
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: selectedAnswer != null ? AppColors.blueBg : AppColors.greyLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedAnswer != null ? AppColors.blue : AppColors.greyDark,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    selectedAnswer ?? '  ___  ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: selectedAnswer != null ? AppColors.blueDark : AppColors.textMuted,
                    ),
                  ),
                ),
                Text(
                  exercise.suffix,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),

          // Options Grid/Chips
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: exercise.options.map((option) {
              final isSelected = selectedAnswer == option;

              return InkWell(
                onTap: () => onSelectAnswer(option),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.blueBg : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.blue : AppColors.greyBorder,
                      width: 2.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected ? AppColors.blueDark : AppColors.greyBorder,
                        offset: const Offset(0, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.blueDark : AppColors.textDark,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
