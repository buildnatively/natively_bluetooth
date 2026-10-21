# Mocking guide

How to mock `NativelyBluetooth` for testing.

## Overview

Since version [1.10.0](https://pub.dev/packages/natively_bluetooth/changelog#1100), `NativelyBluetooth.instance` has been deprecated in favor of static functions. 

Therefore, to mock NativelyBluetooth you must:

1. Wrap `NativelyBluetooth` in a mockable non-static class
2. Add your mocked functions to the mockable class.
2. Use the mockable class in your code

A full example is [here](https://dsavir-h.medium.com/mocking-bluetooth-in-flutter-updated-cb3b9484ae02).

## Mockable class

Create the following class:

```dart
import '../natively_bluetooth.dart';

/// Wrapper for NativelyBluetooth in order to easily mock it
/// Wraps all static calls for testing purposes
class NativelyBluetoothMockable {
  Future<void> startScan({
    List<Guid> withServices = const [],
    Duration? timeout,
    Duration? removeIfGone,
    bool oneByOne = false,
    bool androidUsesFineLocation = false,
  }) {
    return NativelyBluetooth.startScan(
        withServices: withServices,
        timeout: timeout,
        removeIfGone: removeIfGone,
        oneByOne: oneByOne,
        androidUsesFineLocation: androidUsesFineLocation);
  }

  Stream<BluetoothAdapterState> get adapterState {
    return NativelyBluetooth.adapterState;
  }

  Stream<List<ScanResult>> get scanResults {
    return NativelyBluetooth.scanResults;
  }

  bool get isScanningNow {
    return NativelyBluetooth.isScanningNow;
  }

  Stream<bool> get isScanning {
    return NativelyBluetooth.isScanning;
  }

  Future<void> stopScan() {
    return NativelyBluetooth.stopScan();
  }

  void setLogLevel(LogLevel level, {color = true}) {
    return NativelyBluetooth.setLogLevel(level, color: color);
  }

  LogLevel get logLevel {
    return NativelyBluetooth.logLevel;
  }

  Future<bool> get isSupported {
    return NativelyBluetooth.isSupported;
  }

  Future<String> get adapterName {
    return NativelyBluetooth.adapterName;
  }

  Future<void> turnOn({int timeout = 60}) {
    return NativelyBluetooth.turnOn(timeout: timeout);
  }

  List<BluetoothDevice> get connectedDevices {
    return NativelyBluetooth.connectedDevices;
  }

  Future<List<BluetoothDevice>> get systemDevices {
    return NativelyBluetooth.systemDevices;
  }

  Future<PhySupport> getPhySupport() {
    return NativelyBluetooth.getPhySupport();
  }

  Future<List<BluetoothDevice>> get bondedDevices {
    return NativelyBluetooth.bondedDevices;
  }
}
```

## Mock the wrapper class

Using e.g. [Mockito](https://pub.dev/packages/mockito), create a mock for the `NativelyBluetoothMockable` class, and build your tests and stubs.

## Create instance

Use the mockable class where needed, e.g. in `main.dart`:

```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  //instance of NativelyBluetooth that will be passed
  //throughout the app as necessary
  NativelyBluetoothMockable bluePlusMockable = NativelyBluetoothMockable();//<--

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My app',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home:  FindDevicesScreen(
        bluePlusMockable: bluePlusMockable,
      );
    );
  }
}
```

## Use mock instead of NativelyBluetooth

Within your code, replace all calls to `NativelyBluetooth` with the mockable instance, e.g.:  
`NativelyBluetooth.isScanning` --> `bluePlusMockable.isScanning`  
`NativelyBluetooth.startScan` --> `bluePlusMockable.startScan`  
`NativelyBluetooth.scanResults` --> `bluePlusMockable.scanResults`  
etc.

## Example

Detailed example is [here](https://dsavir-h.medium.com/mocking-bluetooth-in-flutter-updated-cb3b9484ae02).
