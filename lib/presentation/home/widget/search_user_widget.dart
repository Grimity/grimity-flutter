import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/provider/home_searching_provider.dart';
import 'package:grimity/domain/entity/user.dart';

import 'empty_state_widget.dart';

class SearchUserWidget extends ConsumerWidget {
  const SearchUserWidget({Key? key}) : super(key: key);

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
            return ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(u.image ?? '')),
              title: Text(u.name ?? '(이름 없음)'),
              subtitle: Text(u.url ?? ''),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('유저 로딩 실패: $e')),
    );
  }
}
