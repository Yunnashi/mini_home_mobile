// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Device {
  int get id;
  String get externalDeviceId;
  int get homeId;
  int get roomId;
  String? get name;
  DeviceType get type;
  bool get isOnline;
  bool get isPowerOn;
  LightState? get lightState;
  AirConditionerState? get airConditionerState;
  String? get nickname;
  double? get temperature;
  String? get mode;
  bool get isOffline;
  String? get fwVersion;
  DateTime? get lastPingedAt;

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeviceCopyWith<Device> get copyWith =>
      _$DeviceCopyWithImpl<Device>(this as Device, _$identity);

  /// Serializes this Device to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Device &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.externalDeviceId, externalDeviceId) ||
                other.externalDeviceId == externalDeviceId) &&
            (identical(other.homeId, homeId) || other.homeId == homeId) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.isPowerOn, isPowerOn) ||
                other.isPowerOn == isPowerOn) &&
            (identical(other.lightState, lightState) ||
                other.lightState == lightState) &&
            (identical(other.airConditionerState, airConditionerState) ||
                other.airConditionerState == airConditionerState) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.isOffline, isOffline) ||
                other.isOffline == isOffline) &&
            (identical(other.fwVersion, fwVersion) ||
                other.fwVersion == fwVersion) &&
            (identical(other.lastPingedAt, lastPingedAt) ||
                other.lastPingedAt == lastPingedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      externalDeviceId,
      homeId,
      roomId,
      name,
      type,
      isOnline,
      isPowerOn,
      lightState,
      airConditionerState,
      nickname,
      temperature,
      mode,
      isOffline,
      fwVersion,
      lastPingedAt);

  @override
  String toString() {
    return 'Device(id: $id, externalDeviceId: $externalDeviceId, homeId: $homeId, roomId: $roomId, name: $name, type: $type, isOnline: $isOnline, isPowerOn: $isPowerOn, lightState: $lightState, airConditionerState: $airConditionerState, nickname: $nickname, temperature: $temperature, mode: $mode, isOffline: $isOffline, fwVersion: $fwVersion, lastPingedAt: $lastPingedAt)';
  }
}

/// @nodoc
abstract mixin class $DeviceCopyWith<$Res> {
  factory $DeviceCopyWith(Device value, $Res Function(Device) _then) =
      _$DeviceCopyWithImpl;
  @useResult
  $Res call(
      {int id,
      String externalDeviceId,
      int homeId,
      int roomId,
      String? name,
      DeviceType type,
      bool isOnline,
      bool isPowerOn,
      LightState? lightState,
      AirConditionerState? airConditionerState,
      String? nickname,
      double? temperature,
      String? mode,
      bool isOffline,
      String? fwVersion,
      DateTime? lastPingedAt});

  $LightStateCopyWith<$Res>? get lightState;
  $AirConditionerStateCopyWith<$Res>? get airConditionerState;
}

/// @nodoc
class _$DeviceCopyWithImpl<$Res> implements $DeviceCopyWith<$Res> {
  _$DeviceCopyWithImpl(this._self, this._then);

  final Device _self;
  final $Res Function(Device) _then;

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? externalDeviceId = null,
    Object? homeId = null,
    Object? roomId = null,
    Object? name = freezed,
    Object? type = null,
    Object? isOnline = null,
    Object? isPowerOn = null,
    Object? lightState = freezed,
    Object? airConditionerState = freezed,
    Object? nickname = freezed,
    Object? temperature = freezed,
    Object? mode = freezed,
    Object? isOffline = null,
    Object? fwVersion = freezed,
    Object? lastPingedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      externalDeviceId: null == externalDeviceId
          ? _self.externalDeviceId
          : externalDeviceId // ignore: cast_nullable_to_non_nullable
              as String,
      homeId: null == homeId
          ? _self.homeId
          : homeId // ignore: cast_nullable_to_non_nullable
              as int,
      roomId: null == roomId
          ? _self.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as int,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as DeviceType,
      isOnline: null == isOnline
          ? _self.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      isPowerOn: null == isPowerOn
          ? _self.isPowerOn
          : isPowerOn // ignore: cast_nullable_to_non_nullable
              as bool,
      lightState: freezed == lightState
          ? _self.lightState
          : lightState // ignore: cast_nullable_to_non_nullable
              as LightState?,
      airConditionerState: freezed == airConditionerState
          ? _self.airConditionerState
          : airConditionerState // ignore: cast_nullable_to_non_nullable
              as AirConditionerState?,
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      temperature: freezed == temperature
          ? _self.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double?,
      mode: freezed == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String?,
      isOffline: null == isOffline
          ? _self.isOffline
          : isOffline // ignore: cast_nullable_to_non_nullable
              as bool,
      fwVersion: freezed == fwVersion
          ? _self.fwVersion
          : fwVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      lastPingedAt: freezed == lastPingedAt
          ? _self.lastPingedAt
          : lastPingedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LightStateCopyWith<$Res>? get lightState {
    if (_self.lightState == null) {
      return null;
    }

    return $LightStateCopyWith<$Res>(_self.lightState!, (value) {
      return _then(_self.copyWith(lightState: value));
    });
  }

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AirConditionerStateCopyWith<$Res>? get airConditionerState {
    if (_self.airConditionerState == null) {
      return null;
    }

    return $AirConditionerStateCopyWith<$Res>(_self.airConditionerState!,
        (value) {
      return _then(_self.copyWith(airConditionerState: value));
    });
  }
}

