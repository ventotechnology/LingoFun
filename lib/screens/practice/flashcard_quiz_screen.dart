import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../theme/app_colors.dart';
import '../../widgets/duo_3d_button.dart';
import '../../services/audio_feedback_service.dart';
import '../../services/tts_service.dart';
import '../../services/curriculum_data.dart';
import '../../models/exercise.dart';
import '../../providers/game_progress_provider.dart';

class Flashcard {
  final String front;
  final String back;
  final String ttsLocale;

  Flashcard({required this.front, required this.back, required this.ttsLocale});
}

class FlashcardQuizScreen extends StatefulWidget {
  const FlashcardQuizScreen({super.key});

  @override
  State<FlashcardQuizScreen> createState() => _FlashcardQuizScreenState();
}

class _FlashcardQuizScreenState extends State<FlashcardQuizScreen> with SingleTickerProviderStateMixin {
  bool _isLevelSelected = false;
  String _selectedLevelTitle = '';
  int _targetUnitPlacement = 0;
  
  List<Flashcard> _deck = [];
  int _currentIndex = 0;
  bool _isFlipped = false;
  int _knownCount = 0;
  late AnimationController _flipController;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _startQuizForLevel(String levelTitle, int startUnit, int endUnit, int targetPlacement) {
    final provider = context.read<GameProgressProvider>();
    final activeCourseId = provider.activeCourseId;
    final course = CurriculumData.getCourse(activeCourseId);
    
    List<Flashcard> generatedDeck = [];
    
    for (var unit in course.units) {
      if (unit.unitNumber >= startUnit && unit.unitNumber <= endUnit) {
        for (var lesson in unit.lessons) {
          for (var ex in lesson.exercises) {
            if (ex is MatchingPairExercise) {
              ex.pairs.forEach((key, value) {
                if (activeCourseId == 'bangla_to_english') {
                  generatedDeck.add(Flashcard(front: key, back: value, ttsLocale: course.ttsLocale));
                } else {
                  generatedDeck.add(Flashcard(front: value, back: key, ttsLocale: course.ttsLocale));
                }
              });
            }
          }
        }
      }
    }
    
    if (generatedDeck.isEmpty) {
      generatedDeck = [
        Flashcard(front: 'No words found', back: 'Try another level', ttsLocale: course.ttsLocale),
      ];
    }
    
    generatedDeck.shuffle();
    // Cap at 20 cards for advanced practice
    if (generatedDeck.length > 20) {
      generatedDeck = generatedDeck.sublist(0, 20);
    }
    
    setState(() {
      _selectedLevelTitle = levelTitle;
      _targetUnitPlacement = targetPlacement;
      _deck = generatedDeck;
      _currentIndex = 0;
      _knownCount = 0;
      _isFlipped = false;
      _isLevelSelected = true;
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
      TtsService.speakText(_deck[_currentIndex].back);
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  void _nextCard(bool knewIt) {
    if (knewIt) {
      _knownCount++;
      AudioFeedbackService.playSuccess();
    } else {
      AudioFeedbackService.playError();
    }

    if (_currentIndex < _deck.length) {
      setState(() {
        _isFlipped = false;
        _flipController.reset();
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLevelSelected) {
      return _buildLevelSelector();
    }

    final bool isFinished = _currentIndex >= _deck.length;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(_selectedLevelTitle, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: isFinished ? 1.0 : _currentIndex / _deck.length,
            backgroundColor: AppColors.greyBorder,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.green),
            minHeight: 4,
          ),
        ),
      ),
      body: isFinished ? _buildResults() : _buildQuiz(),
    );
  }

  Widget _buildLevelSelector() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Select Difficulty', style: TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'How far do you want to learn?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          const Text(
            'Practice vocabulary from beginner all the way to advanced C2 mastery.',
            style: TextStyle(fontSize: 16, color: AppColors.textMuted, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          _buildLevelCard('Beginner (A1)', 'Basic words & greetings', AppColors.green, 1, 4, 4),
          _buildLevelCard('Elementary (A2)', 'Everyday conversations', AppColors.blue, 5, 8, 8),
          _buildLevelCard('Intermediate (B1)', 'Travel & work vocabulary', AppColors.orange, 9, 12, 12),
          _buildLevelCard('Upper Int. (B2)', 'Complex arguments & news', AppColors.purple, 13, 16, 16),
          _buildLevelCard('Advanced (C1)', 'Professional & academic', AppColors.red, 17, 19, 19),
          _buildLevelCard('Mastery (C2)', 'Native-level fluency', AppColors.yellowDark, 20, 20, 20),
        ],
      ),
    );
  }

  Widget _buildLevelCard(String title, String subtitle, Color color, int startUnit, int endUnit, int targetPlacement) {
    return GestureDetector(
      onTap: () => _startQuizForLevel(title, startUnit, endUnit, targetPlacement),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.school_rounded, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark.withValues(alpha: 0.7)),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuiz() {
    if (_deck.isEmpty) return const SizedBox();
    
    final currentCard = _deck[_currentIndex];
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Text(
            'Tap card to flip',
            style: TextStyle(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GestureDetector(
              onTap: _flipCard,
              child: AnimatedBuilder(
                animation: _flipController,
                builder: (context, child) {
                  final angle = _flipController.value * math.pi;
                  final isBackVisible = angle >= math.pi / 2;
                  
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    alignment: Alignment.center,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.greyBorder, width: 3),
                        boxShadow: const [
                          BoxShadow(color: AppColors.greyBorder, offset: Offset(0, 8)),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: isBackVisible
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateY(math.pi),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  currentCard.back,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                currentCard.front,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 32),
          AnimatedOpacity(
            opacity: _isFlipped ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !_isFlipped,
              child: Row(
                children: [
                  Expanded(
                    child: Duo3DButton(
                      text: 'NEED PRACTICE',
                      variant: DuoButtonVariant.danger,
                      onPressed: () => _nextCard(false),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Duo3DButton(
                      text: 'GOT IT',
                      variant: DuoButtonVariant.primary,
                      onPressed: () => _nextCard(true),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildResults() {
    double accuracy = _knownCount / _deck.length;
    
    bool passed = accuracy >= 0.7;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(passed ? Icons.emoji_events_rounded : Icons.local_fire_department_rounded, 
                 size: 80, 
                 color: passed ? AppColors.yellowDark : AppColors.orange),
            const SizedBox(height: 24),
            Text(
              passed ? 'Level Mastered!' : 'Keep Practicing!',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You knew $_knownCount out of ${_deck.length} words.',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 32),
            if (passed)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.greenLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.green, width: 2),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Milestone Unlocked:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.greenDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Unit $_targetUnitPlacement',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.green,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: Duo3DButton(
                text: passed ? 'SKIP TO UNIT $_targetUnitPlacement' : 'CONTINUE',
                variant: passed ? DuoButtonVariant.primary : DuoButtonVariant.neutral,
                onPressed: () {
                  if (passed) {
                    context.read<GameProgressProvider>().skipAheadToUnit(_targetUnitPlacement - 1);
                  }
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
