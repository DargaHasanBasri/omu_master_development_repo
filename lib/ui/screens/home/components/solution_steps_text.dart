import 'package:eight_stone_problem/export.dart';

class SolutionStepsText extends StatelessWidget {
  const SolutionStepsText({
    super.key,
    required this.itemCount,
    required this.stepsText,
  });

  final int itemCount;
  final List<String> stepsText;

  @override
  Widget build(BuildContext context) {
    return itemCount != 0
        ? ListView.builder(
            padding: AppPaddings.smallAll,
            physics: BouncingScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return Text(
                stepsText[index],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              );
            },
          )
        : Center(
            child: Text(
              "Henüz işlem gerçekleştirilmemiş!",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          );
  }
}