/// Adds pattern-matching-related methods to [Device].
extension DevicePatterns on Device {
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
    TResult Function(_Device value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Device() when $default != null:
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
    TResult Function(_Device value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Device():
        return $default(_that);
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
    TResult? Function(_Device value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Device() when $default != null:
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
            String externalDeviceId,
            int homeId,
            int roomId,
            String? name,
            DeviceType type,
            bool isOnline,
            bool isPowerOn,
            LightState? lightState,
            AirConditionerState? airConditionerState,
            String? nickname,
            double? temperature,
            String? mode,
            bool isOffline,
            String? fwVersion,
            DateTime? lastPingedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Device() when $default != null:
        return $default(
            _that.id,
            _that.externalDeviceId,
            _that.homeId,
            _that.roomId,
            _that.name,
            _that.type,
            _that.isOnline,
            _that.isPowerOn,
            _that.lightState,
            _that.airConditionerState,
            _that.nickname,
            _that.temperature,
            _that.mode,
            _that.isOffline,
            _that.fwVersion,
            _that.lastPingedAt);
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
            String externalDeviceId,
            int homeId,
            int roomId,
            String? name,
            DeviceType type,
            bool isOnline,
            bool isPowerOn,
            LightState? lightState,
            AirConditionerState? airConditionerState,
            String? nickname,
            double? temperature,
            String? mode,
            bool isOffline,
            String? fwVersion,
            DateTime? lastPingedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Device():
        return $default(
            _that.id,
            _that.externalDeviceId,
            _that.homeId,
            _that.roomId,
            _that.name,
            _that.type,
            _that.isOnline,
            _that.isPowerOn,
            _that.lightState,
            _that.airConditionerState,
            _that.nickname,
            _that.temperature,
            _that.mode,
            _that.isOffline,
            _that.fwVersion,
            _that.lastPingedAt);
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
            String externalDeviceId,
            int homeId,
            int roomId,
            String? name,
            DeviceType type,
            bool isOnline,
            bool isPowerOn,
            LightState? lightState,
            AirConditionerState? airConditionerState,
            String? nickname,
            double? temperature,
            String? mode,
            bool isOffline,
            String? fwVersion,
            DateTime? lastPingedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Device() when $default != null:
        return $default(
            _that.id,
            _that.externalDeviceId,
            _that.homeId,
            _that.roomId,
            _that.name,
            _that.type,
            _that.isOnline,
            _that.isPowerOn,
            _that.lightState,
            _that.airConditionerState,
            _that.nickname,
            _that.temperature,
            _that.mode,
            _that.isOffline,
            _that.fwVersion,
            _that.lastPingedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Device extends Device {
  const _Device(
      {required this.id,
      required this.externalDeviceId,
      this.homeId = 1,
      this.roomId = 1,
      this.name,
      this.type = DeviceType.light,
      this.isOnline = true,
      this.isPowerOn = false,
      this.lightState,
      this.airConditionerState,
      this.nickname,
      this.temperature,
      this.mode,
      this.isOffline = false,
      this.fwVersion,
      this.lastPingedAt})
      : super._();
  factory _Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  @override
  final int id;
  @override
  final String externalDeviceId;
  @override
  @JsonKey()
  final int homeId;
  @override
  @JsonKey()
  final int roomId;
  @override
  final String? name;
  @override
  @JsonKey()
  final DeviceType type;
  @override
  @JsonKey()
  final bool isOnline;
  @override
  @JsonKey()
  final bool isPowerOn;
  @override
  final LightState? lightState;
  @override
  final AirConditionerState? airConditionerState;
  @override
  final String? nickname;
  @override
  final double? temperature;
  @override
  final String? mode;
  @override
  @JsonKey()
  final bool isOffline;
  @override
  final String? fwVersion;
  @override
  final DateTime? lastPingedAt;

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeviceCopyWith<_Device> get copyWith =>
      __$DeviceCopyWithImpl<_Device>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DeviceToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Device &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.externalDeviceId, externalDeviceId) ||
                other.externalDeviceId == externalDeviceId) &&
            (identical(other.homeId, homeId) || other.homeId == homeId) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.isPowerOn, isPowerOn) ||
                other.isPowerOn == isPowerOn) &&
            (identical(other.lightState, lightState) ||
                other.lightState == lightState) &&
            (identical(other.airConditionerState, airConditionerState) ||
                other.airConditionerState == airConditionerState) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.isOffline, isOffline) ||
                other.isOffline == isOffline) &&
            (identical(other.fwVersion, fwVersion) ||
                other.fwVersion == fwVersion) &&
            (identical(other.lastPingedAt, lastPingedAt) ||
                other.lastPingedAt == lastPingedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      externalDeviceId,
      homeId,
      roomId,
      name,
      type,
      isOnline,
      isPowerOn,
      lightState,
      airConditionerState,
      nickname,
      temperature,
      mode,
      isOffline,
      fwVersion,
      lastPingedAt);

  @override
  String toString() {
    return 'Device(id: $id, externalDeviceId: $externalDeviceId, homeId: $homeId, roomId: $roomId, name: $name, type: $type, isOnline: $isOnline, isPowerOn: $isPowerOn, lightState: $lightState, airConditionerState: $airConditionerState, nickname: $nickname, temperature: $temperature, mode: $mode, isOffline: $isOffline, fwVersion: $fwVersion, lastPingedAt: $lastPingedAt)';
  }
}

