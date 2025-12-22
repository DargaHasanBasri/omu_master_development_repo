import '../export.dart';

class TableBodyRowClear extends StatelessWidget {
  const TableBodyRowClear({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap.call(),
      child: Container(
        alignment: Alignment.center,
        height: 40,
        decoration: BoxDecoration(
          color: ColorName.whiteLilac,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: ColorName.periwinkleGrey.withValues(alpha: 0.4),
          ),
        ),
        child: Icon(Icons.delete, color: ColorName.beanRed),
      ),
    );
  }
}
