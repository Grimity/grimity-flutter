import 'package:grimity/app/environment/environment_enum.dart';
import 'package:grimity/app/environment/flavor.dart';
import 'package:grimity/presentation/app.dart';

/// dev
void main() async {
  Flavor.initialize(Env.dev);

  return runFlavoredApp();
}
