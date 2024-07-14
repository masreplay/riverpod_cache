import 'dart:convert';

import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension FutureProviderOfflinePersistence on Ref {
  /// Return the [future] first if error occurs, it will return the cached value
  Future<T> futureOfflinePersistence<T>({
    required String key,
    required Future<T> Function() future,
    required SharedPreferences sharedPreferences,
    required T Function(Map<String, dynamic> map) fromJson,
    required Map<String, dynamic> Function(T object) toJson,
  }) async {
    try {
      final value = await future();
      await sharedPreferences.setString(key, jsonEncode(toJson(value)));

      return value;
    } catch (e) {
      final String? raw = sharedPreferences.getString(key);
      if (raw == null) rethrow;

      final Map<String, dynamic> cached = jsonDecode(raw);
      return fromJson(cached);
    }
  }

  /// Emit the cache first then the [future] and if error occurred return the cached value
  Stream<T> streamOfflinePersistence<T>({
    required String key,
    required Future<T> Function() future,
    required SharedPreferences sharedPreferences,
    required T Function(Map<String, dynamic> map) fromJson,
    required Map<String, dynamic> Function(T object) toJson,
  }) async* {
    try {
      final String? raw = sharedPreferences.getString(key);
      if (raw != null) {
        final Map<String, dynamic> cached = jsonDecode(raw);
        yield fromJson(cached);
      }

      final value = await future();
      await sharedPreferences.setString(key, jsonEncode(toJson(value)));

      yield value;
    } catch (e) {
      final String? raw = sharedPreferences.getString(key);
      if (raw == null) rethrow;

      final Map<String, dynamic> cached = jsonDecode(raw);
      yield fromJson(cached);
    }
  }
}
