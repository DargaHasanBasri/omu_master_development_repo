import 'package:envied/envied.dart';
import 'package:gen/src/environment/app_env.dart';

part 'dev_env.g.dart';

@Envied(path: 'assets/env/.dev.env', obfuscate: true)

final class DevEnv implements AppEnv {
  @EnviedField(varName: 'BASE_URL')
  static final String _baseUrl = DevEnv._baseUrl;

  @override
  String get baseUrl => _baseUrl;
}
