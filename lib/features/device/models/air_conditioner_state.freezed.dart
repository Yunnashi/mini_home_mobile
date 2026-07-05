// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'air_conditioner_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AirConditionerState {
  int get targetTemperature;
  AirConditionerMode get mode;
  FanSpeed get fanSpeed;

  /// Create a copy of AirConditionerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AirConditionerStateCopyWith<AirConditionerState> get copyWith =>
      _$AirConditionerStateCopyWithImpl<AirConditionerState>(
          this as AirConditionerState, _$identity);

  /// Serializes this AirConditionerState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AirConditionerState &&
            (identical(other.targetTemperature, targetTemperature) ||
                other.targetTemperature == targetTemperature) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.fanSpeed, fanSpeed) ||
                other.fanSpeed == fanSpeed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, targetTemperature, mode, fanSpeed);

  @override
  String toString() {
    return 'AirConditionerState(targetTemperature: $targetTemperature, mode: $mode, fanSpeed: $fanSpeed)';
  }
}

/// @nodoc
abstract mixin class $AirConditionerStateCopyWith<$Res> {
  factory $AirConditionerStateCopyWith(
          AirConditionerState value, $Res Function(AirConditionerState) _then) =
      _$AirConditionerStateCopyWithImpl;
  @useResult
  $Res call(
      {int targetTemperature, AirConditionerMode mode, FanSpeed fanSpeed});
}

/// @nodoc
class _$AirConditionerStateCopyWithImpl<$Res>
    implements $AirConditionerStateCopyWith<$Res> {
  _$AirConditionerStateCopyWithImpl(this._self, this._then);

  final AirConditionerState _self;
  final $Res Function(AirConditionerState) _then;

  /// Create a copy of AirConditionerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetTemperature = null,
    Object? mode = null,
    Object? fanSpeed = null,
  }) {
    return _then(_self.copyWith(
      targetTemperature: null == targetTemperature
          ? _self.targetTemperature
          : targetTemperature // ignore: cast_nullable_to_non_nullable
              as int,
      mode: null == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as AirConditionerMode,
      fanSpeed: null == fanSpeed
          ? _self.fanSpeed
          : fanSpeed // ignore: cast_nullable_to_non_nullable
              as FanSpeed,
    ));
  }
}

/// Adds pattern-matching-related methods to [AirConditionerState].
extension AirConditionerStatePatterns on AirConditionerState {
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
    TResult Function(_AirConditionerState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AirConditionerState() when $default != null:
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
    TResult Function(_AirConditionerState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AirConditionerState():
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
    TResult? Function(_AirConditionerState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AirConditionerState() when $default != null:
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
            int targetTemperature, AirConditionerMode mode, FanSpeed fanSpeed)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AirConditionerState() when $default != null:
        return $default(_that.targetTemperature, _that.mode, _that.fanSpeed);
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
            int targetTemperature, AirConditionerMode mode, FanSpeed fanSpeed)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AirConditionerState():
        return $default(_that.targetTemperature, _that.mode, _that.fanSpeed);
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
            int targetTemperature, AirConditionerMode mode, FanSpeed fanSpeed)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AirConditionerState() when $default != null:
        return $default(_that.targetTemperature, _that.mode, _that.fanSpeed);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AirConditionerState implements AirConditionerState {
  const _AirConditionerState(
      {this.targetTemperature = 24,
      this.mode = AirConditionerMode.auto,
      this.fanSpeed = FanSpeed.auto});
  factory _AirConditionerState.fromJson(Map<String, dynamic> json) =>
      _$AirConditionerStateFromJson(json);

  @override
  @JsonKey()
  final int targetTemperature;
  @override
  @JsonKey()
  final AirConditionerMode mode;
  @override
  @JsonKey()
  final FanSpeed fanSpeed;

  /// Create a copy of AirConditionerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AirConditionerStateCopyWith<_AirConditionerState> get copyWith =>
      __$AirConditionerStateCopyWithImpl<_AirConditionerState>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AirConditionerStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AirConditionerState &&
            (identical(other.targetTemperature, targetTemperature) ||
                other.targetTemperature == targetTemperature) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.fanSpeed, fanSpeed) ||
                other.fanSpeed == fanSpeed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, targetTemperature, mode, fanSpeed);

  @override
  String toString() {
    return 'AirConditionerState(targetTemperature: $targetTemperature, mode: $mode, fanSpeed: $fanSpeed)';
  }
}

/// @nodoc
abstract mixin class _$AirConditionerStateCopyWith<$Res>
    implements $AirConditionerStateCopyWith<$Res> {
  factory _$AirConditionerStateCopyWith(_AirConditionerState value,
          $Res Function(_AirConditionerState) _then) =
      __$AirConditionerStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int targetTemperature, AirConditionerMode mode, FanSpeed fanSpeed});
}

/// @nodoc
class __$AirConditionerStateCopyWithImpl<$Res>
    implements _$AirConditionerStateCopyWith<$Res> {
  __$AirConditionerStateCopyWithImpl(this._self, this._then);

  final _AirConditionerState _self;
  final $Res Function(_AirConditionerState) _then;

  /// Create a copy of AirConditionerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? targetTemperature = null,
    Object? mode = null,
    Object? fanSpeed = null,
  }) {
    return _then(_AirConditionerState(
      targetTemperature: null == targetTemperature
          ? _self.targetTemperature
          : targetTemperature // ignore: cast_nullable_to_non_nullable
              as int,
      mode: null == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as AirConditionerMode,
      fanSpeed: null == fanSpeed
          ? _self.fanSpeed
          : fanSpeed // ignore: cast_nullable_to_non_nullable
              as FanSpeed,
    ));
  }
}

// dart format on
