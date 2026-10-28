import 'package:flutter_test/flutter_test.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/feed_upload/models/feed_upload_model.dart';

void main() {
  final feed = FeedDetailResponse(
    id: 'feed',
    title: '제목',
    thumbnail: 'https://example.com/second_600x600.webp',
    likeCount: 0,
    viewCount: 0,
    cards: [
      'https://example.com/first_600x600.webp',
      'https://example.com/second_600x600.webp',
    ],
    createdAt: DateTime(2026),
    content: '본문',
    tags: ['태그'],
    isLike: false,
    isSave: false,
    commentCount: 0,
    album: const AlbumBaseResponse(id: 'album', name: '앨범'),
    author: const UserBaseWithBlockedResponse(
      id: 'user',
      name: '작가',
      url: 'artist',
      isBlocked: false,
    ),
  );

  test('수정 초기값은 기존 앨범과 대표 이미지를 유지하고 제출을 막는다', () {
    final model = FeedUploadModel.from(feed);

    expect(model.album?.id, 'album');
    expect(model.thumbnail, same(model.images[1]));
    expect(model.canSubmit, isFalse);
    expect(model.copyWith(title: '새 제목').canSubmit, isTrue);
  });

  test('태그와 이미지를 원래 내용으로 되돌리면 변경 없는 상태가 된다', () {
    final model = FeedUploadModel.from(feed);
    final changed = model.copyWith(tags: [...model.tags, '추가']);
    expect(changed.canSubmit, isTrue);

    final restored = changed.copyWith(
      tags: [...model.tags],
      images: [...model.images],
      album: const AlbumBaseResponse(id: 'album', name: '앨범'),
    );
    expect(restored.canSubmit, isFalse);
    expect(model.tags, ['태그']);
    expect(FeedUploadModel.from(feed).different(model), isFalse);
  });

  test('이미지를 모두 삭제한 뒤 다시 선택하면 대표 이미지도 함께 갱신된다', () {
    final model = FeedUploadModel.from(feed);
    final empty = model.copyWith(images: []);
    expect(empty.thumbnail, isNull);
    expect(empty.canSubmit, isFalse);

    final selected = empty.copyWith(
      images: [model.images.first],
      thumbnail: model.images.first,
    );
    expect(selected.thumbnail, same(selected.images.first));
    expect(selected.canSubmit, isTrue);

    final draft = FeedUploadModel.from(null).copyWith(
      images: [model.images.first],
      thumbnail: model.images.first,
      title: '새 피드',
      content: '새 본문',
    );
    expect(draft.canSubmit, isTrue);
  });
}
