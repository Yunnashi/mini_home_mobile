// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserGroup {
  int get id;
  String? get name; // ignore: invalid_annotation_target
  @JsonKey(fromJson: _devicesFromJson, toJson: _devicesToJson)
  List<Device>? get devices;

  /// Create a copy of UserGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserGroupCopyWith<UserGroup> get copyWith =>
      _$UserGroupCopyWithImpl<UserGroup>(this as UserGroup, _$identity);

  /// Serializes this UserGroup to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserGroup &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.devices, devices));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, const DeepCollectionEquality().hash(devices));

  @override
  String toString() {
    return 'UserGroup(id: $id, name: $name, devices: $devices)';
  }
}

/// @nodoc
abstract mixin class $UserGroupCopyWith<$Res> {
  factory $UserGroupCopyWith(UserGroup value, $Res Function(UserGroup) _then) =
      _$UserGroupCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String? name,
      @JsonKey(fromJson: _devicesFromJson, toJson: _devicesToJson)
      List<Device>? devices});
}

/// @nodoc
class _$UserGroupCopyWithImpl<$Res> implements $UserGroupCopyWith<$Res> {
  _$UserGroupCopyWithImpl(this._self, this._then);

  final UserGroup _self;
  final $Res Function(UserGroup) _then;

  /// Create a copy of UserGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? devices = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      devices: freezed == devices
          ? _self.devices
          : devices // ignore: cast_nullable_to_non_nullable
              as List<Device>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [UserGroup].
extension UserGroupPatterns on UserGroup {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UserGroup value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserGroup() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UserGroup value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserGroup():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UserGroup value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserGroup() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int id,
            String? name,
            @JsonKey(fromJson: _devicesFromJson, toJson: _devicesToJson)
            List<Device>? devices)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserGroup() when $default != null:
        return $default(_that.id, _that.name, _that.devices);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int id,
            String? name,
            @JsonKey(fromJson: _devicesFromJson, toJson: _devicesToJson)
            List<Device>? devices)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserGroup():
        return $default(_that.id, _that.name, _that.devices);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int id,
            String? name,
            @JsonKey(fromJson: _devicesFromJson, toJson: _devicesToJson)
            List<Device>? devices)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserGroup() when $default != null:
        return $default(_that.id, _that.name, _that.devices);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserGroup implements UserGroup {
  const _UserGroup(
      {required this.id,
      this.name,
      @JsonKey(fromJson: _devicesFromJson, toJson: _devicesToJson)
      final List<Device>? devices})
      : _devices = devices;
  factory _UserGroup.fromJson(Map<String, dynamic> json) =>
      _$UserGroupFromJson(json);

  @override
  final int id;
  @override
  final String? name;
// ignore: invalid_annotation_target
  final List<Device>? _devices;
// ignore: invalid_annotation_target
  @override
  @JsonKey(fromJson: _devicesFromJson, toJson: _devicesToJson)
  List<Device>? get devices {
    final value = _devices;
    if (value == null) return null;
    if (_devices is EqualUnmodifiableListView) return _devices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of UserGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserGroupCopyWith<_UserGroup> get copyWith =>
      __$UserGroupCopyWithImpl<_UserGroup>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserGroupToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserGroup &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._devices, _devices));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, const DeepCollectionEquality().hash(_devices));

  @override
  String toString() {
    return 'UserGroup(id: $id, name: $name, devices: $devices)';
  }
}

/// @nodoc
abstract mixin class _$UserGroupCopyWith<$Res>
    implements $UserGroupCopyWith<$Res> {
  factory _$UserGroupCopyWith(
          _UserGroup value, $Res Function(_UserGroup) _then) =
      __$UserGroupCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String? name,
      @JsonKey(fromJson: _devicesFromJson, toJson: _devicesToJson)
      List<Device>? devices});
}

/// @nodoc
class __$UserGroupCopyWithImpl<$Res> implements _$UserGroupCopyWith<$Res> {
  __$UserGroupCopyWithImpl(this._self, this._then);

  final _UserGroup _self;
  final $Res Function(_UserGroup) _then;

  /// Create a copy of UserGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? devices = freezed,
  }) {
    return _then(_UserGroup(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      devices: freezed == devices
          ? _self._devices
          : devices // ignore: cast_nullable_to_non_nullable
              as List<Device>?,
    ));
  }
}

// dart format on
