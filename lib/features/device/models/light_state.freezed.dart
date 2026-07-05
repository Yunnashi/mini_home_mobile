// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'light_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LightState {
  int get brightness;
  int get colorTemperature;

  /// Create a copy of LightState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LightStateCopyWith<LightState> get copyWith =>
      _$LightStateCopyWithImpl<LightState>(this as LightState, _$identity);

  /// Serializes this LightState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LightState &&
            (identical(other.brightness, brightness) ||
                other.brightness == brightness) &&
            (identical(other.colorTemperature, colorTemperature) ||
                other.colorTemperature == colorTemperature));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, brightness, colorTemperature);

  @override
  String toString() {
    return 'LightState(brightness: $brightness, colorTemperature: $colorTemperature)';
  }
}

/// @nodoc
abstract mixin class $LightStateCopyWith<$Res> {
  factory $LightStateCopyWith(
          LightState value, $Res Function(LightState) _then) =
      _$LightStateCopyWithImpl;
  @useResult
  $Res call({int brightness, int colorTemperature});
}

/// @nodoc
class _$LightStateCopyWithImpl<$Res> implements $LightStateCopyWith<$Res> {
  _$LightStateCopyWithImpl(this._self, this._then);

  final LightState _self;
  final $Res Function(LightState) _then;

  /// Create a copy of LightState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brightness = null,
    Object? colorTemperature = null,
  }) {
    return _then(_self.copyWith(
      brightness: null == brightness
          ? _self.brightness
          : brightness // ignore: cast_nullable_to_non_nullable
              as int,
      colorTemperature: null == colorTemperature
          ? _self.colorTemperature
          : colorTemperature // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [LightState].
extension LightStatePatterns on LightState {
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
    TResult Function(_LightState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LightState() when $default != null:
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
    TResult Function(_LightState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LightState():
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
    TResult? Function(_LightState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LightState() when $default != null:
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
    TResult Function(int brightness, int colorTemperature)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LightState() when $default != null:
        return $default(_that.brightness, _that.colorTemperature);
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
    TResult Function(int brightness, int colorTemperature) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LightState():
        return $default(_that.brightness, _that.colorTemperature);
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
    TResult? Function(int brightness, int colorTemperature)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LightState() when $default != null:
        return $default(_that.brightness, _that.colorTemperature);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LightState implements LightState {
  const _LightState({this.brightness = 50, this.colorTemperature = 4000});
  factory _LightState.fromJson(Map<String, dynamic> json) =>
      _$LightStateFromJson(json);

  @override
  @JsonKey()
  final int brightness;
  @override
  @JsonKey()
  final int colorTemperature;

  /// Create a copy of LightState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LightStateCopyWith<_LightState> get copyWith =>
      __$LightStateCopyWithImpl<_LightState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LightStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LightState &&
            (identical(other.brightness, brightness) ||
                other.brightness == brightness) &&
            (identical(other.colorTemperature, colorTemperature) ||
                other.colorTemperature == colorTemperature));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, brightness, colorTemperature);

  @override
  String toString() {
    return 'LightState(brightness: $brightness, colorTemperature: $colorTemperature)';
  }
}

/// @nodoc
abstract mixin class _$LightStateCopyWith<$Res>
    implements $LightStateCopyWith<$Res> {
  factory _$LightStateCopyWith(
          _LightState value, $Res Function(_LightState) _then) =
      __$LightStateCopyWithImpl;
  @override
  @useResult
  $Res call({int brightness, int colorTemperature});
}

/// @nodoc
class __$LightStateCopyWithImpl<$Res> implements _$LightStateCopyWith<$Res> {
  __$LightStateCopyWithImpl(this._self, this._then);

  final _LightState _self;
  final $Res Function(_LightState) _then;

  /// Create a copy of LightState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? brightness = null,
    Object? colorTemperature = null,
  }) {
    return _then(_LightState(
      brightness: null == brightness
          ? _self.brightness
          : brightness // ignore: cast_nullable_to_non_nullable
              as int,
      colorTemperature: null == colorTemperature
          ? _self.colorTemperature
          : colorTemperature // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
