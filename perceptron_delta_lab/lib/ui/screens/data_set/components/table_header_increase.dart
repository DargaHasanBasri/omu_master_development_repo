import '../export.dart';

class TableHeaderIncrease extends StatelessWidget {
  const TableHeaderIncrease({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap.call(),
      child: Container(
        padding: AppPaddings.xSmallAll,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorName.rosyPink,
          borderRadius: BorderRadius.only(topRight: Radius.circular(16)),
          border: Border(
            left: BorderSide(
              color: Colors.white.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
        ),
        child: Text(
          '+',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: ColorName.white),
        ),
      ),
    );
  }
}
