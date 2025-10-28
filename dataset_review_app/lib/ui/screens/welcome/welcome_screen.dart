import 'export.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.seashell,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: AppPaddings.xLargeAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: AppPaddings.xLargeTop,
                      child: Assets.images.imgWelcome.image(
                        package: AppConstants.packageName,
                        scale: 1,
                      ),
                    ),
                    Padding(
                      padding: AppPaddings.largeVertical,
                      child: _welcomeMessage(context),
                    ),
                  ],
                ),
              ),
              _welcomeButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _welcomeMessage(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: AppPaddings.xXLargeVertical,
          child: Text(
            LocaleKeys.welcomeScreen_messageTitle.locale,
            style:
                Theme.of(
                  context,
                ).textTheme.displayMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  height: 2,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: AppPaddings.xXLargeHorizontal,
          child: Text(
            LocaleKeys.welcomeScreen_messageSubTitle.locale,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _welcomeButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: AppPaddings.xXLargeVertical,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style.copyWith(
                fontSize: 15,
                decoration: TextDecoration.none,
              ),
              children: [
                TextSpan(
                  text: LocaleKeys.privacyPolicy.locale,
                  style: TextStyle(
                    color: ColorName.blueLotus,
                    decoration: TextDecoration.underline,
                    decorationColor: ColorName.blueLotus,
                    decorationThickness: 0.3,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      print('Privacy Policy');
                    },
                ),
                TextSpan(
                  text: ' ${LocaleKeys.and.locale} ',
                  style: TextStyle(
                    color: ColorName.black,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
                TextSpan(
                  text: LocaleKeys.termsConditions.locale,
                  style: TextStyle(
                    color: ColorName.blueLotus,
                    decoration: TextDecoration.underline,
                    decorationColor: ColorName.blueLotus,
                    decorationThickness: 0.3,
                    textBaseline: TextBaseline.alphabetic,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      print('Terms & conditions tapped');
                    },
                ),
              ],
            ),
          ),
        ),
        CustomButton(
          onTap: () {},
          title: LocaleKeys.buttonTitle_getStarted.locale,
        ),
      ],
    );
  }
}
