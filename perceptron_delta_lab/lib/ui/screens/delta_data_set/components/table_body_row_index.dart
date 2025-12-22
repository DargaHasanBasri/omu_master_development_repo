import '../export.dart';

class TableBodyRowIndex extends StatelessWidget {
  const TableBodyRowIndex({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.smallAll,
      alignment: Alignment.center,
      height: 40,
      decoration: BoxDecoration(
        color: ColorName.whiteLilac,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ColorName.periwinkleGrey.withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        '${title}.',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}
