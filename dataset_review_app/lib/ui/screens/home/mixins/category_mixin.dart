import '../export.dart';

mixin CategoryMixin {
  List<Widget> buildCategoryItems(BuildContext context) {
    final categories = [
      {
        'title': LocaleKeys.homeScreen_documents.locale,
        'icon': Assets.icons.icFile.image(package: AppConstants.packageName),
        'onTap': () {
          print('Documents clicked');
        },
      },
      {
        'title': LocaleKeys.homeScreen_download.locale,
        'icon': Assets.icons.icDownload.image(
          package: AppConstants.packageName,
        ),
        'onTap': () {
          print('Download clicked');
        },
      },
      {
        'title': LocaleKeys.homeScreen_uploaded.locale,
        'icon': Assets.icons.icUploaded.image(
          package: AppConstants.packageName,
        ),
        'onTap': () {
          print('Uploaded clicked');
        },
      },
    ];

    return categories
        .map(
          (e) => CustomCategoryItem(
            title: e['title'] as String,
            icon: e['icon'] as Image,
            onTap: e['onTap'] as VoidCallback,
          ),
        )
        .toList();
  }
}
