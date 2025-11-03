import 'navigation_bar_item.dart';
import '../export.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationBarCubit, int>(
      builder: (context, selectedIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 16),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: ColorName.paleViolet.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: ColorName.blueLotus.withValues(alpha: 0.25),
                  offset: Offset(0, 10),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NavigationBarItem(
                  onTap: () {
                    context.read<BottomNavigationBarCubit>().changeIndex(0);
                  },
                  backgroundColor: selectedIndex == 0
                      ? ColorName.blueLotus.withValues(alpha: 0.4)
                      : Colors.transparent,
                  icon: Assets.icons.icFile,
                ),
                NavigationBarItem(
                  onTap: () {
                    context.read<BottomNavigationBarCubit>().changeIndex(1);
                  },
                  backgroundColor: selectedIndex == 1
                      ? ColorName.blueLotus.withValues(alpha: 0.4)
                      : Colors.transparent,
                  icon: Assets.icons.icDataset,
                ),
                NavigationBarItem(
                  onTap: () {
                    context.read<BottomNavigationBarCubit>().changeIndex(2);
                  },
                  backgroundColor: selectedIndex == 2
                      ? ColorName.blueLotus.withValues(alpha: 0.4)
                      : Colors.transparent,
                  icon: Assets.icons.icUploaded,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
