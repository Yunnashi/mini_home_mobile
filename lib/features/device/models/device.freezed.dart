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
  String? get nickname;
  double? get chargingAmpere;
  double? get maxChargingAmpere;
  @EvseStateConverter()
  EvseState get evseState;
  @EllaStateConverter()
  EllaState get ellaState;
  double? get temperature;
  String? get mode;
  bool get isOffline;
  bool get cplt;
  DeviceModel get model;
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
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.chargingAmpere, chargingAmpere) ||
                other.chargingAmpere == chargingAmpere) &&
            (identical(other.maxChargingAmpere, maxChargingAmpere) ||
                other.maxChargingAmpere == maxChargingAmpere) &&
            (identical(other.evseState, evseState) ||
                other.evseState == evseState) &&
            (identical(other.ellaState, ellaState) ||
                other.ellaState == ellaState) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.isOffline, isOffline) ||
                other.isOffline == isOffline) &&
            (identical(other.cplt, cplt) || other.cplt == cplt) &&
            (identical(other.model, model) || other.model == model) &&
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
      nickname,
      chargingAmpere,
      maxChargingAmpere,
      evseState,
      ellaState,
      temperature,
      mode,
      isOffline,
      cplt,
      model,
      fwVersion,
      lastPingedAt);

  @override
  String toString() {
    return 'Device(id: $id, externalDeviceId: $externalDeviceId, nickname: $nickname, chargingAmpere: $chargingAmpere, maxChargingAmpere: $maxChargingAmpere, evseState: $evseState, ellaState: $ellaState, temperature: $temperature, mode: $mode, isOffline: $isOffline, cplt: $cplt, model: $model, fwVersion: $fwVersion, lastPingedAt: $lastPingedAt)';
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
      String? nickname,
      double? chargingAmpere,
      double? maxChargingAmpere,
      @EvseStateConverter() EvseState evseState,
      @EllaStateConverter() EllaState ellaState,
      double? temperature,
      String? mode,
      bool isOffline,
      bool cplt,
      DeviceModel model,
      String? fwVersion,
      DateTime? lastPingedAt});
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
    Object? nickname = freezed,
    Object? chargingAmpere = freezed,
    Object? maxChargingAmpere = freezed,
    Object? evseState = null,
    Object? ellaState = null,
    Object? temperature = freezed,
    Object? mode = freezed,
    Object? isOffline = null,
    Object? cplt = null,
    Object? model = null,
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
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      chargingAmpere: freezed == chargingAmpere
          ? _self.chargingAmpere
          : chargingAmpere // ignore: cast_nullable_to_non_nullable
              as double?,
      maxChargingAmpere: freezed == maxChargingAmpere
          ? _self.maxChargingAmpere
          : maxChargingAmpere // ignore: cast_nullable_to_non_nullable
              as double?,
      evseState: null == evseState
          ? _self.evseState
          : evseState // ignore: cast_nullable_to_non_nullable
              as EvseState,
      ellaState: null == ellaState
          ? _self.ellaState
          : ellaState // ignore: cast_nullable_to_non_nullable
              as EllaState,
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
      cplt: null == cplt
          ? _self.cplt
          : cplt // ignore: cast_nullable_to_non_nullable
              as bool,
      model: null == model
          ? _self.model
          : model // ignore: cast_nullable_to_non_nullable
              as DeviceModel,
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
            String? nickname,
            double? chargingAmpere,
            double? maxChargingAmpere,
            @EvseStateConverter() EvseState evseState,
            @EllaStateConverter() EllaState ellaState,
            double? temperature,
            String? mode,
            bool isOffline,
            bool cplt,
            DeviceModel model,
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
            _that.nickname,
            _that.chargingAmpere,
            _that.maxChargingAmpere,
            _that.evseState,
            _that.ellaState,
            _that.temperature,
            _that.mode,
            _that.isOffline,
            _that.cplt,
            _that.model,
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
            String? nickname,
            double? chargingAmpere,
            double? maxChargingAmpere,
            @EvseStateConverter() EvseState evseState,
            @EllaStateConverter() EllaState ellaState,
            double? temperature,
            String? mode,
            bool isOffline,
            bool cplt,
            DeviceModel model,
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
            _that.nickname,
            _that.chargingAmpere,
            _that.maxChargingAmpere,
            _that.evseState,
            _that.ellaState,
            _that.temperature,
            _that.mode,
            _that.isOffline,
            _that.cplt,
            _that.model,
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
            String? nickname,
            double? chargingAmpere,
            double? maxChargingAmpere,
            @EvseStateConverter() EvseState evseState,
            @EllaStateConverter() EllaState ellaState,
            double? temperature,
            String? mode,
            bool isOffline,
            bool cplt,
            DeviceModel model,
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
            _that.nickname,
            _that.chargingAmpere,
            _that.maxChargingAmpere,
            _that.evseState,
            _that.ellaState,
            _that.temperature,
            _that.mode,
            _that.isOffline,
            _that.cplt,
            _that.model,
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
      this.nickname,
      this.chargingAmpere,
      this.maxChargingAmpere,
      @EvseStateConverter() required this.evseState,
      @EllaStateConverter() required this.ellaState,
      this.temperature,
      this.mode,
      this.isOffline = false,
      required this.cplt,
      required this.model,
      this.fwVersion,
      this.lastPingedAt})
      : super._();
  factory _Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  @override
  final int id;
  @override
  final String externalDeviceId;
  @override
  final String? nickname;
  @override
  final double? chargingAmpere;
  @override
  final double? maxChargingAmpere;
  @override
  @EvseStateConverter()
  final EvseState evseState;
  @override
  @EllaStateConverter()
  final EllaState ellaState;
  @override
  final double? temperature;
  @override
  final String? mode;
  @override
  @JsonKey()
  final bool isOffline;
  @override
  final bool cplt;
  @override
  final DeviceModel model;
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
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.chargingAmpere, chargingAmpere) ||
                other.chargingAmpere == chargingAmpere) &&
            (identical(other.maxChargingAmpere, maxChargingAmpere) ||
                other.maxChargingAmpere == maxChargingAmpere) &&
            (identical(other.evseState, evseState) ||
                other.evseState == evseState) &&
            (identical(other.ellaState, ellaState) ||
                other.ellaState == ellaState) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.isOffline, isOffline) ||
                other.isOffline == isOffline) &&
            (identical(other.cplt, cplt) || other.cplt == cplt) &&
            (identical(other.model, model) || other.model == model) &&
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
      nickname,
      chargingAmpere,
      maxChargingAmpere,
      evseState,
      ellaState,
      temperature,
      mode,
      isOffline,
      cplt,
      model,
      fwVersion,
      lastPingedAt);

  @override
  String toString() {
    return 'Device(id: $id, externalDeviceId: $externalDeviceId, nickname: $nickname, chargingAmpere: $chargingAmpere, maxChargingAmpere: $maxChargingAmpere, evseState: $evseState, ellaState: $ellaState, temperature: $temperature, mode: $mode, isOffline: $isOffline, cplt: $cplt, model: $model, fwVersion: $fwVersion, lastPingedAt: $lastPingedAt)';
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
      String? nickname,
      double? chargingAmpere,
      double? maxChargingAmpere,
      @EvseStateConverter() EvseState evseState,
      @EllaStateConverter() EllaState ellaState,
      double? temperature,
      String? mode,
      bool isOffline,
      bool cplt,
      DeviceModel model,
      String? fwVersion,
      DateTime? lastPingedAt});
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
    Object? nickname = freezed,
    Object? chargingAmpere = freezed,
    Object? maxChargingAmpere = freezed,
    Object? evseState = null,
    Object? ellaState = null,
    Object? temperature = freezed,
    Object? mode = freezed,
    Object? isOffline = null,
    Object? cplt = null,
    Object? model = null,
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
      nickname: freezed == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      chargingAmpere: freezed == chargingAmpere
          ? _self.chargingAmpere
          : chargingAmpere // ignore: cast_nullable_to_non_nullable
              as double?,
      maxChargingAmpere: freezed == maxChargingAmpere
          ? _self.maxChargingAmpere
          : maxChargingAmpere // ignore: cast_nullable_to_non_nullable
              as double?,
      evseState: null == evseState
          ? _self.evseState
          : evseState // ignore: cast_nullable_to_non_nullable
              as EvseState,
      ellaState: null == ellaState
          ? _self.ellaState
          : ellaState // ignore: cast_nullable_to_non_nullable
              as EllaState,
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
      cplt: null == cplt
          ? _self.cplt
          : cplt // ignore: cast_nullable_to_non_nullable
              as bool,
      model: null == model
          ? _self.model
          : model // ignore: cast_nullable_to_non_nullable
              as DeviceModel,
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
}

// dart format on
