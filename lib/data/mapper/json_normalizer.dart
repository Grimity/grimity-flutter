dynamic normalizeJsonValue(Object? value) {
  if (value == null || value is String || value is num || value is bool) return value;
  if (value is DateTime) return value.toIso8601String();
  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), normalizeJsonValue(item)));
  }
  if (value is Iterable) return value.map(normalizeJsonValue).toList();

  try {
    return normalizeJsonValue((value as dynamic).toJson());
  } on NoSuchMethodError {
    throw StateError('Cannot normalize ${value.runtimeType} to JSON.');
  }
}

Map<String, dynamic> normalizeJsonMap(Map<String, Object?> value) =>
    Map<String, dynamic>.from(normalizeJsonValue(value) as Map);
