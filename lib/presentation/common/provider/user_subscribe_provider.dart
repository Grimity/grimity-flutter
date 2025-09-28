import 'package:grimity/app/enum/subscription_type.enum.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/domain/dto/me_request_params.dart';
import 'package:grimity/domain/entity/subscription.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_subscribe_provider.g.dart';

@Riverpod(keepAlive: true)
class UserSubscribe extends _$UserSubscribe {
  @override
  Subscription? build() {
    return null;
  }

  /*
   * 유저 구독 여부 조회
   * state = Subscription -> 유저 구독 여부 조회 성공
   * state = null -> 유저 구독 여부 조회 실패
   */
  Future<void> getSubscription() async {
    final result = await getSubscriptionUseCase.execute();

    result.fold(
      onSuccess: (data) {
        state = data;
      },
      onFailure: (e) {
        state = null;
      },
    );
  }

  /*
   * 유저 구독 여부 수정
   * 성공을 가정하고 상태 갱신, 실패시 원복
   */
  Future<void> updateSubscription(List<SubscriptionType> next) async {
    // 이전 상태 백업
    final prev = state;

    // 미리 반영
    state = Subscription(subscription: next);

    final param = UpdateSubscriptionRequestParam(subscription: next);
    final result = await updateSubscriptionUseCase.execute(param);

    result.fold(
      onSuccess: (_) {},
      onFailure: (e) {
        // 실패 시 원복
        state = prev;
        ToastService.showError('수정에 실패했습니다');
      },
    );
  }
}
