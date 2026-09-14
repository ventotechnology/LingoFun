import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum DuoButtonVariant {
  primary,
  secondary,
  danger,
  gold,
  purple,
  outline,
  neutral,
}

class Duo3DButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final DuoButtonVariant variant;
  final Widget? icon;
  final double? width;
  final double height;
  final double fontSize;
  final bool fullWidth;
  final bool isRound;

  const Duo3DButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = DuoButtonVariant.primary,
    this.icon,
    this.width,
    this.height = 50.0,
    this.fontSize = 16.0,
    this.fullWidth = true,
    this.isRound = false,
  });

  @override
  State<Duo3DButton> createState() => _Duo3DButtonState();
}

class _Duo3DButtonState extends State<Duo3DButton> {
  bool _isPressed = false;

  (Color topColor, Color bevelColor, Color textColor, Color? borderColor) _getColors() {
    if (widget.onPressed == null) {
      return (
        AppColors.grey,
        AppColors.greyDark,
        AppColors.textSubtle,
        null,
      );
    }

    switch (widget.variant) {
      case DuoButtonVariant.primary:
        return (
          AppColors.green,
          AppColors.greenDark,
          Colors.white,
          null,
        );
      case DuoButtonVariant.secondary:
        return (
          AppColors.blue,
          AppColors.blueDark,
          Colors.white,
          null,
        );
      case DuoButtonVariant.danger:
        return (
          AppColors.red,
          AppColors.redDark,
          Colors.white,
          null,
        );
      case DuoButtonVariant.gold:
        return (
          AppColors.yellow,
          AppColors.yellowDark,
          Colors.white,
          null,
        );
      case DuoButtonVariant.purple:
        return (
          AppColors.purple,
          AppColors.purpleDark,
          Colors.white,
          null,
        );
      case DuoButtonVariant.outline:
        return (
          Colors.white,
          AppColors.greyBorder,
          AppColors.blue,
          AppColors.greyBorder,
        );
      case DuoButtonVariant.neutral:
        return (
          Colors.white,
          AppColors.greyDark,
          AppColors.textDark,
          AppColors.greyBorder,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    const double bevelDepth = 4.0;
    final (topColor, bevelColor, textColor, borderColor) = _getColors();
    final bool isEnabled = widget.onPressed != null;

    final borderRadius = widget.isRound
        ? BorderRadius.circular(widget.height / 2)
        : BorderRadius.circular(16.0);

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      child: SizedBox(
        width: widget.fullWidth ? double.infinity : widget.width,
        height: widget.height + bevelDepth,
        child: Stack(
          children: [
            // 3D Bevel Shadow
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: bevelDepth,
              child: Container(
                decoration: BoxDecoration(
                  color: bevelColor,
                  borderRadius: borderRadius,
                  border: borderColor != null
                      ? Border.all(color: bevelColor, width: 2)
                      : null,
                ),
              ),
            ),
            // Front Face (slides down when pressed)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 60),
              curve: Curves.easeOut,
              left: 0,
              right: 0,
              top: _isPressed ? bevelDepth : 0,
              bottom: _isPressed ? 0 : bevelDepth,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: topColor,
                  borderRadius: borderRadius,
                  border: borderColor != null
                      ? Border.all(color: borderColor, width: 2)
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      widget.icon!,
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text.toUpperCase(),
                      style: TextStyle(
                        color: textColor,
                        fontSize: widget.fontSize,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
