import 'package:backpropagation_algorithm/ui/screens/data/export.dart';
import 'package:backpropagation_algorithm/viewmodel/backprop/backprob_cubit.dart';
import 'package:backpropagation_algorithm/viewmodel/backprop/file_cubit.dart';

class UploadDataset extends StatelessWidget {
  const UploadDataset({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FileCubit, FileState>(
      listenWhen: (prev, curr) =>
      prev.csvText != curr.csvText && curr.csvText != null,
      listener: (context, fileState) {
        context.read<BackpropCubit>().loadCsv(fileState.csvText!);
      },
      child: BlocBuilder<FileCubit, FileState>(
        builder: (context, fileState) {
          return BlocBuilder<BackpropCubit, BackpropState>(
            builder: (context, backpropState) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: ColorName.pastelBlue.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DottedBorder(
                  options: const RoundedRectDottedBorderOptions(
                    dashPattern: [10, 5],
                    strokeWidth: 2,
                    padding: AppPaddings.largeAll,
                    color: ColorName.pastelBlue,
                    radius: Radius.circular(16),
                    stackFit: StackFit.passthrough,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: AppPaddings.mediumAll,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorName.white,
                          boxShadow: [
                            BoxShadow(
                              color: ColorName.black.withValues(alpha: 0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Assets.icons.icData.image(
                          package: AppConstants.packageName,
                          color: ColorName.black,
                        ),
                      ),
                      Padding(
                        padding:
                        AppPaddings.mediumTop + AppPaddings.xXSmallBottom,
                        child: Text(
                          'Veri Seti Yükle',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                      Text(
                        'CSV formatında veri setinizi yükleyin',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: ColorName.paleSky),
                      ),

                      if (fileState.fileName != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Seçilen dosya: ${fileState.fileName}',
                          style: Theme.of(context).textTheme.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                      ],

                      if (backpropState.dataset != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Satır: ${backpropState.dataset!.n} • Özellik: ${backpropState.dataset!.d}',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: ColorName.paleSky),
                        ),
                      ],

                      Padding(
                        padding: AppPaddings.mediumVertical,
                        child: CustomButton(
                          onTapButton: () {
                            if (fileState.isPicking) return;
                            context.read<FileCubit>().pickCsv();
                          },
                          title: fileState.isPicking ? 'Seçiliyor...' : 'Dosya Seç',
                          backgroundColor: const [
                            ColorName.warmBlue,
                            ColorName.blueViolet,
                          ],
                        ),
                      ),

                      if (fileState.error != null) ...[
                        Text(
                          fileState.error!,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: ColorName.radicalRed),
                        ),
                      ],
                      if (backpropState.error != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          backpropState.error!,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: ColorName.radicalRed),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
