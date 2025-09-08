import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/provider/home_searching_provider.dart';
import 'package:grimity/domain/entity/user.dart';

import '../../common/widget/grimity_user_image.dart';
import 'empty_state_widget.dart';

class SearchUserWidget extends ConsumerWidget {
  const SearchUserWidget({Key? key}) : super(key: key);

  ImageProvider<Object>? _getProfileImage(User user) {
    if ((user.image ?? '').isNotEmpty) {
      return NetworkImage(user.image!);
    }
    if ((user.backgroundImage ?? '').isNotEmpty) {
      return NetworkImage(user.backgroundImage!);
    }
    return null;
  }

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
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBanner(u.backgroundImage),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                          child: Builder(
                            builder: (context) {
                              const double avatarSize = 40;
                              final double overlapDy = -(avatarSize / 2.0);

                              return Transform.translate(
                                offset: Offset(0, overlapDy),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GrimityUserImage(imageUrl: u.image, size: avatarSize),

                                    const SizedBox(width: 8),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              RichText(
                                                text: _highlight(
                                                  u.name ?? '이름 없음',
                                                  terms,
                                                  normalStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                  highlightStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                '팔로워 ${u.followerCount ?? 0}',
                                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            u.description ?? '소개가 없습니다',
                                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),

                                    TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        backgroundColor: (u.isFollowing == true)
                                            ? Colors.grey.shade200
                                            : Colors.black,
                                        minimumSize: const Size(60, 32),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: Text(
                                        (u.isFollowing == true) ? '팔로잉' : '팔로우',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: (u.isFollowing == true) ? Colors.black87 : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
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
