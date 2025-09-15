import 'package:grimity/app/base/result.dart';
import 'package:grimity/domain/dto/reports_request_params.dart';

abstract class ReportRepository {
  Future<Result<void>> sendReport(CreateReportRequest request);
}
