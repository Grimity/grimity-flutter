import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/domain/dto/reports_request_params.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'report_api.g.dart';

@injectable
@RestApi()
abstract class ReportAPI {
  @factoryMethod
  factory ReportAPI(Dio dio, {@Named('baseUrl') String baseUrl}) = _ReportAPI;

  @POST('/reports')
  Future<void> sendReport(@Body() CreateReportRequest request);
}
