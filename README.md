# Grimity
그림쟁이들을 위한 그림 커뮤니티, 그리미티에 대한 Flutter 기반의 모바일 애플리케이션입니다.

### 관련 종속성
<a href="https://riverpod.dev/"><img src="https://github.com/user-attachments/assets/ae070ff6-5c2b-43a8-ae97-8f34114093d0"></a>
<a href="https://pub.dev/packages/freezed"><img src="https://github.com/user-attachments/assets/184030ac-da8f-400e-b093-d14a601fd16d"></a>
<a href="https://pub.dev/packages/go_router"><img src="https://github.com/user-attachments/assets/97b636fd-6816-4ef5-861f-daa5081486ea"></a>
<a href="https://pub.dev/packages/dio"><img src="https://github.com/user-attachments/assets/8ea8acf8-d09e-4b3b-837e-daa799b99b08"></a>
<a href="https://pub.dev/packages/retrofit"><img src="https://github.com/user-attachments/assets/93e98556-e40b-4841-8025-c439dc0c9c3f"></a>

| 종속성 | 최소 버전 | 권장 버전 |
| ---- | ------- | ------- |
| Flutter SDK | >= 3.7.2 | [최신 버전](https://github.com/flutter/flutter)

### 설정 파일 불러오기
최상위 경로를 기준으로 터미널에 아래와 같이 입력하세요.

```bash
dart run git_config fetch
```

### VSCode 빌드 작업
**Visual Studio Code**를 사용한다면 프로젝트를 열고 `Ctrl + Shift + B`를 눌러 build_runner watch 작업을 손쉽게 곧바로 실행할 수 있습니다. 이 작업은 Riverpod, Freezed 등의 코드 생성기를 자동으로 감지하고 빌드 합니다.

또는 이를 수동으로 실행하고 싶다면 터미널에 아래와 같이 입력하세요.

```bash
dart run build_runner watch --delete-conflicting-outputs
```
