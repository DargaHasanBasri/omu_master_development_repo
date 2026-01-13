import 'package:data_cpn/routes/app_route_names.dart';
import 'package:data_cpn/ui/screens/model_training/export.dart';
import 'package:data_cpn/viewmodel/model_training/model_training_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModelTrainingScreen extends StatelessWidget {
  const ModelTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;

    return BlocProvider(
      create: (_) => ModelTrainingCubit()..initAndStart(extra),
      child: const _ModelTrainingView(),
    );
  }
}

class _ModelTrainingView extends StatelessWidget {
  const _ModelTrainingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Model Eğitimi',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: BlocListener<ModelTrainingCubit, ModelTrainingState>(
        listenWhen: (p, c) =>
            p.errorMessage != c.errorMessage && c.errorMessage != null,
        listener: (context, state) {
          final msg = state.errorMessage;
          if (msg == null) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
        },
        child: BlocBuilder<ModelTrainingCubit, ModelTrainingState>(
          builder: (context, state) {
            final canViewResults = state.isDone && state.results.isNotEmpty;

            final step1Done = state.stage != TrainingStage.preparing;
            final step2Done =
                state.stage == TrainingStage.training ||
                state.stage == TrainingStage.validating ||
                state.stage == TrainingStage.done;

            final step3Active = state.stage == TrainingStage.training;
            final step3Done =
                state.stage == TrainingStage.validating ||
                state.stage == TrainingStage.done;

            final step4Active = state.stage == TrainingStage.validating;
            final step4Done = state.stage == TrainingStage.done;

            final radiusLabel = (state.currentRadius != null)
                ? 'Radius: ${state.currentRadius!.toStringAsFixed(2)}'
                : 'Radius: -';

            return SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: AppPaddings.largeHorizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header card
                      Container(
                        padding: AppPaddings.mediumAll,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: ColorName.dark,
                          border: Border.all(
                            color: ColorName.blueDress.withValues(alpha: 0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: ColorName.black.withValues(alpha: 0.2),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                          gradient: LinearGradient(
                            stops: const [0.0, 0.5, 1.0],
                            colors: [
                              ColorName.mirage,
                              ColorName.mirage.withValues(alpha: 0),
                              ColorName.mirage.withValues(alpha: 0),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: AppPaddings.mediumAll,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorName.blueDress.withValues(
                                  alpha: 0.2,
                                ),
                                border: Border.all(color: ColorName.blueDress),
                              ),
                              child: Assets.icons.icLogo.image(
                                package: AppConstants.packageGenName,
                              ),
                            ),
                            Padding(
                              padding: AppPaddings.smallTop,
                              child: Text(
                                state.isDone
                                    ? 'Eğitim Tamamlandı ✅'
                                    : 'Model Eğitiliyor...',
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                            ),
                            Padding(
                              padding: AppPaddings.xXSmallTop,
                              child: Text(
                                '$radiusLabel • ${state.fileName ?? ''}',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(color: ColorName.glacier),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Progress card
                      Padding(
                        padding: AppPaddings.largeVertical,
                        child: OverallProgressCard(
                          epochTotal: state.epochTotal,
                          epochCurrent: state.epochCurrent,
                          loss: state.loss,
                          etaText: state.etaText,
                        ),
                      ),

                      // Training steps
                      Container(
                        padding: AppPaddings.largeAll,
                        decoration: BoxDecoration(
                          color: ColorName.dark,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: ColorName.black.withValues(alpha: 0.05),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 8,
                              children: [
                                Assets.icons.icStartEducate.image(
                                  package: AppConstants.packageGenName,
                                ),
                                Text(
                                  'Eğitim Aşamaları',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displayLarge,
                                ),
                              ],
                            ),
                            Padding(
                              padding: AppPaddings.smallAll,
                              child: Column(
                                children: [
                                  _StepRow(
                                    title: 'Veri Hazırlama',
                                    subtitle: 'Veri seti eğitim/test ayrıldı.',
                                    status: step1Done
                                        ? _StepStatus.done
                                        : _StepStatus.active,
                                  ),
                                  const SizedBox(height: 12),
                                  _StepRow(
                                    title: 'Ağ Topolojisi',
                                    subtitle:
                                        'R listesi alındı, eğitim başlıyor.',
                                    status: step2Done
                                        ? _StepStatus.done
                                        : _StepStatus.pending,
                                  ),
                                  const SizedBox(height: 12),
                                  _StepRow(
                                    title: 'Ağırlıkların Güncellenmesi',
                                    subtitle: step3Active
                                        ? 'Kohonen katmanı eğitiliyor...'
                                        : (step3Done
                                              ? 'Eğitim tamamlandı.'
                                              : 'Bekleniyor...'),
                                    status: step3Active
                                        ? _StepStatus.active
                                        : (step3Done
                                              ? _StepStatus.done
                                              : _StepStatus.pending),
                                    activeColor: ColorName.blueDress,
                                  ),
                                  const SizedBox(height: 12),
                                  _StepRow(
                                    title: 'Model Doğrulama',
                                    subtitle: step4Active
                                        ? 'Train/Test metrikleri hesaplanıyor...'
                                        : (step4Done
                                              ? 'Doğrulama tamamlandı.'
                                              : 'Bekleniyor...'),
                                    status: step4Active
                                        ? _StepStatus.active
                                        : (step4Done
                                              ? _StepStatus.done
                                              : _StepStatus.pending),
                                    activeColor: ColorName.blueDress,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // küçük özet (istersen kaldır)
                      if (state.results.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        Text(
                          'Anlık Sonuçlar',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 8),
                        for (final r in state.results)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              padding: AppPaddings.mediumAll,
                              decoration: BoxDecoration(
                                color: ColorName.ebonyClay,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'r=${r.radius.toStringAsFixed(2)} • kural=${r.ruleCount} • '
                                'Train RMSE=${r.train.rmse.toStringAsFixed(3)} • '
                                'Test RMSE=${r.test.rmse.toStringAsFixed(3)}',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(color: ColorName.glacier),
                              ),
                            ),
                          ),
                      ],

                      // CTA
                      Padding(
                        padding: AppPaddings.mediumVertical,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: !canViewResults
                                ? null
                                : () {
                                    context.pushNamed(
                                      AppRouteNames.reporting,
                                      extra: {
                                        'results': state.results,
                                        'fileName': state.fileName,
                                        'epochTotal': state.epochTotal,
                                        'trainingTimeMs': state.trainingTimeMs,
                                      },
                                    );
                                  },
                            child: Ink(
                              padding: AppPaddings.mediumAll,
                              decoration: BoxDecoration(
                                color: canViewResults
                                    ? ColorName.blueDress
                                    : ColorName.darkBlueGrey,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: canViewResults
                                    ? [
                                        BoxShadow(
                                          color: ColorName.blueDress.withValues(
                                            alpha: 0.25,
                                          ),
                                          offset: const Offset(0, 15),
                                          blurRadius: 15,
                                          spreadRadius: -3,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                'Sonuçları Görüntüle',
                                style: Theme.of(context).textTheme.headlineLarge
                                    ?.copyWith(
                                      fontSize: 18,
                                      color: Colors.white.withValues(
                                        alpha: canViewResults ? 1.0 : 0.6,
                                      ),
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

enum _StepStatus { done, active, pending }

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.title,
    required this.subtitle,
    required this.status,
    this.activeColor = ColorName.glacier,
  });

  final String title;
  final String subtitle;
  final _StepStatus status;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color borderColor;
    Color iconColor;
    Color titleColor;

    switch (status) {
      case _StepStatus.done:
        icon = Icons.check;
        borderColor = ColorName.darkMintGreen;
        iconColor = ColorName.darkMintGreen;
        titleColor = Colors.white;
        break;
      case _StepStatus.active:
        icon = Icons.refresh;
        borderColor = activeColor;
        iconColor = activeColor;
        titleColor = activeColor;
        break;
      case _StepStatus.pending:
        icon = Icons.circle_outlined;
        borderColor = ColorName.glacier;
        iconColor = ColorName.glacier;
        titleColor = ColorName.glacier;
        break;
    }

    return Row(
      children: [
        Container(
          padding: AppPaddings.xSmallAll,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: titleColor),
            ),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: ColorName.glacier),
            ),
          ],
        ),
      ],
    );
  }
}
