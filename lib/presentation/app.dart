import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/environment/flavor.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void runFlavoredApp() async {
  await Flavor.instance.setup();

  // Initialize talker
  final talker = TalkerFlutter.init();

  runApp(
    ProviderScope(
      observers: [
        TalkerRiverpodObserver(talker: talker, settings: TalkerRiverpodLoggerSettings(printStateFullData: false)),
      ],
      child: App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MaterialApp.router(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            FlutterQuillLocalizations.delegate,
          ],
          routerConfig: AppRouter.router(ref),
          theme: AppTheme.appTheme,
          debugShowCheckedModeBanner: false,
          builder: (context, child) => FToastBuilder()(context, child),
        );
      },
    );
  }
}
