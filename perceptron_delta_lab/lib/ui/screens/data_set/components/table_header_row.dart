import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perceptron_delta_lab/ui/screens/data_set/components/table_header_decrease.dart';
import 'package:perceptron_delta_lab/ui/screens/data_set/components/table_header_increase.dart';
import 'package:perceptron_delta_lab/ui/screens/data_set/components/table_header_row_item.dart';
import 'package:perceptron_delta_lab/viewmodel/data_set/data_set_table_cubit.dart';

class TableHeaderRow extends StatelessWidget {
  const TableHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataSetTableCubit, DataSetTableState>(
      builder: (context, state) {
        final children = <Widget>[
          Expanded(
            child: TableHeaderDecrease(
              onTap: () => context.read<DataSetTableCubit>().decreaseInputs(),
            ),
          ),
          ...List.generate(
            state.inputCount,
            (i) => Expanded(
              child: TableHeaderRowItem(title: 'x${subscript(i + 1)}'),
            ),
          ),
          // y sabit
          const Expanded(child: TableHeaderRowItem(title: 'y')),
          Expanded(
            child: TableHeaderIncrease(
              onTap: () => context.read<DataSetTableCubit>().increaseInputs(),
            ),
          ),
        ];

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        );
      },
    );
  }
}
