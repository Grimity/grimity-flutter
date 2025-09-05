import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/provider/home_searching_provider.dart';
import 'package:grimity/domain/entity/user.dart';

import '../../../gen/assets.gen.dart';
import 'empty_state_widget.dart';

class SearchUserWidget extends ConsumerWidget {
  const SearchUserWidget({Key? key}) : super(key: key);

  // 프로필 이미지를 가져오는 헬퍼 메서드
  ImageProvider<Object>? _getProfileImage(User user) {
    if ((user.image ?? '').isNotEmpty) {
      return NetworkImage(user.image!);
    }
    if ((user.backgroundImage ?? '').isNotEmpty) {
      return NetworkImage(user.backgroundImage!);
    }
    return null;
  }

  // ⬇️ 하이라이트 유틸: terms 에 포함된 부분만 초록색
  TextSpan _highlight(
      String text,
      List<String> terms, {
        TextStyle? normalStyle,
        TextStyle? highlightStyle,
      }) {
    if (text.isEmpty || terms.isEmpty) {
      return TextSpan(text: text, style: normalStyle);
    }

    // 빈 문자열 제거 + 길이 긴 순으로 정렬(겹침 방지)
    final cleaned = terms
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => b.length.compareTo(a.length));

    if (cleaned.isEmpty) {
      return TextSpan(text: text, style: normalStyle);
    }

    // 안전하게 escape 해서 OR 패턴 생성
    final pattern = cleaned.map(RegExp.escape).join('|');
    final reg = RegExp('($pattern)', caseSensitive: false);

    final spans = <TextSpan>[];
    int start = 0;

    for (final m in reg.allMatches(text)) {
      if (m.start > start) {
        spans.add(TextSpan(
          text: text.substring(start, m.start),
          style: normalStyle,
        ));
      }
      spans.add(TextSpan(
        text: text.substring(m.start, m.end),
        style: highlightStyle,
      ));
      start = m.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: normalStyle));
    }
    return TextSpan(children: spans);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUsers = ref.watch(searchedUsersProvider);

    final query = ref.watch(searchQueryProvider).trim();
    final terms = query.isEmpty
        ? const <String>[]
        : query.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();

    return asyncUsers.when(
      data: (List<User> users) {
        if (users.isEmpty) {
          return EmptyStateWidget();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 검색결과 헤더 ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '검색결과 ',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    TextSpan(
                      text: '${users.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '건',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

            // ── 유저 리스트 ──
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                itemBuilder: (context, i) {
                  final u = users[i];
                  final img = _getProfileImage(u);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 상단: 프로필 + 팔로우 버튼
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                foregroundImage: img, // 실패 시 child 노출
                                child: img == null
                                    ? Assets.icons.home.g.svg(
                                  width: 20,
                                  height: 20,
                                  color: Colors.grey.shade600,
                                )
                                    : null,
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: u.isFollowing == true
                                      ? Colors.grey.shade400
                                      : Colors.black87,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  u.isFollowing == true ? '팔로잉' : '팔로우',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // 이름(키워드 하이라이트 적용)
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: _highlight(
                              u.name ?? '(이름 없음)',
                              terms,
                              // 기본은 검정, 매칭은 초록
                              normalStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              highlightStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),

                          // 팔로워 수
                          Text(
                            '팔로워 ${u.followerCount ?? 0}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),

                          // 설명(키워드 하이라이트 적용)
                          if ((u.description ?? '').isNotEmpty) ...[
                            const SizedBox(height: 8),
                            RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: _highlight(
                                u.description!,
                                terms,
                                normalStyle: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                                highlightStyle: TextStyle(
                                  color: Colors.green.shade700,
                                  fontSize: 13,
                                  height: 1.3,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('유저 로딩 실패: $e')),
    );
  }
}
