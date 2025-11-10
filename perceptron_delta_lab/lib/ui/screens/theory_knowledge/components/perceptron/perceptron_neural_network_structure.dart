import '../../export.dart';

class PerceptronNeuralNetworkStructure extends StatelessWidget
    with TheoryScreenTitleMixin {
  const PerceptronNeuralNetworkStructure({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          spacing: 8,
          children: [
            Text('🔄', style: Theme.of(context).textTheme.titleLarge),
            Text(
              neuralNetworkStructure,
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontSize: 20),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDecoratedBox(context, title: 'x₁'),
            _buildRightArrow(),
            _buildDecoratedBox(context, title: 'Σ'),
            _buildRightArrow(),
            _buildDecoratedBox(context, title: 'f()'),
            _buildRightArrow(),
            _buildDecoratedBox(context, title: 'y'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTitle(context, title: inputs),
            _buildRightArrow(),
            _buildTitle(context, title: addition),
            _buildRightArrow(),
            _buildTitle(context, title: activation),
            _buildRightArrow(),
            _buildTitle(context, title: output),
          ],
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, {required String title}) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w400,
        color: ColorName.monsoon,
      ),
    );
  }

  Widget _buildRightArrow() {
    return Assets.icons.icRightArrowThin.image(
      package: AppConstants.packageName,
    );
  }

  Widget _buildDecoratedBox(BuildContext context, {required String title}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ColorName.cornflower, ColorName.darkLavender],
        ),
      ),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.transparent,
        child: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: ColorName.white),
        ),
      ),
    );
  }
}
