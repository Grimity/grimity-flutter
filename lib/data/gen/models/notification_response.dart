// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_response.freezed.dart';
part 'notification_response.g.dart';

@Freezed()
abstract class NotificationResponse with _$NotificationResponse {
  const factory NotificationResponse({
    required String id,
    required DateTime createdAt,
    required bool isRead,

    /// 클릭 시 이동할 페이지 FULL URL
    required String link,
    required String? image,
    required String message,
  }) = _NotificationResponse;

  factory NotificationResponse.fromJson(Map<String, Object?> json) => _$NotificationResponseFromJson(json);
}
