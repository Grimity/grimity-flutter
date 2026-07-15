import 'package:flutter/widgets.dart';

abstract class Setting<T> extends ChangeNotifier {
  String get key;

  T getValue();

  Future<void> setValue(T newValue);
}
