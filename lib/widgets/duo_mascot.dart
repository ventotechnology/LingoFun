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

class DuoMascot extends StatefulWidget {
  final double size;
  final MascotMood mood;
  final String? speechBubbleText;
  final String? outfitId; // If null, reads from GameProgressProvider if available

  const DuoMascot({
    super.key,
    this.size = 120,
    this.mood = MascotMood.happy,
    this.speechBubbleText,
    this.outfitId,
  });

  @override
  State<DuoMascot> createState() => _DuoMascotState();
}

class _DuoMascotState extends State<DuoMascot>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String effectiveOutfit = widget.outfitId ?? 'classic';
    if (widget.outfitId == null) {
      try {
        final provider = context.watch<GameProgressProvider>();
        effectiveOutfit = provider.equippedOutfitId;
      } catch (_) {
        // Fallback if rendered outside provider tree
      }
    }

    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            widget.mood == MascotMood.celebrating
                ? _bounceAnimation.value * 1.5
                : _bounceAnimation.value,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.speechBubbleText != null) ...[
                _buildSpeechBubble(),
                const SizedBox(height: 8),
              ],
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CustomPaint(
                  painter: _MascotPainter(
                    mood: widget.mood,
                    outfitId: effectiveOutfit,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpeechBubble() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _MascotPainter extends CustomPainter {
  final MascotMood mood;
  final String outfitId;

  _MascotPainter({
    required this.mood,
    required this.outfitId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Body Paint (Vibrant Duolingo Green)
    final bodyPaint = Paint()
      ..color = AppColors.green
      ..style = PaintingStyle.fill;

    // Body Shadow/Bevel (Dark Green)
    final shadowPaint = Paint()
      ..color = AppColors.greenDark
      ..style = PaintingStyle.fill;

    // Orange Beak / Feet Paint
    final orangePaint = Paint()
      ..color = AppColors.orange
      ..style = PaintingStyle.fill;

    // White Paint (Eyes, Belly)
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Dark Pupil Paint
    final darkPaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..style = PaintingStyle.fill;

    // 1. Feet
    final leftFoot = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.38, h * 0.95), width: w * 0.22, height: h * 0.12),
      const Radius.circular(8),
    );
    final rightFoot = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.62, h * 0.95), width: w * 0.22, height: h * 0.12),
      const Radius.circular(8),
    );
    canvas.drawRRect(leftFoot, orangePaint);
    canvas.drawRRect(rightFoot, orangePaint);

    // 2. Body (Chubby Oval)
    final bodyRect = Rect.fromCenter(center: Offset(w * 0.5, h * 0.52), width: w * 0.78, height: h * 0.82);
    final bodyShadowRect = Rect.fromCenter(center: Offset(w * 0.5, h * 0.54), width: w * 0.78, height: h * 0.82);
    canvas.drawOval(bodyShadowRect, shadowPaint);
    canvas.drawOval(bodyRect, bodyPaint);

    // 3. Belly (Light Green Patch)
    final bellyPaint = Paint()
      ..color = AppColors.greenLight
      ..style = PaintingStyle.fill;
    final bellyRect = Rect.fromCenter(center: Offset(w * 0.5, h * 0.68), width: w * 0.46, height: h * 0.42);
    canvas.drawOval(bellyRect, bellyPaint);

    // Feathers on belly (little chevron arches)
    final featherPaint = Paint()
      ..color = AppColors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path1 = Path()
      ..moveTo(w * 0.43, h * 0.66)
      ..quadraticBezierTo(w * 0.47, h * 0.69, w * 0.51, h * 0.66);
    final path2 = Path()
      ..moveTo(w * 0.53, h * 0.66)
      ..quadraticBezierTo(w * 0.57, h * 0.69, w * 0.61, h * 0.66);
    final path3 = Path()
      ..moveTo(w * 0.48, h * 0.74)
      ..quadraticBezierTo(w * 0.52, h * 0.77, w * 0.56, h * 0.74);
    canvas.drawPath(path1, featherPaint);
    canvas.drawPath(path2, featherPaint);
    canvas.drawPath(path3, featherPaint);

    // 4. Wings
    final leftWingRect = Rect.fromCenter(
      center: Offset(mood == MascotMood.celebrating ? w * 0.16 : w * 0.14, mood == MascotMood.celebrating ? h * 0.42 : h * 0.55),
      width: w * 0.22,
      height: h * 0.38,
    );
    final rightWingRect = Rect.fromCenter(
      center: Offset(mood == MascotMood.celebrating ? w * 0.84 : w * 0.86, mood == MascotMood.celebrating ? h * 0.42 : h * 0.55),
      width: w * 0.22,
      height: h * 0.38,
    );
    canvas.drawOval(leftWingRect, shadowPaint);
    canvas.drawOval(leftWingRect, bodyPaint);
    canvas.drawOval(rightWingRect, shadowPaint);
    canvas.drawOval(rightWingRect, bodyPaint);

    // 5. Big Expressive Eyes
    final leftEyeCenter = Offset(w * 0.36, h * 0.40);
    final rightEyeCenter = Offset(w * 0.64, h * 0.40);
    final eyeRadius = w * 0.16;

    // Eye whites
    canvas.drawCircle(leftEyeCenter, eyeRadius, whitePaint);
    canvas.drawCircle(rightEyeCenter, eyeRadius, whitePaint);

    if (mood == MascotMood.crying) {
      // Sad squinting eyes
      final sadEyePaint = Paint()
        ..color = const Color(0xFF2C3E50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round;

      final sadLeft = Path()
        ..moveTo(leftEyeCenter.dx - eyeRadius * 0.6, leftEyeCenter.dy)
        ..quadraticBezierTo(leftEyeCenter.dx, leftEyeCenter.dy - eyeRadius * 0.5, leftEyeCenter.dx + eyeRadius * 0.6, leftEyeCenter.dy);
      final sadRight = Path()
        ..moveTo(rightEyeCenter.dx - eyeRadius * 0.6, rightEyeCenter.dy)
        ..quadraticBezierTo(rightEyeCenter.dx, rightEyeCenter.dy - eyeRadius * 0.5, rightEyeCenter.dx + eyeRadius * 0.6, rightEyeCenter.dy);

      canvas.drawPath(sadLeft, sadEyePaint);
      canvas.drawPath(sadRight, sadEyePaint);

      // Tear drop
      final tearPaint = Paint()..color = AppColors.blue;
      canvas.drawCircle(Offset(leftEyeCenter.dx - 4, leftEyeCenter.dy + 16), 4, tearPaint);
      canvas.drawCircle(Offset(rightEyeCenter.dx + 4, rightEyeCenter.dy + 16), 4, tearPaint);
    } else {
      // Pupils
      final pupilShiftX = mood == MascotMood.thinking ? 4.0 : 0.0;
      final pupilShiftY = mood == MascotMood.celebrating ? -2.0 : 1.0;
      final pupilRadius = eyeRadius * 0.55;

      canvas.drawCircle(
        Offset(leftEyeCenter.dx + pupilShiftX, leftEyeCenter.dy + pupilShiftY),
        pupilRadius,
        darkPaint,
      );
      canvas.drawCircle(
        Offset(rightEyeCenter.dx + pupilShiftX, rightEyeCenter.dy + pupilShiftY),
        pupilRadius,
        darkPaint,
      );

      // Cute white catchlights
      canvas.drawCircle(
        Offset(leftEyeCenter.dx + pupilShiftX - 3, leftEyeCenter.dy + pupilShiftY - 3),
        pupilRadius * 0.38,
        whitePaint,
      );
      canvas.drawCircle(
        Offset(rightEyeCenter.dx + pupilShiftX - 3, rightEyeCenter.dy + pupilShiftY - 3),
        pupilRadius * 0.38,
        whitePaint,
      );
    }

    // 6. Cute Beak (Triangle)
    final beakPath = Path();
    beakPath.moveTo(w * 0.43, h * 0.44);
    beakPath.lineTo(w * 0.57, h * 0.44);
    beakPath.lineTo(w * 0.50, h * 0.53);
    beakPath.close();

    canvas.drawPath(beakPath, orangePaint);

    // 7. Dynamic Outfits & Accessories Layer
    _drawOutfit(canvas, size, w, h);
  }

  void _drawOutfit(Canvas canvas, Size size, double w, double h) {
    switch (outfitId) {
      case 'beret':
        _drawBeret(canvas, w, h);
        break;
      case 'samurai':
        _drawSamuraiHeadband(canvas, w, h);
        break;
      case 'coder':
        _drawCoderGear(canvas, w, h);
        break;
      case 'crown':
        _drawCrown(canvas, w, h);
        break;
      case 'classic':
      default:
        // No extra headwear
        break;
    }
  }

  void _drawBeret(Canvas canvas, double w, double h) {
    canvas.save();
    // Tilt the beret to the right
    canvas.translate(w * 0.54, h * 0.16);
    canvas.rotate(0.18);

    // Shadow
    final beretShadowPaint = Paint()..color = const Color(0xFFB71C1C);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 4), width: w * 0.68, height: h * 0.22),
      beretShadowPaint,
    );

    // Beret Main Cap
    final beretPaint = Paint()..color = const Color(0xFFE53935);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: w * 0.68, height: h * 0.22),
      beretPaint,
    );

    // Top stem / stalk
    final stemPaint = Paint()
      ..color = const Color(0xFFB71C1C)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final stemPath = Path()
      ..moveTo(0, -h * 0.11)
      ..quadraticBezierTo(4, -h * 0.15, 6, -h * 0.17);
    canvas.drawPath(stemPath, stemPaint);

    // Artist Paint Brush peeking behind
    final brushHandlePaint = Paint()
      ..color = const Color(0xFF8D6E63)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.25, -h * 0.05), Offset(w * 0.40, -h * 0.20), brushHandlePaint);

    // Brush tip
    final tipPaint = Paint()..color = AppColors.blue;
    canvas.drawCircle(Offset(w * 0.40, -h * 0.20), 4, tipPaint);

    canvas.restore();
  }

  void _drawSamuraiHeadband(Canvas canvas, double w, double h) {
    // White Hachimaki band across forehead
    final bandPaint = Paint()..color = Colors.white;
    final bandShadowPaint = Paint()..color = const Color(0xFFB0BEC5);

    final bandRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.24), width: w * 0.82, height: h * 0.09),
      const Radius.circular(4),
    );
    final bandShadowRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.25), width: w * 0.82, height: h * 0.09),
      const Radius.circular(4),
    );

    canvas.drawRRect(bandShadowRect, bandShadowPaint);
    canvas.drawRRect(bandRect, bandPaint);

    // Rising Sun emblem (red circle in center)
    final sunPaint = Paint()..color = const Color(0xFFE53935);
    canvas.drawCircle(Offset(w * 0.5, h * 0.24), w * 0.040, sunPaint);

    // Fluttering headband tails on the right
    final tailPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final tailOutline = Paint()
      ..color = const Color(0xFFCFD8DC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final tailPath1 = Path()
      ..moveTo(w * 0.88, h * 0.24)
      ..quadraticBezierTo(w * 0.98, h * 0.28, w * 0.95, h * 0.38)
      ..lineTo(w * 0.90, h * 0.35)
      ..close();
    final tailPath2 = Path()
      ..moveTo(w * 0.88, h * 0.26)
      ..quadraticBezierTo(w * 0.96, h * 0.35, w * 0.92, h * 0.46)
      ..lineTo(w * 0.86, h * 0.40)
      ..close();

    canvas.drawPath(tailPath1, tailPaint);
    canvas.drawPath(tailPath1, tailOutline);
    canvas.drawPath(tailPath2, tailPaint);
    canvas.drawPath(tailPath2, tailOutline);
  }

  void _drawCoderGear(Canvas canvas, double w, double h) {
    // Hoodie collar at base of head
    final hoodiePaint = Paint()..color = const Color(0xFF1E293B);
    final collarPath = Path()
      ..moveTo(w * 0.20, h * 0.72)
      ..quadraticBezierTo(w * 0.50, h * 0.86, w * 0.80, h * 0.72)
      ..lineTo(w * 0.76, h * 0.82)
      ..quadraticBezierTo(w * 0.50, h * 0.92, w * 0.24, h * 0.82)
      ..close();
    canvas.drawPath(collarPath, hoodiePaint);

    // Hacker Glasses Frame
    final framePaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeJoin = StrokeJoin.round;

    final lensFillPaint = Paint()
      ..color = const Color(0xFF00E676).withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;

    // Left Lens
    final leftLens = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.36, h * 0.40), width: w * 0.28, height: h * 0.26),
      const Radius.circular(8),
    );
    // Right Lens
    final rightLens = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.64, h * 0.40), width: w * 0.28, height: h * 0.26),
      const Radius.circular(8),
    );

    canvas.drawRRect(leftLens, lensFillPaint);
    canvas.drawRRect(rightLens, lensFillPaint);
    canvas.drawRRect(leftLens, framePaint);
    canvas.drawRRect(rightLens, framePaint);

    // Bridge between frames
    canvas.drawLine(Offset(w * 0.48, h * 0.38), Offset(w * 0.52, h * 0.38), framePaint);

    // Matrix green terminal reflection in left lens
    final codeGlowPaint = Paint()
      ..color = const Color(0xFF00E676)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.28, h * 0.36), Offset(w * 0.38, h * 0.36), codeGlowPaint);
    canvas.drawLine(Offset(w * 0.28, h * 0.41), Offset(w * 0.42, h * 0.41), codeGlowPaint);
    canvas.drawLine(Offset(w * 0.28, h * 0.46), Offset(w * 0.35, h * 0.46), codeGlowPaint);
  }

  void _drawCrown(Canvas canvas, double w, double h) {
    // Golden Crown base & peaks
    final goldPaint = Paint()..color = const Color(0xFFFFD700);
    final goldShadowPaint = Paint()..color = const Color(0xFFC79A00);

    final crownShadowPath = Path()
      ..moveTo(w * 0.30, h * 0.17)
      ..lineTo(w * 0.26, h * 0.06) // left peak
      ..lineTo(w * 0.39, h * 0.12)
      ..lineTo(w * 0.50, h * 0.01) // center peak (tallest)
      ..lineTo(w * 0.61, h * 0.12)
      ..lineTo(w * 0.74, h * 0.06) // right peak
      ..lineTo(w * 0.70, h * 0.17)
      ..close();
    canvas.drawPath(crownShadowPath, goldShadowPaint);

    final crownPath = Path()
      ..moveTo(w * 0.30, h * 0.15)
      ..lineTo(w * 0.26, h * 0.04) // left peak
      ..lineTo(w * 0.39, h * 0.10)
      ..lineTo(w * 0.50, -h * 0.01) // center peak
      ..lineTo(w * 0.61, h * 0.10)
      ..lineTo(w * 0.74, h * 0.04) // right peak
      ..lineTo(w * 0.70, h * 0.15)
      ..close();
    canvas.drawPath(crownPath, goldPaint);

    // Crown base headband
    final crownBand = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.14), width: w * 0.42, height: h * 0.04),
      const Radius.circular(3),
    );
    canvas.drawRRect(crownBand, goldShadowPaint);

    // Ruby gems on 3 peaks
    final rubyPaint = Paint()..color = const Color(0xFFE53935);
    final rubyHighlight = Paint()..color = Colors.white;

    for (final pt in [
      Offset(w * 0.26, h * 0.04),
      Offset(w * 0.50, -h * 0.01),
      Offset(w * 0.74, h * 0.04),
    ]) {
      canvas.drawCircle(pt, 4, rubyPaint);
      canvas.drawCircle(Offset(pt.dx - 1, pt.dy - 1), 1.5, rubyHighlight);
    }

    // Emerald & Sapphire jewels along base band
    final emeraldPaint = Paint()..color = const Color(0xFF00E676);
    final sapphirePaint = Paint()..color = const Color(0xFF1E88E5);
    canvas.drawCircle(Offset(w * 0.40, h * 0.14), 2.5, emeraldPaint);
    canvas.drawCircle(Offset(w * 0.50, h * 0.14), 3.0, rubyPaint);
    canvas.drawCircle(Offset(w * 0.60, h * 0.14), 2.5, sapphirePaint);
  }

  @override
  bool shouldRepaint(covariant _MascotPainter oldDelegate) {
    return oldDelegate.mood != mood || oldDelegate.outfitId != outfitId;
  }
}
