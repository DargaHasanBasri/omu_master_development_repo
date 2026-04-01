import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:interval_halving_method/core/models/iteration_step.dart';

class FunctionGraphCard extends StatelessWidget {
  const FunctionGraphCard({
    required this.functionText,
    required this.currentStep,
    required this.initialStep,
    super.key,
  });

  final String functionText;
  final IterationStep currentStep;
  final IterationStep initialStep;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4E7EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Interval Halving Method',
            style: TextStyle(
              color: Color(0xFF667085),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  functionText,
                  style: const TextStyle(
                    color: Color(0xFF101828),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                  // Çok uzunsa 2 satıra kadar izin ver, daha uzarsa sonuna "..." koy
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ITERATION ${currentStep.iteration}',
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Container(
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomPaint(
                // YENİ DİNAMİK PAINTER'I ÇAĞIRIYORUZ
                painter: _DynamicGraphPainter(
                  functionText: functionText,
                  currentStep: currentStep,
                  initialStep: initialStep,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              _buildLegendItem(color: const Color(0xFFF04438), label: 'x1'),
              _buildLegendItem(
                color: const Color(0xFF2563EB),
                label: 'Midpoint (xm)',
              ),
              _buildLegendItem(color: const Color(0xFF12B76A), label: 'x2'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF475467),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------------
// TAMAMEN GERÇEK MATEMATİKSEL DEĞERLERLE ÇİZİM YAPAN DİNAMİK PAINTER
// ------------------------------------------------------------------
class _DynamicGraphPainter extends CustomPainter {
  final String functionText;
  final IterationStep currentStep;
  final IterationStep initialStep;

  _DynamicGraphPainter({
    required this.functionText,
    required this.currentStep,
    required this.initialStep,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Izgaraları (Grid) Çiz
    final gridPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 1.0;
    for (int i = 1; i <= 3; i++) {
      canvas.drawLine(
        Offset(0, size.height * (i / 4)),
        Offset(size.width, size.height * (i / 4)),
        gridPaint,
      );
      canvas.drawLine(
        Offset(size.width * (i / 4), 0),
        Offset(size.width * (i / 4), size.height),
        gridPaint,
      );
    }

    // 2. Fonksiyonu Parçala ve 50 Noktada Hesapla (Gerçek Eğri Çizimi İçin)
    Parser p = Parser();
    Expression exp;
    try {
      exp = p.parse(functionText);
    } catch (e) {
      return; // Fonksiyon hatalıysa çizmeyi durdur
    }
    ContextModel cm = ContextModel();

    // Kamera açısını (X Eksenini) BAŞLANGIÇ aralığına göre sabitliyoruz ki zoom etkisi olmasın,
    // noktaların birbirine yaklaştığı net görülsün.
    double minX = initialStep.a;
    double maxX = initialStep.b;
    double rangeX = maxX - minX == 0 ? 1 : maxX - minX;

    List<Offset> mathPoints = [];
    double minY = double.infinity;
    double maxY = -double.infinity;

    // Gerçek eğriyi çizmek için 50 farklı x noktasında y değerini buluyoruz
    for (int i = 0; i <= 50; i++) {
      double xValue = minX + (rangeX * (i / 50));
      cm.bindVariable(Variable('x'), Number(xValue));
      double yValue = (exp.evaluate(EvaluationType.REAL, cm) as num).toDouble();
      mathPoints.add(Offset(xValue, yValue));
      if (yValue < minY) minY = yValue;
      if (yValue > maxY) maxY = yValue;
    }

    double rangeY = maxY - minY == 0 ? 1 : maxY - minY;

    // Ekrana Oturtma (Mapping) Fonksiyonları
    double paddingX = size.width * 0.1;
    double drawWidth = size.width * 0.8;
    double getX(double val) => paddingX + drawWidth * ((val - minX) / rangeX);

    double paddingY = size.height * 0.15;
    double drawHeight = size.height * 0.7;
    // Y ekseni canvas'ta terstir (0 en üsttedir), bu yüzden çıkartarak hizalıyoruz
    double getY(double val) =>
        size.height - paddingY - drawHeight * ((val - minY) / rangeY);

    // 3. Mevcut Adımın 'a' ve 'b' sınırlarını kesikli çizgi olarak çiz (Gittikçe daralacaklar)
    final Paint dashedPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    double aX = getX(currentStep.a);
    double bX = getX(currentStep.b);

    _drawDashedLine(
      canvas,
      Offset(aX, 0),
      Offset(aX, size.height),
      dashedPaint,
    );
    _drawDashedLine(
      canvas,
      Offset(bX, 0),
      Offset(bX, size.height),
      dashedPaint,
    );

    // 4. Gerçek Fonksiyon Eğrisini Çiz
    final Paint curvePaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    final Path curvePath = Path();
    for (int i = 0; i < mathPoints.length; i++) {
      double px = getX(mathPoints[i].dx);
      double py = getY(mathPoints[i].dy);
      if (i == 0) {
        curvePath.moveTo(px, py);
      } else {
        curvePath.lineTo(px, py);
      }
    }
    canvas.drawPath(curvePath, curvePaint);

    // 5. O anki iterasyonun x1, xm, x2 noktalarını TAM OLARAK eğrinin üzerine çiz
    _drawPointWithLabel(
      canvas,
      Offset(getX(currentStep.x1), getY(currentStep.fx1)),
      'x1',
      const Color(0xFFF04438),
    );
    _drawPointWithLabel(
      canvas,
      Offset(getX(currentStep.xm), getY(currentStep.fxm)),
      'xm',
      const Color(0xFF2563EB),
    );
    _drawPointWithLabel(
      canvas,
      Offset(getX(currentStep.x2), getY(currentStep.fx2)),
      'x2',
      const Color(0xFF12B76A),
    );

    // 6. a ve b harflerini alta yazdır
    _drawLabel(
      canvas,
      'a',
      Offset(aX + 4, size.height - 20),
      const Color(0xFF64748B),
    );
    _drawLabel(
      canvas,
      'b',
      Offset(bX - 14, size.height - 20),
      const Color(0xFF64748B),
    );
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const int dashWidth = 5;
    const int dashSpace = 5;
    double startY = p1.dy;
    while (startY < p2.dy) {
      canvas.drawLine(
        Offset(p1.dx, startY),
        Offset(p1.dx, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  void _drawPointWithLabel(
    Canvas canvas,
    Offset offset,
    String label,
    Color color,
  ) {
    final Paint pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: offset, width: 8, height: 16),
      pointPaint,
    );
    _drawLabel(
      canvas,
      label,
      Offset(offset.dx - 8, offset.dy - 24),
      color,
      isBold: true,
    );
  }

  void _drawLabel(
    Canvas canvas,
    String text,
    Offset offset,
    Color color, {
    bool isBold = false,
  }) {
    final TextSpan span = TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
      ),
    );
    final TextPainter tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, offset);
  }

  // İterasyon adımı değiştiğinde grafiğin kendini YENİDEN çizmesi için true dönüyoruz
  @override
  bool shouldRepaint(covariant _DynamicGraphPainter oldDelegate) {
    return oldDelegate.currentStep.iteration != currentStep.iteration;
  }
}
