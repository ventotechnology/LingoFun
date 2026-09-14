import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DuoProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double height;
  final Color fillColor;
  final Color fillDarkColor;
  final Color backgroundColor;

  const DuoProgressBar({
    super.key,
    required this.progress,
    this.height = 16.0,
    this.fillColor = AppColors.green,
    this.fillDarkColor = AppColors.greenDark,
    this.backgroundColor = AppColors.grey,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final targetWidth = constraints.maxWidth * clampedProgress;

          return Stack(
            children: [
              // Animated Fill Bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                width: targetWidth,
                height: height,
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(height / 2),
                  boxShadow: [
                    BoxShadow(
                      color: fillDarkColor,
                      offset: const Offset(0, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: targetWidth > 20
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.only(top: 2, left: 6, right: 6),
                          height: height * 0.28,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(height / 4),
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
