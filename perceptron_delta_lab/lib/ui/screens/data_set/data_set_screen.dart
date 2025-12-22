import 'package:flutter/services.dart';
import 'package:perceptron_delta_lab/ui/screens/data_set/components/table_body.dart';
import 'package:perceptron_delta_lab/viewmodel/data_set/data_set_table_cubit.dart';
import '../../../routes/app_route_names.dart';
import 'components/perceptron_params_bar.dart';
import 'components/table_header_row.dart';
import 'export.dart';

class DataSetScreen extends StatelessWidget {
  const DataSetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DataSetTableCubit(initialInputCount: 3),
      child: Builder(
        builder: (context) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: true,
            backgroundColor: ColorName.whiteSmoke,
            appBar: AppBar(
              backgroundColor: ColorName.white,
              title: Text(
                'Percepton Veri Seti',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              leading: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: CircleBorder(),
                  splashColor: ColorName.darkLavender.withValues(alpha: 0.3),
                  onTap: () => context.pop(),
                  child: Ink(
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Assets.icons.icArrowBack.image(
                      package: AppConstants.packageName,
                      color: ColorName.darkLavender,
                      scale: 1.6,
                    ),
                  ),
                ),
              ),
            ),
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SafeArea(
                bottom: false,
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(20),
                  child: SingleChildScrollView(
                    padding: AppPaddings.mediumVertical,
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: AppPaddings.largeAll + AppPaddings.smallBottom,
                      child: Column(
                        spacing: 20,
                        children: [
                          Container(
                            padding: AppPaddings.mediumAll,
                            decoration: BoxDecoration(
                              color: ColorName.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorName.black.withValues(
                                    alpha: 0.08,
                                  ),
                                  offset: Offset(0, 4),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              spacing: 8,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [PerceptronParamsBar()],
                            ),
                          ),
                          Container(
                            padding: AppPaddings.largeAll,
                            decoration: BoxDecoration(
                              color: ColorName.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorName.black.withValues(
                                    alpha: 0.08,
                                  ),
                                  offset: Offset(0, 4),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              spacing: 16,
                              children: [
                                Row(
                                  spacing: 8,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: ColorName.darkLavender,
                                    ),
                                    Text(
                                      'Girdiler',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(fontSize: 24),
                                    ),
                                  ],
                                ),
                                Column(
                                  spacing: 4,
                                  children: [
                                    const TableHeaderRow(),
                                    TableBody(),
                                  ],
                                ),
                                Row(
                                  spacing: 8,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
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
                                            context
                                                .read<DataSetTableCubit>()
                                                .applyDefaultDataset();
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
                                    Row(
                                      children: [
                                        Text(
                                          'Temizle',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.headlineSmall,
                                        ),
                                        SizedBox(width: 4),
                                        GestureDetector(
                                          onTap: () async {
                                            final cubit = context
                                                .read<DataSetTableCubit>();
                                            cubit.clearAll();
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
                                  ],
                                ),
                                Row(
                                  spacing: 8,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Eğit',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.headlineSmall,
                                        ),
                                        SizedBox(width: 4),
                                        GestureDetector(
                                          onTap: () async {
                                            final cubit = context
                                                .read<DataSetTableCubit>();
                                            try {
                                              final trace = await cubit
                                                  .trainPerceptronWithTrace(
                                                    maxEpochs: 500,
                                                  );
                                              if (!context.mounted) return;
                                              context.pushNamed(
                                                AppRouteNames.perceptronTrace,
                                                extra: trace,
                                              );
                                            } catch (e) {
                                              if (!context.mounted) return;
                                              await showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: const Text('Hata'),
                                                  content: Text('$e'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            context,
                                                          ),
                                                      child: const Text(
                                                        'Tamam',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
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
                                    Row(
                                      children: [
                                        Text(
                                          'Test Et',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.headlineSmall,
                                        ),
                                        SizedBox(width: 4),
                                        GestureDetector(
                                          onTap: () async {
                                            final cubit = context
                                                .read<DataSetTableCubit>();
                                            try {
                                              final result = await cubit
                                                  .testPerceptron();
                                              if (!context.mounted) return;

                                              context.pushNamed(
                                                AppRouteNames.perceptronTest,
                                                extra: result,
                                              );
                                            } catch (e) {
                                              if (!context.mounted) return;
                                              await showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: const Text('Hata'),
                                                  content: Text('$e'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            context,
                                                          ),
                                                      child: const Text(
                                                        'Tamam',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
