import '../export.dart';

class NumBox extends StatelessWidget {
  const NumBox({
    super.key,
    required this.onTapBox,
    this.number,
  });

  final int? number;
  final VoidCallback onTapBox;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onTapBox.call(),
        child: Ink(
          padding: AppPaddings.mediumVertical + AppPaddings.largeHorizontal,
          decoration: BoxDecoration(
            color: ColorName.toolbox,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${number ?? 0}',
            style: number != null
                ? Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(
                    color: ColorName.white,
                  )
                : Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(
                    color: Colors.transparent,
                  ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
