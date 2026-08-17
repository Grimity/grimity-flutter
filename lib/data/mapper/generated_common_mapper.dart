import 'package:grimity/data/gen/models/app_version_response.dart' as generated;
import 'package:grimity/data/gen/models/notification_response.dart' as generated;
import 'package:grimity/data/gen/models/popular_tag_response.dart' as generated;
import 'package:grimity/domain/entity/app_version.dart';
import 'package:grimity/domain/entity/notification.dart';
import 'package:grimity/domain/entity/tag.dart';

extension GeneratedAppVersionResponseMapper on generated.AppVersionResponse {
  AppVersion toEntity() => AppVersion(version: version, createdAt: createdAt);
}

extension GeneratedNotificationResponsesMapper on List<generated.NotificationResponse> {
  List<Notification> toEntity() =>
      map(
        (response) => Notification(
          id: response.id,
          createdAt: response.createdAt,
          isRead: response.isRead,
          link: response.link,
          image: response.image,
          message: response.message,
        ),
      ).toList();
}

extension GeneratedPopularTagResponsesMapper on List<generated.PopularTagResponse> {
  List<Tag> toEntity() => map((response) => Tag(tagName: response.tagName, thumbnail: response.thumbnail)).toList();
}
