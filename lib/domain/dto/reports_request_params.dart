import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/enum/report.enum.dart';

part 'reports_request_params.freezed.dart';

part 'reports_request_params.g.dart';

@freezed
abstract class CreateReportRequest with _$CreateReportRequest {
  const factory CreateReportRequest({
    required ReportType type, // 신고 타입
    required ReportRefType refType, // 신고 대상 타입
    required String refId, // 신고 대상 ID
    String? content,
  }) = _CreateReportRequest;

  factory CreateReportRequest.fromJson(Map<String, dynamic> json) => _$CreateReportRequestFromJson(json);
}
