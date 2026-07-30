// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UsageDevice {
  int get id;
  String get deviceId; // 実際はexternalDeviceId
  String? get name;
  String? get nickname;

  /// Create a copy of UsageDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UsageDeviceCopyWith<UsageDevice> get copyWith =>
      _$UsageDeviceCopyWithImpl<UsageDevice>(this as UsageDevice, _$identity);

  /// Serializes this UsageDevice to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UsageDevice &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, deviceId, name, nickname);

  @override
  String toString() {
    return 'UsageDevice(id: $id, deviceId: $deviceId, name: $name, nickname: $nickname)';
  }
}

/// @nodoc
abstract mixin class $UsageDeviceCopyWith<$Res> {
  factory $UsageDeviceCopyWith(
          UsageDevice value, $Res Function(UsageDevice) _then) =
      _$UsageDeviceCopyWithImpl;
  @useResult
  $Res call({int id, String deviceId, String? name, String? nickname});
}

/// @nodoc
class _$UsageDeviceCopyWithImpl<$Res> implements $UsageDeviceCopyWith<$Res> {
  _$UsageDeviceCopyWithImpl(this._self, this._then);

  final UsageDevice _self;
  final $Res Function(UsageDevice) _then;

  /// Create a copy of UsageDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? deviceId = null,
    Object? name = freezed,
    Object? nickname = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      deviceId: null == deviceId
          ? _self.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [UsageDevice].
extension UsageDevicePatterns on UsageDevice {
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
    TResult Function(_UsageDevice value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UsageDevice() when $default != null:
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
    TResult Function(_UsageDevice value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsageDevice():
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
    TResult? Function(_UsageDevice value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsageDevice() when $default != null:
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
    TResult Function(int id, String deviceId, String? name, String? nickname)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UsageDevice() when $default != null:
        return $default(_that.id, _that.deviceId, _that.name, _that.nickname);
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
    TResult Function(int id, String deviceId, String? name, String? nickname)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsageDevice():
        return $default(_that.id, _that.deviceId, _that.name, _that.nickname);
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
    TResult? Function(int id, String deviceId, String? name, String? nickname)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsageDevice() when $default != null:
        return $default(_that.id, _that.deviceId, _that.name, _that.nickname);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UsageDevice implements UsageDevice {
  const _UsageDevice(
      {required this.id, required this.deviceId, this.name, this.nickname});
  factory _UsageDevice.fromJson(Map<String, dynamic> json) =>
      _$UsageDeviceFromJson(json);

  @override
  final int id;
  @override
  final String deviceId;
// 実際はexternalDeviceId
  @override
  final String? name;
  @override
  final String? nickname;

  /// Create a copy of UsageDevice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UsageDeviceCopyWith<_UsageDevice> get copyWith =>
      __$UsageDeviceCopyWithImpl<_UsageDevice>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UsageDeviceToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UsageDevice &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, deviceId, name, nickname);

  @override
  String toString() {
    return 'UsageDevice(id: $id, deviceId: $deviceId, name: $name, nickname: $nickname)';
  }
}

/// @nodoc
abstract mixin class _$UsageDeviceCopyWith<$Res>
    implements $UsageDeviceCopyWith<$Res> {
  factory _$UsageDeviceCopyWith(
          _UsageDevice value, $Res Function(_UsageDevice) _then) =
      __$UsageDeviceCopyWithImpl;
  @override
  @useResult
  $Res call({int id, String deviceId, String? name, String? nickname});
}

/// @nodoc
class __$UsageDeviceCopyWithImpl<$Res> implements _$UsageDeviceCopyWith<$Res> {
  __$UsageDeviceCopyWithImpl(this._self, this._then);

  final _UsageDevice _self;
  final $Res Function(_UsageDevice) _then;

  /// Create a copy of UsageDevice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? deviceId = null,
    Object? name = freezed,
    Object? nickname = freezed,
  }) {
    return _then(_UsageDevice(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      deviceId: null == deviceId
          ? _self.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$Usage {
  int get id;
  UsageDevice get device;
  String? get startedAt;
  String? get finishedAt;
  bool get isFinalized;
  String get activityType;
  double get energyKwh;
  int get durationSeconds;
  String? get createdAt;
  String? get updatedAt;

  /// Create a copy of Usage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UsageCopyWith<Usage> get copyWith =>
      _$UsageCopyWithImpl<Usage>(this as Usage, _$identity);

  /// Serializes this Usage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Usage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.device, device) || other.device == device) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.finishedAt, finishedAt) ||
                other.finishedAt == finishedAt) &&
            (identical(other.isFinalized, isFinalized) ||
                other.isFinalized == isFinalized) &&
            (identical(other.activityType, activityType) ||
                other.activityType == activityType) &&
            (identical(other.energyKwh, energyKwh) ||
                other.energyKwh == energyKwh) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      device,
      startedAt,
      finishedAt,
      isFinalized,
      activityType,
      energyKwh,
      durationSeconds,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'Usage(id: $id, device: $device, startedAt: $startedAt, finishedAt: $finishedAt, isFinalized: $isFinalized, activityType: $activityType, energyKwh: $energyKwh, durationSeconds: $durationSeconds, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $UsageCopyWith<$Res> {
  factory $UsageCopyWith(Usage value, $Res Function(Usage) _then) =
      _$UsageCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      UsageDevice device,
      String? startedAt,
      String? finishedAt,
      bool isFinalized,
      String activityType,
      double energyKwh,
      int durationSeconds,
      String? createdAt,
      String? updatedAt});

  $UsageDeviceCopyWith<$Res> get device;
}

/// @nodoc
class _$UsageCopyWithImpl<$Res> implements $UsageCopyWith<$Res> {
  _$UsageCopyWithImpl(this._self, this._then);

  final Usage _self;
  final $Res Function(Usage) _then;

  /// Create a copy of Usage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? device = null,
    Object? startedAt = freezed,
    Object? finishedAt = freezed,
    Object? isFinalized = null,
    Object? activityType = null,
    Object? energyKwh = null,
    Object? durationSeconds = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      device: null == device
          ? _self.device
          : device // ignore: cast_nullable_to_non_nullable
              as UsageDevice,
      startedAt: freezed == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      finishedAt: freezed == finishedAt
          ? _self.finishedAt
          : finishedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isFinalized: null == isFinalized
          ? _self.isFinalized
          : isFinalized // ignore: cast_nullable_to_non_nullable
              as bool,
      activityType: null == activityType
          ? _self.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as String,
      energyKwh: null == energyKwh
          ? _self.energyKwh
          : energyKwh // ignore: cast_nullable_to_non_nullable
              as double,
      durationSeconds: null == durationSeconds
          ? _self.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of Usage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UsageDeviceCopyWith<$Res> get device {
    return $UsageDeviceCopyWith<$Res>(_self.device, (value) {
      return _then(_self.copyWith(device: value));
    });
  }
}

/// Adds pattern-matching-related methods to [Usage].
extension UsagePatterns on Usage {
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
    TResult Function(_Usage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Usage() when $default != null:
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
    TResult Function(_Usage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Usage():
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
    TResult? Function(_Usage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Usage() when $default != null:
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
            UsageDevice device,
            String? startedAt,
            String? finishedAt,
            bool isFinalized,
            String activityType,
            double energyKwh,
            int durationSeconds,
            String? createdAt,
            String? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Usage() when $default != null:
        return $default(
            _that.id,
            _that.device,
            _that.startedAt,
            _that.finishedAt,
            _that.isFinalized,
            _that.activityType,
            _that.energyKwh,
            _that.durationSeconds,
            _that.createdAt,
            _that.updatedAt);
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
            UsageDevice device,
            String? startedAt,
            String? finishedAt,
            bool isFinalized,
            String activityType,
            double energyKwh,
            int durationSeconds,
            String? createdAt,
            String? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Usage():
        return $default(
            _that.id,
            _that.device,
            _that.startedAt,
            _that.finishedAt,
            _that.isFinalized,
            _that.activityType,
            _that.energyKwh,
            _that.durationSeconds,
            _that.createdAt,
            _that.updatedAt);
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
            UsageDevice device,
            String? startedAt,
            String? finishedAt,
            bool isFinalized,
            String activityType,
            double energyKwh,
            int durationSeconds,
            String? createdAt,
            String? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Usage() when $default != null:
        return $default(
            _that.id,
            _that.device,
            _that.startedAt,
            _that.finishedAt,
            _that.isFinalized,
            _that.activityType,
            _that.energyKwh,
            _that.durationSeconds,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Usage implements Usage {
  const _Usage(
      {required this.id,
      required this.device,
      this.startedAt,
      this.finishedAt,
      required this.isFinalized,
      required this.activityType,
      required this.energyKwh,
      required this.durationSeconds,
      required this.createdAt,
      required this.updatedAt});
  factory _Usage.fromJson(Map<String, dynamic> json) => _$UsageFromJson(json);

  @override
  final int id;
  @override
  final UsageDevice device;
  @override
  final String? startedAt;
  @override
  final String? finishedAt;
  @override
  final bool isFinalized;
  @override
  final String activityType;
  @override
  final double energyKwh;
  @override
  final int durationSeconds;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;

  /// Create a copy of Usage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UsageCopyWith<_Usage> get copyWith =>
      __$UsageCopyWithImpl<_Usage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UsageToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Usage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.device, device) || other.device == device) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.finishedAt, finishedAt) ||
                other.finishedAt == finishedAt) &&
            (identical(other.isFinalized, isFinalized) ||
                other.isFinalized == isFinalized) &&
            (identical(other.activityType, activityType) ||
                other.activityType == activityType) &&
            (identical(other.energyKwh, energyKwh) ||
                other.energyKwh == energyKwh) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      device,
      startedAt,
      finishedAt,
      isFinalized,
      activityType,
      energyKwh,
      durationSeconds,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'Usage(id: $id, device: $device, startedAt: $startedAt, finishedAt: $finishedAt, isFinalized: $isFinalized, activityType: $activityType, energyKwh: $energyKwh, durationSeconds: $durationSeconds, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$UsageCopyWith<$Res> implements $UsageCopyWith<$Res> {
  factory _$UsageCopyWith(_Usage value, $Res Function(_Usage) _then) =
      __$UsageCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      UsageDevice device,
      String? startedAt,
      String? finishedAt,
      bool isFinalized,
      String activityType,
      double energyKwh,
      int durationSeconds,
      String? createdAt,
      String? updatedAt});

  @override
  $UsageDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$UsageCopyWithImpl<$Res> implements _$UsageCopyWith<$Res> {
  __$UsageCopyWithImpl(this._self, this._then);

  final _Usage _self;
  final $Res Function(_Usage) _then;

  /// Create a copy of Usage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? device = null,
    Object? startedAt = freezed,
    Object? finishedAt = freezed,
    Object? isFinalized = null,
    Object? activityType = null,
    Object? energyKwh = null,
    Object? durationSeconds = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_Usage(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      device: null == device
          ? _self.device
          : device // ignore: cast_nullable_to_non_nullable
              as UsageDevice,
      startedAt: freezed == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      finishedAt: freezed == finishedAt
          ? _self.finishedAt
          : finishedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isFinalized: null == isFinalized
          ? _self.isFinalized
          : isFinalized // ignore: cast_nullable_to_non_nullable
              as bool,
      activityType: null == activityType
          ? _self.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as String,
      energyKwh: null == energyKwh
          ? _self.energyKwh
          : energyKwh // ignore: cast_nullable_to_non_nullable
              as double,
      durationSeconds: null == durationSeconds
          ? _self.durationSeconds
          : durationSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of Usage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UsageDeviceCopyWith<$Res> get device {
    return $UsageDeviceCopyWith<$Res>(_self.device, (value) {
      return _then(_self.copyWith(device: value));
    });
  }
}

// dart format on
