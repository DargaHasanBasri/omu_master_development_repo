import '../export.dart';

class TableRowInput extends StatelessWidget {
  const TableRowInput({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      textEditingController: controller,
      onChanged: onChanged,
    );
  }
}
