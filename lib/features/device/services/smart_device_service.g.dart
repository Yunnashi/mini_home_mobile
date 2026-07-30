// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_device_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$smartDeviceServiceHash() =>
    r'e943160ec81d00c0ba54da5a546ade7e16429350';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$SmartDeviceService
    extends BuildlessAutoDisposeAsyncNotifier<Device> {
  late final int deviceId;

  FutureOr<Device> build(
    int deviceId,
  );
}

/// See also [SmartDeviceService].
@ProviderFor(SmartDeviceService)
const smartDeviceServiceProvider = SmartDeviceServiceFamily();

/// See also [SmartDeviceService].
class SmartDeviceServiceFamily extends Family<AsyncValue<Device>> {
  /// See also [SmartDeviceService].
  const SmartDeviceServiceFamily();

  /// See also [SmartDeviceService].
  SmartDeviceServiceProvider call(
    int deviceId,
  ) {
    return SmartDeviceServiceProvider(
      deviceId,
    );
  }

  @override
  SmartDeviceServiceProvider getProviderOverride(
    covariant SmartDeviceServiceProvider provider,
  ) {
    return call(
      provider.deviceId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'smartDeviceServiceProvider';
}

/// See also [SmartDeviceService].
class SmartDeviceServiceProvider
    extends AutoDisposeAsyncNotifierProviderImpl<SmartDeviceService, Device> {
  /// See also [SmartDeviceService].
  SmartDeviceServiceProvider(
    int deviceId,
  ) : this._internal(
          () => SmartDeviceService()..deviceId = deviceId,
          from: smartDeviceServiceProvider,
          name: r'smartDeviceServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$smartDeviceServiceHash,
          dependencies: SmartDeviceServiceFamily._dependencies,
          allTransitiveDependencies:
              SmartDeviceServiceFamily._allTransitiveDependencies,
          deviceId: deviceId,
        );

  SmartDeviceServiceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.deviceId,
  }) : super.internal();

  final int deviceId;

  @override
  FutureOr<Device> runNotifierBuild(
    covariant SmartDeviceService notifier,
  ) {
    return notifier.build(
      deviceId,
    );
  }

  @override
  Override overrideWith(SmartDeviceService Function() create) {
    return ProviderOverride(
      origin: this,
      override: SmartDeviceServiceProvider._internal(
        () => create()..deviceId = deviceId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        deviceId: deviceId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SmartDeviceService, Device>
      createElement() {
    return _SmartDeviceServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SmartDeviceServiceProvider && other.deviceId == deviceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, deviceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SmartDeviceServiceRef on AutoDisposeAsyncNotifierProviderRef<Device> {
  /// The parameter `deviceId` of this provider.
  int get deviceId;
}

class _SmartDeviceServiceProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SmartDeviceService, Device>
    with SmartDeviceServiceRef {
  _SmartDeviceServiceProviderElement(super.provider);

  @override
  int get deviceId => (origin as SmartDeviceServiceProvider).deviceId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
