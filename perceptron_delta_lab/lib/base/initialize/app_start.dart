import 'package:easy_localization/easy_localization.dart';
import '../export.dart';

/// A static class that handles application initialization.
class AppStart {
  static Future<void> init() async {
    /// Flutter starts widget binding.
    WidgetsFlutterBinding.ensureInitialized();

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    /// Sets the system interface style.
    /// Status bar color and screen brightness are specified.
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,

        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    /// Initializes the EasyLocalization library.
    await EasyLocalization.ensureInitialized();
  }
}
