import 'dart:convert';

import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension SharedPreferencesCache on Ref {
  //
  Future<T> offlinePersistence<T>({
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
}
