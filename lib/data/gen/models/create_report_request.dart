// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

import 'report_ref_type.dart';
import 'report_type.dart';

part 'create_report_request.freezed.dart';
part 'create_report_request.g.dart';

@Freezed()
abstract class CreateReportRequest with _$CreateReportRequest {
  const factory CreateReportRequest({
    /// 신고 타입
    required ReportType type,

    /// 신고 대상 타입
    required ReportRefType refType,

    /// 신고 대상 아이디
    required String refId,
    String? content,
  }) = _CreateReportRequest;

  factory CreateReportRequest.fromJson(Map<String, Object?> json) => _$CreateReportRequestFromJson(json);
}
