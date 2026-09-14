import 'package:flutter/material.dart';
import '../../../models/exercise.dart';
import '../../../services/tts_service.dart';
import '../../../theme/app_colors.dart';

class MultipleChoiceWidget extends StatelessWidget {
  final MultipleChoiceExercise exercise;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  const MultipleChoiceWidget({
    super.key,
    required this.exercise,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prompt Title
          Text(
            exercise.prompt,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),

          // Speaker Question Card
          InkWell(
            onTap: () {
              final text = exercise.speakerText ?? exercise.question;
              TtsService().speak(text);
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
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
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.blueBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.volume_up_rounded,
                      color: AppColors.blue,
                      size: 26,
                    ),
                  ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    exercise.question,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

          // Options List
          ...List.generate(exercise.options.length, (index) {
            final isSelected = selectedIndex == index;
            final optionText = exercise.options[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: InkWell(
                onTap: () => onSelect(index),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.blueBg : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.blue : AppColors.greyBorder,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected ? AppColors.blueDark : AppColors.greyBorder,
                        offset: const Offset(0, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Badge (1, 2, 3)
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.blue : AppColors.greyLight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? AppColors.blueDark : AppColors.greyDark,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textMuted,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          optionText,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? AppColors.blueDark : AppColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
