import 'package:flutter/services.dart';
import '../export.dart';
import 'package:perceptron_delta_lab/viewmodel/data_set/data_set_table_cubit.dart';

class PerceptronParamsBar extends StatefulWidget {
  const PerceptronParamsBar({super.key, this.fieldWidth = 64});

  final double fieldWidth;

  @override
  State<PerceptronParamsBar> createState() => _PerceptronParamsBarState();
}

class _PerceptronParamsBarState extends State<PerceptronParamsBar> {
  final _numFmt = FilteringTextInputFormatter.allow(RegExp(r'[-0-9\.,]'));
  final _intFmt = FilteringTextInputFormatter.digitsOnly;

  List<TextEditingController> _wCtrls = [];
  final _etaCtrl = TextEditingController();
  final _phiCtrl = TextEditingController();
  final _epochCtrl = TextEditingController();

  void _syncControllers(DataSetTableState s) {
    final k = s.inputCount;

    // W controller sayısı uymuyorsa baştan kur (tam temiz kurulum)
    if (_wCtrls.length != k) {
      for (final c in _wCtrls) c.dispose();
      _wCtrls = List.generate(k, (_) => TextEditingController());
    }

    // Cubit -> UI (artır/azalt/clearAll sonrası boş değerler yansır)
    for (int i = 0; i < k; i++) {
      final want = s.weightTexts[i] ?? '';
      if (_wCtrls[i].text != want) {
        _wCtrls[i].value = TextEditingValue(
          text: want,
          selection: TextSelection.collapsed(offset: want.length),
        );
      }
    }
    final wantEta = s.learningRateText ?? '';
    if (_etaCtrl.text != wantEta) {
      _etaCtrl.value = TextEditingValue(
        text: wantEta,
        selection: TextSelection.collapsed(offset: wantEta.length),
      );
    }
    final wantPhi = s.biasText ?? '';
    if (_phiCtrl.text != wantPhi) {
      _phiCtrl.value = TextEditingValue(
        text: wantPhi,
        selection: TextSelection.collapsed(offset: wantPhi.length),
      );
    }

    final wantEpoch = s.epochLimitText ?? '';
    if (_epochCtrl.text != wantEpoch) {
      _epochCtrl.value = TextEditingValue(
        text: wantEpoch,
        selection: TextSelection.collapsed(offset: wantEpoch.length),
      );
    }
  }

  @override
  void dispose() {
    for (final c in _wCtrls) c.dispose();
    _etaCtrl.dispose();
    _phiCtrl.dispose();
    _epochCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataSetTableCubit, DataSetTableState>(
      buildWhen: (p, n) =>
          p.inputCount != n.inputCount ||
          p.weightTexts != n.weightTexts ||
          p.learningRateText != n.learningRateText ||
          p.biasText != n.biasText ||
          p.trainedWeights != n.trainedWeights ||
          p.trainedBiasWeight != n.trainedBiasWeight ||
          p.hasTrained != n.hasTrained ||
          p.epochLimitText != n.epochLimitText,
      builder: (context, state) {
        _syncControllers(state);

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Doldur',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall,
                ),
                SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    context.read<DataSetTableCubit>().applyDefaultParams();
                  },
                  child: Assets.icons.icTap.image(
                    package: AppConstants.packageName,
                    color: ColorName.darkLavender,
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                // W1..Wk (dinamik)
                ...List.generate(state.inputCount, (i) {
                  return SizedBox(
                    width: widget.fieldWidth,
                    child: CustomTextFormField(
                      textFormTitle: 'w${i + 1}',
                      textFormWidth: widget.fieldWidth,
                      textEditingController: _wCtrls[i],
                      hintText: '0.0',
                      inputType: const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      inputFormatters: [_numFmt],
                      onChanged: (t) =>
                          context.read<DataSetTableCubit>().setWeightText(
                            i,
                            t.isEmpty ? null : t.replaceAll(',', '.'),
                          ),
                    ),
                  );
                }),

                // η
                SizedBox(
                  width: widget.fieldWidth,
                  child: CustomTextFormField(
                    textFormTitle: 'η',
                    textFormWidth: widget.fieldWidth,
                    textEditingController: _etaCtrl,
                    hintText: '0.10',
                    inputType: const TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    inputFormatters: [_numFmt],
                    onChanged: (t) =>
                        context.read<DataSetTableCubit>().setLearningRateText(
                          t.isEmpty ? null : t.replaceAll(',', '.'),
                        ),
                  ),
                ),

                // φ
                SizedBox(
                  width: widget.fieldWidth,
                  child: CustomTextFormField(
                    textFormTitle: 'φ',
                    textFormWidth: widget.fieldWidth,
                    textEditingController: _phiCtrl,
                    hintText: '0.50',
                    inputType: const TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    inputFormatters: [_numFmt],
                    onChanged: (t) => context
                        .read<DataSetTableCubit>()
                        .setBiasText(t.isEmpty ? null : t.replaceAll(',', '.')),
                  ),
                ),
              ],
            ),
            CustomTextFormField(
              textFormTitle: 'Epoch Sınırı',
              textEditingController: _epochCtrl,
              hintText: '500',
              inputType: const TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              inputFormatters: [_intFmt],
              onChanged: (value) {
                context.read<DataSetTableCubit>().setEpochLimitText(
                  value.isEmpty ? null : value,
                );
              },
            ),
            // ------------------- Eğitim sonrası değerler -------------------
            if (state.hasTrained &&
                state.trainedWeights != null &&
                state.trainedBiasWeight != null) ...[
              Column(
                children: [
                  Padding(
                    padding: AppPaddings.smallVertical,
                    child: Text(
                      'Eğitim Sonrası Ağırlıklar',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      ...List.generate(state.trainedWeights!.length, (i) {
                        final wVal = state.trainedWeights![i];
                        return _ResultBox(
                          title: 'w${i + 1}*',
                          value: wVal.toStringAsFixed(1),
                          width: widget.fieldWidth,
                        );
                      }),

                      _ResultBox(
                        title: 'φ*',
                        value: state.trainedBiasWeight!.toStringAsFixed(1),
                        width: widget.fieldWidth,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

class _ResultBox extends StatelessWidget {
  final String title;
  final String value;
  final double width;

  const _ResultBox({
    required this.title,
    required this.value,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppPaddings.xSmallVertical,
            child: Text(title, style: Theme.of(context).textTheme.labelSmall),
          ),
          Container(
            height: 40,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F7),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E5EA)),
            ),
            child: Text(value, style: Theme.of(context).textTheme.labelSmall),
          ),
        ],
      ),
    );
  }
}
