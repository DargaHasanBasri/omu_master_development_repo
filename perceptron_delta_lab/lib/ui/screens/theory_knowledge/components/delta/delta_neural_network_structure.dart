import '../../export.dart';

class DeltaNeuralNetworkStructure extends StatelessWidget
    with TheoryScreenTitleMixin {
  const DeltaNeuralNetworkStructure({super.key});

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
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 8,
          children: [
            _buildDecoratedBox(context, title: 'xᵢ'),
            _buildRightArrow(),
            _buildDecoratedBox(context, title: 'Σ'),
            _buildRightArrow(),
            _buildDecoratedBox(context, title: 'ŷ'),
            _buildRightArrow(),
            _buildDecoratedBox(context, title: 't'),
            _buildRightArrow(),
            _buildDecoratedBox(context, title: 'e'),
            _buildRightArrow(),
            _buildDecoratedBox(context, title: 'w,b'),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 8,
          children: [
            _buildTitle(context, title: inputs),
            _buildRightArrow(),
            _buildTitle(context, title: addition),
            _buildRightArrow(),
            _buildTitle(context, title: guess),
            _buildRightArrow(),
            _buildTitle(context, title: target),
            _buildRightArrow(),
            _buildTitle(context, title: mistake),
            _buildRightArrow(),
            _buildTitle(context, title: update),
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
