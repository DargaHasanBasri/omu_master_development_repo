import 'package:data_cpn/export.dart';

class OverallProgressCard extends StatelessWidget {
  const OverallProgressCard({
    required this.epochCurrent,
    required this.epochTotal,
    required this.loss,
    super.key,
    this.title = 'GENEL İLERLEME',
    this.etaText = '~2 dk',
  });

  final String title;
  final String etaText;
  final int epochCurrent;
  final int epochTotal;
  final double loss;

  double get _progress01 {
    if (epochTotal <= 0) return 0;
    return (epochCurrent / epochTotal).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final progress01 = _progress01;
    final percent = (progress01 * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: ColorName.glacier,
                ),
              ),
            ),
            Text(
              '$percent%',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: ColorName.blueDress,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _MiniProgressBar(
          value: progress01,
          height: 8,
          fillColor: ColorName.blueDress,
          trackColor: ColorName.cadetGrey,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 14,
          runSpacing: 6,
          alignment: .center,
          children: [
            _MetricPair(label: 'Tahmini süre:', value: etaText),
            _MetricPair(label: 'Epoch:', value: '$epochCurrent/$epochTotal'),
            _MetricPair(label: 'Loss:', value: loss.toStringAsFixed(3)),
          ],
        ),
      ],
    );
  }
}

class _MetricPair extends StatelessWidget {
  const _MetricPair({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label ',
          style: theme.textTheme.labelSmall?.copyWith(
            color: ColorName.glacier,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }
}

class _MiniProgressBar extends StatelessWidget {
  const _MiniProgressBar({
    required this.value,
    required this.height,
    required this.fillColor,
    required this.trackColor,
  });

  final double value;
  final double height;
  final Color fillColor;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                height: height,
                width: constraints.maxWidth,
                color: trackColor,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                height: height,
                width: constraints.maxWidth * v,
                color: fillColor,
              ),
            ],
          );
        },
      ),
    );
  }
}
