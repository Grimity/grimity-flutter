import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/enum/report.enum.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/dto/reports_request_params.dart';
import 'package:grimity/domain/usecase/report_usecases.dart';
import 'package:grimity/presentation/report/provider/report_argument_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_provider.g.dart';

part 'report_provider.freezed.dart';

@riverpod
class Report extends _$Report {
  @override
  ReportState build(ReportRefType refType, String refId) {
    return ReportState(refType: refType, refId: refId);
  }

  void updateType(ReportType? type) {
    state = state.copyWith(type: type);
  }

  void updateContent(String? content) {
    state = state.copyWith(content: content);
  }

  void _setUploading(bool uploading) {
    state = state.copyWith(uploading: uploading);
  }

  FutureOr<bool> sendReport() async {
    if (state.type == null) {
      ToastService.showError('신고 타입을 선택해주세요');
      return false;
    }

    if (state.uploading == true) {
      ToastService.showError('전송 중 입니다');
      return false;
    }

    _setUploading(true);

    try {
      final request = CreateReportRequest(
        type: state.type!,
        refType: refType,
        refId: refId,
        content: state.type! == ReportType.other ? state.content : null,
      );
      final result = await sendReportUseCase.execute(request);
      final isSuccess = result.fold(
        onSuccess: (_) {
          return true;
        },
        onFailure: (e) {
          ToastService.showError('서버 전송에 실패했습니다');
          return false;
        },
      );

      return isSuccess;
    } finally {
      _setUploading(false);
    }
  }
}

@freezed
abstract class ReportState with _$ReportState {
  const factory ReportState({
    @Default(null) ReportType? type,
    required ReportRefType refType,
    required String refId,
    @Default(null) String? content,
    @Default(false) bool uploading,
  }) = _AlbumOrganizeState;
}

mixin class ReportMixin {
  ReportState reportState(WidgetRef ref) {
    final refType = ref.read(reportRefTypeArgumentProvider);
    final refId = ref.read(reportRefIdArgumentProvider);

    return ref.watch(reportProvider(refType, refId));
  }

  Report reportNotifier(WidgetRef ref) {
    final refType = ref.read(reportRefTypeArgumentProvider);
    final refId = ref.read(reportRefIdArgumentProvider);

    return ref.read(reportProvider(refType, refId).notifier);
  }
}
