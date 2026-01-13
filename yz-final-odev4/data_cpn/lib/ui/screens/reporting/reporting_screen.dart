import 'package:data_cpn/ui/screens/reporting/export.dart';
import 'package:data_cpn/viewmodel/model_training/model_training_cubit.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportingScreen extends StatefulWidget {
  const ReportingScreen({super.key});

  @override
  State<ReportingScreen> createState() => _ReportingScreenState();
}

class _ReportingScreenState extends State<ReportingScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;

    final results =
        (extra?['results'] as List?)?.cast<RadiusResult>() ?? <RadiusResult>[];
    final fileName = extra?['fileName'] as String?;
    final epochTotal = extra?['epochTotal'] as int?;
    final trainingTimeMs = extra?['trainingTimeMs'] as int?;

    if (results.isEmpty) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'Raporlama',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontSize: 18),
          ),
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Center(
          child: Text(
            'Rapor verisi bulunamadı (results boş).',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: ColorName.glacier),
          ),
        ),
      );
    }

    _selectedIndex = _selectedIndex.clamp(0, results.length - 1);
    final selected = results[_selectedIndex];

    final radiiCount = results.length;
    final stepsPerRadius = (epochTotal != null && radiiCount > 0)
        ? (epochTotal ~/ radiiCount)
        : null;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Raporlama',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: AppPaddings.largeHorizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ✅ Ödev eşleştirme özeti / veri bilgisi
                _InfoCard(
                  fileName: fileName,
                  radiiCount: radiiCount,
                  selectedRadius: selected.radius,
                  splitText: '70% Eğitim • 30% Test',
                  epochTotal: epochTotal,
                  stepsPerRadius: stepsPerRadius,
                  trainingTimeMs: trainingTimeMs,
                ),

                const SizedBox(height: 16),

                // ✅ Radius seçim alanı (dinamik)
                Padding(
                  padding: AppPaddings.xSmallVertical,
                  child: Text(
                    'YARIÇAP PARAMETRE SEÇİMİ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorName.cadetGrey,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(results.length, (i) {
                      final r = results[i].radius;
                      final selectedChip = i == _selectedIndex;

                      return Padding(
                        padding: EdgeInsets.only(
                          right: i == results.length - 1 ? 0 : 12,
                        ),
                        child: _RadiusChip(
                          text: 'r=${r.toStringAsFixed(2)}',
                          isSelected: selectedChip,
                          onTap: () => setState(() => _selectedIndex = i),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 18),

                // ✅ Ödev: “Radius: 0.5 seçildi, kural sayısı 25 oldu” gibi rapor satırı
                _SelectedSummaryLine(
                  radius: selected.radius,
                  ruleCount: selected.ruleCount,
                  trainRmse: selected.train.rmse,
                  testRmse: selected.test.rmse,
                ),

                Padding(
                  padding: AppPaddings.largeTop + AppPaddings.smallBottom,
                  child: Text(
                    'Ayrıntılı Metrikler',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineLarge?.copyWith(fontSize: 18),
                  ),
                ),

                // ✅ Train/Test metrik kartları (dinamik)
                Row(
                  children: [
                    Expanded(
                      child: _MetricsCard(
                        title: 'TRAIN',
                        metrics: selected.train,
                        icon: Assets.icons.icMseTraining.image(
                          package: AppConstants.packageGenName,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricsCard(
                        title: 'TEST',
                        metrics: selected.test,
                        icon: Assets.icons.icMseTest.image(
                          package: AppConstants.packageGenName,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ✅ Kural sayısı + epoch + süre (dinamik)
                Container(
                  padding: AppPaddings.mediumAll,
                  decoration: BoxDecoration(
                    color: ColorName.darkBlueGrey,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: ColorName.black.withValues(alpha: 0.35),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _KeyValueRow(
                        label: 'Kural Sayısı (Kohonen nöron)',
                        value: '${selected.ruleCount}',
                        icon: Assets.icons.icEpochRun.image(
                          package: AppConstants.packageGenName,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _KeyValueRow(
                        label: 'Epoch/Adım (Toplam)',
                        value: epochTotal?.toString() ?? '—',
                        icon: Assets.icons.icEpochRun.image(
                          package: AppConstants.packageGenName,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _KeyValueRow(
                        label: 'Training Time (ms)',
                        value: trainingTimeMs != null
                            ? '${trainingTimeMs}ms'
                            : '—',
                        icon: Assets.icons.icTrainingTime.image(
                          package: AppConstants.packageGenName,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ✅ Grafikler (yana kaydırmalı)
                Padding(
                  padding: AppPaddings.smallBottom,
                  child: Text(
                    'Grafikler (Yana Kaydır)',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),

                SizedBox(
                  height: 260,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _ChartCard(
                        title: 'RMSE (Train vs Test)',
                        child: _TwoLineChart(
                          xs: results.map((e) => e.radius).toList(),
                          y1: results.map((e) => e.train.rmse).toList(),
                          y2: results.map((e) => e.test.rmse).toList(),
                          y1Name: 'Train',
                          y2Name: 'Test',
                        ),
                      ),
                      const SizedBox(width: 12),
                      _ChartCard(
                        title: 'MSE (Train vs Test)',
                        child: _TwoLineChart(
                          xs: results.map((e) => e.radius).toList(),
                          y1: results.map((e) => e.train.mse).toList(),
                          y2: results.map((e) => e.test.mse).toList(),
                          y1Name: 'Train',
                          y2Name: 'Test',
                        ),
                      ),
                      const SizedBox(width: 12),
                      _ChartCard(
                        title: 'Kural Sayısı (Radius → Rule)',
                        child: _BarChart(
                          xs: results.map((e) => e.radius).toList(),
                          ys: results
                              .map((e) => e.ruleCount.toDouble())
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _ChartCard(
                        title: 'R² (Train vs Test)',
                        child: _TwoLineChart(
                          xs: results.map((e) => e.radius).toList(),
                          y1: results.map((e) => e.train.r2).toList(),
                          y2: results.map((e) => e.test.r2).toList(),
                          y1Name: 'Train',
                          y2Name: 'Test',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ✅ Ödev raporu için yorum alanı (sen doldurursun)
                Container(
                  padding: AppPaddings.mediumAll,
                  decoration: BoxDecoration(
                    color: ColorName.dark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColorName.darkGreyBlue),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Değerlendirme / Yorum',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '• Radius arttıkça kural sayısı genelde ...\n'
                        '• Train/Test farkı (overfit/underfit) açısından ...\n'
                        '• En iyi genelleme: Test RMSE en düşük olan radius seçilebilir.',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: ColorName.glacier,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: AppPaddings.mediumVertical,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => context.pop(), // istersen home route yap
                      child: Ink(
                        padding: AppPaddings.mediumAll,
                        decoration: BoxDecoration(
                          color: ColorName.blueDress,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: ColorName.blueDress.withValues(
                                alpha: 0.25,
                              ),
                              offset: const Offset(0, 15),
                              blurRadius: 15,
                              spreadRadius: -3,
                            ),
                          ],
                        ),
                        child: Text(
                          'Ana Sayfaya Dön',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineLarge?.copyWith(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- UI Pieces ----------------

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.fileName,
    required this.radiiCount,
    required this.selectedRadius,
    required this.splitText,
    required this.epochTotal,
    required this.stepsPerRadius,
    required this.trainingTimeMs,
  });

  final String? fileName;
  final int radiiCount;
  final double selectedRadius;
  final String splitText;
  final int? epochTotal;
  final int? stepsPerRadius;
  final int? trainingTimeMs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.mediumAll,
      decoration: BoxDecoration(
        color: ColorName.dark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorName.darkGreyBlue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ödev Özeti', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 6),
          Text(
            '• Split: $splitText\n'
            '• Modifiye CPN eğitimi ✅\n'
            '• Radius sayısı: $radiiCount (en az 4 ✅)\n'
            '• Seçili radius: r=${selectedRadius.toStringAsFixed(2)}',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: ColorName.glacier),
          ),
          const SizedBox(height: 10),
          Text(
            'Dosya: ${fileName ?? '—'}',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: ColorName.cadetGrey),
          ),
          const SizedBox(height: 6),
          Text(
            'Epoch Total: ${epochTotal ?? '—'} • '
            'Satır Limiti (radius başına): ${stepsPerRadius ?? '—'} • '
            'Süre: ${trainingTimeMs != null ? '${trainingTimeMs}ms' : '—'}',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: ColorName.cadetGrey),
          ),
        ],
      ),
    );
  }
}

class _RadiusChip extends StatelessWidget {
  const _RadiusChip({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? ColorName.blueDress : ColorName.darkBlueGrey;
    final fg = isSelected ? Colors.white : ColorName.cadetGrey;

    return ClipRRect(
      borderRadius: BorderRadius.circular(80),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(80),
        child: Ink(
          padding: AppPaddings.xSmallVertical + AppPaddings.mediumHorizontal,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(80),
            boxShadow: [
              BoxShadow(
                color: bg.withValues(alpha: 0.2),
                offset: const Offset(0, 10),
                blurRadius: 15,
                spreadRadius: -3,
              ),
            ],
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: fg),
          ),
        ),
      ),
    );
  }
}

class _SelectedSummaryLine extends StatelessWidget {
  const _SelectedSummaryLine({
    required this.radius,
    required this.ruleCount,
    required this.trainRmse,
    required this.testRmse,
  });

  final double radius;
  final int ruleCount;
  final double trainRmse;
  final double testRmse;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.mediumAll,
      decoration: BoxDecoration(
        color: ColorName.ebonyClay,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Radius: ${radius.toStringAsFixed(2)} seçildi • '
        'Kural sayısı: $ruleCount • '
        'Train RMSE: ${trainRmse.toStringAsFixed(4)} • '
        'Test RMSE: ${testRmse.toStringAsFixed(4)}',
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: ColorName.glacier),
      ),
    );
  }
}

class _MetricsCard extends StatelessWidget {
  const _MetricsCard({
    required this.title,
    required this.metrics,
    required this.icon,
  });

  final String title;
  final Metrics metrics;
  final Image icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.mediumAll,
      decoration: BoxDecoration(
        color: ColorName.darkBlueGrey,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: ColorName.black.withValues(alpha: 0.35),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: AppPaddings.xSmallAll,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorName.pickledBlueWood,
                ),
                child: icon,
              ),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 12),
          _MiniMetric(label: 'MAE', value: metrics.mae),
          _MiniMetric(label: 'MSE', value: metrics.mse),
          _MiniMetric(label: 'RMSE', value: metrics.rmse),
          _MiniMetric(label: 'R²', value: metrics.r2),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: ColorName.cadetGrey),
          ),
          Text(
            value.toStringAsFixed(4),
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final Image icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: AppPaddings.xSmallAll,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: ColorName.pickledBlueWood,
          ),
          child: icon,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      padding: AppPaddings.mediumAll,
      decoration: BoxDecoration(
        color: ColorName.darkBlueGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 10),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ---------------- Charts (fl_chart) ----------------

class _TwoLineChart extends StatelessWidget {
  const _TwoLineChart({
    required this.xs,
    required this.y1,
    required this.y2,
    required this.y1Name,
    required this.y2Name,
  });

  final List<double> xs;
  final List<double> y1;
  final List<double> y2;
  final String y1Name;
  final String y2Name;

  @override
  Widget build(BuildContext context) {
    final spots1 = <FlSpot>[];
    final spots2 = <FlSpot>[];

    for (var i = 0; i < xs.length; i++) {
      spots1.add(FlSpot(xs[i], y1[i]));
      spots2.add(FlSpot(xs[i], y2[i]));
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots1,
            isCurved: true,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            color: ColorName.blueDress,
          ),
          LineChartBarData(
            spots: spots2,
            isCurved: true,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            color: ColorName.cadetGrey,
          ),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({required this.xs, required this.ys});

  final List<double> xs;
  final List<double> ys;

  @override
  Widget build(BuildContext context) {
    final groups = <BarChartGroupData>[];

    for (var i = 0; i < xs.length; i++) {
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: ys[i],
              width: 14,
              borderRadius: BorderRadius.circular(6),
              color: ColorName.blueDress,
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(show: false),
        barGroups: groups,
      ),
    );
  }
}
