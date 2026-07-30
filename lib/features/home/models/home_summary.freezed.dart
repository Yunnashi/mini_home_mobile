// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeSummary {
  int? get activeDeviceCount;
  int? get indoorTemperature;
  double? get todayEnergyKwh;

  /// Create a copy of HomeSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeSummaryCopyWith<HomeSummary> get copyWith =>
      _$HomeSummaryCopyWithImpl<HomeSummary>(this as HomeSummary, _$identity);

  /// Serializes this HomeSummary to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeSummary &&
            (identical(other.activeDeviceCount, activeDeviceCount) ||
                other.activeDeviceCount == activeDeviceCount) &&
            (identical(other.indoorTemperature, indoorTemperature) ||
                other.indoorTemperature == indoorTemperature) &&
            (identical(other.todayEnergyKwh, todayEnergyKwh) ||
                other.todayEnergyKwh == todayEnergyKwh));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, activeDeviceCount, indoorTemperature, todayEnergyKwh);

  @override
  String toString() {
    return 'HomeSummary(activeDeviceCount: $activeDeviceCount, indoorTemperature: $indoorTemperature, todayEnergyKwh: $todayEnergyKwh)';
  }
}

/// @nodoc
abstract mixin class $HomeSummaryCopyWith<$Res> {
  factory $HomeSummaryCopyWith(
          HomeSummary value, $Res Function(HomeSummary) _then) =
      _$HomeSummaryCopyWithImpl;
  @useResult
  $Res call(
      {int? activeDeviceCount, int? indoorTemperature, double? todayEnergyKwh});
}

/// @nodoc
class _$HomeSummaryCopyWithImpl<$Res> implements $HomeSummaryCopyWith<$Res> {
  _$HomeSummaryCopyWithImpl(this._self, this._then);

  final HomeSummary _self;
  final $Res Function(HomeSummary) _then;

  /// Create a copy of HomeSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeDeviceCount = freezed,
    Object? indoorTemperature = freezed,
    Object? todayEnergyKwh = freezed,
  }) {
    return _then(_self.copyWith(
      activeDeviceCount: freezed == activeDeviceCount
          ? _self.activeDeviceCount
          : activeDeviceCount // ignore: cast_nullable_to_non_nullable
              as int?,
      indoorTemperature: freezed == indoorTemperature
          ? _self.indoorTemperature
          : indoorTemperature // ignore: cast_nullable_to_non_nullable
              as int?,
      todayEnergyKwh: freezed == todayEnergyKwh
          ? _self.todayEnergyKwh
          : todayEnergyKwh // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// Adds pattern-matching-related methods to [HomeSummary].
extension HomeSummaryPatterns on HomeSummary {
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
    TResult Function(_HomeSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeSummary() when $default != null:
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
    TResult Function(_HomeSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeSummary():
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
    TResult? Function(_HomeSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeSummary() when $default != null:
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
    TResult Function(int? activeDeviceCount, int? indoorTemperature,
            double? todayEnergyKwh)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeSummary() when $default != null:
        return $default(_that.activeDeviceCount, _that.indoorTemperature,
            _that.todayEnergyKwh);
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
    TResult Function(int? activeDeviceCount, int? indoorTemperature,
            double? todayEnergyKwh)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeSummary():
        return $default(_that.activeDeviceCount, _that.indoorTemperature,
            _that.todayEnergyKwh);
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
    TResult? Function(int? activeDeviceCount, int? indoorTemperature,
            double? todayEnergyKwh)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeSummary() when $default != null:
        return $default(_that.activeDeviceCount, _that.indoorTemperature,
            _that.todayEnergyKwh);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HomeSummary implements HomeSummary {
  const _HomeSummary(
      {this.activeDeviceCount, this.indoorTemperature, this.todayEnergyKwh});
  factory _HomeSummary.fromJson(Map<String, dynamic> json) =>
      _$HomeSummaryFromJson(json);

  @override
  final int? activeDeviceCount;
  @override
  final int? indoorTemperature;
  @override
  final double? todayEnergyKwh;

  /// Create a copy of HomeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HomeSummaryCopyWith<_HomeSummary> get copyWith =>
      __$HomeSummaryCopyWithImpl<_HomeSummary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HomeSummaryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HomeSummary &&
            (identical(other.activeDeviceCount, activeDeviceCount) ||
                other.activeDeviceCount == activeDeviceCount) &&
            (identical(other.indoorTemperature, indoorTemperature) ||
                other.indoorTemperature == indoorTemperature) &&
            (identical(other.todayEnergyKwh, todayEnergyKwh) ||
                other.todayEnergyKwh == todayEnergyKwh));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, activeDeviceCount, indoorTemperature, todayEnergyKwh);

  @override
  String toString() {
    return 'HomeSummary(activeDeviceCount: $activeDeviceCount, indoorTemperature: $indoorTemperature, todayEnergyKwh: $todayEnergyKwh)';
  }
}

/// @nodoc
abstract mixin class _$HomeSummaryCopyWith<$Res>
    implements $HomeSummaryCopyWith<$Res> {
  factory _$HomeSummaryCopyWith(
          _HomeSummary value, $Res Function(_HomeSummary) _then) =
      __$HomeSummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? activeDeviceCount, int? indoorTemperature, double? todayEnergyKwh});
}

/// @nodoc
class __$HomeSummaryCopyWithImpl<$Res> implements _$HomeSummaryCopyWith<$Res> {
  __$HomeSummaryCopyWithImpl(this._self, this._then);

  final _HomeSummary _self;
  final $Res Function(_HomeSummary) _then;

  /// Create a copy of HomeSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? activeDeviceCount = freezed,
    Object? indoorTemperature = freezed,
    Object? todayEnergyKwh = freezed,
  }) {
    return _then(_HomeSummary(
      activeDeviceCount: freezed == activeDeviceCount
          ? _self.activeDeviceCount
          : activeDeviceCount // ignore: cast_nullable_to_non_nullable
              as int?,
      indoorTemperature: freezed == indoorTemperature
          ? _self.indoorTemperature
          : indoorTemperature // ignore: cast_nullable_to_non_nullable
              as int?,
      todayEnergyKwh: freezed == todayEnergyKwh
          ? _self.todayEnergyKwh
          : todayEnergyKwh // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

// dart format on
