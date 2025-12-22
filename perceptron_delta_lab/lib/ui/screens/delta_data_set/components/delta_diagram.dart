import 'dart:math';
import 'dart:ui';
import '../../../../viewmodel/delta_data_set/delta_data_set_table_cubit.dart';
import '../export.dart';

class DeltaDiagram extends StatelessWidget {
  const DeltaDiagram({super.key, this.strokeWidth = 2.0});

  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeltaTableCubit, DeltaTableState>(
      buildWhen: (p, n) => p.columnCount != n.columnCount,
      builder: (context, state) {
        return CustomPaint(
          painter: _DeltaPainter(
            xCount: state.columnCount,
            stroke: strokeWidth,
            color: ColorName.darkLavender,
            textColor: ColorName.darkLavender,
          ),
        );
      },
    );
  }
}

class _DeltaPainter extends CustomPainter {
  _DeltaPainter({
    required this.xCount,
    required this.stroke,
    required this.color,
    required this.textColor,
  });

  final int xCount;
  final double stroke;
  final Color color;
  final Color textColor;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    final leftPad = size.width * 0.08;
    final rightPad = size.width * 0.08;
    final topPad = size.height * 0.12;

    final center = Offset(size.width * 0.52, size.height * 0.52);
    final radius = min(size.width, size.height) * 0.24;

    canvas.drawCircle(center, radius, p);
    _drawText(
      canvas,
      '∑',
      center,
      styleSize: radius * 0.55,
      color: textColor,
      centerAnchor: true,
    );

    final sumRight = Offset(center.dx + radius, center.dy);
    final outEnd = Offset(size.width - rightPad, center.dy);
    _drawArrow(canvas, sumRight, outEnd, p);
    _drawText(
      canvas,
      'ŷ',
      outEnd.translate(6, -14),
      styleSize: 14,
      color: textColor,
    );

    // Bias oku (üstten aşağı) + '1' ve φ
    final biasTop = Offset(center.dx, topPad);
    final biasEnd = Offset(center.dx, center.dy - radius - 2);
    _drawArrow(canvas, biasTop, biasEnd, p);

    _drawLabelCapsule(canvas, biasTop.translate(-6, -16), '1'); // sabit giriş
    _drawLabelCapsule(
      canvas,
      Offset(center.dx + 10, (biasTop.dy + biasEnd.dy) / 2 - 10),
      'φ',
      fontSize: 12,
      padH: 6,
    );

    final bandTop = center.dy - radius * 0.70;
    final bandBot = center.dy + radius * 0.70;

    for (int i = 0; i < xCount; i++) {
      final t = (xCount == 1) ? 0.5 : i / (xCount - 1);
      final y = lerpDouble(bandTop, bandBot, t)!;

      final start = Offset(leftPad, y);
      final end = Offset(center.dx - radius - 4, y);

      _drawArrow(canvas, start, end, p);

      _drawLabelCapsule(canvas, start.translate(-18, -16), 'x${_sub(i + 1)}');

      final midX = lerpDouble(start.dx, end.dx, 0.65)!;
      _drawLabelCapsule(
        canvas,
        Offset(midX - 10, y - 18),
        'w${_sub(i + 1)}',
        fontSize: 12,
        padH: 4,
      );
    }
  }

  void _drawArrow(Canvas canvas, Offset from, Offset to, Paint p) {
    canvas.drawLine(from, to, p);
    final dir = to - from;
    final len = dir.distance;
    if (len <= 0) return;
    final u = dir / len;
    const head = 10.0;
    final ortho = Offset(-u.dy, u.dx);
    final tip = to;
    final p1 = tip - u * head + ortho * (head / 2.2);
    final p2 = tip - u * head - ortho * (head / 2.2);
    final path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(p1.dx, p1.dy)
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(p2.dx, p2.dy);
    canvas.drawPath(path, p);
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset anchor, {
    double styleSize = 14,
    required Color color,
    bool centerAnchor = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: styleSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final pos = centerAnchor
        ? anchor - Offset(tp.width / 2, tp.height / 2)
        : anchor;
    tp.paint(canvas, pos);
  }

  void _drawLabelCapsule(
    Canvas canvas,
    Offset topLeft,
    String text, {
    double fontSize = 14,
    double padH = 6,
    double padV = 2,
    Color bg = const Color(0xF0FFFFFF),
    Color fg = const Color(0xFF5E3FA3),
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: fg,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        topLeft.dx,
        topLeft.dy,
        tp.width + padH * 2,
        tp.height + padV * 2,
      ),
      const Radius.circular(8),
    );

    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = bg;
    canvas.drawRRect(rect, fill);
    tp.paint(canvas, topLeft.translate(padH, padV));
  }

  @override
  bool shouldRepaint(covariant _DeltaPainter old) =>
      old.xCount != xCount ||
      old.stroke != stroke ||
      old.color != color ||
      old.textColor != textColor;

  String _sub(int n) {
    const m = {
      '0': '₀',
      '1': '₁',
      '2': '₂',
      '3': '₃',
      '4': '₄',
      '5': '₅',
      '6': '₆',
      '7': '₇',
      '8': '₈',
      '9': '₉',
      '-': '₋',
    };
    return n.toString().split('').map((c) => m[c] ?? c).join();
  }
}
