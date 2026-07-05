// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fw_update_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FwUpdateInfo {
  /// 最新ファームウェアバージョン
  String? get latestVersion;

  /// Create a copy of FwUpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FwUpdateInfoCopyWith<FwUpdateInfo> get copyWith =>
      _$FwUpdateInfoCopyWithImpl<FwUpdateInfo>(
          this as FwUpdateInfo, _$identity);

  /// Serializes this FwUpdateInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FwUpdateInfo &&
            (identical(other.latestVersion, latestVersion) ||
                other.latestVersion == latestVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, latestVersion);

  @override
  String toString() {
    return 'FwUpdateInfo(latestVersion: $latestVersion)';
  }
}

/// @nodoc
abstract mixin class $FwUpdateInfoCopyWith<$Res> {
  factory $FwUpdateInfoCopyWith(
          FwUpdateInfo value, $Res Function(FwUpdateInfo) _then) =
      _$FwUpdateInfoCopyWithImpl;
  @useResult
  $Res call({String? latestVersion});
}

/// @nodoc
class _$FwUpdateInfoCopyWithImpl<$Res> implements $FwUpdateInfoCopyWith<$Res> {
  _$FwUpdateInfoCopyWithImpl(this._self, this._then);

  final FwUpdateInfo _self;
  final $Res Function(FwUpdateInfo) _then;

  /// Create a copy of FwUpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latestVersion = freezed,
  }) {
    return _then(_self.copyWith(
      latestVersion: freezed == latestVersion
          ? _self.latestVersion
          : latestVersion // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [FwUpdateInfo].
extension FwUpdateInfoPatterns on FwUpdateInfo {
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
    TResult Function(_FwUpdateInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FwUpdateInfo() when $default != null:
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
    TResult Function(_FwUpdateInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FwUpdateInfo():
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
    TResult? Function(_FwUpdateInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FwUpdateInfo() when $default != null:
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
    TResult Function(String? latestVersion)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FwUpdateInfo() when $default != null:
        return $default(_that.latestVersion);
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
    TResult Function(String? latestVersion) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FwUpdateInfo():
        return $default(_that.latestVersion);
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
    TResult? Function(String? latestVersion)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FwUpdateInfo() when $default != null:
        return $default(_that.latestVersion);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FwUpdateInfo implements FwUpdateInfo {
  const _FwUpdateInfo({this.latestVersion});
  factory _FwUpdateInfo.fromJson(Map<String, dynamic> json) =>
      _$FwUpdateInfoFromJson(json);

  /// 最新ファームウェアバージョン
  @override
  final String? latestVersion;

  /// Create a copy of FwUpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FwUpdateInfoCopyWith<_FwUpdateInfo> get copyWith =>
      __$FwUpdateInfoCopyWithImpl<_FwUpdateInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FwUpdateInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FwUpdateInfo &&
            (identical(other.latestVersion, latestVersion) ||
                other.latestVersion == latestVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, latestVersion);

  @override
  String toString() {
    return 'FwUpdateInfo(latestVersion: $latestVersion)';
  }
}

/// @nodoc
abstract mixin class _$FwUpdateInfoCopyWith<$Res>
    implements $FwUpdateInfoCopyWith<$Res> {
  factory _$FwUpdateInfoCopyWith(
          _FwUpdateInfo value, $Res Function(_FwUpdateInfo) _then) =
      __$FwUpdateInfoCopyWithImpl;
  @override
  @useResult
  $Res call({String? latestVersion});
}

/// @nodoc
class __$FwUpdateInfoCopyWithImpl<$Res>
    implements _$FwUpdateInfoCopyWith<$Res> {
  __$FwUpdateInfoCopyWithImpl(this._self, this._then);

  final _FwUpdateInfo _self;
  final $Res Function(_FwUpdateInfo) _then;

  /// Create a copy of FwUpdateInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? latestVersion = freezed,
  }) {
    return _then(_FwUpdateInfo(
      latestVersion: freezed == latestVersion
          ? _self.latestVersion
          : latestVersion // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
