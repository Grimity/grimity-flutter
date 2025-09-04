import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/provider/home_searching_provider.dart';
import 'package:grimity/domain/entity/user.dart';

import 'empty_state_widget.dart';

class SearchUserWidget extends ConsumerWidget {
  const SearchUserWidget({Key? key}) : super(key: key);

  // 프로필 이미지를 가져오는 헬퍼 메서드
  ImageProvider? _getProfileImage(User user) {
    // 1. image 필드 확인
    if (user.image != null && user.image!.isNotEmpty) {
      return NetworkImage(user.image!);
    }
    // 2. backgroundImage 필드 확인
    if (user.backgroundImage != null && user.backgroundImage!.isNotEmpty) {
      return NetworkImage(user.backgroundImage!);
    }
    // 3. 둘 다 없으면 null 반환 (기본 아이콘 표시됨)
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUsers = ref.watch(searchedUsersProvider);

    return asyncUsers.when(
      data: (List<User> users) {
        if (users.isEmpty) {
          return EmptyStateWidget();
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, i) {
            final u = users[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 영역: 프로필 이미지와 팔로우 버튼
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: u.image != null && u.image!.isNotEmpty
                            ? NetworkImage(u.image!)
                            : null,
                        child: u.image == null || u.image!.isEmpty
                            ? Icon(Icons.person, color: Colors.grey.shade600, size: 20)
                            : null,
                        backgroundColor: Colors.white,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: u.isFollowing == true ? Colors.grey.shade400 : Colors.black87,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          u.isFollowing == true ? '팔로잉' : '팔로우',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // 이름과 팔로워 수
                  Row(
                    children: [
                      Text(
                        u.name ?? '(이름 없음)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '팔로워 ${u.followerCount ?? 0}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  // 설명 (있는 경우만 표시)
                  if (u.description != null && u.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      u.description!,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('유저 로딩 실패: $e')),
    );
  }
}