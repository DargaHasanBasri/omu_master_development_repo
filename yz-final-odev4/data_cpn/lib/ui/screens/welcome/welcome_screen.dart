import 'package:data_cpn/ui/screens/welcome/export.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: AppPaddings.largeAll,
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                Padding(
                  padding: AppPaddings.mediumVertical,
                  child: Row(
                    mainAxisAlignment: .center,
                    spacing: 10,
                    children: [
                      Container(
                        padding: AppPaddings.xSmallAll,
                        decoration: BoxDecoration(
                          color: ColorName.blueDress.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Assets.icons.icLogo.image(
                          package: AppConstants.packageGenName,
                        ),
                      ),
                      Text(
                        'DATACPN',
                        style:
                            Theme.of(
                              context,
                            ).textTheme.labelLarge?.copyWith(
                              color: ColorName.cadetGrey,
                            ),
                        textAlign: .center,
                      ),
                    ],
                  ),
                ),
                Assets.icons.icWelcome.image(
                  package: AppConstants.packageGenName,
                ),
                Padding(
                  padding: AppPaddings.xLargeTop,
                  child: Text(
                    'CPN Algoritmalarıyla Verilerinizi Dönüştürün',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: AppPaddings.mediumTop,
                  child: Text(
                    'Karmaşık veri setlerini analiz edin ve süreçlerinizi '
                    'optimize etmek için güçlü simülasyonları '
                    'cebinizde taşıyın.',
                    style:
                        Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          color: ColorName.cadetGrey,
                        ),
                    textAlign: .center,
                  ),
                ),
                Padding(
                  padding: AppPaddings.xLargeTop,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        context.pushNamed(AppRouteNames.dataLoadingScreen);
                      },
                      child: Ink(
                        padding: AppPaddings.mediumAll,
                        decoration: BoxDecoration(
                          color: ColorName.blueDress,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: ColorName.blueDress.withValues(
                                alpha: 0.25,
                              ),
                              offset: const Offset(0, 15),
                              blurRadius: 15,
                              spreadRadius: -3,
                            ),
                          ],
                        ),
                        child: Text(
                          'Hemen Başla',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineLarge?.copyWith(fontSize: 18),
                          textAlign: .center,
                        ),
                      ),
                    ),
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
