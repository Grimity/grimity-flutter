// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';

import 'clients/app_api.dart';
import 'clients/auth_api.dart';
import 'clients/users_api.dart';
import 'clients/me_api.dart';
import 'clients/feeds_api.dart';
import 'clients/tags_api.dart';
import 'clients/posts_api.dart';
import 'clients/albums_api.dart';
import 'clients/feed_comments_api.dart';
import 'clients/notifications_api.dart';
import 'clients/post_comments_api.dart';
import 'clients/reports_api.dart';
import 'clients/chats_api.dart';
import 'clients/chat_messages_api.dart';
import 'clients/images_api.dart';
import 'clients/commissions_api.dart';
import 'clients/commission_works_api.dart';

/// grimity API `v1.0.0`.
///
///
class RestClient {
  RestClient(
    Dio dio, {
    String? baseUrl,
  }) : _dio = dio,
       _baseUrl = baseUrl;

  final Dio _dio;
  final String? _baseUrl;

  static String get version => '1.0.0';

  AppApi? _app;
  AuthApi? _auth;
  UsersApi? _users;
  MeApi? _me;
  FeedsApi? _feeds;
  TagsApi? _tags;
  PostsApi? _posts;
  AlbumsApi? _albums;
  FeedCommentsApi? _feedComments;
  NotificationsApi? _notifications;
  PostCommentsApi? _postComments;
  ReportsApi? _reports;
  ChatsApi? _chats;
  ChatMessagesApi? _chatMessages;
  ImagesApi? _images;
  CommissionsApi? _commissions;
  CommissionWorksApi? _commissionWorks;

  AppApi get app => _app ??= AppApi(_dio, baseUrl: _baseUrl);

  AuthApi get auth => _auth ??= AuthApi(_dio, baseUrl: _baseUrl);

  UsersApi get users => _users ??= UsersApi(_dio, baseUrl: _baseUrl);

  MeApi get me => _me ??= MeApi(_dio, baseUrl: _baseUrl);

  FeedsApi get feeds => _feeds ??= FeedsApi(_dio, baseUrl: _baseUrl);

  TagsApi get tags => _tags ??= TagsApi(_dio, baseUrl: _baseUrl);

  PostsApi get posts => _posts ??= PostsApi(_dio, baseUrl: _baseUrl);

  AlbumsApi get albums => _albums ??= AlbumsApi(_dio, baseUrl: _baseUrl);

  FeedCommentsApi get feedComments => _feedComments ??= FeedCommentsApi(_dio, baseUrl: _baseUrl);

  NotificationsApi get notifications => _notifications ??= NotificationsApi(_dio, baseUrl: _baseUrl);

  PostCommentsApi get postComments => _postComments ??= PostCommentsApi(_dio, baseUrl: _baseUrl);

  ReportsApi get reports => _reports ??= ReportsApi(_dio, baseUrl: _baseUrl);

  ChatsApi get chats => _chats ??= ChatsApi(_dio, baseUrl: _baseUrl);

  ChatMessagesApi get chatMessages => _chatMessages ??= ChatMessagesApi(_dio, baseUrl: _baseUrl);

  ImagesApi get images => _images ??= ImagesApi(_dio, baseUrl: _baseUrl);

  CommissionsApi get commissions => _commissions ??= CommissionsApi(_dio, baseUrl: _baseUrl);

  CommissionWorksApi get commissionWorks => _commissionWorks ??= CommissionWorksApi(_dio, baseUrl: _baseUrl);
}
