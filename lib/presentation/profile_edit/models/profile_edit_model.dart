// Copyright © 2026 Grimity. All rights reserved.
// Licensed under the Grimity Source-Available License v1.0.
// AI/ML training and dataset use are prohibited. See LICENSE.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/app/app_user.dart';

/// 프로필 수정에 필요한 입력 데이터를 관리하는 모델.
class ProfileEditModel({
  required final ImageProvider? avatar,
  required final ImageProvider? banner,
  required final String nickname,
  required final String description,
  required final String url,
  required final List<LinkResponse> links,
}) {
  factory current() {
    return .new(
      avatar: profile.image?.toImage(),
      banner: profile.backgroundImage?.toImage(),
      nickname: profile.name,
      description: profile.description,
      url: profile.url,
      links: profile.links.toList(),
    );
  }

  /// 현재 사용자 프로필과 비교하여 변경된 내용이 있는지 여부.
  bool get hasChanges {
    return avatar != profile.image?.toImage() ||
        banner != profile.backgroundImage?.toImage() ||
        nickname != profile.name ||
        description != profile.description ||
        url != profile.url ||
        !listEquals(links, profile.links);
  }

  /// 필수 입력값을 충족하고 변경된 내용이 있어 제출할 수 있는지 여부.
  bool get canSubmit {
    // 이름이나 주소가 입력되지 않은 링크가 있을 경우.
    for (final link in links) {
      if (link.linkName.trim().isEmpty || link.link.trim().isEmpty) {
        return false;
      }
    }

    return nickname.length >= 2 && url.trim().isNotEmpty && hasChanges;
  }

  /// 지정한 값을 반영한 새 모델을 반환합니다.
  ProfileEditModel copyWith({
    ImageProvider? Function()? avatar,
    ImageProvider? Function()? banner,
    String? nickname,
    String? description,
    String? url,
    List<LinkResponse>? links,
  }) {
    return .new(
      avatar: avatar != null ? avatar() : this.avatar,
      banner: banner != null ? banner() : this.banner,
      nickname: nickname ?? this.nickname,
      description: description ?? this.description,
      url: url ?? this.url,
      links: links ?? this.links,
    );
  }
}
