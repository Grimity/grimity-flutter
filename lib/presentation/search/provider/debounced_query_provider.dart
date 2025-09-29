import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'search_provider.dart';

final debounceDurationMsProvider = Provider<int>((_) => 350);

final debouncedQueryProvider = FutureProvider.autoDispose<String>((ref) async {
  final delayMs = ref.watch(debounceDurationMsProvider);
  final raw = ref.watch(searchQueryProvider);
  final q = raw.trim();

  if (q.isEmpty) return '';

  final completer = Completer<String>();
  final timer = Timer(Duration(milliseconds: delayMs), () {
    if (!completer.isCompleted) completer.complete(q);
  });

  ref.onDispose(() {
    if (timer.isActive) timer.cancel();
  });

  return completer.future;
});