/// @nodoc
abstract mixin class _$DeviceCopyWith<$Res> implements $DeviceCopyWith<$Res> {
  factory _$DeviceCopyWith(_Device value, $Res Function(_Device) _then) =
      __$DeviceCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int id,
      String externalDeviceId,
      int homeId,
      int roomId,
      String? name,
      DeviceType type,
      bool isOnline,
      bool isPowerOn,
      LightState? lightState,
      AirConditionerState? airConditionerState,
      String? nickname,
      double? temperature,
      String? mode,
      bool isOffline,
      String? fwVersion,
      DateTime? lastPingedAt});

  @override
  $LightStateCopyWith<$Res>? get lightState;
  @override
  $AirConditionerStateCopyWith<$Res>? get airConditionerState;
}

/// @nodoc
class __$DeviceCopyWithImpl<$Res> implements _$DeviceCopyWith<$Res> {
  __$DeviceCopyWithImpl(this._self, this._then);

  final _Device _self;
  final $Res Function(_Device) _then;

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? externalDeviceId = null,
    Object? homeId = null,
    Object? roomId = null,
    Object? name = freezed,
    Object? type = null,
    Object? isOnline = null,
    Object? isPowerOn = null,
    Object? lightState = freezed,
    Object? airConditionerState = freezed,
    Object? nickname = freezed,
    Object? temperature = freezed,
    Object? mode = freezed,
    Object? isOffline = null,
    Object? fwVersion = freezed,
    Object? lastPingedAt = freezed,
  }) {
    return _then(_Device(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      externalDeviceId: null == externalDeviceId
          ? _self.externalDeviceId
          : externalDeviceId // ignore: cast_nullable_to_non_nullable
              as String,
      homeId: null == homeId
          ? _self.homeId
          : homeId // ignore: cast_nullable_to_non_nullable
              as int,
      roomId: null == roomId
          ? _self.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as int,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as DeviceType,
      isOnline: null == isOnline
          ? _self.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      isPowerOn: null == isPowerOn
          ? _self.isPowerOn
          : isPowerOn // ignore: cast_nullable_to_non_nullable
              as bool,
      lightState: freezed == lightState
          ? _self.lightState
          : lightState // ignore: cast_nullable_to_non_nullable
              as LightState?,
      airConditionerState: freezed == airConditionerState
          ? _self.airConditionerState
          : airConditionerState // ignore: cast_nullable_to_non_nullable
              as AirConditionerState?,
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      temperature: freezed == temperature
          ? _self.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double?,
      mode: freezed == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String?,
      isOffline: null == isOffline
          ? _self.isOffline
          : isOffline // ignore: cast_nullable_to_non_nullable
              as bool,
      fwVersion: freezed == fwVersion
          ? _self.fwVersion
          : fwVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      lastPingedAt: freezed == lastPingedAt
          ? _self.lastPingedAt
          : lastPingedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LightStateCopyWith<$Res>? get lightState {
    if (_self.lightState == null) {
      return null;
    }

    return $LightStateCopyWith<$Res>(_self.lightState!, (value) {
      return _then(_self.copyWith(lightState: value));
    });
  }

  /// Create a copy of Device
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AirConditionerStateCopyWith<$Res>? get airConditionerState {
    if (_self.airConditionerState == null) {
      return null;
    }

    return $AirConditionerStateCopyWith<$Res>(_self.airConditionerState!,
        (value) {
      return _then(_self.copyWith(airConditionerState: value));
    });
  }
}

// dart format on
