import '../export.dart';

class TableHeaderRowItem extends StatelessWidget {
  const TableHeaderRowItem({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.xSmallAll,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [ColorName.cornflower, ColorName.darkLavender],
        ),
        border: Border.symmetric(
          vertical: BorderSide(
            color: Colors.white.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: ColorName.white),
      ),
    );
  }
}
