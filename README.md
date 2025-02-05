<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

서버에서 반환하는 기본 response 데이터 및 에러를 DTO 를 통해 변환

## Features

- ApiContext 를 통해 api 통신과 관련된 모든 데이터 관리
- 서버에서 기본적으로 반환하는 response 값 변환
- 서버에서 반환하는 에러 코드를 통해 exception 발생

## Getting started

### dependencies
http: ^1.2.2

### dev_dependencies
flutter_lints: ^3.0.0
  
## Usage
```dart
ApiContext
``` 를

```dart
final context = ApiContext();
final response = await network.current.request(context);
```

## Additional information

# network_manager
