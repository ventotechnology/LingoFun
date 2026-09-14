import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/exercise.dart';
import '../../models/lesson.dart';
import '../../providers/game_progress_provider.dart';
import '../../services/audio_feedback_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/duo_3d_button.dart';
import '../../widgets/duo_progress_bar.dart';
import 'lesson_complete_screen.dart';
import 'widgets/feedback_bottom_sheet.dart';
import 'widgets/fill_in_blank_widget.dart';
import 'widgets/matching_pairs_widget.dart';
import 'widgets/multiple_choice_widget.dart';
import 'widgets/sentence_builder_widget.dart';
import 'widgets/speaking_challenge_widget.dart';

class LessonSessionScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonSessionScreen({
    super.key,
    required this.lesson,
  });

  @override
  State<LessonSessionScreen> createState() => _LessonSessionScreenState();
}

class _LessonSessionScreenState extends State<LessonSessionScreen> {
  int _currentIndex = 0;
  int _mistakesCount = 0;
  int _consecutiveCorrect = 0;

  // Evaluation states
  bool _isChecked = false;
  bool _isCorrect = false;
  String _correctAnswerText = '';

  // Inputs
  int? _selectedMultipleChoice;
  List<String> _currentSentenceTokens = [];
  bool _matchingPairsCompleted = false;
  String? _selectedBlankWord;
  bool _speakingCompleted = false;

  Exercise get _currentExercise => widget.lesson.exercises[_currentIndex];

  bool get _canCheckAnswer {
    if (_isChecked) return false;
    final ex = _currentExercise;
    if (ex is MultipleChoiceExercise) {
      return _selectedMultipleChoice != null;
    } else if (ex is SentenceBuilderExercise) {
      return _currentSentenceTokens.isNotEmpty;
    } else if (ex is MatchingPairExercise) {
      return _matchingPairsCompleted;
    } else if (ex is FillInBlankExercise) {
      return _selectedBlankWord != null;
    } else if (ex is SpeakingExercise) {
      return _speakingCompleted;
    }
    return false;
  }

  void _checkAnswer() {
    if (!_canCheckAnswer) return;

    final ex = _currentExercise;
    bool isCorrect = false;
    String correctText = '';

    if (ex is MultipleChoiceExercise) {
      isCorrect = _selectedMultipleChoice == ex.correctIndex;
      correctText = ex.options[ex.correctIndex];
    } else if (ex is SentenceBuilderExercise) {
      final userSentence = _currentSentenceTokens.join(' ').trim().toLowerCase();
      final targetSentence = ex.correctSequence.join(' ').trim().toLowerCase();
      isCorrect = userSentence == targetSentence;
      correctText = ex.correctSequence.join(' ');
    } else if (ex is MatchingPairExercise) {
      isCorrect = _matchingPairsCompleted;
      correctText = 'All pairs matched!';
    } else if (ex is FillInBlankExercise) {
      isCorrect = _selectedBlankWord == ex.blankAnswer;
      correctText = '${ex.prefix}${ex.blankAnswer}${ex.suffix}';
    } else if (ex is SpeakingExercise) {
      isCorrect = _speakingCompleted;
      correctText = ex.targetPhrase;
    }

    if (isCorrect) {
      AudioFeedbackService.playSuccess();
      _consecutiveCorrect++;
    } else {
      AudioFeedbackService.playError();
      _mistakesCount++;
      _consecutiveCorrect = 0;
      context.read<GameProgressProvider>().loseHeart();
      context.read<GameProgressProvider>().recordMistake(ex.id);
    }

    setState(() {
      _isChecked = true;
      _isCorrect = isCorrect;
      _correctAnswerText = correctText;
    });

    // If hearts hit 0, show out of hearts dialog
    final remainingHearts = context.read<GameProgressProvider>().hearts;
    if (remainingHearts <= 0 && !isCorrect) {
      _showOutOfHeartsDialog();
    }
  }

