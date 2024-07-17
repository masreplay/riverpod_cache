import 'dart:convert';

import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension FutureProviderOfflinePersistence<State> on FutureProviderRef<State> {
  /// Return the [future] first if error occurs, it will return the cached value
  ///
  /// [T] is the type that will be emitted
  /// [Encodable] is the type that can be converted to and from json, and must be encodable by [jsonEncode]
  Future<T> futureFirstOfflinePersistence<T, Encodable>({
    required String key,
    required Future<T> Function() future,
    required SharedPreferences sharedPreferences,
    required T Function(Encodable json) fromJson,
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
}
