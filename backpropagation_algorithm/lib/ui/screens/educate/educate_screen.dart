import 'package:backpropagation_algorithm/routes/app_route_names.dart';
import 'package:backpropagation_algorithm/ui/screens/educate/export.dart';
import 'package:backpropagation_algorithm/viewmodel/backprop/backprob_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EducateScreen extends StatefulWidget {
  const EducateScreen({super.key});

  @override
  State<EducateScreen> createState() => _EducateScreenState();
}

class _EducateScreenState extends State<EducateScreen> {
  late final TextEditingController learningRate;
  late final TextEditingController numberNeurons;
  late final TextEditingController totalEpoch;

  @override
  void initState() {
    super.initState();
    learningRate = TextEditingController();
    numberNeurons = TextEditingController();
    totalEpoch = TextEditingController();
  }

  @override
  void dispose() {
    learningRate.dispose();
    numberNeurons.dispose();
    totalEpoch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BackpropCubit, BackpropState>(
      listenWhen: (prev, curr) =>
          prev.isTraining == true && curr.isTraining == false,
      listener: (context, state) {
        if (state.error == null && state.metricsTest.isNotEmpty) {
          context.pushNamed(AppRouteNames.metrics);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: AppPaddings.mediumAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: AppPaddings.xSmallBottom,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: const Icon(Icons.arrow_back_ios),
                        ),
                        Text(
                          'Model Eğitimi',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SingleChildScrollView(
                        padding: AppPaddings.smallAll,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          spacing: 24,
                          children: [
                            const EducationalStatus(),
                            HyperparametersInputs(
                              learningRate: learningRate,
                              numberNeurons: numberNeurons,
                              totalEpoch: totalEpoch,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
