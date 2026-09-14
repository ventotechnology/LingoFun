import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/exercise.dart';
import '../../../services/audio_feedback_service.dart';
import '../../../theme/app_colors.dart';

class MatchingPairsWidget extends StatefulWidget {
  final MatchingPairExercise exercise;
  final VoidCallback onAllMatched;

  const MatchingPairsWidget({
    super.key,
    required this.exercise,
    required this.onAllMatched,
  });

  @override
  State<MatchingPairsWidget> createState() => _MatchingPairsWidgetState();
}

class _MatchingPairsWidgetState extends State<MatchingPairsWidget> {
  late List<String> _leftItems;
  late List<String> _rightItems;

  String? _selectedLeft;
  String? _selectedRight;
  final Set<String> _matchedLefts = {};
  final Set<String> _matchedRights = {};

  bool _isChecking = false;
  bool _lastMatchWrong = false;

  @override
  void initState() {
    super.initState();
    _initPairs();
  }

  void _initPairs() {
    _leftItems = widget.exercise.pairs.keys.toList()..shuffle(Random());
    _rightItems = widget.exercise.pairs.values.toList()..shuffle(Random());
  }

  void _selectLeft(String item) {
    if (_matchedLefts.contains(item) || _isChecking) return;
    setState(() {
      _selectedLeft = item;
      _lastMatchWrong = false;
    });
    AudioFeedbackService.playClick();
    _checkPair();
  }

  void _selectRight(String item) {
    if (_matchedRights.contains(item) || _isChecking) return;
    setState(() {
      _selectedRight = item;
      _lastMatchWrong = false;
    });
    AudioFeedbackService.playClick();
    _checkPair();
  }

  void _checkPair() async {
    if (_selectedLeft == null || _selectedRight == null) return;

    final correctTarget = widget.exercise.pairs[_selectedLeft!];

    if (correctTarget == _selectedRight) {
      // MATCH!
      AudioFeedbackService.playSuccess();
      setState(() {
        _matchedLefts.add(_selectedLeft!);
        _matchedRights.add(_selectedRight!);
        _selectedLeft = null;
        _selectedRight = null;
      });

      // Check if all pairs are solved
      if (_matchedLefts.length == widget.exercise.pairs.length) {
        widget.onAllMatched();
      }
    } else {
      // MISMATCH!
      AudioFeedbackService.playError();
      setState(() {
        _isChecking = true;
        _lastMatchWrong = true;
      });

      await Future.delayed(const Duration(milliseconds: 600));

      if (mounted) {
        setState(() {
          _selectedLeft = null;
          _selectedRight = null;
          _isChecking = false;
          _lastMatchWrong = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            widget.exercise.prompt,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),

          // Two-Column Grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column
              Expanded(
                child: Column(
                  children: _leftItems.map((item) {
                    final isMatched = _matchedLefts.contains(item);
                    final isSelected = _selectedLeft == item;
                    final isWrong = isSelected && _lastMatchWrong;

                    return _buildTile(
                      text: item,
                      isMatched: isMatched,
                      isSelected: isSelected,
                      isWrong: isWrong,
                      onTap: () => _selectLeft(item),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 14),

              // Right Column
              Expanded(
                child: Column(
                  children: _rightItems.map((item) {
                    final isMatched = _matchedRights.contains(item);
                    final isSelected = _selectedRight == item;
                    final isWrong = isSelected && _lastMatchWrong;

                    return _buildTile(
                      text: item,
                      isMatched: isMatched,
                      isSelected: isSelected,
                      isWrong: isWrong,
                      onTap: () => _selectRight(item),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required String text,
    required bool isMatched,
    required bool isSelected,
    required bool isWrong,
    required VoidCallback onTap,
  }) {
    Color bgColor = Colors.white;
    Color borderColor = AppColors.greyBorder;
    Color shadowColor = AppColors.greyBorder;
    Color textColor = AppColors.textDark;

    if (isMatched) {
      bgColor = AppColors.greyLight;
      borderColor = AppColors.grey;
      shadowColor = Colors.transparent;
      textColor = AppColors.textSubtle;
    } else if (isWrong) {
      bgColor = AppColors.redBg;
      borderColor = AppColors.red;
      shadowColor = AppColors.redDark;
      textColor = AppColors.redText;
    } else if (isSelected) {
      bgColor = AppColors.blueBg;
      borderColor = AppColors.blue;
      shadowColor = AppColors.blueDark;
      textColor = AppColors.blueDark;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: isMatched ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 60,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2.2),
            boxShadow: shadowColor != Colors.transparent
                ? [
                    BoxShadow(
                      color: shadowColor,
                      offset: const Offset(0, 3),
                      blurRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              decoration: isMatched ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ),
    );
  }
}
