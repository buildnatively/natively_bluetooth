// Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../flutter_bluetooth.dart';

class BluetoothDescriptor {
  final DeviceIdentifier remoteId;
  final Guid serviceUuid;
  final Guid characteristicUuid;
  final Guid descriptorUuid;
  final Guid? primaryServiceUuid;
  final int? instanceId;

  BluetoothDescriptor({
    required this.remoteId,
    required this.serviceUuid,
    required this.characteristicUuid,
    required this.descriptorUuid,
    this.primaryServiceUuid,
    this.instanceId,
  });

  BluetoothDescriptor.fromProto(BmBluetoothDescriptor p)
      : remoteId = p.remoteId,
        serviceUuid = p.serviceUuid,
        characteristicUuid = p.characteristicUuid,
        descriptorUuid = p.descriptorUuid,
        primaryServiceUuid = p.primaryServiceUuid,
        instanceId = p.instanceId;

  /// convenience accessor
  Guid get uuid => descriptorUuid;

  /// convenience accessor
  BluetoothDevice get device => BluetoothDevice(remoteId: remoteId);

  /// this variable is updated:
  ///   - anytime `read()` is called
  ///   - anytime `write()` is called
  ///   - when the device is disconnected it is cleared
  List<int> get lastValue {
    String key = "$serviceUuid:$characteristicUuid:$descriptorUuid:${instanceId ?? 'noinst'}";
    return FlutterBluetooth._lastDescs[remoteId]?[key] ?? [];
  }

  /// this stream emits values:
  ///   - anytime `read()` is called
  ///   - anytime `write()` is called
  ///   - and when first listened to, it re-emits the last value for convenience
  Stream<List<int>> get lastValueStream => _mergeStreams(
          [FlutterBluetoothPlatform.instance.onDescriptorRead, FlutterBluetoothPlatform.instance.onDescriptorWritten])
      .where((p) => p.remoteId == remoteId)
      .where((p) => p.characteristicUuid == characteristicUuid)
      .where((p) => p.serviceUuid == serviceUuid)
      .where((p) => p.descriptorUuid == descriptorUuid)
      .where((p) => p.primaryServiceUuid == primaryServiceUuid)
      .where((p) => p.success == true)
      .where((p) => p.instanceId == null || p.instanceId == instanceId)
      .map((p) => p.value)
      .newStreamWithInitialValue(lastValue);

  /// this stream emits values:
  ///   - anytime `read()` is called
  Stream<List<int>> get onValueReceived => FlutterBluetoothPlatform.instance.onDescriptorRead
      .where((p) => p.remoteId == remoteId)
      .where((p) => p.characteristicUuid == characteristicUuid)
      .where((p) => p.serviceUuid == serviceUuid)
      .where((p) => p.descriptorUuid == descriptorUuid)
      .where((p) => p.primaryServiceUuid == primaryServiceUuid)
      .where((p) => p.success == true)
      .where((p) => p.instanceId == null || p.instanceId == instanceId)
      .map((p) => p.value);

