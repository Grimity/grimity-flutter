class Version {
  final int major;
  final int minor;
  final int patch;

  Version(this.major, this.minor, this.patch);

  factory Version.parse(String version) {
    final parts = version.split('.');
    final major = int.tryParse(parts[0]) ?? 0;
    final minor = int.tryParse(parts[1]) ?? 0;
    final patch = int.tryParse(parts[2]) ?? 0;

    return Version(major, minor, patch);
  }

  // 강제 업데이트 필요 여부.
  // Major 버전이 더 큰 경우 true
  // Major 버전이 같고, Minor 버전이 더 큰 경우 true
  // 나머지 false
  bool isNeedForceUpdate(Version other) {
    if (other.major > major) return true;
    if (other.major == major && other.minor > minor) return true;
    return false;
  }
}
