import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../models/exercise.dart';
import '../../../services/audio_feedback_service.dart';
import '../../../services/tts_service.dart';
import '../../../theme/app_colors.dart';

class SpeakingChallengeWidget extends StatefulWidget {
  final SpeakingExercise exercise;
  final ValueChanged<bool> onSpeechEvaluated;
  final VoidCallback? onCantSpeakNow;

  const SpeakingChallengeWidget({
    super.key,
    required this.exercise,
    required this.onSpeechEvaluated,
    this.onCantSpeakNow,
  });

  @override
  State<SpeakingChallengeWidget> createState() => _SpeakingChallengeWidgetState();
}

class _SpeakingChallengeWidgetState extends State<SpeakingChallengeWidget>
    with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  bool _isCompleted = false;
  late AnimationController _waveController;

  final Set<int> _spokenWordIndices = {};

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _startSpeakingSimulation() {
    setState(() {
      _isRecording = true;
      _spokenWordIndices.clear();
    });

    AudioFeedbackService.playClick();

    // Simulate real-time word-by-word speech recognition
    final words = widget.exercise.targetWords;
    for (var i = 0; i < words.length; i++) {
      Future.delayed(Duration(milliseconds: 450 * (i + 1)), () {
        if (!mounted || !_isRecording) return;
        setState(() {
          _spokenWordIndices.add(i);
        });

        if (_spokenWordIndices.length == words.length) {
          _finishSpeaking(true);
        }
      });
    }
  }

  void _finishSpeaking(bool success) {
    setState(() {
      _isRecording = false;
      _isCompleted = success;
    });

    if (success) {
      AudioFeedbackService.playSuccess();
    }
    widget.onSpeechEvaluated(success);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Prompt & Speaker Audio
        Row(
          children: [
            IconButton(
              iconSize: 36,
              icon: const Icon(Icons.volume_up_rounded, color: AppColors.blue),
              onPressed: () {
                TtsService.speakText(widget.exercise.speakerText ?? widget.exercise.targetPhrase);
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.exercise.prompt,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Target Phrase Container
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.greyBorder, width: 2),
            boxShadow: const [
              BoxShadow(
                color: AppColors.greyBorder,
                offset: Offset(0, 3),
                blurRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: List.generate(widget.exercise.targetWords.length, (i) {
                  final isSpoken = _spokenWordIndices.contains(i);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSpoken
                          ? AppColors.greenLight.withValues(alpha: 0.3)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSpoken ? AppColors.green : AppColors.greyBorder,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      widget.exercise.targetWords[i],
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: isSpoken ? AppColors.greenDark : AppColors.textDark,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 14),
              Text(
                widget.exercise.translation,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Animated Audio Waveform (Visible during recording)
        if (_isRecording) ...[
          AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(7, (i) {
                  final phase = (i * 0.4);
                  final height = 12.0 + 32.0 * math.sin((_waveController.value * math.pi) + phase).abs();
                  return Container(
                    width: 6,
                    height: height,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Listening to your voice...',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.blueDark,
            ),
          ),
        ] else if (_isCompleted) ...[
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded, color: AppColors.green, size: 24),
              SizedBox(width: 8),
              Text(
                'Great pronunciation! Spot on!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.greenDark,
                ),
              ),
            ],
          ),
        ] else ...[
          const Text(
            'Tap microphone and read out loud',
            style: TextStyle(fontSize: 14, color: AppColors.textMuted, fontWeight: FontWeight.w600),
          ),
        ],

        const SizedBox(height: 20),

        // Big Tactile Microphone Button
        GestureDetector(
          onTap: _isRecording ? null : _startSpeakingSimulation,
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isRecording
                  ? AppColors.red
                  : (_isCompleted ? AppColors.green : AppColors.blue),
              boxShadow: [
                BoxShadow(
                  color: _isRecording
                      ? AppColors.redDark
                      : (_isCompleted ? AppColors.greenDark : AppColors.blueDark),
                  offset: const Offset(0, 5),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Icon(
              _isRecording ? Icons.graphic_eq_rounded : Icons.mic_rounded,
              color: Colors.white,
              size: 42,
            ),
          ),
        ),

        const Spacer(),

        // "Can't speak now" toggle
        TextButton(
          onPressed: widget.onCantSpeakNow ?? () => widget.onSpeechEvaluated(true),
          child: const Text(
            "CAN'T SPEAK RIGHT NOW",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: AppColors.textMuted,
              letterSpacing: 0.8,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
