enum UploadImageType {
  profile,
  feed,
  background,
  post;

  String toJson() => name;

  static UploadImageType fromJson(String value) => UploadImageType.values.firstWhere((e) => e.name == value);
}
