import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/provider/home_searching_provider.dart';

final debouncedQueryProvider = FutureProvider.autoDispose<String>((ref) async {
  ref.watch(searchQueryProvider);

  await Future.delayed(const Duration(milliseconds: 500));

  return ref.read(searchQueryProvider).trim();
});