import 'package:flutter/foundation.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/post.dart';

/// 변경되거나 변경될 수 있는 데이터에 대한 오래된 인스턴스들을 재갱신시키기 위해 사용됩니다.
class SyncUtil<T> {
  SyncUtil(this.getId);

  final String Function(T value) getId;

  static final feed = SyncUtil<Feed>((feed) => feed.id);
  static final post = SyncUtil<Post>((post) => post.id);

  final _listeners = <String, List<ValueChanged<T>>>{};

  void listen(T value, ValueChanged<T> listener) {
    final id = getId(value);
    _listeners.putIfAbsent(id, () => []).add(listener);
  }

  void cancel(T value, ValueChanged<T>? listener) {
    final id = getId(value);
    _listeners[id]?.remove(listener);
  }

  void notify(T value) {
    final listeners = _listeners[getId(value)];
    if (listeners != null) {
      for (final listener in listeners.toList()) {
        listener(value);
      }
    }
  }
}
