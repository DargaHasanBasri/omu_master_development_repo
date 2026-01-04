import 'package:backpropagation_algorithm/ui/screens/data/export.dart';
import 'package:backpropagation_algorithm/viewmodel/backprop/backprob_cubit.dart';

class DataPreview extends StatelessWidget {
  const DataPreview({super.key, this.maxRows = 10});

  final int maxRows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.largeAll,
      decoration: BoxDecoration(
        color: ColorName.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorName.black.withValues(alpha: 0.1),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Veri Önizleme',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),

          BlocBuilder<BackpropCubit, BackpropState>(
            builder: (context, state) {
              final ds = state.dataset;

              if (ds == null) {
                return Container(
                  width: double.infinity,
                  padding: AppPaddings.xLargeAll,
                  decoration: BoxDecoration(
                    color: ColorName.alabaster,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Veri yüklendikten sonra burada görüntülenecek',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: ColorName.paleSky),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final rowCount = ds.n;
              final previewCount = rowCount < maxRows ? rowCount : maxRows;

              final columns = <String>[...ds.featureNames, 'y'];

              return Container(
                decoration: BoxDecoration(
                  color: ColorName.alabaster,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: AppPaddings.smallAll,
                      child: Text(
                        'Toplam: $rowCount satır • ${ds.d} özellik • Önizleme: $previewCount satır',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: ColorName.paleSky,
                        ),
                      ),
                    ),

                    const Divider(height: 1),

                    SizedBox(
                      height: 320,
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: columns.length * 140,
                            child: ListView.separated(
                              padding: AppPaddings.smallAll,
                              itemCount: previewCount + 1, // +1 header
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  // HEADER
                                  return _HeaderRow(columns: columns);
                                }

                                final i = index - 1;
                                final xRow = ds.x[i];
                                final yVal = ds.y[i];

                                final cells = <String>[
                                  ...xRow.map(_fmt),
                                  _fmt(yVal),
                                ];

                                return _DataRow(cells: cells);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  static String _fmt(double v) {
    // çok uzun float’ları kırp
    final s = v.toStringAsFixed(4);
    // 1.0000 -> 1
    return s.replaceAll(RegExp(r'\.?0+$'), '');
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.columns});
  final List<String> columns;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: columns
          .map(
            (c) => Container(
              width: 120,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: ColorName.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ColorName.pastelBlue),
              ),
              child: Text(
                c,
                style: Theme.of(context).textTheme.labelSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({required this.cells});
  final List<String> cells;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: cells
          .map(
            (v) => Container(
              width: 120,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: ColorName.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                v,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: ColorName.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
    );
  }
}
