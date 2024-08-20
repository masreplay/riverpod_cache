// ignore_for_file: unused_result

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

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
Stream<TodoResponse> cacheFirstTodo(CacheFirstTodoRef ref) {
  return ref.cacheFirstOfflinePersistence(
    key: 'todo',
    future: () async {
      log('[cacheFirstTodo] Future request sent');
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

@riverpod
Future<TodoResponse> futureFirstTodo(FutureFirstTodoRef ref) {
  return ref.futureFirstOfflinePersistence(
    key: 'todo',
    future: () async {
      log('[futureFirstTodo] Future request sent');
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

@riverpod
Future<TodoResponse> cacheOrFutureTodo(CacheOrFutureTodoRef ref) {
  return ref.cacheOrFutureIfNotPersistence(
    key: 'todo',
    future: () async {
      log('[cacheOrFutureTodo] Future request sent');
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
    final cacheFirstProvider = cacheFirstTodoProvider;
    final cacheFirstState = ref.watch(cacheFirstProvider);

    final futureFirstProvider = futureFirstTodoProvider;
    final futureFirstState = ref.watch(futureFirstProvider);

    final cacheOrFutureProvider = cacheOrFutureTodoProvider;
    final cacheOrFutureState = ref.watch(cacheOrFutureProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Riverpod Cache Example'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            ref.refresh(cacheFirstProvider.future);
            ref.refresh(futureFirstProvider);
            ref.refresh(cacheOrFutureProvider);
            return;
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Cache First',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                cacheFirstState.when(
                  data: (data) {
                    return Text(
                      const JsonEncoder.withIndent('  ').convert(data.toJson()),
                    );
                  },
                  error: (error, _) {
                    return Text(error.toString());
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Future First',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                futureFirstState.when(
                  data: (data) {
                    return Text(
                      const JsonEncoder.withIndent('  ').convert(data.toJson()),
                    );
                  },
                  error: (error, _) {
                    return Text(error.toString());
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Cache or Future',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                cacheOrFutureState.when(
                  data: (data) {
                    return Text(
                      const JsonEncoder.withIndent('  ').convert(data.toJson()),
                    );
                  },
                  error: (error, _) {
                    return Text(error.toString());
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
