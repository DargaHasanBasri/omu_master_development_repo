import 'package:flutter/services.dart';
import '../export.dart';
import 'package:perceptron_delta_lab/viewmodel/delta_data_set/delta_data_set_table_cubit.dart';

class DeltaParamsBar extends StatefulWidget {
  const DeltaParamsBar({super.key, this.fieldWidth = 64});

  final double fieldWidth;

  @override
  State<DeltaParamsBar> createState() => _DeltaParamsBarState();
}

class _DeltaParamsBarState extends State<DeltaParamsBar> {
  final _numFmt = FilteringTextInputFormatter.allow(RegExp(r'[-0-9\.,]'));

  List<TextEditingController> _wCtrls = [];
  final _etaCtrl = TextEditingController();
  final _phiCtrl = TextEditingController();

  void _syncControllers(DeltaTableState s) {
    final k = s.columnCount;

    // W controller sayısı uymuyorsa baştan kur
    if (_wCtrls.length != k) {
      for (final c in _wCtrls) {
        c.dispose();
      }
      _wCtrls = List.generate(k, (_) => TextEditingController());
    }

    // Cubit -> UI (artır/azalt/clearAll sonrası)
    for (int i = 0; i < k; i++) {
      final want = s.weights[i] ?? '';
      if (_wCtrls[i].text != want) {
        _wCtrls[i].value = TextEditingValue(
          text: want,
          selection: TextSelection.collapsed(offset: want.length),
        );
      }
    }

    final wantEta = s.eta ?? '';
    if (_etaCtrl.text != wantEta) {
      _etaCtrl.value = TextEditingValue(
        text: wantEta,
        selection: TextSelection.collapsed(offset: wantEta.length),
      );
    }

    final wantPhi = s.phi ?? '';
    if (_phiCtrl.text != wantPhi) {
      _phiCtrl.value = TextEditingValue(
        text: wantPhi,
        selection: TextSelection.collapsed(offset: wantPhi.length),
      );
    }
  }

  @override
  void dispose() {
    for (final c in _wCtrls) {
      c.dispose();
    }
    _etaCtrl.dispose();
    _phiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeltaTableCubit, DeltaTableState>(
      buildWhen: (p, n) =>
      p.columnCount != n.columnCount ||
          p.weights != n.weights ||
          p.eta != n.eta ||
          p.phi != n.phi ||
          p.trainedW != n.trainedW ||
          p.trainedPhi != n.trainedPhi ||
          p.hasTrained != n.hasTrained,
      builder: (context, state) {
        _syncControllers(state);

        return Column(
          children: [
            // --------- Parametre input alanları ---------
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                // w1..wk (dinamik)
                ...List.generate(state.columnCount, (i) {
                  return SizedBox(
                    width: widget.fieldWidth,
                    child: CustomTextFormField(
                      key: ValueKey('delta_w_$i'),
                      textFormTitle: 'w${i + 1}',
                      textFormWidth: widget.fieldWidth,
                      textEditingController: _wCtrls[i],
                      hintText: '0.0000',
                      inputType: const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      inputFormatters: [_numFmt],
                      onChanged: (t) {
                        context.read<DeltaTableCubit>().setWeight(
                          i,
                          t.isEmpty ? null : t.replaceAll(',', '.'),
                        );
                      },
                    ),
                  );
                }),

                // η
                SizedBox(
                  width: widget.fieldWidth,
                  child: CustomTextFormField(
                    key: const ValueKey('delta_eta'),
                    textFormTitle: 'η',
                    textFormWidth: widget.fieldWidth,
                    textEditingController: _etaCtrl,
                    hintText: '0.1000',
                    inputType: const TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    inputFormatters: [_numFmt],
                    onChanged: (t) {
                      context.read<DeltaTableCubit>().setEta(
                        t.isEmpty ? null : t.replaceAll(',', '.'),
                      );
                    },
                  ),
                ),

                // φ (bias)
                SizedBox(
                  width: widget.fieldWidth,
                  child: CustomTextFormField(
                    key: const ValueKey('delta_phi'),
                    textFormTitle: 'φ',
                    textFormWidth: widget.fieldWidth,
                    textEditingController: _phiCtrl,
                    hintText: '0.5000',
                    inputType: const TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    inputFormatters: [_numFmt],
                    onChanged: (t) {
                      context.read<DeltaTableCubit>().setPhi(
                        t.isEmpty ? null : t.replaceAll(',', '.'),
                      );
                    },
                  ),
                ),
              ],
            ),

            // --------- Eğitim sonrası değerler ---------
            if (state.hasTrained &&
                state.trainedW != null &&
                state.trainedPhi != null) ...[
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
                      ...List.generate(state.trainedW!.length, (i) {
                        final wVal = state.trainedW![i];
                        return _DeltaResultBox(
                          title: 'w${i + 1}*',
                          value: wVal.toStringAsFixed(4),
                          width: widget.fieldWidth,
                        );
                      }),

                      _DeltaResultBox(
                        title: 'φ*',
                        value: state.trainedPhi!.toStringAsFixed(4),
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

class _DeltaResultBox extends StatelessWidget {
  final String title;
  final String value;
  final double width;

  const _DeltaResultBox({
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
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelSmall,
            ),
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
            child: Text(
              value,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}
