// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_report_request.dart';

part 'reports_api.g.dart';

@RestApi()
abstract class ReportsApi {
  factory ReportsApi(Dio dio, {String? baseUrl}) = _ReportsApi;

  /// 신고하기
  @POST('/reports')
  Future<void> reportCreate({
    @Body() required CreateReportRequest body,
  });
}
