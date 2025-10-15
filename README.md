# Grimity
그림쟁이들을 위한 그림 커뮤니티, 그리미티에 대한 Flutter 기반의 모바일 애플리케이션입니다.

### 설정 파일 불러오기
최상위 경로를 기준으로 터미널에 아래와 같이 입력하세요.

```bash
dart run tools/fetch_config.dart
```


### VSCode 빌드 작업
**Visual Studio Code**를 사용한다면 프로젝트를 열고 `Ctrl + Shift + B`를 눌러 build_runner watch 작업을 손쉽게 곧바로 실행할 수 있습니다. 이 작업은 Riverpod, Freezed 등의 코드 생성기를 자동으로 감지하고 빌드 합니다.

또는 이를 수동으로 실행하고 싶다면 터미널에 아래와 같이 입력하세요.

```bash
dart run build_runner watch --delete-conflicting-outputs
```
