import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grimity/app/enum/grimity.enum.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/app/util/validator_util.dart';
import 'package:grimity/domain/dto/me_request_params.dart';
import 'package:grimity/domain/entity/link.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/domain/usecase/users_usecase.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_edit_provider.freezed.dart';
part 'profile_edit_provider.g.dart';

/// 프로필 수정 상태를 관리하는 프로바이더
@riverpod
class ProfileEdit extends _$ProfileEdit {
  @override
  ProfileEditState build() {
    final user = ref.read(userAuthProvider);

    if (user == null) {
      return const ProfileEditState(nickname: '', originalNickname: '', description: '', url: '', links: []);
    }

    return ProfileEditState(
      image: user.image,
      backgroundImage: user.backgroundImage,
      nickname: user.name,
      originalNickname: user.name,
      description: user.description ?? '',
      url: user.url,
      links: user.links ?? [],
    );
  }

  /// 이미지 업데이트
  void updateImage(String? image) {
    state = state.copyWith(image: image);
  }

  /// 배경 이미지 업데이트
  void updateBackgroundImage(String? backgroundImage) {
    state = state.copyWith(backgroundImage: backgroundImage);
  }

  /// 닉네임 업데이트
  void updateNickname(String nickname) {
    state = state.copyWith(nickname: nickname, nicknameState: GrimityTextFieldState.normal);
  }

  /// 소개 업데이트
  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  /// URL 업데이트
  void updateUrl(String url) {
    state = state.copyWith(url: url, urlState: GrimityTextFieldState.normal);
  }

  void toggleLinkEditing() {
    state = state.copyWith(isLinkEditing: !state.isLinkEditing);
  }

  void addLink(Link link) {
    final newLinks = List<Link>.from(state.links);
    newLinks.add(link);
    state = state.copyWith(links: newLinks);
  }

  void updateLinks(List<Link> newLinks) {
    state = state.copyWith(links: newLinks);
  }

  void deleteLink(Link link) {
    final newLinks = List<Link>.from(state.links);
    newLinks.removeWhere((l) => l.linkName == link.linkName && l.link == link.link);
    state = state.copyWith(links: newLinks);
  }

  void updateLinkUrl(Link oldLink, String newUrl) {
    final newLinks = List<Link>.from(state.links);
    final index = newLinks.indexWhere((l) => l.linkName == oldLink.linkName && l.link == oldLink.link);
    if (index != -1) {
      newLinks[index] = Link(linkName: oldLink.linkName, link: newUrl);
      state = state.copyWith(links: newLinks);
    }
  }

  void updateLinkName(Link oldLink, String newName) {
    final newLinks = List<Link>.from(state.links);
    final index = newLinks.indexWhere((l) => l.linkName == oldLink.linkName && l.link == oldLink.link);
    if (index != -1) {
      newLinks[index] = Link(linkName: newName, link: oldLink.link);
      state = state.copyWith(links: newLinks);
    }
  }

  Future<void> updateUser() async {
    if (!await validate()) {
      return;
    }

    final request = UpdateUserRequest(
      name: state.nickname,
      url: state.url,
      description: state.description,
      links: state.links,
    );

    final result = await updateUserUseCase.execute(request);

    result.fold(
      onSuccess: (data) {
        state = state.copyWith(isSaved: true);
        ToastService.show('프로필 수정이 완료되었습니다');
        ref.read(userAuthProvider.notifier).getUser();
      },
      onFailure: (error) {
        ToastService.showError('프로필 수정에 실패했습니다');
      },
    );
  }

  /// 유효성 체크
  Future<bool> validate() async {
    await Future.wait([checkNicknameDuplicate(), checkUrlValidity()]);

    return state.nicknameState == GrimityTextFieldState.normal && state.urlState == GrimityTextFieldState.normal;
  }

  /// 닉네임 중복 확인
  Future<void> checkNicknameDuplicate() async {
    if (state.originalNickname == state.nickname) {
      state = state.copyWith(isNicknameChecking: false, nicknameState: GrimityTextFieldState.normal);
      return;
    }

    if (!ValidatorUtil.isValidNickname(state.nickname) || state.isNicknameChecking) {
      state = state.copyWith(
        isNicknameChecking: false,
        nicknameState: GrimityTextFieldState.error,
        nicknameCheckMessage: '닉네임은 최소 2자, 최대 12자까지 입력할 수 있어요',
      );
      return;
    }

    state = state.copyWith(isNicknameChecking: true);

    // 닉네임 중복 확인
    final result = await nameCheckUseCase.execute(state.nickname);
    result.fold(
      onSuccess: (data) {
        state = state.copyWith(isNicknameChecking: false, nicknameState: GrimityTextFieldState.normal);
      },
      onFailure: (error) {
        state = state.copyWith(
          isNicknameChecking: false,
          nicknameState: GrimityTextFieldState.error,
          nicknameCheckMessage: '중복된 닉네임입니다',
        );
      },
    );
  }

  /// URL 유효성 검증
  Future<void> checkUrlValidity() async {
    if (!ValidatorUtil.isValidUrl(state.url) || state.isUrlChecking) {
      state = state.copyWith(
        isUrlChecking: false,
        urlState: GrimityTextFieldState.error,
        urlCheckMessage: '숫자, 영문(소문자), 언더바(_)만 입력 가능합니다.',
      );
      return;
    }

    state = state.copyWith(isUrlChecking: true);

    try {
      final bool isAvailable = ValidatorUtil.isValidUrl(state.url);

      if (!isAvailable) {
        state = state.copyWith(
          isUrlChecking: false,
          urlState: GrimityTextFieldState.error,
          urlCheckMessage: '숫자, 영문(소문자), 언더바(_)만 입력 가능합니다.',
        );
        return;
      }

      state = state.copyWith(isUrlChecking: false, urlState: GrimityTextFieldState.normal);
    } catch (e) {
      state = state.copyWith(
        isUrlChecking: false,
        urlState: GrimityTextFieldState.error,
        urlCheckMessage: 'URL 확인 중 오류가 발생했습니다.',
      );
    }
  }
}

/// 프로필 수정 상태 클래스
@freezed
abstract class ProfileEditState with _$ProfileEditState {
  const factory ProfileEditState({
    @Default(false) bool isLoading,
    @Default(false) bool isSaved,
    String? image,
    String? backgroundImage,
    required String nickname,
    required String originalNickname,
    @Default(GrimityTextFieldState.normal) GrimityTextFieldState nicknameState,
    @Default(false) bool isNicknameChecking,
    String? nicknameCheckMessage,
    required String description,
    required String url,
    @Default(GrimityTextFieldState.normal) GrimityTextFieldState urlState,
    @Default(false) bool isUrlChecking,
    String? urlCheckMessage,
    @Default(false) bool isLinkEditing,
    @Default([]) List<Link> links,
  }) = _ProfileEditState;
}
