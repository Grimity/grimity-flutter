import 'package:flutter_test/flutter_test.dart';
import 'package:grimity/api/api.dart';
import 'package:grimity/presentation/post_upload/models/post_upload_model.dart';

void main() {
  test('초기 입력값이 없으면 필수 입력값만 채워도 제출할 수 있는지 확인', () {
    final model = PostUploadModel.from(null, content: '', hasText: false);
    expect(model.canSubmit, isFalse);

    final updated = model.copyWith(
      title: '제목',
      content: '<p>본문</p>',
      hasText: true,
    );

    expect(updated.canSubmit, isTrue);
  });

  test('초기 입력값이 있으면 변경 사항이 있어야 제출할 수 있는지 확인', () {
    final model = PostUploadModel.from(
      PostDetailResponse(
        id: '',
        title: '제목',
        content: '<p>본문</p>',
        createdAt: DateTime(2026),
        type: .normal,
        viewCount: 0,
        commentCount: 0,
        likeCount: 0,
        isLike: false,
        isSave: false,
        author: const .new(id: '', name: '작가', url: 'user'),
      ),
      content: '<p>본문</p>',
      hasText: true,
    );

    expect(model.canSubmit, isFalse);

    final updated = model.copyWith(title: '수정한 제목');
    expect(updated.canSubmit, isTrue);
    expect(updated.copyWith(title: model.title).canSubmit, isFalse);
  });
}
