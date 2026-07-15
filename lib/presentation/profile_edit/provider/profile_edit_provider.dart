import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:grimity/app/config/app_router.dart';
import 'package:grimity/app/enum/grimity.enum.dart';
import 'package:grimity/app/extension/string_extension.dart';
import 'package:grimity/app/service/toast_service.dart';
import 'package:grimity/app/util/validator_util.dart';
import 'package:grimity/domain/dto/me_request_params.dart';
import 'package:grimity/domain/entity/link.dart';
import 'package:grimity/domain/usecase/me_usecases.dart';
import 'package:grimity/domain/usecase/users_usecase.dart';
import 'package:grimity/presentation/common/provider/user_auth_provider.dart';
import 'package:grimity/presentation/profile/provider/profile_data_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_edit_provider.freezed.dart';

part 'profile_edit_provider.g.dart';

/// 프로필 수정 상태를 관리하는 프로바이더
@riverpod
class ProfileEdit extends _$ProfileEdit {
  @override
  ProfileEditState build() {
    final user = ref.read(userAuthProvider);

    late ProfileEditState state;

    if (user == null) {
      state = const ProfileEditState(
        nickname: '',
        originalNickname: '',
        description: '',
        url: '',
        links: [],
      );
    } else {
      state = ProfileEditState(
        image: user.image,
        backgroundImage: user.backgroundImage,
        nickname: user.name,
        originalNickname: user.name,
        description: user.description ?? '',
        url: user.url,
        links: user.links ?? [],
      );
    }

    state = state.copyWith(initialState: state);

    return state;
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

  Future<bool> updateUser() async {
    if (!await validate()) {
      return false;
    }

    try {
      state = state.copyWith(isLoading: true);

      final request = UpdateUserRequest(
        name: state.nickname,
        url: state.url,
        description: state.description,
        links: state.links,
      );

      final result = await updateUserUseCase.execute(request);

      // 새로운 사용자 정보로 새로고침
      if (result.isSuccess) {
        await ref.read(userAuthProvider.notifier).getUser();
      }

      return result.fold(
        onSuccess: (data) {
          ToastService.showSuccess('프로필 수정이 완료되었어요');
          return true;
        },
        onFailure: (error) {
          ToastService.showFailure('프로필 수정에 실패했어요');
          return false;
        },
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
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
    if (!ValidatorUtil.isAvailableUrl(state.url) || state.isUrlChecking) {
      state = state.copyWith(
        isUrlChecking: false,
        urlState: GrimityTextFieldState.error,
        urlCheckMessage: state.url.getUrlCheckMessage(),
      );
      return;
    }

    state = state.copyWith(isUrlChecking: true);

    try {
      final bool isAvailable = ValidatorUtil.isAvailableUrl(state.url);

      if (!isAvailable) {
        state = state.copyWith(
          isUrlChecking: false,
          urlState: GrimityTextFieldState.error,
          urlCheckMessage: state.url.getUrlCheckMessage(),
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

  Future<void> handleSave(BuildContext context) async {
    final router = ref.read(routerProvider);

    final isSuccess = await updateUser();

    if (isSuccess && context.mounted && state.isSaveable) {
      final newUrl = state.url;

      // 기존 프로필 페이지에서 사용하는 데이터 무효화
      ref.invalidate(profileDataProvider);

      // 기존 프로필 URL이 변경된 경우
      if (state.initialState?.url != newUrl) {
        context.pop();

        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) => router.pushReplacement(ProfileRoute.makePath(newUrl)),
        );
      }

      state = state.copyWith(initialState: state);
    }
  }
}

/// 프로필 수정 상태 클래스
@freezed
abstract class ProfileEditState with _$ProfileEditState {
  const ProfileEditState._();

  const factory ProfileEditState({
    ProfileEditState? initialState,
    @Default(false) bool isLoading,
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

  bool get isSaveable {
    if (initialState == null) return false;

    final hasChanges =
        image != initialState!.image ||
        backgroundImage != initialState!.backgroundImage ||
        (nickname.isNotEmpty && nickname != initialState!.nickname) ||
        description != initialState!.description ||
        url != initialState!.url ||
        _isLinksChanged(links, initialState!.links);

    final isValid = nicknameState == GrimityTextFieldState.normal && urlState == GrimityTextFieldState.normal;

    return !isLinkEditing && hasChanges && isValid;
  }

  bool _isLinksChanged(List<Link> current, List<Link> initial) {
    if (current.length != initial.length) return true;
    for (int i = 0; i < current.length; i++) {
      if (current[i].linkName != initial[i].linkName || current[i].link != initial[i].link) {
        return true;
      }
    }
    return false;
  }
}
