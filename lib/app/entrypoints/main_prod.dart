import 'package:grimity/app/environment/environment_enum.dart';
import 'package:grimity/app/environment/flavor.dart';
import 'package:grimity/presentation/app.dart';

/// prod
void main() async {
  Flavor.initialize(Env.prod);

  return runFlavoredApp();
}