  void _nextExercise() {
    if (_currentIndex + 1 < widget.lesson.exercises.length) {
      setState(() {
        _currentIndex++;
        _isChecked = false;
        _isCorrect = false;
        _correctAnswerText = '';
        _selectedMultipleChoice = null;
        _currentSentenceTokens = [];
        _matchingPairsCompleted = false;
        _selectedBlankWord = null;
        _speakingCompleted = false;
      });
    } else {
      // Lesson Complete!
      final totalExercises = widget.lesson.exercises.length;
      final accuracy = totalExercises > 0
          ? (((totalExercises - _mistakesCount) / totalExercises) * 100).clamp(0, 100).toInt()
          : 100;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LessonCompleteScreen(
            lesson: widget.lesson,
            accuracy: accuracy,
            xpEarned: widget.lesson.xpReward,
          ),
        ),
      );
    }
  }

  void _showOutOfHeartsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.heart_broken_rounded, color: AppColors.red, size: 28),
            SizedBox(width: 8),
            Text('Out of Hearts!', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        content: const Text(
          'You ran out of hearts. Practice in the Gym to earn them back or refill with gems in the shop!',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          Duo3DButton(
            text: 'REFILL (100 GEMS)',
            variant: DuoButtonVariant.gold,
            onPressed: () {
              final bought = context.read<GameProgressProvider>().buyHeartRefill();
              Navigator.pop(ctx);
              if (!bought) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Not enough gems! Practice to earn hearts.')),
                );
                Navigator.pop(context); // exit lesson
              }
            },
          ),
          const SizedBox(height: 10),
          Duo3DButton(
            text: 'QUIT LESSON',
            variant: DuoButtonVariant.neutral,
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmExit() async {
    final shouldQuit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Quit lesson?', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Are you sure? Any progress in this session will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('KEEP GOING', style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('END SESSION', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    return shouldQuit ?? false;
  }

  Widget _buildCurrentExerciseWidget() {
    final ex = _currentExercise;

    if (ex is MultipleChoiceExercise) {
      return MultipleChoiceWidget(
        key: ValueKey(ex.id),
        exercise: ex,
        selectedIndex: _selectedMultipleChoice,
        onSelect: (index) {
          if (_isChecked) return;
          setState(() => _selectedMultipleChoice = index);
          AudioFeedbackService.playClick();
        },
      );
    } else if (ex is SentenceBuilderExercise) {
      return SentenceBuilderWidget(
        key: ValueKey(ex.id),
        exercise: ex,
        onSequenceChanged: (tokens) {
          if (_isChecked) return;
          setState(() => _currentSentenceTokens = tokens);
          AudioFeedbackService.playClick();
        },
      );
    } else if (ex is MatchingPairExercise) {
      return MatchingPairsWidget(
        key: ValueKey(ex.id),
        exercise: ex,
        onAllMatched: () {
          setState(() => _matchingPairsCompleted = true);
          _checkAnswer();
        },
      );
    } else if (ex is FillInBlankExercise) {
      return FillInBlankWidget(
        key: ValueKey(ex.id),
        exercise: ex,
        selectedAnswer: _selectedBlankWord,
        onSelectAnswer: (word) {
          if (_isChecked) return;
          setState(() => _selectedBlankWord = word);
          AudioFeedbackService.playClick();
        },
      );
    } else if (ex is SpeakingExercise) {
      return SpeakingChallengeWidget(
        key: ValueKey(ex.id),
        exercise: ex,
        onSpeechEvaluated: (success) {
          setState(() => _speakingCompleted = success);
          if (success) {
            _checkAnswer();
          }
        },
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<GameProgressProvider>();
    final progressValue = (_currentIndex + 1) / widget.lesson.exercises.length;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final nav = Navigator.of(context);
        final shouldQuit = await _confirmExit();
        if (shouldQuit && mounted) {
          nav.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Top Lesson Bar: Close, Progress, Hearts
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 28, color: AppColors.textMuted),
                      onPressed: () async {
                        final nav = Navigator.of(context);
                        final shouldQuit = await _confirmExit();
                        if (shouldQuit && mounted) {
                          nav.pop();
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DuoProgressBar(
                        progress: progressValue,
                        height: 16,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Row(
                      children: [
                        const Icon(Icons.favorite_rounded, color: AppColors.red, size: 24),
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
                  ],
                ),
              ),

              // Animated Combo Streak Badge
              if (_consecutiveCorrect >= 2)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.orange, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: AppColors.orange, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '$_consecutiveCorrect IN A ROW! COMBO!',
                        style: const TextStyle(
                          color: AppColors.orangeDark,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),

              // Main Exercise Content
              Expanded(
                child: _buildCurrentExerciseWidget(),
              ),

              // Bottom Action Area
              if (_isChecked)
                FeedbackBottomSheet(
                  isCorrect: _isCorrect,
                  correctAnswerText: _correctAnswerText,
                  onContinue: _nextExercise,
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: AppColors.greyBorder, width: 2)),
                  ),
                  child: Duo3DButton(
                    text: 'CHECK',
                    variant: DuoButtonVariant.primary,
                    onPressed: _canCheckAnswer ? _checkAnswer : null,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
