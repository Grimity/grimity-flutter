// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/widgets.dart';
import 'package:grimity/api/api.dart';
import 'package:pervice/pervice.dart';

/// 여러 화면에서 사용하는 사용자 액션과 요청 실패 처리를 모아 둔 클래스.
abstract class AppUseCase {
  /// 피드의 좋아요 상태와 개수를 먼저 반영하고, 요청 실패 시 이전 상태로 복구합니다.
  static Future<void> likeFeed(
    BuildContext context, {
    required String id,
    required bool value,
    required ValueState<bool> isLike,
    required ValueState<int> likeCount,
  }) async {
    try {
      // 요청 전에 좋아요 상태를 화면에 반영.
      isLike.value = value;
      likeCount.value += value ? 1 : -1;

      if (value) {
        await PutFeedsByIdLike(id: id).request();
      } else {
        await DeleteFeedsByIdLike(id: id).request();
      }
    } catch (_) {
      // 요청 실패 시 이전 상태로 복구.
      isLike.value = !value;
      likeCount.value += value ? -1 : 1;
      rethrow;
    }
  }

  /// 글의 좋아요 상태와 개수를 먼저 반영하고, 요청 실패 시 이전 상태로 복구합니다.
  static Future<void> likePost(
    BuildContext context, {
    required String id,
    required bool value,
    required ValueState<bool> isLike,
    required ValueState<int> likeCount,
  }) async {
    try {
      // 요청 전에 좋아요 상태를 화면에 반영.
      isLike.value = value;
      likeCount.value += value ? 1 : -1;

      if (value) {
        await PutPostsByIdLike(id: id).request();
      } else {
        await DeletePostsByIdLike(id: id).request();
      }
    } catch (_) {
      // 요청 실패 시 이전 상태로 복구.
      isLike.value = !value;
      likeCount.value += value ? -1 : 1;
      rethrow;
    }
  }

  /// 사용자를 팔로우하고 팔로워 수를 늘리며, 요청 실패 시 이전 상태로 복구합니다.
  static Future<void> follow(
    BuildContext context, {
    required String id,
    required ValueState<bool> isFollowing,
    required ValueState<int> followerCount,
  }) async {
    try {
      // 요청 전에 팔로우 상태를 화면에 반영.
      isFollowing.value = true;
      followerCount.value += 1;

      await PutUsersByIdFollow(id: id).request();
    } catch (_) {
      // 요청 실패 시 이전 상태로 복구.
      isFollowing.value = false;
      followerCount.value -= 1;
      rethrow;
    }
  }

  /// 사용자의 팔로우를 취소하고 팔로워 수를 줄이며, 요청 실패 시 이전 상태로 복구합니다.
  static Future<void> unFollow(
    BuildContext context, {
    required String id,
    required ValueState<bool> isFollowing,
    required ValueState<int> followerCount,
  }) async {
    try {
      // 요청 전에 팔로우 상태를 화면에 반영.
      isFollowing.value = false;
      followerCount.value -= 1;

      await DeleteUsersByIdFollow(id: id).request();
    } catch (_) {
      // 요청 실패 시 이전 상태로 복구.
      isFollowing.value = true;
      followerCount.value += 1;
      rethrow;
    }
  }
}
