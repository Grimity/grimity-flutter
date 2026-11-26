<img width="1024" height="300" alt="banner" src="https://github.com/user-attachments/assets/3d68364b-e05a-4e54-afd5-571a14267426" />

# 🖌️ Grimity

그림쟁이들을 위한 그림 커뮤니티, 그리미티에 대한 Flutter 기반의 모바일 애플리케이션입니다.

<a href="https://play.google.com/store/apps/details?id=com.grimity.flutter"><img height="50" alt="Google Play" src="https://github.com/user-attachments/assets/cb3b771c-a41b-4878-9606-75dc6a5555a0" />
<a href="https://apps.apple.com/us/app/%EA%B7%B8%EB%A6%AC%EB%AF%B8%ED%8B%B0/id6754501709"><img height="50" alt="App Store" src="https://github.com/user-attachments/assets/a00afbda-3e96-4d2b-9f7c-ef6b3bf2129e" /></a>

<img width="3667" height="1080" alt="Preview Images" src="https://github.com/user-attachments/assets/d617c22c-0c61-4b49-ad9c-95ca59336b8e" />

### 🔗 관련 종속성

| 종속성 | 최소 버전 | 배포 버전 |
| ---- | ------- | ------- |
| Flutter SDK | >= 3.50.0 | [FLUTTER_VERSION](https://github.com/Grimity/grimity-flutter/settings/variables/actions) |

### 🚀 자동화 배포

자동화 배포를 위한 CI/CD 에서는 Fastlane을 통한 GitHub Actions를 사용합니다.

- 상단 Actions 탭 클릭
- 왼쪽 사이드바에서 All workflows → 자동화 배포 선택
- Run workflow 버튼 클릭
- 배포할 버전 입력 ...(이하 생략)

### 🗂️ 초기 세팅하기

해당 CLI는 앱 빌드에 필요한 [비공개 설정 파일](https://github.com/Grimity/grimity-flutter-config)을 가져오며, macOS에서는 앱 서명 인증서도 함께 설정합니다.

```bash
dart run tools/setup.dart
```

### ⚙️ 설정 파일 불러오기

`tools/setup.dart`를 실행했다면 별도로 실행할 필요는 없습니다.

다만 [비공개 설정 파일](https://github.com/Grimity/grimity-flutter-config)이 업데이트된 경우, 변경 사항을 반영하려면 다시 실행해야 합니다.

```bash
dart run git_config fetch
```

### 🏗️ OpenAPI 코드 생성하기

서버의 OpenAPI 명세를 기준으로 API 클라이언트와 요청, 응답 모델을 생성합니다.

```bash
dart run tools/openapi.dart
```

### 🔍 코드 품질 검사

일관된 코드 스타일을 유지하고 오류의 재발을 방지하기 위해, 커밋 전 반드시 코드 포맷을 적용하고 커스텀 린트와 회귀 테스트를 통과해야 합니다.

> [!NOTE]
> 푸시와 PR 생성 시 GitHub Actions에서 자동으로 검사하고 있으니, 주기적으로 확인해주세요.

```bash
dart format .
```

```bash
flutter test .
```

```bash
flutter analyze
```

## License

Grimity is source-available under the Grimity Source-Available License v1.0.

This project is not Open Source as defined by the Open Source Initiative.
