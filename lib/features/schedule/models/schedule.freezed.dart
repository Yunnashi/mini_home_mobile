// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Schedule {
  String get id;
  String get startAt;
  String get finishAt;
  bool get isEndsNextDay;
  List<Weekday> get weekdays;
  bool get isEnabled;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduleCopyWith<Schedule> get copyWith =>
      _$ScheduleCopyWithImpl<Schedule>(this as Schedule, _$identity);

  /// Serializes this Schedule to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Schedule &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.finishAt, finishAt) ||
                other.finishAt == finishAt) &&
            (identical(other.isEndsNextDay, isEndsNextDay) ||
                other.isEndsNextDay == isEndsNextDay) &&
            const DeepCollectionEquality().equals(other.weekdays, weekdays) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, startAt, finishAt,
      isEndsNextDay, const DeepCollectionEquality().hash(weekdays), isEnabled);

  @override
  String toString() {
    return 'Schedule(id: $id, startAt: $startAt, finishAt: $finishAt, isEndsNextDay: $isEndsNextDay, weekdays: $weekdays, isEnabled: $isEnabled)';
  }
}

/// @nodoc
abstract mixin class $ScheduleCopyWith<$Res> {
  factory $ScheduleCopyWith(Schedule value, $Res Function(Schedule) _then) =
      _$ScheduleCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String startAt,
      String finishAt,
      bool isEndsNextDay,
      List<Weekday> weekdays,
      bool isEnabled});
}

/// @nodoc
class _$ScheduleCopyWithImpl<$Res> implements $ScheduleCopyWith<$Res> {
  _$ScheduleCopyWithImpl(this._self, this._then);

  final Schedule _self;
  final $Res Function(Schedule) _then;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startAt = null,
    Object? finishAt = null,
    Object? isEndsNextDay = null,
    Object? weekdays = null,
    Object? isEnabled = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startAt: null == startAt
          ? _self.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as String,
      finishAt: null == finishAt
          ? _self.finishAt
          : finishAt // ignore: cast_nullable_to_non_nullable
              as String,
      isEndsNextDay: null == isEndsNextDay
          ? _self.isEndsNextDay
          : isEndsNextDay // ignore: cast_nullable_to_non_nullable
              as bool,
      weekdays: null == weekdays
          ? _self.weekdays
          : weekdays // ignore: cast_nullable_to_non_nullable
              as List<Weekday>,
      isEnabled: null == isEnabled
          ? _self.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [Schedule].
extension SchedulePatterns on Schedule {
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
    TResult Function(_Schedule value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Schedule() when $default != null:
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
    TResult Function(_Schedule value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Schedule():
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
    TResult? Function(_Schedule value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Schedule() when $default != null:
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
    TResult Function(String id, String startAt, String finishAt,
            bool isEndsNextDay, List<Weekday> weekdays, bool isEnabled)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Schedule() when $default != null:
        return $default(_that.id, _that.startAt, _that.finishAt,
            _that.isEndsNextDay, _that.weekdays, _that.isEnabled);
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
    TResult Function(String id, String startAt, String finishAt,
            bool isEndsNextDay, List<Weekday> weekdays, bool isEnabled)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Schedule():
        return $default(_that.id, _that.startAt, _that.finishAt,
            _that.isEndsNextDay, _that.weekdays, _that.isEnabled);
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
    TResult? Function(String id, String startAt, String finishAt,
            bool isEndsNextDay, List<Weekday> weekdays, bool isEnabled)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Schedule() when $default != null:
        return $default(_that.id, _that.startAt, _that.finishAt,
            _that.isEndsNextDay, _that.weekdays, _that.isEnabled);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Schedule implements Schedule {
  const _Schedule(
      {required this.id,
      required this.startAt,
      required this.finishAt,
      required this.isEndsNextDay,
      required final List<Weekday> weekdays,
      required this.isEnabled})
      : _weekdays = weekdays;
  factory _Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  @override
  final String id;
  @override
  final String startAt;
  @override
  final String finishAt;
  @override
  final bool isEndsNextDay;
  final List<Weekday> _weekdays;
  @override
  List<Weekday> get weekdays {
    if (_weekdays is EqualUnmodifiableListView) return _weekdays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weekdays);
  }

  @override
  final bool isEnabled;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ScheduleCopyWith<_Schedule> get copyWith =>
      __$ScheduleCopyWithImpl<_Schedule>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ScheduleToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Schedule &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startAt, startAt) || other.startAt == startAt) &&
            (identical(other.finishAt, finishAt) ||
                other.finishAt == finishAt) &&
            (identical(other.isEndsNextDay, isEndsNextDay) ||
                other.isEndsNextDay == isEndsNextDay) &&
            const DeepCollectionEquality().equals(other._weekdays, _weekdays) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, startAt, finishAt,
      isEndsNextDay, const DeepCollectionEquality().hash(_weekdays), isEnabled);

  @override
  String toString() {
    return 'Schedule(id: $id, startAt: $startAt, finishAt: $finishAt, isEndsNextDay: $isEndsNextDay, weekdays: $weekdays, isEnabled: $isEnabled)';
  }
}

/// @nodoc
abstract mixin class _$ScheduleCopyWith<$Res>
    implements $ScheduleCopyWith<$Res> {
  factory _$ScheduleCopyWith(_Schedule value, $Res Function(_Schedule) _then) =
      __$ScheduleCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String startAt,
      String finishAt,
      bool isEndsNextDay,
      List<Weekday> weekdays,
      bool isEnabled});
}

/// @nodoc
class __$ScheduleCopyWithImpl<$Res> implements _$ScheduleCopyWith<$Res> {
  __$ScheduleCopyWithImpl(this._self, this._then);

  final _Schedule _self;
  final $Res Function(_Schedule) _then;

  /// Create a copy of Schedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? startAt = null,
    Object? finishAt = null,
    Object? isEndsNextDay = null,
    Object? weekdays = null,
    Object? isEnabled = null,
  }) {
    return _then(_Schedule(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startAt: null == startAt
          ? _self.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as String,
      finishAt: null == finishAt
          ? _self.finishAt
          : finishAt // ignore: cast_nullable_to_non_nullable
              as String,
      isEndsNextDay: null == isEndsNextDay
          ? _self.isEndsNextDay
          : isEndsNextDay // ignore: cast_nullable_to_non_nullable
              as bool,
      weekdays: null == weekdays
          ? _self._weekdays
          : weekdays // ignore: cast_nullable_to_non_nullable
              as List<Weekday>,
      isEnabled: null == isEnabled
          ? _self.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
