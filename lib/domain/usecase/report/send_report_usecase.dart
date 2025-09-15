import 'dart:async';

import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/reports_request_params.dart';
import 'package:grimity/domain/repository/report_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SendReportUseCase extends UseCase<CreateReportRequest, Result<void>> {
  SendReportUseCase(this._reportRepository);

  final ReportRepository _reportRepository;

  @override
  FutureOr<Result<void>> execute(CreateReportRequest request) async {
    return await _reportRepository.sendReport(request);
  }
}
