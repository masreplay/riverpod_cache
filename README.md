# Riverpod offline persistence

[![Pub](https://img.shields.io/pub/v/riverpod_cache.svg)](https://pub.dev/packages/riverpod_cache)
[![GitHub stars](https://img.shields.io/github/stars/masreplay/riverpod_cache.svg?style=social)](https://github.com/masreplay/riverpod_cache)

Add offline persistence support for Riverpod providers

## inspiration
Fix Riverpod issue of cache and offline persistence  https://github.com/rrousselGit/riverpod/issues/1032

## Features
- [x] Cache `FutureProvider` 
- [x] Cache `StreamProvider` 
- [x] Cache `StateNotifierProvider`
- [x] Cache `StateProvider`
- [x] And more...

## Getting Started

In order to use this package, you need to add `riverpod_cache` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  riverpod_cache: ^0.0.2
```

Then, run `flutter pub get` to fetch the package.

## Usage

```dart
import 'package:riverpod_cache/riverpod_cache.dart';

@riverpod
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError();
}

@riverpod
Stream<TodoResponse> todo(TodoRef ref) {
  return ref.cacheFirstOfflinePersistence(
    key: 'todo',
    future: () async {
      await Future.delayed(const Duration(seconds: 2));
      final response = await Dio().get(
        'https://jsonplaceholder.typicode.com/todos/1',
      );

      final result = TodoResponse.fromJson(response.data);

      return result;
    },
    sharedPreferences: ref.read(sharedPreferencesProvider),
    fromJson: TodoResponse.fromJson,
    toJson: (object) => object.toJson(),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MainApp(),
    ),
  );
}
```
## Documentation

For more details, check out the [documentation](https://pub.dev/documentation/riverpod_cache/latest/).

## Contributing

Contributions are welcome! If you find any issues or have suggestions, please create a new issue or submit a pull request.

## License

This project is licensed under the [MIT License](./LICENSE).
