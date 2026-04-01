import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:interval_halving_method/routes/app_route_names.dart';
import 'package:interval_halving_method/ui/screens/home/export.dart';
import 'package:interval_halving_method/view_model/optimization_cubit.dart';
import 'package:interval_halving_method/view_model/optimization_state.dart'; // State'leri import etmeyi unutma

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lowerLimitController = TextEditingController();
    final upperLimitController = TextEditingController();
    final errorToleranceController = TextEditingController();

    return BlocListener<OptimizationCubit, OptimizationState>(
      listener: (context, state) {
        if (state is OptimizationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hesaplama tamamlandı!'),
              backgroundColor: Colors.green,
            ),
          );

          // go_router ile İterasyon ekranına geçiş yapıyoruz:
          context.pushNamed(AppRouteNames.iterationName);
        }
        // Eğer formül yazımında veya hesaplamada hata olduysa:
        else if (state is OptimizationError) {
          debugPrint('❌ HATA: ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          backgroundColor: ColorName.white,
          title: Text(
            'Interval Halving',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: AppPaddings.largeAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Assets.icons.icFunction.image(
                      package: AppConstants.packageGenName,
                    ),
                    Text(
                      'AMAÇ FONKSİYONU',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
                Container(
                  margin: AppPaddings.smallTop,
                  padding: AppPaddings.mediumAll,
                  decoration: BoxDecoration(
                    color: ColorName.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ColorName.catskillWhite),
                    boxShadow: [
                      BoxShadow(
                        color: ColorName.black.withValues(alpha: 0.05),
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Function f(x)',
                        style:
                            Theme.of(
                              context,
                            ).textTheme.labelSmall?.copyWith(
                              color: ColorName.blueGrey,
                            ),
                      ),
                      const MathInputCard(),
                    ],
                  ),
                ),
                const Padding(
                  padding: AppPaddings.smallVertical,
                  child: ObjectiveToggle(),
                ),
                Padding(
                  padding: AppPaddings.smallTop,
                  child: Row(
                    spacing: 8,
                    children: [
                      Assets.icons.icLimit.image(
                        package: AppConstants.packageGenName,
                      ),
                      Text(
                        'İNTERVAL LİMİTS [a, b]',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: AppPaddings.smallVertical,
                  child: IntervalInputCard(
                    lowerLimitController: lowerLimitController,
                    upperLimitController: upperLimitController,
                  ),
                ),
                Padding(
                  padding: AppPaddings.smallVertical,
                  child: Row(
                    spacing: 8,
                    children: [
                      Assets.icons.icCalculator.image(
                        package: AppConstants.packageGenName,
                        color: ColorName.blueDress,
                      ),
                      Text(
                        'PARAMETRELER',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                ),
                ErrorToleranceCard(
                  controller: errorToleranceController,
                ),
                Padding(
                  padding: AppPaddings.xLargeVertical,
                  child: PrimaryActionButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      final funcString = context.read<FunctionCubit>().state;
                      final aVal = double.tryParse(lowerLimitController.text);
                      final bVal = double.tryParse(upperLimitController.text);
                      final epsVal = double.tryParse(
                        errorToleranceController.text,
                      );
                      final objective = context.read<ObjectiveCubit>().state;

                      if (funcString.isEmpty ||
                          aVal == null ||
                          bVal == null ||
                          epsVal == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Lütfen tüm alanları geçerli değerlerle doldurun.',
                            ),
                          ),
                        );
                        return;
                      }

                      // 2. Çözüm metodunu tetikliyoruz. Bu bitince yukarıdaki BlocListener çalışacak.
                      context.read<OptimizationCubit>().solve(
                        functionString: funcString,
                        lowerLimit: aVal,
                        upperLimit: bVal,
                        epsilon: epsVal,
                        objective: objective,
                      );
                    },
                    text: 'Optimizasyonu Çöz',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
