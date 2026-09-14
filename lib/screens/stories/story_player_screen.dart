import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/story.dart';
import '../../providers/game_progress_provider.dart';
import '../../services/audio_feedback_service.dart';
import '../../services/curriculum_data.dart';
import '../../services/tts_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/duo_3d_button.dart';
import '../../widgets/duo_mascot.dart';
import '../../widgets/duo_progress_bar.dart';

class StoryPlayerScreen extends StatefulWidget {
  final Story story;

  const StoryPlayerScreen({
    super.key,
    required this.story,
  });

  @override
  State<StoryPlayerScreen> createState() => _StoryPlayerScreenState();
}

class _StoryPlayerScreenState extends State<StoryPlayerScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  int _revealedCount = 1;
  final Set<String> _revealedTranslations = {};

  // Checkpoint State
  int? _selectedOptionIndex;
  bool _checkpointSolved = true;
  bool _showErrorFeedback = false;

  // Completion State
  bool _isFinished = false;
  late AnimationController _confettiAnimController;

  @override
  void initState() {
    super.initState();
    _confettiAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _checkInitialCheckpoint();
    _playCurrentLineAudio();
  }

  @override
  void dispose() {
    _confettiAnimController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _checkInitialCheckpoint() {
    if (widget.story.lines.isNotEmpty) {
      final first = widget.story.lines[0];
      if (first.question != null) {
        _checkpointSolved = false;
      }
    }
  }

  void _playCurrentLineAudio() {
    if (_revealedCount <= 0 || _revealedCount > widget.story.lines.length) return;
    final currentLine = widget.story.lines[_revealedCount - 1];
    final course = CurriculumData.getCourse(widget.story.courseId);
    TtsService.speakText(currentLine.text, language: course.ttsLocale);
  }

  void _onContinuePressed() {
    if (!_checkpointSolved) return;

    if (_revealedCount < widget.story.lines.length) {
      setState(() {
        _revealedCount++;
        final nextLine = widget.story.lines[_revealedCount - 1];
        if (nextLine.question != null) {
          _checkpointSolved = false;
          _selectedOptionIndex = null;
          _showErrorFeedback = false;
        }
      });

      _playCurrentLineAudio();
      _scrollToBottom();
    } else {
      _finishStory();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _checkCheckpointAnswer() {
    if (_revealedCount <= 0) return;
    final currentLine = widget.story.lines[_revealedCount - 1];
    final question = currentLine.question;
    if (question == null || _selectedOptionIndex == null) return;

    if (_selectedOptionIndex == question.correctIndex) {
      AudioFeedbackService.playSuccess();
      setState(() {
        _checkpointSolved = true;
        _showErrorFeedback = false;
      });
      _scrollToBottom();
    } else {
      AudioFeedbackService.playError();
      setState(() {
        _showErrorFeedback = true;
      });
    }
  }

  void _finishStory() {
    AudioFeedbackService.playComplete();
    _confettiAnimController.forward(from: 0.0);
    setState(() {
      _isFinished = true;
    });
  }

  void _claimRewardsAndExit() {
    final provider = context.read<GameProgressProvider>();
    provider.completeStory(
      widget.story.id,
      widget.story.xpReward,
      widget.story.gemReward,
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) {
      return _buildCompletionView();
    }

    final totalLines = widget.story.lines.length;
    final progressVal = (_revealedCount / totalLines).clamp(0.0, 1.0);
    final activeLine = _revealedCount > 0 ? widget.story.lines[_revealedCount - 1] : null;
    final hasActiveQuestion = activeLine?.question != null && !_checkpointSolved;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textDark, size: 28),
          onPressed: () => _confirmExit(context),
        ),
        title: DuoProgressBar(progress: progressVal),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                widget.story.emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _revealedCount,
              itemBuilder: (ctx, index) {
                final line = widget.story.lines[index];
                final isCurrent = index == _revealedCount - 1;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStoryLineItem(line),
                    if (isCurrent && line.question != null && !_checkpointSolved)
                      _buildCheckpointWidget(line.question!),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.greyBorder, width: 2)),
            ),
            child: SafeArea(
              top: false,
              child: hasActiveQuestion
                  ? Duo3DButton(
                      text: 'CHECK ANSWER',
                      variant: DuoButtonVariant.primary,
                      height: 52,
                      onPressed: _selectedOptionIndex != null
                          ? _checkCheckpointAnswer
                          : null,
                    )
                  : Duo3DButton(
                      text: _revealedCount >= totalLines ? 'FINISH STORY' : 'CONTINUE',
                      variant: DuoButtonVariant.primary,
                      height: 52,
                      onPressed: _onContinuePressed,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryLineItem(StoryLine line) {
    final isNarrator = line.isNarrator;
    final isTranslationRevealed = _revealedTranslations.contains(line.id);
    final course = CurriculumData.getCourse(widget.story.courseId);

    if (isNarrator) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.greyBorder, width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.volume_up_rounded, color: AppColors.blue, size: 22),
              onPressed: () => TtsService.speakText(line.text, language: course.ttsLocale),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    line.translation,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final character = line.character!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Character Avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: character.themeColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(color: character.themeColor, width: 2),
            ),
            child: Center(
              child: Text(
                character.avatarEmoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Speech Bubble
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: character.themeColor,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isTranslationRevealed) {
                        _revealedTranslations.remove(line.id);
                      } else {
                        _revealedTranslations.add(line.id);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                      border: Border.all(color: AppColors.greyBorder, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.greyBorder.withValues(alpha: 0.4),
                          offset: const Offset(0, 3),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                line.text,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.volume_up_rounded, color: AppColors.blue, size: 22),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              onPressed: () => TtsService.speakText(line.text, language: course.ttsLocale),
                            ),
                          ],
                        ),
                        if (isTranslationRevealed) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              line.translation,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 4),
                          const Text(
                            'Tap to view translation',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.greyDark,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckpointWidget(CheckpointQuestion question) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _showErrorFeedback ? AppColors.red : AppColors.blue,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'CHECKPOINT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Check your understanding',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),

          ...List.generate(question.options.length, (optIndex) {
            final isSelected = _selectedOptionIndex == optIndex;
            final isCorrect = _checkpointSolved && isSelected;
            final isWrong = _showErrorFeedback && isSelected;

            Color borderColor = AppColors.greyBorder;
            Color bgColor = Colors.white;

            if (isCorrect) {
              borderColor = AppColors.green;
              bgColor = AppColors.greenBg;
            } else if (isWrong) {
              borderColor = AppColors.red;
              bgColor = AppColors.redBg;
            } else if (isSelected) {
              borderColor = AppColors.blue;
              bgColor = AppColors.blueBg;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedOptionIndex = optIndex;
                    _showErrorFeedback = false;
                  });
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? borderColor : Colors.white,
                          border: Border.all(
                            color: isSelected ? borderColor : AppColors.greyBorder,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${optIndex + 1}',
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textMuted,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          question.options[optIndex],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isWrong ? AppColors.red : AppColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          if (_showErrorFeedback)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: const [
                  Icon(Icons.info_outline_rounded, color: AppColors.red, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Not quite right, try another option!',
                    style: TextStyle(
                      color: AppColors.red,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompletionView() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Animated Confetti Canvas
          AnimatedBuilder(
            animation: _confettiAnimController,
            builder: (ctx, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: ConfettiBurstPainter(progress: _confettiAnimController.value),
              );
            },
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Big Animated Celebration Card
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: AppColors.yellow.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.yellow, width: 4),
                    ),
                    child: Center(
                      child: Text(
                        widget.story.emoji,
                        style: const TextStyle(fontSize: 54),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Story Complete!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You finished "${widget.story.title}"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Mascot Celebration
                  const DuoMascot(
                    mood: MascotMood.celebrating,
                    size: 130,
                  ),
                  const SizedBox(height: 32),

                  // Rewards Card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.greyBorder, width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildRewardBadge(
                          icon: Icons.bolt_rounded,
                          color: AppColors.yellow,
                          label: '+${widget.story.xpReward} XP',
                        ),
                        Container(width: 1, height: 40, color: AppColors.greyBorder),
                        _buildRewardBadge(
                          icon: Icons.diamond_rounded,
                          color: AppColors.blue,
                          label: '+${widget.story.gemReward} Gems',
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Duo3DButton(
                    text: 'CLAIM REWARDS',
                    variant: DuoButtonVariant.primary,
                    height: 54,
                    onPressed: _claimRewardsAndExit,
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

  Widget _buildRewardBadge({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  void _confirmExit(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Quit Story?', style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text(
          'Are you sure you want to quit? Your current reading progress in this story will not be saved.',
          style: TextStyle(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('KEEP READING', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('QUIT', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

class ConfettiBurstPainter extends CustomPainter {
  final double progress;
  static final List<_Particle> _particles = List.generate(60, (i) {
    final rand = Random(i * 19);
    return _Particle(
      xOffset: (rand.nextDouble() - 0.5) * 400,
      ySpeed: 200 + rand.nextDouble() * 500,
      rotationSpeed: (rand.nextDouble() - 0.5) * 10,
      size: 6 + rand.nextDouble() * 8,
      color: [
        AppColors.green,
        AppColors.blue,
        AppColors.yellow,
        AppColors.red,
        AppColors.purple,
        AppColors.orange,
      ][rand.nextInt(6)],
    );
  });

  ConfettiBurstPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0 || progress >= 1.0) return;

    final centerX = size.width / 2;
    final startY = size.height * 0.25;

    for (final p in _particles) {
      final paint = Paint()..color = p.color.withValues(alpha: (1.0 - progress).clamp(0.0, 1.0));
      final x = centerX + p.xOffset * progress;
      final y = startY + p.ySpeed * progress;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * p.rotationSpeed);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ConfettiBurstPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _Particle {
  final double xOffset;
  final double ySpeed;
  final double rotationSpeed;
  final double size;
  final Color color;

  _Particle({
    required this.xOffset,
    required this.ySpeed,
    required this.rotationSpeed,
    required this.size,
    required this.color,
  });
}
