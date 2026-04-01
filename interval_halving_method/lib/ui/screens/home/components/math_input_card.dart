import 'package:interval_halving_method/ui/screens/home/export.dart';

class MathInputCard extends StatefulWidget {
  const MathInputCard({super.key});

  @override
  State<MathInputCard> createState() => _MathInputCardState();
}

class _MathInputCardState extends State<MathInputCard> {
  late final TextEditingController _mainFunctionController;
  late final TextEditingController _numberController;

  bool _showAdvancedKeyboard = false;

  @override
  void initState() {
    super.initState();
    _mainFunctionController = TextEditingController();
    _numberController = TextEditingController();
  }

  @override
  void dispose() {
    _mainFunctionController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  void _insertText(String insertValue) {
    final text = _mainFunctionController.text;
    final selection = _mainFunctionController.selection;

    if (selection.baseOffset == -1) {
      _mainFunctionController.text = text + insertValue;
      return;
    }

    final newText = text.replaceRange(
      selection.start,
      selection.end,
      insertValue,
    );
    _mainFunctionController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + insertValue.length,
      ),
    );
  }

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
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            TextFormField(
              controller: _mainFunctionController,
              // Sadece sayısal klavyenin çıkması için eklendi
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              decoration: InputDecoration(
                hintText: 'f(x) = x^2 - 4',
                filled: true,
                fillColor: const Color(0xFFF8F9FB),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showAdvancedKeyboard
                        ? Icons.keyboard_arrow_up
                        : Icons.calculate_outlined,
                    color: _showAdvancedKeyboard
                        ? Theme.of(context).primaryColor
                        : ColorName.blueGrey,
                  ),
                  onPressed: () {
                    setState(() {
                      _showAdvancedKeyboard = !_showAdvancedKeyboard;
                    });
                    if (_showAdvancedKeyboard) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: ColorName.catskillWhite),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: ColorName.catskillWhite),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
            ),

            if (_showAdvancedKeyboard) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildMiniButton('x'),
                  _buildMiniButton('+'),
                  _buildMiniButton('-'),
                  _buildMiniButton('*'),
                  _buildMiniButton('/'),
                  _buildMiniButton('^'),
                  _buildMiniButton('('),
                  _buildMiniButton(')'),
                  _buildMiniButton('sin('),
                  _buildMiniButton('cos('),
                  _buildMiniButton('tan('),
                  _buildMiniButton('arcsin('),
                  _buildMiniButton('arccos('),
                  _buildMiniButton('arctan('),
                  _buildMiniButton('ln('),
                  _buildMiniButton('log('),
                ],
              ),
            ],
            PrimaryActionButton(
              text: 'Fonksiyonu Onayla',
              icon: const Icon(Icons.save_outlined, color: Colors.white),
              backgroundColor: const Color(0xFF1976D2),
              onPressed: () {
                final currentFunction = _mainFunctionController.text;
                if (currentFunction.isNotEmpty) {
                  context.read<FunctionCubit>().saveFunction(currentFunction);
                  setState(() {
                    _showAdvancedKeyboard = false;
                  });
                  FocusManager.instance.primaryFocus?.unfocus();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Fonksiyon kaydedildi: $currentFunction'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniButton(String label) {
    return InkWell(
      onTap: () => _insertText(label),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE4E7EC)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF344054),
          ),
        ),
      ),
    );
  }
}
