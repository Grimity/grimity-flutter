enum FollowTabType {
  follower('팔로워', '아직 나를 팔로우하는 유저가 없어요'),
  following('팔로잉', '아직 팔로잉하는 유저가 없어요');

  final String title;

  final String emptyMessage;

  const FollowTabType(this.title, this.emptyMessage);
}
