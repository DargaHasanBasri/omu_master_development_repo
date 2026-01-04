import 'package:backpropagation_algorithm/routes/app_route_names.dart';
import 'package:backpropagation_algorithm/ui/screens/home/export.dart';
import 'package:go_router/go_router.dart';

class QuickTransactions extends StatelessWidget {
  const QuickTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.largeAll,
      decoration: BoxDecoration(
        color: ColorName.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorName.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hızlı İşlemler',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Column(
            spacing: 16,
            children: [
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: HomeItem(
                      backgroundColor: ColorName.warmBlue,
                      icon: Assets.icons.icData.image(
                        package: AppConstants.packageName,
                      ),
                      onTap: () {
                        context.pushNamed(AppRouteNames.data);
                      },
                      subTitle: 'CSV dosyası',
                      title: 'Veri Yükle',
                    ),
                  ),
                  Expanded(
                    child: HomeItem(
                      backgroundColor: ColorName.blueViolet,
                      icon: Assets.icons.icEducate.image(
                        package: AppConstants.packageName,
                      ),
                      onTap: () {
                        context.pushNamed(AppRouteNames.educate);
                      },
                      subTitle: 'Eğitime Başla',
                      title: 'Model eğit',
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: HomeItem(
                      backgroundColor: ColorName.radicalRed,
                      icon: Assets.icons.icResults.image(
                        package: AppConstants.packageName,
                      ),
                      onTap: () {
                        context.pushNamed(AppRouteNames.results);
                      },
                      subTitle: 'Sonuçlar',
                      title: 'Grafikler',
                    ),
                  ),
                  Expanded(
                    child: HomeItem(
                      backgroundColor: ColorName.bamboo,
                      icon: Assets.icons.icHome.image(
                        package: AppConstants.packageName,
                      ),
                      onTap: () {
                        context.pushNamed(AppRouteNames.metrics);
                      },
                      subTitle: 'Performans',
                      title: 'Metrikler',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
