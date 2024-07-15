// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'5bd64b2e955a2adbe9af0a4cd3edab6923105998';

/// See also [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider =
    AutoDisposeProvider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SharedPreferencesRef = AutoDisposeProviderRef<SharedPreferences>;
String _$todoHash() => r'd2043c155aba538eda21e481142a923bbacac91a';

/// See also [todo].
@ProviderFor(todo)
final todoProvider = AutoDisposeFutureProvider<TodoResponse>.internal(
  todo,
  name: r'todoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TodoRef = AutoDisposeFutureProviderRef<TodoResponse>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
