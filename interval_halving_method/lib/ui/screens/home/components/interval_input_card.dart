import 'package:flutter/services.dart';
import 'package:interval_halving_method/ui/screens/home/export.dart';

class IntervalInputCard extends StatelessWidget {
  const IntervalInputCard({
    required this.lowerLimitController,
    required this.upperLimitController,
    super.key,
  });

  final TextEditingController lowerLimitController;
  final TextEditingController upperLimitController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppPaddings.smallTop,
      padding: AppPaddings.mediumAll,
      decoration: BoxDecoration(
        color: ColorName.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorName.catskillWhite),
        boxShadow: [
          BoxShadow(
            color: ColorName.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildInputField(
              context: context,
              controller: lowerLimitController,
              label: 'Lower Limit (a)',
              hintText: '-10',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildInputField(
              context: context,
              controller: upperLimitController,
              label: 'Upper Limit (b)',
              hintText: '10',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hintText,
  }) {
    final labelStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: ColorName.blueGrey,
      fontWeight: FontWeight.w600,
    );

    final inputStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: ColorName.black,
    );

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: ColorName.catskillWhite),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Text(label, style: labelStyle),
        TextFormField(
          controller: controller,
          style: inputStyle,
          keyboardType: const TextInputType.numberWithOptions(
            signed: true,
            decimal: true,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
          ],
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: inputStyle?.copyWith(
              color: ColorName.blueGrey.withValues(alpha: 0.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FB),
            border: inputBorder,
            enabledBorder: inputBorder,
            focusedBorder: inputBorder.copyWith(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            isDense: true,
          ),
        ),
      ],
    );
  }
}
