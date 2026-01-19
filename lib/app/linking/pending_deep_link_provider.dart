import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pending_deep_link_provider.g.dart';

@Riverpod(keepAlive: true)
class PendingDeepLink extends _$PendingDeepLink {
  @override
  String? build() => null;

  void setLink(String link) {
    state = link;
  }

  String? consume() {
    final link = state;
    state = null;
    return link;
  }
}
