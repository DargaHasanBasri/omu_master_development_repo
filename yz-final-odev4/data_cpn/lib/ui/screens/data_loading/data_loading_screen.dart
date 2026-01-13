import 'package:data_cpn/routes/app_route_names.dart';
import 'package:data_cpn/ui/screens/data_loading/export.dart';
import 'package:data_cpn/viewmodel/data_loading/data_loading_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataLoadingScreen extends StatelessWidget {
  const DataLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DataLoadingCubit(),
      child: const _DataLoadingView(),
    );
  }
}

class _DataLoadingView extends StatelessWidget {
  const _DataLoadingView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DataLoadingCubit>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Veri Yükleme',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: BlocListener<DataLoadingCubit, DataLoadingState>(
        listenWhen: (p, c) => p.errorMessage != c.errorMessage && c.errorMessage != null,
        listener: (context, state) {
          final msg = state.errorMessage;
          if (msg == null) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: AppPaddings.largeAll,
              child: BlocBuilder<DataLoadingCubit, DataLoadingState>(
                builder: (context, state) {
                  final isLoading = state.status == DataLoadingStatus.loading;
                  final enabled = !isLoading && state.isValid;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: AppPaddings.mediumBottom,
                        child: Text(
                          'Veri Seti Yükle',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22),
                        ),
                      ),
                      Text(
                        'Lütfen CPN algoritması analizi için x1, x2 ve y_norm '
                            'sütunlarını içeren dosyanızı seçin.',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: ColorName.iron,
                        ),
                      ),

                      Padding(
                        padding: AppPaddings.xLargeVertical,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: ColorName.dark,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DottedBorder(
                            options: const RoundedRectDottedBorderOptions(
                              dashPattern: [10, 5],
                              strokeWidth: 2,
                              padding: AppPaddings.xLargeAll,
                              color: ColorName.darkGreyBlue,
                              radius: Radius.circular(12),
                              stackFit: StackFit.passthrough,
                            ),
                            child: Column(
                              spacing: 12,
                              children: [
                                Container(
                                  padding: AppPaddings.largeAll,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorName.ebonyClay,
                                  ),
                                  child: Assets.icons.icLoadingData.image(
                                    package: AppConstants.packageGenName,
                                  ),
                                ),
                                Text(
                                  'Dosya Seçmek İçin Dokun',
                                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '.csv veya .xlsx formatları kabul edilir.',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: ColorName.glacier,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                Padding(
                                  padding: AppPaddings.mediumTop,
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(8),
                                        onTap: isLoading ? null : () => cubit.pickFile(),
                                        child: Ink(
                                          padding: AppPaddings.largeHorizontal +
                                              AppPaddings.smallVertical,
                                          decoration: BoxDecoration(
                                            color: ColorName.darkBlueGrey,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: isLoading
                                              ? const SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                              : Text(
                                            'Göz At',
                                            style: Theme.of(context).textTheme.labelLarge,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Seçilen dosya kartı
                      if (state.fileName != null)
                        Padding(
                          padding: AppPaddings.smallBottom,
                          child: Container(
                            padding: AppPaddings.mediumAll,
                            decoration: BoxDecoration(
                              color: ColorName.ebonyClay,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.description, color: ColorName.glacier),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.fileName!,
                                        style: Theme.of(context).textTheme.headlineSmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${state.prettySize} • ${state.columns.length} sütun • '
                                            '${state.rowsRead} okundu'
                                            '${state.rowsSkipped > 0 ? ' • ${state.rowsSkipped} atlandı' : ''}',
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: ColorName.glacier,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  state.isValid ? Icons.verified : Icons.error_outline,
                                  color: state.isValid
                                      ? ColorName.darkMintGreen
                                      : Colors.orangeAccent,
                                ),
                              ],
                            ),
                          ),
                        ),

                      if (state.fileName != null && !state.isValid)
                        Padding(
                          padding: AppPaddings.smallBottom,
                          child: Text(
                            'Dosyada x1, x2 ve y_norm sütunları bulunmalı.',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.orangeAccent,
                            ),
                          ),
                        ),

                      // CTA -> ParameterSettings
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: !enabled
                              ? null
                              : () {
                            context.pushNamed(
                              AppRouteNames.parameterSettings,
                              extra: {
                                'x': state.x, // List<List<double>>
                                'y': state.y, // List<double> (y_norm)
                                'fileName': state.fileName,
                                'columns': state.columns,
                              },
                            );
                          },
                          child: Ink(
                            padding: AppPaddings.mediumAll,
                            decoration: BoxDecoration(
                              color: enabled ? ColorName.blueDress : ColorName.darkBlueGrey,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: enabled
                                  ? [
                                BoxShadow(
                                  color: ColorName.blueDress.withValues(alpha: 0.25),
                                  offset: const Offset(0, 15),
                                  blurRadius: 15,
                                  spreadRadius: -3,
                                ),
                              ]
                                  : null,
                            ),
                            child: Text(
                              'Yükle ve Analiz Et',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontSize: 18,
                                color: Colors.white.withValues(alpha: enabled ? 1.0 : 0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
