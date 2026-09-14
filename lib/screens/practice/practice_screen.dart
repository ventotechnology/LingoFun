import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/exercise.dart';
import '../../providers/game_progress_provider.dart';
import '../../services/audio_feedback_service.dart';
import '../../services/curriculum_data.dart';
import '../../services/tts_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/duo_3d_button.dart';
import '../../widgets/duo_mascot.dart';
import '../match_madness/match_madness_screen.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  int _selectedTab = 0; // 0 = Flashcards, 1 = Mistakes Notebook
  int _cardIndex = 0;
  bool _revealed = false;

  // Mistakes Review State
  int _mistakeIndex = 0;
  int? _selectedOptionIndex;
  bool _mistakeChecked = false;
  bool _mistakeCorrect = false;

  final List<(String es, String en, String example)> _flashcards = const [
    ('El agua', 'Water', 'Bebo agua fría.'),
    ('El pan', 'Bread', 'Como pan con mantequilla.'),
    ('La manzana', 'Apple', 'Una manzana roja.'),
    ('Buenos días', 'Good morning', 'Buenos días, amigos.'),
    ('Muchas gracias', 'Thank you very much', 'Muchas gracias por todo.'),
    ('El gato', 'Cat', 'El gato duerme mucho.'),
    ('El café', 'Coffee', 'Un café por favor.'),
  ];

  void _nextCard() {
    setState(() {
      _revealed = false;
      _cardIndex = (_cardIndex + 1) % _flashcards.length;
    });
  }

  void _resetMistakeSelection() {
    setState(() {
      _selectedOptionIndex = null;
      _mistakeChecked = false;
      _mistakeCorrect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<GameProgressProvider>();
    final mistakeCount = progress.mistakeExerciseIds.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Practice & Gym',
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
        child: Column(
          children: [
            // Mode Selector Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.greyBorder, width: 2),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabButton(
                        index: 0,
                        title: 'Vocabulary Gym',
                        icon: Icons.style_rounded,
                        badgeText: null,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _buildTabButton(
                        index: 1,
                        title: 'Mistakes',
                        icon: Icons.auto_fix_high_rounded,
                        badgeText: mistakeCount > 0 ? '$mistakeCount' : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: _selectedTab == 0
                  ? _buildFlashcardsView(progress)
                  : _buildMistakesView(progress),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required int index,
    required String title,
    required IconData icon,
    String? badgeText,
  }) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
          _resetMistakeSelection();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: AppColors.greyBorder,
                    offset: Offset(0, 2),
                    blurRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.greenDark : AppColors.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: isSelected ? AppColors.textDark : AppColors.textMuted,
              ),
            ),
            if (badgeText != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- TAB 0: FLASHCARDS GYM ---

  Widget _buildFlashcardsView(GameProgressProvider progress) {
    final card = _flashcards[_cardIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              const DuoMascot(
                size: 64,
                mood: MascotMood.happy,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Warm up your vocabulary!',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      progress.hearts < 5
                          ? 'Complete flashcards to restore lost hearts!'
                          : 'Your hearts are full! Practice to sharpen skills.',
                      style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Match Madness Arcade Banner
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MatchMadnessScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C4DFF), Color(0xFF651FFF)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF4A148C),
                    offset: Offset(0, 3),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bolt_rounded, color: Colors.yellowAccent, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '⚡ MATCH MADNESS SPEED RUN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.6,
                          ),
                        ),
                        Text(
                          'Match pairs against the clock for bonus XP & Gems!',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 22),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Interactive Flashcard
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _revealed = !_revealed),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _revealed ? AppColors.blueBg : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _revealed ? AppColors.blue : AppColors.greyBorder,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _revealed ? AppColors.blueDark : AppColors.greyBorder,
                      offset: const Offset(0, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'CARD ${_cardIndex + 1} OF ${_flashcards.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textMuted,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      card.$1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_revealed) ...[
                      const Divider(height: 32, thickness: 1.5, color: AppColors.blueLight),
                      Text(
                        card.$2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blueDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Example: "${card.$3}"',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textMuted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ] else ...[
                      const Text(
                        'Tap card to reveal translation',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSubtle,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Duo3DButton(
                  text: 'NEXT CARD',
                  variant: DuoButtonVariant.neutral,
                  onPressed: _nextCard,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Duo3DButton(
                  text: '+1 HEART',
                  variant: DuoButtonVariant.primary,
                  onPressed: progress.hearts < 5
                      ? () {
                          context.read<GameProgressProvider>().addHeart();
                          AudioFeedbackService.playSuccess();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('❤️ +1 Heart restored!'),
                              backgroundColor: AppColors.green,
                            ),
                          );
                          _nextCard();
                        }
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- TAB 1: MISTAKES NOTEBOOK ---

  Widget _buildMistakesView(GameProgressProvider progress) {
    final mistakeIds = progress.mistakeExerciseIds.toList();

    if (mistakeIds.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              DuoMascot(
                size: 110,
                mood: MascotMood.celebrating,
                speechBubbleText: 'Clean sheet! 🎉',
              ),
              SizedBox(height: 24),
              Text(
                'No Mistakes in Notebook!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'You have mastered all your past mistakes, or made none yet. Keep learning in the lessons!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      );
    }

    final safeIndex = _mistakeIndex % mistakeIds.length;
    final currentMistakeId = mistakeIds[safeIndex];
    final exercise = CurriculumData.findExerciseById(currentMistakeId);

    if (exercise == null) {
      return Center(
        child: Text('Mistake $currentMistakeId not found in curriculum.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MISTAKE ${safeIndex + 1} OF ${mistakeIds.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.orange,
                  letterSpacing: 1.0,
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.skip_next_rounded, size: 18),
                label: const Text('Skip'),
                onPressed: () {
                  setState(() {
                    _mistakeIndex = (_mistakeIndex + 1) % mistakeIds.length;
                    _resetMistakeSelection();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            exercise.prompt,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: _buildMistakeExerciseContent(exercise),
          ),

          const SizedBox(height: 12),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: Duo3DButton(
              text: _mistakeChecked
                  ? (_mistakeCorrect ? 'CONTINUE' : 'TRY AGAIN')
                  : 'CHECK ANSWER',
              variant: _mistakeChecked
                  ? (_mistakeCorrect ? DuoButtonVariant.primary : DuoButtonVariant.danger)
                  : (_selectedOptionIndex != null
                      ? DuoButtonVariant.primary
                      : DuoButtonVariant.neutral),
              onPressed: _selectedOptionIndex == null && !_mistakeChecked
                  ? null
                  : () => _handleMistakeAction(exercise, currentMistakeId),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMistakeExerciseContent(Exercise exercise) {
    if (exercise is MultipleChoiceExercise) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.greyBorder, width: 2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    exercise.question,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                if (exercise.speakerText != null)
                  IconButton(
                    icon: const Icon(Icons.volume_up_rounded, color: AppColors.blue, size: 28),
                    onPressed: () => TtsService.speakText(exercise.speakerText!),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: exercise.options.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final isSelected = _selectedOptionIndex == i;
                Color borderColor = AppColors.greyBorder;
                Color bgColor = Colors.white;

                if (_mistakeChecked) {
                  if (i == exercise.correctIndex) {
                    borderColor = AppColors.green;
                    bgColor = AppColors.greenLight.withValues(alpha: 0.3);
                  } else if (isSelected && !_mistakeCorrect) {
                    borderColor = AppColors.red;
                    bgColor = AppColors.red.withValues(alpha: 0.15);
                  }
                } else if (isSelected) {
                  borderColor = AppColors.blue;
                  bgColor = AppColors.blueBg;
                }

                return GestureDetector(
                  onTap: _mistakeChecked
                      ? null
                      : () {
                          AudioFeedbackService.playClick();
                          setState(() => _selectedOptionIndex = i);
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Text(
                      exercise.options[i],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    } else if (exercise is FillInBlankExercise) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.greyBorder, width: 2),
            ),
            child: Text(
              '${exercise.prefix} [ ___ ] ${exercise.suffix}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(exercise.options.length, (i) {
              final isSelected = _selectedOptionIndex == i;
              return ChoiceChip(
                label: Text(
                  exercise.options[i],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                selected: isSelected,
                onSelected: _mistakeChecked
                    ? null
                    : (val) {
                        setState(() => _selectedOptionIndex = val ? i : null);
                      },
              );
            }),
          ),
        ],
      );
    }

    return Center(
      child: Text('Reviewing exercise: ${exercise.prompt}'),
    );
  }

  void _handleMistakeAction(Exercise exercise, String mistakeId) {
    if (_mistakeChecked) {
      if (_mistakeCorrect) {
        // Move to next mistake
        _resetMistakeSelection();
      } else {
        _resetMistakeSelection();
      }
      return;
    }

    bool isCorrect = false;
    if (exercise is MultipleChoiceExercise) {
      isCorrect = _selectedOptionIndex == exercise.correctIndex;
    } else if (exercise is FillInBlankExercise) {
      if (_selectedOptionIndex != null) {
        isCorrect = exercise.options[_selectedOptionIndex!] == exercise.blankAnswer;
      }
    }

    setState(() {
      _mistakeChecked = true;
      _mistakeCorrect = isCorrect;
    });

    if (isCorrect) {
      AudioFeedbackService.playSuccess();
      context.read<GameProgressProvider>().resolveMistake(mistakeId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Mistake Mastered! +1 Heart, +5 Gems!'),
          backgroundColor: AppColors.green,
        ),
      );
    } else {
      AudioFeedbackService.playError();
    }
  }
}
