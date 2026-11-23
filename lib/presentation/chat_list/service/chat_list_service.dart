import 'package:flutter/foundation.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/extensions/string_extension.dart';

/// 변경 신호를 감지해 채팅 목록을 다시 불러오는 서비스.
class ChatListService extends LoadMoreService<ChatsResponse> {
  new({
    required String keyword,
    required this.listenable,
  }) : super(
         builder: (cursor) {
           return GetChats(
             cursor: cursor,
             keyword: keyword.orNull,
           );
         },
         cursorOf: (data) => data.nextCursor,
       ) {
    listenable.addListener(refresh);
  }

  final Listenable listenable;

  @override
  void dispose() {
    listenable.removeListener(refresh);
    super.dispose();
  }
}
