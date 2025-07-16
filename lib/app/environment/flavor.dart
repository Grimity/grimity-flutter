import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grimity/app/config/app_config.dart';
import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/app/environment/environment_enum.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class Flavor {
  Flavor._();

  static final Flavor _instance = Flavor._();
  static late Env _env;

  static Flavor get instance => _instance;

  static Env get env => _env;

  static void initialize(Env type) {
    _env = type;
  }

  Future<void> setup() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Load dotEnv
    await dotenv.load(fileName: env.dotFileName);

    // AppConfig init
    AppConfig.initialize(apiUrl: env.apiUrl, imageUrl: env.imageUrl);

    // Initialize get_it
    await configureDependencies(env.getString);

    // Initialize Kakao
    KakaoSdk.init(nativeAppKey: env.kakaoApiKey);
  }
}