  /// Retrieves the value of a specified descriptor
  Future<List<int>> read({int timeout = 15}) async {
    // check connected
    if (device.isDisconnected) {
      throw FlutterBluetoothException(
          ErrorPlatform.bluetooth, "readDescriptor", BluetoothErrorCode.deviceIsDisconnected.index, "device is not connected");
    }

    // Only allow a single ble operation to be underway at a time
    _Mutex mtx = _MutexFactory.getMutexForKey("global");
    await mtx.take();

    // return value
    List<int> readValue = [];

    try {
      var request = BmReadDescriptorRequest(
        remoteId: remoteId,
        serviceUuid: serviceUuid,
        characteristicUuid: characteristicUuid,
        descriptorUuid: descriptorUuid,
        primaryServiceUuid: primaryServiceUuid,
        instanceId: instanceId,
      );

      Stream<BmDescriptorData> responseStream = FlutterBluetoothPlatform.instance.onDescriptorRead
          .where((p) => p.remoteId == request.remoteId)
          .where((p) => p.serviceUuid == request.serviceUuid)
          .where((p) => p.characteristicUuid == request.characteristicUuid)
          .where((p) => p.descriptorUuid == request.descriptorUuid)
          .where((p) => p.primaryServiceUuid == request.primaryServiceUuid)
          .where((p) => p.instanceId == null || p.instanceId == instanceId);

      // Start listening now, before invokeMethod, to ensure we don't miss the response
      Future<BmDescriptorData> futureResponse = responseStream.first;

      // invoke
      await FlutterBluetooth._invokeMethod(() => FlutterBluetoothPlatform.instance.readDescriptor(request));

      // wait for response
      BmDescriptorData response = await futureResponse
          .bluetoothEnsureAdapterIsOn("readDescriptor")
          .bluetoothEnsureDeviceIsConnected(device, "readDescriptor")
          .bluetoothTimeout(timeout, "readDescriptor");

      // failed?
      if (!response.success) {
        throw FlutterBluetoothException(_nativeError, "readDescriptor", response.errorCode, response.errorString);
      }

      readValue = response.value;
    } finally {
      mtx.give();
    }

    return readValue;
  }

  /// Writes the value of a descriptor
  Future<void> write(List<int> value, {int timeout = 15}) async {
    // check connected
    if (device.isDisconnected) {
      throw FlutterBluetoothException(
          ErrorPlatform.bluetooth, "writeDescriptor", BluetoothErrorCode.deviceIsDisconnected.index, "device is not connected");
    }

    // Only allow a single ble operation to be underway at a time
    _Mutex mtx = _MutexFactory.getMutexForKey("global");
    await mtx.take();

    try {
      var request = BmWriteDescriptorRequest(
        remoteId: remoteId,
        serviceUuid: serviceUuid,
        characteristicUuid: characteristicUuid,
        descriptorUuid: descriptorUuid,
        value: value,
        primaryServiceUuid: primaryServiceUuid,
        instanceId: instanceId,
      );

      Stream<BmDescriptorData> responseStream = FlutterBluetoothPlatform.instance.onDescriptorWritten
          .where((p) => p.remoteId == request.remoteId)
          .where((p) => p.serviceUuid == request.serviceUuid)
          .where((p) => p.characteristicUuid == request.characteristicUuid)
          .where((p) => p.descriptorUuid == request.descriptorUuid)
          .where((p) => p.primaryServiceUuid == request.primaryServiceUuid)
          .where((p) => p.instanceId == null || p.instanceId == instanceId);

      // Start listening now, before invokeMethod, to ensure we don't miss the response
      Future<BmDescriptorData> futureResponse = responseStream.first;

      // invoke
      await FlutterBluetooth._invokeMethod(() => FlutterBluetoothPlatform.instance.writeDescriptor(request));

      // wait for response
      BmDescriptorData response = await futureResponse
          .bluetoothEnsureAdapterIsOn("writeDescriptor")
          .bluetoothEnsureDeviceIsConnected(device, "writeDescriptor")
          .bluetoothTimeout(timeout, "writeDescriptor");

      // failed?
      if (!response.success) {
        throw FlutterBluetoothException(_nativeError, "writeDescriptor", response.errorCode, response.errorString);
      }
    } finally {
      mtx.give();
    }

    return Future.value();
  }

  @override
  String toString() {
    return 'BluetoothDescriptor{'
        'remoteId: $remoteId, '
        'serviceUuid: $serviceUuid, '
        'characteristicUuid: $characteristicUuid, '
        'descriptorUuid: $descriptorUuid, '
        'primaryServiceUuid: $primaryServiceUuid'
        'lastValue: $lastValue'
        'instanceId: $instanceId'
        '}';
  }

  @Deprecated('Use onValueReceived instead')
  Stream<List<int>> get value => onValueReceived;

  @Deprecated('Use remoteId instead')
  DeviceIdentifier get deviceId => remoteId;
}
