import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/gen/models/create_report_request.dart' as generated;
import 'package:grimity/data/gen/models/report_ref_type.dart' as generated;
import 'package:grimity/data/gen/models/report_type.dart' as generated;
import 'package:grimity/data/gen/rest_client.dart';
import 'package:grimity/domain/dto/reports_request_params.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ReportService {
  final RestClient _client;

  ReportService(this._client);

  Future<Result<void>> sendReport(CreateReportRequest request) async {
    try {
      await _client.reports.reportCreate(
        body: generated.CreateReportRequest(
          type: generated.ReportType.fromJson(request.type.wire),
          refType: generated.ReportRefType.fromJson(request.refType.toJson()),
          refId: request.refId,
          content: request.content,
        ),
      );
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
