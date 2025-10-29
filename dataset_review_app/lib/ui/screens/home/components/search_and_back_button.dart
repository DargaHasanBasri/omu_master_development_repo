import '../export.dart';

class SearchAndBackButton extends StatelessWidget {
  const SearchAndBackButton({super.key, required this.textEditingController});

  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Ink(
            padding: AppPaddings.xSmallAll,
            child: Assets.icons.icArrowBackLeft.image(
              package: AppConstants.packageName,
              height: 24,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: AppPaddings.xXSmallHorizontal + AppPaddings.xSmallLeft,
            child: CustomTextFormField(
              textEditingController: textEditingController,
              backgroundColor: ColorName.lavenderMist,
              hintText: LocaleKeys.homeScreen_searchBarHintText.locale,
            ),
          ),
        ),
        Padding(
          padding: AppPaddings.xSmallHorizontal,
          child: Assets.icons.icSearch.image(
            package: AppConstants.packageName,
            height: 24,
          ),
        ),
      ],
    );
  }
}
