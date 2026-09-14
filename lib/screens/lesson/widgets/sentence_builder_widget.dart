import 'package:flutter/material.dart';
import '../../../models/exercise.dart';
import '../../../services/tts_service.dart';
import '../../../theme/app_colors.dart';

class SentenceBuilderWidget extends StatefulWidget {
  final SentenceBuilderExercise exercise;
  final ValueChanged<List<String>> onSequenceChanged;

  const SentenceBuilderWidget({
    super.key,
    required this.exercise,
    required this.onSequenceChanged,
  });

  @override
  State<SentenceBuilderWidget> createState() => _SentenceBuilderWidgetState();
}

class _SentenceBuilderWidgetState extends State<SentenceBuilderWidget> {
  // Track tokens placed in sentence by index in tokenBank
  final List<int> _selectedIndices = [];

  void _addToken(int index) {
    setState(() {
      _selectedIndices.add(index);
    });
    _notify();
  }

  void _removeTokenAt(int positionInAssembly) {
    setState(() {
      _selectedIndices.removeAt(positionInAssembly);
    });
    _notify();
  }

  void _notify() {
    final tokens = _selectedIndices.map((i) => widget.exercise.tokenBank[i]).toList();
    widget.onSequenceChanged(tokens);
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;

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
          const SizedBox(height: 24),

          // Target Sentence Speaker Bubble
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  final text = exercise.speakerText ?? exercise.sentenceToTranslate;
                  TtsService().speak(text);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.blueBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.blue, width: 2),
                  ),
                  child: const Icon(
                    Icons.volume_up_rounded,
                    color: AppColors.blue,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  child: Text(
                    exercise.sentenceToTranslate,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Sentence Assembly Area
          Container(
            constraints: const Duration(milliseconds: 200) == Duration.zero ? null : const BoxConstraints(minHeight: 110),
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.greyDark.withValues(alpha: 0.5), width: 1.5),
            ),
            child: _selectedIndices.isEmpty
                ? const Center(
                    child: Text(
                      'Tap the words below to build the sentence',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(_selectedIndices.length, (assemblyPos) {
                      final bankIndex = _selectedIndices[assemblyPos];
                      final word = exercise.tokenBank[bankIndex];

                      return _WordChip(
                        text: word,
                        onTap: () => _removeTokenAt(assemblyPos),
                        isPlaced: false,
                      );
                    }),
                  ),
          ),
          const SizedBox(height: 36),

          // Word Bank Pool
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 12,
            children: List.generate(exercise.tokenBank.length, (index) {
              final isUsed = _selectedIndices.contains(index);
              final word = exercise.tokenBank[index];

              return isUsed
                  // Disabled placeholder slot
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.grey, width: 2),
                      ),
                      child: Text(
                        word,
                        style: const TextStyle(
                          color: Colors.transparent,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  // Active interactive chip
                  : _WordChip(
                      text: word,
                      onTap: () => _addToken(index),
                      isPlaced: false,
                    );
            }),
          ),
        ],
      ),
    );
  }
}

class _WordChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isPlaced;

  const _WordChip({
    required this.text,
    required this.onTap,
    required this.isPlaced,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.greyBorder, width: 2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.greyBorder,
              offset: Offset(0, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
