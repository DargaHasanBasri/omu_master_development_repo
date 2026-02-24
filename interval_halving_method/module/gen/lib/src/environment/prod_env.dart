import 'package:envied/envied.dart';
import 'package:gen/src/environment/app_env.dart';

part 'prod_env.g.dart';

@Envied(path: 'assets/env/.prod.env', obfuscate: true)

final class ProdEnv implements AppEnv {
  @EnviedField(varName: 'BASE_URL')
  static final String _baseUrl = ProdEnv._baseUrl;

  @override
  String get baseUrl => _baseUrl;
}
