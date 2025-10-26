import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:grimity/app/environment/environment_enum.dart';
import 'package:grimity/app/environment/flavor.dart';
import 'package:grimity/firebase_options_dev.dart';
import 'package:grimity/presentation/app.dart';

/// dev
void main() async {
  Flavor.initialize(Env.dev);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  return runFlavoredApp();
}
