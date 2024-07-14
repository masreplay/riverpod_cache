import 'dart:convert';

import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension FutureProviderOfflinePersistence on Ref {
  /// Return the [future] first if error occurs, it will return the cached value
  ///
  /// [T] is the type that will be emitted
  /// [Encodable] is the type that can be converted to and from json, and must be encodable by [jsonEncode]
  Future<T> futureFirstOfflinePersistence<T, Encodable>({
    required String key,
    required Future<T> Function() future,
    required SharedPreferences sharedPreferences,
    required T Function(Encodable map) fromJson,
    required Encodable Function(T object) toJson,
  }) async {
    try {
      final value = await future();
      await sharedPreferences.setString(key, jsonEncode(toJson(value)));

      return value;
    } catch (e) {
      final raw = sharedPreferences.getString(key);
      if (raw == null) rethrow;

      return fromJson(jsonDecode(raw));
    }
  }

  /// Emit the cache first then the [future] and if error occurred emit the cache
  ///
  /// [T] is the type that will be emitted
  /// [Encodable] is the type that can be converted to and from json, and must be encodable by [jsonEncode]
  Stream<T> cacheFirstOfflinePersistence<T, Encodable>({
    required String key,
    required Future<T> Function() future,
    required SharedPreferences sharedPreferences,
    required T Function(Encodable map) fromJson,
    required Encodable Function(T object) toJson,
  }) async* {
    T? getCachedResult() {
      final raw = sharedPreferences.getString(key);
      if (raw == null) return null;
      return fromJson(jsonDecode(raw));
    }

    try {
      final cachedResult = getCachedResult();
      if (cachedResult != null) yield cachedResult;

      final result = await future();

      if (cachedResult == result) return;

      await sharedPreferences.setString(key, jsonEncode(toJson(result)));
      yield result;
    } catch (e) {
      final cachedResult = getCachedResult();
      if (cachedResult != null) {
        yield cachedResult;
      } else {
        rethrow;
      }
    }
  }
}
