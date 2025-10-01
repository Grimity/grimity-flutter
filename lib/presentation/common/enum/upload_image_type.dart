enum UploadImageType {
  profile,
  feed,
  background,
  post,
  chat;

  String toJson() => name;

  static UploadImageType fromJson(String value) => UploadImageType.values.firstWhere((e) => e.name == value);
}
