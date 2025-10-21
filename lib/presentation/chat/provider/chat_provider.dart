import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/data/data_source/remote/chat_api.dart';
import 'package:grimity/data/model/chat/chat_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_provider.freezed.dart';
part 'chat_provider.g.dart';

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    required List<ChatResponse> chats,
    String? keyword,
    String? nextCursor,
  }) = _ChatState;
}

@riverpod
class ChatProvider extends _$ChatProvider {
  ChatState get _state => state.value!;

  @override
  FutureOr<ChatState> build() async {
    final response = await getIt<ChatAPI>().search(null, null, null);
    return ChatState(
      chats: response.chats,
      keyword: null,
      nextCursor: response.nextCursor,
    );
  }

  Future<void> loadMore() async {
    assert(_state.nextCursor != null);
    final response = await getIt<ChatAPI>().search(null, _state.nextCursor, _state.keyword);

    state = AsyncData(_state.copyWith(
      chats: [..._state.chats, ...response.chats],
      nextCursor: response.nextCursor,
    ));
  }

  Future<void> refresh() async {
    final response = await getIt<ChatAPI>().search(null, null, _state.keyword);

    state = AsyncData(_state.copyWith(
      chats: response.chats,
      nextCursor: response.nextCursor,
    ));
  }
}
