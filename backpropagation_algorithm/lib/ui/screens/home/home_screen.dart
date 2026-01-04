import 'package:backpropagation_algorithm/ui/screens/home/export.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: AppPaddings.mediumVertical,
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: AppPaddings.mediumHorizontal,
                child: Column(
                  spacing: 16,
                  children: [
                    ProjectStatus(),
                    QuickTransactions(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
