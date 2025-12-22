import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perceptron_delta_lab/viewmodel/data_set/data_set_table_cubit.dart';
import 'package:perceptron_delta_lab/ui/screens/data_set/components/table_body_row_index.dart';
import 'package:perceptron_delta_lab/ui/screens/data_set/components/table_body_row_clear.dart';
import 'package:perceptron_delta_lab/ui/screens/data_set/components/table_row_input.dart';

class TableBody extends StatefulWidget {
  const TableBody({super.key});

  @override
  State<TableBody> createState() => _TableBodyState();
}

class _TableBodyState extends State<TableBody> {
  List<List<TextEditingController>> _controllers = [];

  void _rebuildControllersIfNeeded(DataSetTableState state) {
    final rows = state.rowCount;
    final cols = state.inputCount + 1;

    final needRebuild =
        _controllers.isEmpty ||
        _controllers.length != rows ||
        _controllers.first.length != cols;

    if (needRebuild) {
      for (final rowCtrls in _controllers) {
        for (final c in rowCtrls) {
          c.dispose();
        }
      }
      _controllers = List.generate(rows, (r) {
        return List.generate(cols, (c) {
          final txt = state.samples[r][c] ?? '';
          return TextEditingController(text: txt);
        });
      });
    } else {
      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
          final want = (state.samples[r][c] ?? '');
          final ctrl = _controllers[r][c];
          if (ctrl.text != want) {
            ctrl.value = ctrl.value.copyWith(
              text: want,
              selection: TextSelection.collapsed(offset: want.length),
            );
          }
        }
      }
    }
  }

  @override
  void dispose() {
    for (final rowCtrls in _controllers) {
      for (final c in rowCtrls) {
        c.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataSetTableCubit, DataSetTableState>(
      buildWhen: (p, n) =>
          p.inputCount != n.inputCount ||
          p.rowCount != n.rowCount ||
          p.samples != n.samples,
      builder: (context, state) {
        _rebuildControllersIfNeeded(state);

        return Column(
          children: [
            // TABLONUN SATIRLARI
            ...List.generate(state.rowCount, (row) {
              final cells = <Widget>[];

              for (int col = 0; col < state.inputCount; col++) {
                final ctrl = _controllers[row][col];
                cells.add(
                  Expanded(
                    child: TableRowInput(
                      controller: ctrl,
                      onChanged: (t) => context.read<DataSetTableCubit>().setCell(
                        row,
                        col,
                        t.isEmpty ? null : t,
                      ),
                    ),
                  ),
                );
              }

              final yCtrl = _controllers[row][state.inputCount];
              cells.add(
                Expanded(
                  child: TableRowInput(
                    controller: yCtrl,
                    onChanged: (t) => context.read<DataSetTableCubit>().setCell(
                      row,
                      state.inputCount,
                      t.isEmpty ? null : t,
                    ),
                  ),
                ),
              );

              return Row(
                children: [
                  Expanded(child: TableBodyRowIndex(title: '${row + 1}')),
                  ...cells,
                  Expanded(
                    child: TableBodyRowClear(
                      onTap: () {
                        context.read<DataSetTableCubit>().clearRow(row);
                        for (int c = 0; c <= state.inputCount; c++) {
                          _controllers[row][c].clear();
                        }
                      },
                    ),
                  ),
                ],
              );
            }),

            const SizedBox(height: 8),

            // SATIR + / - BUTONLARI
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  tooltip: 'Satır Sil',
                  onPressed: () {
                    context.read<DataSetTableCubit>().removeRow();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Satır Ekle',
                  onPressed: () {
                    context.read<DataSetTableCubit>().addRow();
                  },
                ),
              ],
            ),
          ],
        );

      },
    );
  }
}
