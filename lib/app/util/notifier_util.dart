import 'package:flutter/foundation.dart';
import 'package:grimity/domain/entity/feed.dart';
import 'package:grimity/domain/entity/post.dart';

typedef NotifierGetId<T> = String Function(T value);

class NotifierUtil<T> {
  NotifierUtil(this.getId);

  final NotifierGetId<T> getId;

  static final feed = NotifierUtil<Feed>((feed) => feed.id);
  static final post = NotifierUtil<Post>((post) => post.id);

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
