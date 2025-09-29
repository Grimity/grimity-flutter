import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/search/provider/search_provider.dart';
import 'package:grimity/domain/entity/user.dart';
import '../../../app/config/app_typeface.dart';
import '../../common/widget/grimity_user_image.dart';
import 'empty_state_widget.dart';

class SearchUserWidget extends ConsumerWidget {
  const SearchUserWidget({super.key});

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
          color: Colors.black,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

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
      ..sort((a, b) => b.length.compareTo(a.length));

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
            // 헤더
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '검색결과 ', style: AppTypeface.caption1),
                    TextSpan(
                      text: '${users.length}',
                      style: AppTypeface.caption1.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '건', style: AppTypeface.caption1),
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

                  const double avatarSize  = 40;
                  const double hPad        = 12;
                  const double overlapDy   = -((avatarSize / 2.0) + 13);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildBanner(u.backgroundImage),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(hPad, 12, hPad, 12),
                          //이걸 column형태로 변경하면 오류가 남
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Transform.translate(
                                offset: Offset(0, overlapDy),
                                child: GrimityUserImage(imageUrl: u.image, size: avatarSize),
                              ),
                              const SizedBox(width: 15),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: _highlight(
                                        u.name,
                                        normalStyle: AppTypeface.label2.copyWith(color: Colors.black87),
                                        terms,
                                        highlightStyle: AppTypeface.label2.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '팔로워 ${u.followerCount ?? 0}',
                                      style: AppTypeface.caption2.copyWith(color: Colors.grey),
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
                                  minimumSize: const Size(64, 32),
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  (u.isFollowing == true) ? '팔로잉' : '팔로우',
                                  style: AppTypeface.caption2.copyWith(
                                    color: (u.isFollowing == true) ? Colors.black87 : Colors.white,
                                  ),
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
