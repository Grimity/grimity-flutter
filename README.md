# 🖌️ Grimity
그림쟁이들을 위한 그림 커뮤니티, 그리미티에 대한 Flutter 기반의 모바일 애플리케이션입니다.

<a href="https://play.google.com/store/apps/details?id=com.grimity.flutter"><img height="50" alt="Google Play" src="https://github.com/user-attachments/assets/cb3b771c-a41b-4878-9606-75dc6a5555a0" />
<a href="https://apps.apple.com/us/app/%EA%B7%B8%EB%A6%AC%EB%AF%B8%ED%8B%B0/id6754501709"><img height="50" alt="App Store" src="https://github.com/user-attachments/assets/a00afbda-3e96-4d2b-9f7c-ef6b3bf2129e" /></a>


<img width="3667" height="1080" src="https://github.com/user-attachments/assets/d617c22c-0c61-4b49-ad9c-95ca59336b8e" />

### 🔗 관련 종속성
<a href="https://riverpod.dev/"><img src="https://github.com/user-attachments/assets/ae070ff6-5c2b-43a8-ae97-8f34114093d0"></a>
<a href="https://pub.dev/packages/freezed"><img src="https://github.com/user-attachments/assets/184030ac-da8f-400e-b093-d14a601fd16d"></a>
<a href="https://pub.dev/packages/go_router"><img src="https://github.com/user-attachments/assets/97b636fd-6816-4ef5-861f-daa5081486ea"></a>
<a href="https://pub.dev/packages/dio"><img src="https://github.com/user-attachments/assets/8ea8acf8-d09e-4b3b-837e-daa799b99b08"></a>
<a href="https://pub.dev/packages/retrofit"><img src="https://github.com/user-attachments/assets/93e98556-e40b-4841-8025-c439dc0c9c3f"></a>

| 종속성 | 최소 버전 | 배포 버전 |
| ---- | ------- | ------- |
| Flutter SDK | >= 3.35.7 | [FLUTTER_VERSION](https://github.com/Grimity/grimity-flutter/settings/variables/actions) |

### 🚀 자동화 배포
자동화 배포를 위한 CI/CD 에서는 Fastlane을 통한 GitHub Actions를 사용합니다.

- 상단 Actions 탭 클릭
- 왼쪽 사이드바에서 All workflows → 자동화 배포 선택
- Run workflow 버튼 클릭
- 배포할 버전 입력 ...(이하 생략)

### 🗂️ 초기 세팅하기
최상위 경로를 기준으로 터미널에 아래와 같이 입력하세요.

> [!NOTE]
> 해당 CLI는 앱을 빌드 하는데 필수적인 설정 파일들을 불러오고 build_runner와 같은 Dart 전처리를 수행하는 등의 작업을 수행합니다.

```bash
dart run tools/setup.dart
```

### ⚙️ 설정 파일 불러오기
최상위 경로를 기준으로 터미널에 아래와 같이 입력하세요.

```bash
dart run git_config fetch
```

### 🔗 XCode 빌드 종속성
XCode를 통한 빌드 과정에서는 FlutterFire CLI가 필수적으로 설치되어 있어야 합니다. 따라서 최상위 경로를 기준으로 터미널에 아래와 같이 입력하세요.

```bash
dart pub global activate flutterfire_cli
```

### 💻 VSCode 빌드 작업
**Visual Studio Code**를 사용한다면 프로젝트를 열고 `Ctrl + Shift + B`를 눌러 build_runner watch 작업을 손쉽게 곧바로 실행할 수 있습니다. 이 작업은 Riverpod, Freezed 등의 코드 생성기를 자동으로 감지하고 빌드 합니다.

또는 이를 수동으로 실행하고 싶다면 터미널에 아래와 같이 입력하세요.

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### 🔥 앱 빌드 & 실행
해당 프로젝트는 **Flavor**를 사용합니다. 따라서 앱을 실행할 때는 환경에 맞는 엔트리포인트와 함께 아래 명령어를 터미널에 입력해야 합니다.

#### 개발 서버

```bash
flutter run --profile --flavor dev --target lib/app/entrypoints/main_dev.dart
```

#### 운영 서버

```bash
flutter run --profile --flavor prod --target lib/app/entrypoints/main_prod.dart
```
