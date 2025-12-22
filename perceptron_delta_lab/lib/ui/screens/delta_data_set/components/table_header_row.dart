import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perceptron_delta_lab/ui/screens/delta_data_set/components/table_header_decrease.dart';
import 'package:perceptron_delta_lab/ui/screens/delta_data_set/components/table_header_increase.dart';
import 'package:perceptron_delta_lab/ui/screens/delta_data_set/components/table_header_row_item.dart';
import '../../../../viewmodel/delta_data_set/delta_data_set_table_cubit.dart';

class TableHeaderRow extends StatelessWidget {
  const TableHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeltaTableCubit, DeltaTableState>(
      builder: (context, state) {
        final children = <Widget>[
          Expanded(
            child: TableHeaderDecrease(
              onTap: () => context.read<DeltaTableCubit>().decrease(),
            ),
          ),
          ...List.generate(
            state.columnCount,
            (i) => Expanded(
              child: TableHeaderRowItem(title: 'x${subscript(i + 1)}'),
            ),
          ),
          const Expanded(child: TableHeaderRowItem(title: 'y')),
          Expanded(
            child: TableHeaderIncrease(
              onTap: () => context.read<DeltaTableCubit>().increase(),
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
