import 'package:backpropagation_algorithm/base/initialize/export.dart';

/// A static class that handles application initialization.
class AppStart {
  static Future<void> init() async {
    /// Flutter starts widget binding.
    WidgetsFlutterBinding.ensureInitialized();


    /// Sets the system interface style.
    /// Status bar color and screen brightness are specified.
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,

        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }
}
