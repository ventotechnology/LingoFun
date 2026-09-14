import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_progress_provider.dart';
import '../theme/app_colors.dart';

enum MascotMood {
  happy,
  celebrating,
  thinking,
  crying,
}

/// Lingo the Cosmic Fluency Bird — LingoFun's Original Mascot 🦜✨
class LingoMascot extends StatefulWidget {
  final double size;
  final MascotMood mood;
  final String? speechBubbleText;
  final String? outfitId;

  const LingoMascot({
    super.key,
    this.size = 120,
    this.mood = MascotMood.happy,
    this.speechBubbleText,
    this.outfitId,
  });

  @override
  State<LingoMascot> createState() => _LingoMascotState();
}

class _LingoMascotState extends State<LingoMascot>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _wingAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _wingAnimation = Tween<double>(begin: -0.05, end: 0.15).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeInOut,
      ),
    );

    _animController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String currentOutfit = widget.outfitId ?? 'classic';
    if (widget.outfitId == null) {
      try {
        final progress = context.watch<GameProgressProvider>();
        currentOutfit = progress.equippedOutfitId;
      } catch (_) {}
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.speechBubbleText != null) ...[
          _buildSpeechBubble(),
          const SizedBox(height: 8),
        ],
        AnimatedBuilder(
          animation: _animController,
          builder: (ctx, child) {
            final bounceY = widget.mood == MascotMood.celebrating
                ? _bounceAnimation.value * 1.8
                : _bounceAnimation.value;
            final wingAngle = widget.mood == MascotMood.celebrating
                ? _wingAnimation.value * 2.5
                : _wingAnimation.value;

            return Transform.translate(
              offset: Offset(0, bounceY),
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: CustomPaint(
                  painter: _LingoBirdPainter(
                    mood: widget.mood,
                    outfitId: currentOutfit,
                    wingAngle: wingAngle,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSpeechBubble() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
        widget.speechBubbleText!,
        style: const TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
    );
  }
}

/// Backward compatibility alias
typedef DuoMascot = LingoMascot;

class _LingoBirdPainter extends CustomPainter {
  final MascotMood mood;
  final String outfitId;
  final double wingAngle;

  _LingoBirdPainter({
    required this.mood,
    required this.outfitId,
    required this.wingAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Palette for Lingo the Cosmic Fluency Bird
    const tealCyan = Color(0xFF00C4CC);
    const emerald = Color(0xFF00D26A);
    const crestGold = Color(0xFFFFB800);
    const amberBeak = Color(0xFFFF7A00);
    const purpleWing = Color(0xFF9B51E0);

    // 1. Feathery Tail
    final tailPath = Path();
    tailPath.moveTo(w * 0.35, h * 0.75);
    tailPath.quadraticBezierTo(w * 0.15, h * 0.85, w * 0.10, h * 0.95);
    tailPath.quadraticBezierTo(w * 0.25, h * 0.88, w * 0.35, h * 0.85);
    tailPath.quadraticBezierTo(w * 0.20, h * 0.98, w * 0.25, h * 1.0);
    tailPath.quadraticBezierTo(w * 0.35, h * 0.90, w * 0.45, h * 0.82);
    tailPath.close();

    final tailPaint = Paint()
      ..shader = const LinearGradient(
        colors: [tealCyan, purpleWing],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ).createShader(Rect.fromLTWH(w * 0.1, h * 0.7, w * 0.35, h * 0.3));
    canvas.drawPath(tailPath, tailPaint);

    // 2. Little Bird Feet
    final feetPaint = Paint()
      ..color = amberBeak
      ..strokeWidth = w * 0.05
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(w * 0.42, h * 0.85), Offset(w * 0.40, h * 0.95), feetPaint);
    canvas.drawLine(Offset(w * 0.40, h * 0.95), Offset(w * 0.35, h * 0.95), feetPaint);

    canvas.drawLine(Offset(w * 0.58, h * 0.85), Offset(w * 0.60, h * 0.95), feetPaint);
    canvas.drawLine(Offset(w * 0.60, h * 0.95), Offset(w * 0.65, h * 0.95), feetPaint);

    // 3. Body: Rounded energetic teardrop/egg
    final bodyRect = Rect.fromLTWH(w * 0.22, h * 0.22, w * 0.56, h * 0.64);
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [tealCyan, emerald],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bodyRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, Radius.circular(w * 0.26)),
      bodyPaint,
    );

    // 4. Belly Patch: Warm creamy yellow/white
    final bellyPaint = Paint()..color = const Color(0xFFFFFBEA);
    final bellyRect = Rect.fromLTWH(w * 0.34, h * 0.48, w * 0.32, h * 0.34);
    canvas.drawOval(bellyRect, bellyPaint);

    // 5. Golden Feather Crest on Head
    final crestPaint = Paint()..color = crestGold;
    final crestPath = Path();
    crestPath.moveTo(w * 0.44, h * 0.22);
    crestPath.quadraticBezierTo(w * 0.40, h * 0.08, w * 0.48, h * 0.06);
    crestPath.quadraticBezierTo(w * 0.52, h * 0.12, w * 0.50, h * 0.22);

    crestPath.moveTo(w * 0.48, h * 0.22);
    crestPath.quadraticBezierTo(w * 0.52, h * 0.04, w * 0.60, h * 0.05);
    crestPath.quadraticBezierTo(w * 0.58, h * 0.14, w * 0.54, h * 0.22);

    crestPath.moveTo(w * 0.52, h * 0.22);
    crestPath.quadraticBezierTo(w * 0.62, h * 0.09, w * 0.68, h * 0.12);
    crestPath.quadraticBezierTo(w * 0.64, h * 0.18, w * 0.58, h * 0.22);
    canvas.drawPath(crestPath, crestPaint);

    // 6. Dynamic Wings
    canvas.save();
    canvas.translate(w * 0.24, h * 0.52);
    canvas.rotate(-wingAngle);
    final leftWingPath = Path();
    leftWingPath.moveTo(0, 0);
    leftWingPath.quadraticBezierTo(-w * 0.18, h * 0.10, -w * 0.15, h * 0.28);
    leftWingPath.quadraticBezierTo(0, h * 0.24, w * 0.06, h * 0.10);
    leftWingPath.close();

    final leftWingPaint = Paint()
      ..shader = const LinearGradient(
        colors: [emerald, purpleWing],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(-w * 0.18, 0, w * 0.25, h * 0.3));
    canvas.drawPath(leftWingPath, leftWingPaint);
    canvas.restore();

    // Right Wing
    canvas.save();
    canvas.translate(w * 0.76, h * 0.52);
    canvas.rotate(wingAngle);
    final rightWingPath = Path();
    rightWingPath.moveTo(0, 0);
    rightWingPath.quadraticBezierTo(w * 0.18, h * 0.10, w * 0.15, h * 0.28);
    rightWingPath.quadraticBezierTo(0, h * 0.24, -w * 0.06, h * 0.10);
    rightWingPath.close();

    final rightWingPaint = Paint()
      ..shader = const LinearGradient(
        colors: [emerald, purpleWing],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w * 0.25, h * 0.3));
    canvas.drawPath(rightWingPath, rightWingPaint);
    canvas.restore();

    // 7. Expressive Anime Eyes
    _drawEyes(canvas, w, h);

    // 8. Curved Golden-Amber Beak
    final beakPaint = Paint()..color = amberBeak;
    final beakPath = Path();
    beakPath.moveTo(w * 0.44, h * 0.42);
    beakPath.quadraticBezierTo(w * 0.50, h * 0.38, w * 0.56, h * 0.42);
    beakPath.quadraticBezierTo(w * 0.52, h * 0.56, w * 0.50, h * 0.58);
    beakPath.quadraticBezierTo(w * 0.48, h * 0.56, w * 0.44, h * 0.42);
    beakPath.close();
    canvas.drawPath(beakPath, beakPaint);

    // Beak shine
    final beakShine = Paint()..color = Colors.white.withValues(alpha: 0.6);
    canvas.drawCircle(Offset(w * 0.50, h * 0.43), w * 0.02, beakShine);

    // 9. Rosy Cheeks
    if (mood == MascotMood.happy || mood == MascotMood.celebrating) {
      final blushPaint = Paint()..color = const Color(0xFFFF758F).withValues(alpha: 0.45);
      canvas.drawCircle(Offset(w * 0.31, h * 0.46), w * 0.05, blushPaint);
      canvas.drawCircle(Offset(w * 0.69, h * 0.46), w * 0.05, blushPaint);
    }

    // 10. Outfits
    _drawOutfit(canvas, w, h);
  }

  void _drawEyes(Canvas canvas, double w, double h) {
    final eyeWhite = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = const Color(0xFF1E293B);
    final sparkPaint = Paint()..color = Colors.white;

    if (mood == MascotMood.celebrating) {
      // Joyful arcs
      final arcPaint = Paint()
        ..color = const Color(0xFF1E293B)
        ..strokeWidth = w * 0.04
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawArc(Rect.fromLTWH(w * 0.31, h * 0.34, w * 0.12, w * 0.08), math.pi, math.pi, false, arcPaint);
      canvas.drawArc(Rect.fromLTWH(w * 0.57, h * 0.34, w * 0.12, w * 0.08), math.pi, math.pi, false, arcPaint);
      return;
    }

    if (mood == MascotMood.crying) {
      // Sad eyes & tear
      final sadPaint = Paint()
        ..color = const Color(0xFF1E293B)
        ..strokeWidth = w * 0.04
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawArc(Rect.fromLTWH(w * 0.31, h * 0.36, w * 0.12, w * 0.08), 0, math.pi, false, sadPaint);
      canvas.drawArc(Rect.fromLTWH(w * 0.57, h * 0.36, w * 0.12, w * 0.08), 0, math.pi, false, sadPaint);

      final tearPaint = Paint()..color = const Color(0xFF38BDF8);
      canvas.drawOval(Rect.fromLTWH(w * 0.33, h * 0.48, w * 0.06, w * 0.10), tearPaint);
      return;
    }

    // Big anime friendly eyes
    canvas.drawOval(Rect.fromLTWH(w * 0.30, h * 0.30, w * 0.15, w * 0.18), eyeWhite);
    canvas.drawOval(Rect.fromLTWH(w * 0.55, h * 0.30, w * 0.15, w * 0.18), eyeWhite);

    // Pupils
    canvas.drawOval(Rect.fromLTWH(w * 0.34, h * 0.32, w * 0.10, w * 0.13), pupilPaint);
    canvas.drawOval(Rect.fromLTWH(w * 0.56, h * 0.32, w * 0.10, w * 0.13), pupilPaint);

    // Star sparkle reflection
    canvas.drawCircle(Offset(w * 0.37, h * 0.35), w * 0.035, sparkPaint);
    canvas.drawCircle(Offset(w * 0.40, h * 0.40), w * 0.018, sparkPaint);

    canvas.drawCircle(Offset(w * 0.59, h * 0.35), w * 0.035, sparkPaint);
    canvas.drawCircle(Offset(w * 0.62, h * 0.40), w * 0.018, sparkPaint);
  }

  void _drawOutfit(Canvas canvas, double w, double h) {
    if (outfitId == 'beret') {
      final beretPaint = Paint()..color = const Color(0xFFEF4444);
      canvas.drawOval(Rect.fromLTWH(w * 0.36, h * 0.14, w * 0.30, h * 0.12), beretPaint);
      canvas.drawCircle(Offset(w * 0.50, h * 0.14), w * 0.02, beretPaint);
    } else if (outfitId == 'samurai') {
      final helmPaint = Paint()..color = const Color(0xFF0F172A);
      canvas.drawArc(Rect.fromLTWH(w * 0.32, h * 0.16, w * 0.36, h * 0.14), math.pi, math.pi, true, helmPaint);
      final crestPaint = Paint()..color = const Color(0xFFFFB800);
      canvas.drawCircle(Offset(w * 0.50, h * 0.17), w * 0.03, crestPaint);
    } else if (outfitId == 'gold') {
      final crownPaint = Paint()..color = const Color(0xFFFFD700);
      final crownPath = Path();
      crownPath.moveTo(w * 0.36, h * 0.20);
      crownPath.lineTo(w * 0.32, h * 0.10);
      crownPath.lineTo(w * 0.43, h * 0.15);
      crownPath.lineTo(w * 0.50, h * 0.06);
      crownPath.lineTo(w * 0.57, h * 0.15);
      crownPath.lineTo(w * 0.68, h * 0.10);
      crownPath.lineTo(w * 0.64, h * 0.20);
      crownPath.close();
      canvas.drawPath(crownPath, crownPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LingoBirdPainter oldDelegate) =>
      oldDelegate.mood != mood ||
      oldDelegate.outfitId != outfitId ||
      oldDelegate.wingAngle != wingAngle;
}
