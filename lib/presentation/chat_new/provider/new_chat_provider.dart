import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/data/data_source/remote/chat_api.dart';
import 'package:grimity/data/data_source/remote/me_api.dart';
import 'package:grimity/data/model/user/follow_user_response.dart';
import 'package:grimity/domain/dto/chat_request_params.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_chat_provider.freezed.dart';
part 'new_chat_provider.g.dart';

@freezed
abstract class NewChatState with _$NewChatState {
  const factory NewChatState({
    required List<FollowUserResponse> followings,
    String? keyword,
    String? nextCursor,
    String? selectedUserId,
  }) = _NewChatState;
}

@riverpod
class NewChatProvider extends _$NewChatProvider {
  String? _keyword;

  @override
  FutureOr<NewChatState> build() async {
    final response = await getIt<MeAPI>().getMyFollowings(null, null, null);
    return NewChatState(
      keyword: null,
      followings: response.followings,
      nextCursor: response.nextCursor,
      selectedUserId: null,
    );
  }

  /// 현재 선택된 사용자에 대한 채팅 방을 생성하고 뷰어로 이동합니다.
  // ignore: avoid_build_context_in_providers
  void submit(BuildContext context) async {
    assert(state.value?.selectedUserId != null);
    final response = await getIt<ChatAPI>().createChat(
      CreateChatRequest(targetUserId: state.value!.selectedUserId!),
    );

    // 메세지 뷰어 페이지로 이동.
    if (context.mounted) {
      ChatMessageRoute(response.id).pushReplacement(context);
    }
  }

  /// 메세지를 보낼 대상을 주어진 사용자로 선택합니다.
  void select(FollowUserResponse user) {
    assert(state.value != null);
    state = AsyncData(state.value!.copyWith(selectedUserId: user.id));
  }

  /// 다음 페이지에 대한 추가 데이터를 불러옵니다.
  Future<void> loadMore() async {
    assert(state.value?.nextCursor != null);
    final response = await getIt<MeAPI>().getMyFollowings(
      null,
      state.value?.nextCursor,
      state.value?.keyword,
    );

    state = AsyncData(
      state.value!.copyWith(
        followings: [...state.value!.followings, ...response.followings],
        nextCursor: response.nextCursor,
      ),
    );
  }

  /// 주어진 문자열을 검색 키워드로 설정합니다.
  Future<void> setKeyword(String newKeyword) async {
    _keyword = newKeyword == "" ? null : newKeyword;
  }

  /// 현재 설정된 검색 키워드를 기반으로 데이터를 다시 불러옵니다.
  Future<void> refresh() async {
    final response = await getIt<MeAPI>().getMyFollowings(
      null,
      null,
      _keyword,
    );

    state = AsyncData(
      state.value!.copyWith(
        followings: response.followings,
        nextCursor: response.nextCursor,
        keyword: _keyword,
      ),
    );
  }
}
