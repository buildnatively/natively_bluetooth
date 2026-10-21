# Mocking guide

How to mock `FlutterBluetooth` for testing.

## Overview

Since version [1.10.0](https://pub.dev/packages/flutter_bluetooth/changelog#1100), `FlutterBluetooth.instance` has been deprecated in favor of static functions. 

Therefore, to mock FlutterBluetooth you must:

1. Wrap `FlutterBluetooth` in a mockable non-static class
2. Add your mocked functions to the mockable class.
2. Use the mockable class in your code

A full example is [here](https://dsavir-h.medium.com/mocking-bluetooth-in-flutter-updated-cb3b9484ae02).

## Mockable class

Create the following class:

```dart
import '../flutter_bluetooth.dart';

/// Wrapper for FlutterBluetooth in order to easily mock it
/// Wraps all static calls for testing purposes
class FlutterBluetoothMockable {
  Future<void> startScan({
    List<Guid> withServices = const [],
    Duration? timeout,
    Duration? removeIfGone,
    bool oneByOne = false,
    bool androidUsesFineLocation = false,
  }) {
    return FlutterBluetooth.startScan(
        withServices: withServices,
        timeout: timeout,
        removeIfGone: removeIfGone,
        oneByOne: oneByOne,
        androidUsesFineLocation: androidUsesFineLocation);
  }

  Stream<BluetoothAdapterState> get adapterState {
    return FlutterBluetooth.adapterState;
  }

  Stream<List<ScanResult>> get scanResults {
    return FlutterBluetooth.scanResults;
  }

  bool get isScanningNow {
    return FlutterBluetooth.isScanningNow;
  }

  Stream<bool> get isScanning {
    return FlutterBluetooth.isScanning;
  }

  Future<void> stopScan() {
    return FlutterBluetooth.stopScan();
  }

  void setLogLevel(LogLevel level, {color = true}) {
    return FlutterBluetooth.setLogLevel(level, color: color);
  }

  LogLevel get logLevel {
    return FlutterBluetooth.logLevel;
  }

  Future<bool> get isSupported {
    return FlutterBluetooth.isSupported;
  }

  Future<String> get adapterName {
    return FlutterBluetooth.adapterName;
  }

  Future<void> turnOn({int timeout = 60}) {
    return FlutterBluetooth.turnOn(timeout: timeout);
  }

  List<BluetoothDevice> get connectedDevices {
    return FlutterBluetooth.connectedDevices;
  }

  Future<List<BluetoothDevice>> get systemDevices {
    return FlutterBluetooth.systemDevices;
  }

  Future<PhySupport> getPhySupport() {
    return FlutterBluetooth.getPhySupport();
  }

  Future<List<BluetoothDevice>> get bondedDevices {
    return FlutterBluetooth.bondedDevices;
  }
}
```

## Mock the wrapper class

Using e.g. [Mockito](https://pub.dev/packages/mockito), create a mock for the `FlutterBluetoothMockable` class, and build your tests and stubs.

## Create instance

Use the mockable class where needed, e.g. in `main.dart`:

```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  //instance of FlutterBluetooth that will be passed
  //throughout the app as necessary
  FlutterBluetoothMockable bluePlusMockable = FlutterBluetoothMockable();//<--

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

## Use mock instead of FlutterBluetooth

Within your code, replace all calls to `FlutterBluetooth` with the mockable instance, e.g.:  
`FlutterBluetooth.isScanning` --> `bluePlusMockable.isScanning`  
`FlutterBluetooth.startScan` --> `bluePlusMockable.startScan`  
`FlutterBluetooth.scanResults` --> `bluePlusMockable.scanResults`  
etc.

## Example

Detailed example is [here](https://dsavir-h.medium.com/mocking-bluetooth-in-flutter-updated-cb3b9484ae02).
