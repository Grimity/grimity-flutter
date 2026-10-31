// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/widgets/sliver_posts.dart';

/// [PostsResponse]에 대한 유틸리티 확장.
extension PostsResponseExtension on PostsResponse {
  /// 응답에 포함된 게시글의 개수.
  int get itemCount => posts.length;

  /// 인덱스에 해당하는 게시글의 표시 정보를 반환합니다.
  SliverPost itemBuilder(BuildContext context, int index) {
    final post = posts[index];

    return (
      id: post.id,
      nickname: post.author.name,
      title: post.title,
      content: post.content,
      thumbnail: post.thumbnail,
      type: post.type,
      createdAt: post.createdAt,
      viewCount: post.viewCount.toInt(),
      commentCount: post.commentCount.toInt(),
    );
  }
}
