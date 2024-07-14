import 'dart:convert';

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
  return ref.cacheFirstOfflinePersistence(
    key: 'todo',
    future: () async {
      await Future.delayed(const Duration(seconds: 2));
      final response = await Dio().get(
        'https://jsonplaceholder.typicode.com/todos/1',
      );

      final result = TodoResponse.fromJson(response.data);

      print('Success');
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
    final provider = todoProvider;
    final state = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Cache Example'),
      ),
      body: state.when(
        data: (data) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(provider.future),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Center(
                child: Text(
                  const JsonEncoder.withIndent('  ').convert(data.toJson()),
                ),
              ),
            ),
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
