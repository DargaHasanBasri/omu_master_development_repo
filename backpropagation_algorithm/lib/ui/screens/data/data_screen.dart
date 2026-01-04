import 'package:backpropagation_algorithm/ui/screens/data/export.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Veri Yönetimi',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: const SingleChildScrollView(
                    padding: AppPaddings.smallAll,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      spacing: 24,
                      children: [
                        UploadDataset(),
                        DataPartitionSettings(),
                        DataPreview(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
