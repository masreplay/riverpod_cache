import 'package:dio/dio.dart';
import 'package:example/todo_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_cache/riverpod_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'main.g.dart';

@riverpod
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError();
}

@riverpod
Stream<TodoResponse> todo(TodoRef ref) {
  return ref.streamOfflinePersistence(
    key: 'todo',
    future: () async {
      final response = await Dio().get(
        'https://jsonplaceholder.typicode.com/todos/1',
      );
      return TodoResponse.fromJson(response.data);
    },
    sharedPreferences: ref.read(sharedPreferencesProvider),
    fromJson: TodoResponse.fromJson,
    toJson: (value) => value.toJson(),
  );
}

Future<void> main() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(todoProvider);

    return Scaffold(
      body: state.when(
        data: (data) {
          return const Center(
            child: Text('Hello World!'),
          );
        },
        error: (error, StackTrace stackTrace) {
          return Center(
            child: Text('Error: $error'),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
