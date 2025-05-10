extension DateTimeExtension on DateTime {
  String toRelativeTime() {
    final now = DateTime.now();
    final diff = now.difference(this);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    }
    if (diff.inDays < 30) {
      return '${diff.inDays}일 전';
    }
    if (diff.inDays < 365) {
      return '${diff.inDays ~/ 30}달 전';
    }
    return '${diff.inDays ~/ 365}년 전';
  }
}
