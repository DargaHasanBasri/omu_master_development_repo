import 'dart:math' as math;
import 'package:backpropagation_algorithm/export.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartSeries {
  ChartSeries({
    required this.name,
    required this.values,
    required this.color,
  });

  final String name;
  final List<double> values;
  final Color color;
}

class LineChartCard extends StatelessWidget {
  const LineChartCard({
    required this.lines,
    super.key,
  });

  final List<_Line> lines;

  static LineChartCard fromSeries({
    required List<ChartSeries> series,
    int maxPoints = 250,
  }) {
    final lines = <_Line>[];

    for (final s in series) {
      final spots = _toSpots(s.values, maxPoints: maxPoints);
      lines.add(_Line(name: s.name, spots: spots, color: s.color));
    }

    return LineChartCard(lines: lines);
  }

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty || lines.every((l) => l.spots.isEmpty)) {
      return _empty();
    }

    // min/max
    double minX = lines.first.spots.first.x;
    double maxX = lines.first.spots.last.x;
    double minY = lines.first.spots.first.y;
    double maxY = lines.first.spots.first.y;

    for (final l in lines) {
      for (final p in l.spots) {
        minX = math.min(minX, p.x);
        maxX = math.max(maxX, p.x);
        minY = math.min(minY, p.y);
        maxY = math.max(maxY, p.y);
      }
    }

    final pad = (maxY - minY).abs() * 0.08;
    final yMin = minY - (pad == 0 ? 1 : pad);
    final yMax = maxY + (pad == 0 ? 1 : pad);

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: yMin,
        maxY: yMax,
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: ColorName.mercury),
        ),
        titlesData: const FlTitlesData(show: false),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => ColorName.black.withValues(alpha: 0.7),
          ),
        ),
        lineBarsData: [
          for (final l in lines)
            LineChartBarData(
              spots: l.spots,
              isCurved: false,
              barWidth: 2,
              color: l.color,
              dotData: const FlDotData(show: false),
            ),
        ],
      ),
    );
  }

  Widget _empty() => Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: ColorName.alabaster,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      'Veri yok',
      style: TextStyle(color: ColorName.paleSky),
    ),
  );
}

class LossChartCard extends StatelessWidget {
  const LossChartCard({
    required this.epochs,
    required this.trainLoss,
    required this.testLoss,
    super.key,
  });

  final List<int> epochs; // boş gelebilir
  final List<double> trainLoss;
  final List<double> testLoss;

  @override
  Widget build(BuildContext context) {
    if (trainLoss.isEmpty || testLoss.isEmpty) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorName.alabaster,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Loss verisi yok',
          style: TextStyle(color: ColorName.paleSky),
        ),
      );
    }

    final len = math.min(trainLoss.length, testLoss.length);
    final xEpochs = epochs.isNotEmpty && epochs.length >= len
        ? epochs.take(len).toList()
        : List<int>.generate(len, (i) => i + 1);

    final trainSpots = <FlSpot>[];
    final testSpots = <FlSpot>[];
    for (int i = 0; i < len; i++) {
      trainSpots.add(FlSpot(xEpochs[i].toDouble(), trainLoss[i]));
      testSpots.add(FlSpot(xEpochs[i].toDouble(), testLoss[i]));
    }

    return LineChartCard(
      lines: [
        _Line(name: 'Train Loss', spots: trainSpots, color: ColorName.blueViolet),
        _Line(name: 'Test Loss', spots: testSpots, color: ColorName.pumpkinOrange),
      ],
    );
  }
}

class _Line {
  _Line({
    required this.name,
    required this.spots,
    required this.color,
  });

  final String name;
  final List<FlSpot> spots;
  final Color color;
}

/// index tabanlı downsample: çok büyük veride UI kasmasın
List<FlSpot> _toSpots(List<double> values, {required int maxPoints}) {
  if (values.isEmpty) return const [];
  if (values.length <= maxPoints) {
    return List<FlSpot>.generate(values.length,
            (i) => FlSpot(i.toDouble(), values[i]));
  }

  final step = (values.length / maxPoints).ceil();
  final spots = <FlSpot>[];
  for (int i = 0; i < values.length; i += step) {
    spots.add(FlSpot(i.toDouble(), values[i]));
  }
  // son nokta garanti
  final lastIdx = values.length - 1;
  if (spots.isEmpty || spots.last.x != lastIdx.toDouble()) {
    spots.add(FlSpot(lastIdx.toDouble(), values[lastIdx]));
  }
  return spots;
}
