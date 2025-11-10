import 'package:collection/collection.dart';
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
    required List<String> selectedChats,
    required bool isSelectMode,
  }) = _ChatState;
}

@riverpod
class ChatProvider extends _$ChatProvider {
  ChatState get _state => state.value!;
  String? _keyword;

  @override
  FutureOr<ChatState> build() async {
    final response = await getIt<ChatAPI>().search(null, null, null);

    return ChatState(
      chats: response.chats,
      keyword: null,
      nextCursor: response.nextCursor,
      selectedChats: [],
      isSelectMode: false,
    );
  }

  /// 주어진 문자열을 검색어로 정의합니다.
  void setKeyword(String newValue) {
    _keyword = newValue == "" ? null : newValue;
  }

  /// 다음 페이지에 대한 추가 데이터를 불러옵니다.
  Future<void> loadMore() async {
    assert(_state.nextCursor != null);
    final response = await getIt<ChatAPI>().search(null, _state.nextCursor, _state.keyword);

    state = AsyncData(_state.copyWith(chats: [..._state.chats, ...response.chats], nextCursor: response.nextCursor));
  }

  /// 현재 데이터를 모두 버리고 다시 처음부터 데이터를 불러옵니다.
  Future<void> refresh() async {
    final response = await getIt<ChatAPI>().search(null, null, _keyword);

    state = AsyncData(_state.copyWith(chats: response.chats, keyword: _keyword, nextCursor: response.nextCursor));
  }

  /// 현재 선택 상태 여부를 정의합니다.
  void setSelectMode(bool value) {
    state = AsyncData(_state.copyWith(isSelectMode: value));
  }

  /// 주어진 채팅이 선택되었는지에 대한 여부를 반환합니다.
  bool hasSelected(ChatResponse chat) {
    return _state.selectedChats.firstWhereOrNull((id) => id == chat.id) != null;
  }

  /// 주어진 채팅에 대한 선택 여부를 정의합니다.
  void selectChat(ChatResponse chat, bool value) {
    assert(_state.isSelectMode);
    final newItems = _state.selectedChats.toList();

    if (value) {
      newItems.add(chat.id);
    } else {
      newItems.removeWhere((id) => id == chat.id);
    }

    state = AsyncData(_state.copyWith(selectedChats: newItems));
  }

  /// 모든 채팅을 대상으로 선택 여부를 정의합니다.
  void selectChatAll(bool value) {
    if (value) {
      state = AsyncData(_state.copyWith(selectedChats: _state.chats.map((e) => e.id).toList()));
    } else {
      state = AsyncData(_state.copyWith(selectedChats: []));
    }
  }
}
