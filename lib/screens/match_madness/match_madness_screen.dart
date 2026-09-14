import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/exercise.dart';
import '../../providers/game_progress_provider.dart';
import '../../services/audio_feedback_service.dart';
import '../../services/curriculum_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/duo_3d_button.dart';
import '../../widgets/duo_mascot.dart';

class MatchMadnessScreen extends StatefulWidget {
  const MatchMadnessScreen({super.key});

  @override
  State<MatchMadnessScreen> createState() => _MatchMadnessScreenState();
}

class _MatchPairItem {
  final String id;
  final String text;
  final bool isLeft; // true = foreign term, false = english translation

  const _MatchPairItem({
    required this.id,
    required this.text,
    required this.isLeft,
  });
}

class _MatchMadnessScreenState extends State<MatchMadnessScreen>
    with SingleTickerProviderStateMixin {
  static const int _initialTimeSeconds = 60;
  int _secondsLeft = _initialTimeSeconds;
  Timer? _gameTimer;

  int _matchesCount = 0;
  int _combo = 1;
  int _maxCombo = 1;
  bool _isGameOver = false;

  // Selected item tracking
  _MatchPairItem? _selectedLeft;
  _MatchPairItem? _selectedRight;

  // Flash animation states
  String? _flashingCorrectId;
  String? _flashingIncorrectLeftText;
  String? _flashingIncorrectRightText;

  // Active slots (5 left, 5 right)
  final List<_MatchPairItem> _leftSlots = [];
  final List<_MatchPairItem> _rightSlots = [];

  // Vocabulary bank to replenish from
  final List<(String id, String foreign, String english)> _remainingBank = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeGame();
    });
  }

  void _initializeGame() {
    final progress = context.read<GameProgressProvider>();
    final courseId = progress.activeCourseId;

    // 1. Gather all pairs from course
    final pairsMap = <String, String>{};
    final units = CurriculumData.getUnitsForCourse(courseId);

    for (final unit in units) {
      for (final lesson in unit.lessons) {
        for (final ex in lesson.exercises) {
          if (ex is MatchingPairExercise) {
            pairsMap.addAll(ex.pairs);
          } else if (ex is MultipleChoiceExercise) {
            final cleanQuestion = ex.question.replaceAll(RegExp(r'[^\w\s\u00C0-\u017F\u3040-\u30FF\u4E00-\u9FAF]'), '').trim();
            final cleanOption = ex.options[ex.correctIndex].replaceAll(RegExp(r'[^\w\s\u00C0-\u017F\u3040-\u30FF\u4E00-\u9FAF]'), '').trim();
            if (cleanQuestion.isNotEmpty && cleanOption.isNotEmpty) {
              pairsMap[cleanQuestion] = cleanOption;
            }
          }
        }
      }
    }

    // Default backup vocabulary if course has few pairs
    final fallbackPairs = {
      'Hola': 'Hello',
      'El agua': 'Water',
      'El pan': 'Bread',
      'El gato': 'Cat',
      'El perro': 'Dog',
      'El café': 'Coffee',
      'Gracias': 'Thank you',
      'Buenos días': 'Good morning',
      'Por favor': 'Please',
      'El amigo': 'Friend',
      'La manzana': 'Apple',
      'La leche': 'Milk',
      'La casa': 'House',
      'El libro': 'Book',
      'Rojo': 'Red',
      'Verde': 'Green',
      'Azul': 'Blue',
      'Uno': 'One',
      'Dos': 'Two',
      'Tres': 'Three',
    };

    pairsMap.addAll(fallbackPairs);

    // Convert to list & shuffle
    int pairIdCounter = 0;
    _remainingBank.clear();
    pairsMap.forEach((k, v) {
      _remainingBank.add(('pair_${pairIdCounter++}', k, v));
    });
    _remainingBank.shuffle(Random());

    // 2. Populate initial 5 slots
    _leftSlots.clear();
    _rightSlots.clear();

    final initialPairs = <(String id, String foreign, String english)>[];
    while (initialPairs.length < 5 && _remainingBank.isNotEmpty) {
      initialPairs.add(_remainingBank.removeLast());
    }

    for (final p in initialPairs) {
      _leftSlots.add(_MatchPairItem(id: p.$1, text: p.$2, isLeft: true));
    }

    final shuffledRight = List<(String id, String foreign, String english)>.from(initialPairs)..shuffle();
    for (final p in shuffledRight) {
      _rightSlots.add(_MatchPairItem(id: p.$1, text: p.$3, isLeft: false));
    }

    setState(() {
      _secondsLeft = _initialTimeSeconds;
      _matchesCount = 0;
      _combo = 1;
      _maxCombo = 1;
      _isGameOver = false;
      _selectedLeft = null;
      _selectedRight = null;
      _flashingCorrectId = null;
      _flashingIncorrectLeftText = null;
      _flashingIncorrectRightText = null;
    });

    _startTimer();
  }

  void _startTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() {
          _secondsLeft = 0;
          _isGameOver = true;
        });
        _onGameCompleted();
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  void _onItemTapped(_MatchPairItem item) {
    if (_isGameOver || _flashingCorrectId != null) return;

    AudioFeedbackService.playClick();

    setState(() {
      if (item.isLeft) {
        _selectedLeft = (_selectedLeft?.text == item.text) ? null : item;
      } else {
        _selectedRight = (_selectedRight?.text == item.text) ? null : item;
      }
    });

    // Check if both sides selected
    if (_selectedLeft != null && _selectedRight != null) {
      _verifyMatch(_selectedLeft!, _selectedRight!);
    }
  }

  void _verifyMatch(_MatchPairItem left, _MatchPairItem right) {
    if (left.id == right.id) {
      // Correct match!
      final matchedId = left.id;
      final newCombo = _combo + 1;
      AudioFeedbackService.playMatchCombo(newCombo);

      setState(() {
        _matchesCount++;
        _combo = newCombo;
        if (_combo > _maxCombo) _maxCombo = _combo;
        _flashingCorrectId = matchedId;
      });

      // After brief green flash, replenish slot
      Future.delayed(const Duration(milliseconds: 220), () {
        if (!mounted) return;

        setState(() {
          _flashingCorrectId = null;
          _selectedLeft = null;
          _selectedRight = null;

          _leftSlots.removeWhere((item) => item.id == matchedId);
          _rightSlots.removeWhere((item) => item.id == matchedId);

          // Replenish from bank or reshuffle
          if (_remainingBank.isNotEmpty) {
            final next = _remainingBank.removeLast();
            _leftSlots.add(_MatchPairItem(id: next.$1, text: next.$2, isLeft: true));
            _rightSlots.add(_MatchPairItem(id: next.$1, text: next.$3, isLeft: false));
            _rightSlots.shuffle();
          }
        });
      });
    } else {
      // Incorrect match!
      AudioFeedbackService.playError();
      final leftText = left.text;
      final rightText = right.text;

      setState(() {
        _combo = 1; // Reset combo
        _flashingIncorrectLeftText = leftText;
        _flashingIncorrectRightText = rightText;
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        setState(() {
          _flashingIncorrectLeftText = null;
          _flashingIncorrectRightText = null;
          _selectedLeft = null;
          _selectedRight = null;
        });
      });
    }
  }

  void _onGameCompleted() {
    AudioFeedbackService.playComplete();

    // Calculate stars:
    // 10 matches = 1 star (+20 XP, 10 gems)
    // 20 matches = 2 stars (+40 XP, 20 gems)
    // 30 matches = 3 stars (+60 XP, 30 gems)
    int stars = 0;
    int xpEarned = 10;
    int gemsEarned = 5;

    if (_matchesCount >= 30) {
      stars = 3;
      xpEarned = 60;
      gemsEarned = 30;
    } else if (_matchesCount >= 20) {
      stars = 2;
      xpEarned = 40;
      gemsEarned = 20;
    } else if (_matchesCount >= 10) {
      stars = 1;
      xpEarned = 20;
      gemsEarned = 10;
    }

    final progress = context.read<GameProgressProvider>();
    progress.gainGems(gemsEarned);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _MatchMadnessResultDialog(
        matches: _matchesCount,
        maxCombo: _maxCombo,
        stars: stars,
        xpEarned: xpEarned,
        gemsEarned: gemsEarned,
        onPlayAgain: () {
          Navigator.pop(ctx);
          _initializeGame();
        },
        onDone: () {
          Navigator.pop(ctx);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerRatio = (_secondsLeft / _initialTimeSeconds).clamp(0.0, 1.0);
    final isUrgent = _secondsLeft <= 10;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('⚡', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            const Text(
              'Match Madness',
              style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.textDark),
            ),
            const Spacer(),
            // Live Matches Counter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.yellow.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.yellowDark, width: 1.5),
              ),
              child: Text(
                '$_matchesCount matches',
                style: const TextStyle(
                  color: AppColors.yellowDark,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textMuted, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // Timer & Combo Status Bar
              Row(
                children: [
                  Icon(
                    Icons.timer_rounded,
                    color: isUrgent ? AppColors.red : AppColors.blueDark,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: timerRatio,
                        minHeight: 12,
                        backgroundColor: AppColors.surface,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isUrgent ? AppColors.red : AppColors.blue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '0:${_secondsLeft.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: isUrgent ? AppColors.red : AppColors.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Combo Streak Banner
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _combo > 1
                        ? [const Color(0xFFFF9600), const Color(0xFFFF4B4B)]
                        : [AppColors.surface, AppColors.surface],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _combo > 1 ? const Color(0xFFCE7900) : AppColors.greyBorder,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _combo > 1 ? '🔥 $_combo x COMBO! 🔥' : 'Tap pairs to match!',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: _combo > 1 ? Colors.white : AppColors.textMuted,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 5 vs 5 Two-Column Matching Grid
              Expanded(
                child: Row(
                  children: [
                    // Left Column (Foreign Vocabulary)
                    Expanded(
                      child: Column(
                        children: List.generate(5, (index) {
                          if (index >= _leftSlots.length) {
                            return const Expanded(child: SizedBox());
                          }
                          final item = _leftSlots[index];
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: _buildMatchCard(item, isLeft: true),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Right Column (English Translations)
                    Expanded(
                      child: Column(
                        children: List.generate(5, (index) {
                          if (index >= _rightSlots.length) {
                            return const Expanded(child: SizedBox());
                          }
                          final item = _rightSlots[index];
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: _buildMatchCard(item, isLeft: false),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchCard(_MatchPairItem item, {required bool isLeft}) {
    final isSelected = isLeft
        ? _selectedLeft?.text == item.text
        : _selectedRight?.text == item.text;

    final isCorrect = _flashingCorrectId == item.id;
    final isIncorrect = isLeft
        ? _flashingIncorrectLeftText == item.text
        : _flashingIncorrectRightText == item.text;

    Color bgColor = Colors.white;
    Color borderColor = AppColors.greyBorder;
    Color shadowColor = AppColors.greyBorder;
    Color textColor = AppColors.textDark;

    if (isCorrect) {
      bgColor = AppColors.greenLight.withValues(alpha: 0.35);
      borderColor = AppColors.green;
      shadowColor = AppColors.greenDark;
      textColor = AppColors.greenDark;
    } else if (isIncorrect) {
      bgColor = AppColors.red.withValues(alpha: 0.15);
      borderColor = AppColors.red;
      shadowColor = AppColors.redDark;
      textColor = AppColors.redDark;
    } else if (isSelected) {
      bgColor = AppColors.blueBg;
      borderColor = AppColors.blue;
      shadowColor = AppColors.blueDark;
      textColor = AppColors.blueDark;
    }

    return GestureDetector(
      onTap: () => _onItemTapped(item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: isSelected ? 2.5 : 2),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: Offset(0, isSelected ? 1 : 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Text(
          item.text,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class _MatchMadnessResultDialog extends StatelessWidget {
  final int matches;
  final int maxCombo;
  final int stars;
  final int xpEarned;
  final int gemsEarned;
  final VoidCallback onPlayAgain;
  final VoidCallback onDone;

  const _MatchMadnessResultDialog({
    required this.matches,
    required this.maxCombo,
    required this.stars,
    required this.xpEarned,
    required this.gemsEarned,
    required this.onPlayAgain,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DuoMascot(
              size: 80,
              mood: MascotMood.celebrating,
            ),
            const SizedBox(height: 12),
            const Text(
              'TIME’S UP!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textDark,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),

            // Stars Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                final earned = i < stars;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    earned ? Icons.star_rounded : Icons.star_border_rounded,
                    color: earned ? const Color(0xFFFFD700) : AppColors.greyBorder,
                    size: 38,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // Stats Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.greyBorder, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ResultStat(label: 'MATCHES', value: '$matches', color: AppColors.blue),
                  _ResultStat(label: 'MAX COMBO', value: '${maxCombo}x', color: AppColors.orange),
                  _ResultStat(label: 'XP', value: '+$xpEarned', color: AppColors.yellowDark),
                  _ResultStat(label: 'GEMS', value: '+$gemsEarned', color: AppColors.blueDark),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Actions
            Row(
              children: [
                Expanded(
                  child: Duo3DButton(
                    text: 'DONE',
                    variant: DuoButtonVariant.neutral,
                    onPressed: onDone,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Duo3DButton(
                    text: 'REPLAY',
                    variant: DuoButtonVariant.primary,
                    onPressed: onPlayAgain,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ResultStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
