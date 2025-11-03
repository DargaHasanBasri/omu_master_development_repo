import 'export.dart';

class HomeScreen extends StatelessWidget with CategoryMixin {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BlocProvider(
        create: (_) => BottomNavigationBarCubit(),
        child: CustomNavigationBar(),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    AppPaddings.mediumHorizontal + AppPaddings.smallVertical,
                child: SearchAndBackButton(
                  textEditingController: textEditingController,
                ),
              ),
              SizedBox(
                height: AppConstants.datasetListViewHeight,
                child: Padding(
                  padding: AppPaddings.largeHorizontal,
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(20),
                    child: ListView.separated(
                      padding: AppPaddings.xSmallVertical,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return DatasetListItem();
                      },
                      separatorBuilder: (context, index) =>
                          Padding(padding: AppPaddings.mediumBottom),
                      itemCount: 10,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: AppPaddings.xSmallVertical,
                child: Text(
                  LocaleKeys.homeScreen_categories.locale,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: AppPaddings.largeHorizontal,
                child: Wrap(
                  spacing: AppConstants.categoryWrapGap,
                  runSpacing: AppConstants.categoryWrapGap,
                  alignment: WrapAlignment.spaceBetween,
                  children: buildCategoryItems(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
