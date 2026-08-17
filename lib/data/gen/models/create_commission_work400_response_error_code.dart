// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum CreateCommissionWork400ResponseErrorCode {
  @JsonValue('SELF_REQUEST_NOT_ALLOWED')
  selfRequestNotAllowed('SELF_REQUEST_NOT_ALLOWED'),
  @JsonValue('COMMISSION_AUTHOR_MISMATCH')
  commissionAuthorMismatch('COMMISSION_AUTHOR_MISMATCH'),
  @JsonValue('ANSWERS_LENGTH_MISMATCH')
  answersLengthMismatch('ANSWERS_LENGTH_MISMATCH'),
  @JsonValue('ANSWER_TYPE_REQUIRED')
  answerTypeRequired('ANSWER_TYPE_REQUIRED'),
  @JsonValue('ANSWER_TITLE_REQUIRED')
  answerTitleRequired('ANSWER_TITLE_REQUIRED'),
  @JsonValue('SELECT_OPTIONS_REQUIRED')
  selectOptionsRequired('SELECT_OPTIONS_REQUIRED'),
  @JsonValue('TEXT_ANSWER_REQUIRED')
  textAnswerRequired('TEXT_ANSWER_REQUIRED'),
  @JsonValue('TEXT_HAS_SELECTED_OPTIONS')
  textHasSelectedOptions('TEXT_HAS_SELECTED_OPTIONS'),
  @JsonValue('SELECT_HAS_TEXT')
  selectHasText('SELECT_HAS_TEXT'),
  @JsonValue('SELECT_HAS_ATTACHED_IMAGES')
  selectHasAttachedImages('SELECT_HAS_ATTACHED_IMAGES'),
  @JsonValue('SELECTED_OPTION_NOT_IN_OPTIONS')
  selectedOptionNotInOptions('SELECTED_OPTION_NOT_IN_OPTIONS'),
  @JsonValue('SELECTED_OPTIONS_DUPLICATED')
  selectedOptionsDuplicated('SELECTED_OPTIONS_DUPLICATED'),
  @JsonValue('SINGLE_SELECT_ANSWER_INVALID')
  singleSelectAnswerInvalid('SINGLE_SELECT_ANSWER_INVALID'),
  @JsonValue('MULTI_SELECT_ANSWER_REQUIRED')
  multiSelectAnswerRequired('MULTI_SELECT_ANSWER_REQUIRED'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  const CreateCommissionWork400ResponseErrorCode(this.json);

  factory CreateCommissionWork400ResponseErrorCode.fromJson(String json) => values.firstWhere(
    (e) => e.json == json,
    orElse: () => $unknown,
  );

  final String? json;
  String toJson() {
    final value = json;
    if (value == null) {
      throw StateError(
        'Cannot convert enum value with null JSON representation to String. '
        'This usually happens for \$unknown or @JsonValue(null) entries.',
      );
    }
    return value as String;
  }

  @override
  String toString() => json?.toString() ?? super.toString();

  /// Returns all defined enum values excluding the $unknown value.
  static List<CreateCommissionWork400ResponseErrorCode> get $valuesDefined =>
      values.where((value) => value != $unknown).toList();
}
