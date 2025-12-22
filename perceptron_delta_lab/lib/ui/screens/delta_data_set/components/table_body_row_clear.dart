import '../export.dart';

class TableBodyRowClear extends StatelessWidget {
  const TableBodyRowClear({
    super.key,
    required this.onTap,
    this.tooltip = 'Satırı temizle',
  });

  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
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
      ),
    );
  }
}
