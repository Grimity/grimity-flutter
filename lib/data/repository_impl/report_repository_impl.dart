import 'package:grimity/app/base/result.dart';
import 'package:grimity/data/data_source/remote/report_api.dart';
import 'package:grimity/domain/dto/reports_request_params.dart';
import 'package:grimity/domain/repository/report_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ReportRepository)
class ReportRepositoryImpl extends ReportRepository {
  final ReportAPI _reportAPI;

  ReportRepositoryImpl(this._reportAPI);

  @override
  Future<Result<void>> sendReport(CreateReportRequest request) async {
    try {
      await _reportAPI.sendReport(request);
      return Result.success(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
