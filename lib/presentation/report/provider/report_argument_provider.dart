import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_argument_provider.g.dart';

@Riverpod(dependencies: [])
ReportRefType reportRefTypeArgument(Ref ref) {
  throw Exception(
    'reportRefTypeArgument was accessed before initialization. '
    'Make sure to provide the argument via ProviderScope.overrideWithValue or set it during route initialization.',
  );
}

@Riverpod(dependencies: [])
String reportRefIdArgument(Ref ref) {
  throw Exception(
    'reportRefIdArgument was accessed before initialization. '
    'Make sure to provide the argument via ProviderScope.overrideWithValue or set it during route initialization.',
  );
}
