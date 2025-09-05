import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/provider/home_searching_provider.dart';
import 'package:grimity/domain/entity/user.dart';

import '../../../gen/assets.gen.dart';
import 'empty_state_widget.dart';

class SearchUserWidget extends ConsumerWidget {
  const SearchUserWidget({Key? key}) : super(key: key);

  // 프로필 이미지 (image 우선, 없으면 backgroundImage 사용)
  ImageProvider<Object>? _getProfileImage(User user) {
    if ((user.image ?? '').isNotEmpty) {
      return NetworkImage(user.image!);
    }
    if ((user.backgroundImage ?? '').isNotEmpty) {
      return NetworkImage(user.backgroundImage!);
    }
    return null;
  }

  // 기본 배너
  Widget _defaultBanner() {
    return Container(
      height: 84,
      alignment: Alignment.center,
      color: const Color(0xFFF4F5F7),
      child: Text(
        'Grimity',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.black.withOpacity(0.10),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // 배너: backgroundImage가 있으면 이미지, 없으면 기본 배너
  Widget _buildBanner(String? bgUrl) {
    if (bgUrl == null || bgUrl.isEmpty) {
      return _defaultBanner();
    }
    return SizedBox(
      height: 84,
      width: double.infinity,
      child: Image.network(
        bgUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _defaultBanner(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(color: const Color(0xFFF4F5F7));
        },
      ),
    );
  }

  // 하이라이트 유틸: terms 에 포함된 부분만 초록색
  TextSpan _highlight(
      String text,
      List<String> terms, {
        TextStyle? normalStyle,
        TextStyle? highlightStyle,
      }) {
    if (text.isEmpty || terms.isEmpty) {
      return TextSpan(text: text, style: normalStyle);
    }

    final cleaned = terms
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => b.length.compareTo(a.length)); // 긴 키워드 우선

    if (cleaned.isEmpty) {
      return TextSpan(text: text, style: normalStyle);
    }

    final pattern = cleaned.map(RegExp.escape).join('|');
    final reg = RegExp('($pattern)', caseSensitive: false);

    final spans = <TextSpan>[];
    int start = 0;

    for (final m in reg.allMatches(text)) {
      if (m.start > start) {
        spans.add(TextSpan(text: text.substring(start, m.start), style: normalStyle));
      }
      spans.add(TextSpan(text: text.substring(m.start, m.end), style: highlightStyle));
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

            // ── 유저 리스트 (배너+카드) ──
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                itemBuilder: (context, i) {
                  final u = users[i];
                  final img = _getProfileImage(u);
                  final isFollowing = u.isFollowing == true;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias, // 상단 배너 모서리 클리핑
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 상단 배너 (bg 있으면 이미지, 없으면 기본)
                        _buildBanner(u.backgroundImage),

                        // 본문
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 아바타 + 팔로우 버튼
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.grey[200],
                                    foregroundImage: img, // NetworkImage 등
                                    child: img == null
                                        ? Assets.icons.home.g.svg(
                                      width: 18,
                                      height: 18,
                                      color: Colors.grey.shade500,
                                    )
                                        : null,
                                  ),
                                  const Spacer(),
                                  // 팔로우 버튼 (상태에 따라 색/라벨)
                                  Material(
                                    color: isFollowing ? Colors.grey.shade400 : Colors.black87,
                                    borderRadius: BorderRadius.circular(18),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(18),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                        child: Text(
                                          '팔로우', // isFollowing 시 '팔로잉'으로 바꾸고 싶으면 조건 처리
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // 이름(하이라이트) + 팔로워 (한 줄에 붙여서)
                              RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  children: [
                                    _highlight(
                                      u.name ?? '익명',
                                      terms,
                                      normalStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      highlightStyle: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.green,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' · 팔로워 ${u.followerCount ?? 0}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),

                              // 설명 (1줄)
                              if ((u.description ?? '').isNotEmpty)
                                Text(
                                  u.description!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    height: 1.2,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
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
