import "dart:convert";

import "package:flutter/foundation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

mixin AutoDisposeNotifierNotifierOfflinePersistenceMixin<State>
    on AutoDisposeNotifier<State> {
  @protected
  SharedPreferences get sharedPreferences;

  @protected
  String get key;

  @protected
  State get defaultState;

  @protected
  Map<String, dynamic> toJson(State value);

  @protected
  State fromJson(Map<String, dynamic> map);

  @protected
  String jsonEncode(Map<String, dynamic> data) {
    return json.encode(data);
  }

  @protected
  Map<String, dynamic> jsonDecode(String raw) {
    return json.decode(raw) as Map<String, dynamic>;
  }

  Future<State> updateState(State state) async {
    try {
      final Map<String, dynamic> jsonData = toJson(state);
      final String raw = jsonEncode(jsonData);
      await sharedPreferences.setString(key, raw);

      return this.state = state;
    } catch (e) {
      return this.state;
    }
  }

  Future<State> update(State Function(State state) changed) {
    return updateState(changed(state));
  }

  Future<void> clear() => updateState(defaultState);

  State firstBuild() {
    final raw = sharedPreferences.getString(key);

    final default_ = defaultState;
    if (raw == null) return default_;
    try {
      final Map<String, dynamic> map = jsonDecode(raw);
      return fromJson(map);
    } catch (e) {
      return default_;
    }
  }
}

mixin NotifierOfflinePersistenceMixin<State> on Notifier<State> {
  @protected
  SharedPreferences get sharedPreferences;

  @protected
  String get key;

  @protected
  State get defaultState;

  @protected
  Map<String, dynamic> toJson(State value);

  @protected
  State fromJson(Map<String, dynamic> map);

  @protected
  String jsonEncode(Map<String, dynamic> data) {
    return json.encode(data);
  }

  @protected
  Map<String, dynamic> jsonDecode(String raw) {
    return json.decode(raw) as Map<String, dynamic>;
  }

  Future<State> updateState(State state) async {
    try {
      final Map<String, dynamic> jsonData = toJson(state);
      final String raw = jsonEncode(jsonData);
      await sharedPreferences.setString(key, raw);

      return this.state = state;
    } catch (e) {
      return this.state;
    }
  }

  Future<State> update(State Function(State state) changed) {
    return updateState(changed(state));
  }

  Future<void> clear() => updateState(defaultState);

  State firstBuild() {
    final raw = sharedPreferences.getString(key);

    final default_ = defaultState;
    if (raw == null) return default_;
    try {
      final Map<String, dynamic> map = jsonDecode(raw);
      return fromJson(map);
    } catch (e) {
      return default_;
    }
  }
}
