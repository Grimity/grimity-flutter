enum StorageTabType {
  likeFeed("좋아요한 그림", "아직 좋아요한 그림이 없어요"),
  saveFeed("저장한 그림", "아직 저장한 그림이 없어요"),
  savePost("저장한 글", "아직 저장한 글이 없어요");

  final String title;
  final String emptyMessage;

  const StorageTabType(this.title, this.emptyMessage);
}
