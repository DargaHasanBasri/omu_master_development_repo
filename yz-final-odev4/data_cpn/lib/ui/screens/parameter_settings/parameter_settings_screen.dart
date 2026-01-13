import 'package:data_cpn/routes/app_route_names.dart';
import 'package:data_cpn/ui/screens/parameter_settings/export.dart';
import 'package:data_cpn/viewmodel/parameter_settings/parameter_settings_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParameterSettingsScreen extends StatelessWidget {
  const ParameterSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;

    return BlocProvider(
      create: (_) => ParameterSettingsCubit()..initFromExtra(extra),
      child: const _ParameterSettingsView(),
    );
  }
}

class _ParameterSettingsView extends StatefulWidget {
  const _ParameterSettingsView();

  @override
  State<_ParameterSettingsView> createState() => _ParameterSettingsViewState();
}

class _ParameterSettingsViewState extends State<_ParameterSettingsView> {
  final List<TextEditingController> _controllers = [];
  late final TextEditingController _epochController;

  @override
  void initState() {
    super.initState();

    _epochController = TextEditingController();
    _epochController.addListener(() {
      context.read<ParameterSettingsCubit>().setEpochLimitText(
        _epochController.text,
      );
    });

    _ensureControllerCount(4);
  }

  @override
  void dispose() {
    _epochController.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _ensureControllerCount(int targetCount) {
    final cubit = context.read<ParameterSettingsCubit>();

    while (_controllers.length < targetCount) {
      final index = _controllers.length;
      final c = TextEditingController();

      c.addListener(() {
        cubit.setRadiusText(index, c.text);
      });

      _controllers.add(c);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ParameterSettingsCubit>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Parametre Ayarları',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: BlocListener<ParameterSettingsCubit, ParameterSettingsState>(
        listenWhen: (p, c) =>
            p.errorMessage != c.errorMessage && c.errorMessage != null,
        listener: (context, state) {
          final msg = state.errorMessage;
          if (msg == null) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
        },
        child: BlocBuilder<ParameterSettingsCubit, ParameterSettingsState>(
          builder: (context, state) {
            _ensureControllerCount(state.radiusTexts.length);

            final canStart =
                state.isValid && (state.x != null) && (state.y != null);

            return SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: AppPaddings.largeHorizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: AppPaddings.mediumAll,
                        decoration: BoxDecoration(
                          color: ColorName.dark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: ColorName.darkGreyBlue),
                          boxShadow: [
                            BoxShadow(
                              color: ColorName.black.withValues(alpha: 0.05),
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          spacing: 12,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorName.blueDress.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                              child: Assets.icons.icInfo.image(
                                package: AppConstants.packageGenName,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CPN Algoritma Parametreleri',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelMedium,
                                  ),
                                  Text(
                                    'Algoritma eğitimi için kullanılacak yarıçap (radius) değerlerini giriniz. '
                                    'Bu değerler veri kümeleme hassasiyetini belirler.',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  if (state.fileName != null)
                                    Text(
                                      'Dosya: ${state.fileName} • Satır: ${state.sampleCount}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(color: ColorName.glacier),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: AppPaddings.largeVertical,
                        child: Column(
                          children: [
                            // ✅ Epoch sınırı (opsiyonel)
                            CustomTextFormField(
                              controller: _epochController,
                              textFieldTitle: 'Epoch Sınırı (Opsiyonel)',
                              inputType: TextInputType.number,
                              hintText: 'örn: 500',
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 16),

                            for (
                              int i = 0;
                              i < state.radiusTexts.length;
                              i++
                            ) ...[
                              CustomTextFormField(
                                controller: _controllers[i],
                                textFieldTitle: 'Yarıçap Değeri ${i + 1}',
                                inputType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                hintText: i == 0
                                    ? '0.5'
                                    : i == 1
                                    ? '1.0'
                                    : i == 2
                                    ? '1.5'
                                    : i == 3
                                    ? '2.0'
                                    : 'örn: 2.5',
                                textInputAction:
                                    i == state.radiusTexts.length - 1
                                    ? TextInputAction.done
                                    : TextInputAction.next,
                              ),
                              const SizedBox(height: 16),
                            ],

                            if (state.validationMessage != null)
                              Padding(
                                padding: AppPaddings.smallBottom,
                                child: Text(
                                  state.validationMessage!,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(color: Colors.orangeAccent),
                                ),
                              ),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => cubit.addRadiusField(),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: ColorName.dark,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: DottedBorder(
                                    options:
                                        const RoundedRectDottedBorderOptions(
                                          dashPattern: [10, 5],
                                          strokeWidth: 2,
                                          padding: AppPaddings.mediumAll,
                                          color: ColorName.darkGreyBlue,
                                          radius: Radius.circular(12),
                                          stackFit: StackFit.passthrough,
                                        ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      spacing: 8,
                                      children: [
                                        Assets.icons.icPlus.image(
                                          package: AppConstants.packageGenName,
                                        ),
                                        Text(
                                          'Yeni Yarıçap Ekle',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                color: ColorName.cadetGrey,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: AppPaddings.mediumBottom,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: !canStart
                                ? null
                                : () {
                                    context.pushNamed(
                                      AppRouteNames.modelTraining,
                                      extra: {
                                        'x': state.x,
                                        'y': state.y,
                                        'radii': state.radii,
                                        'fileName': state.fileName,
                                        'maxEpochPerRadius':
                                            state.maxEpochPerRadius,
                                      },
                                    );
                                  },
                            child: Ink(
                              padding: AppPaddings.mediumAll,
                              decoration: BoxDecoration(
                                color: canStart
                                    ? ColorName.blueDress
                                    : ColorName.darkBlueGrey,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: canStart
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
                                'Eğitimi Başlat',
                                style: Theme.of(context).textTheme.headlineLarge
                                    ?.copyWith(
                                      fontSize: 18,
                                      color: Colors.white.withValues(
                                        alpha: canStart ? 1.0 : 0.6,
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
