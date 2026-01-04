import 'package:backpropagation_algorithm/ui/screens/results/export.dart';

class ResultItem extends StatelessWidget {
  const ResultItem({
    required this.backgroundColor,
    required this.titleValue,
    required this.title,
    super.key,
  });

  final String title;
  final String titleValue;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.mediumAll,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorName.black.withValues(alpha: 0.1),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        spacing: 2,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: ColorName.white),
          ),
          Text(
            titleValue,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: ColorName.white),
          ),
        ],
      ),
    );
  }
}
