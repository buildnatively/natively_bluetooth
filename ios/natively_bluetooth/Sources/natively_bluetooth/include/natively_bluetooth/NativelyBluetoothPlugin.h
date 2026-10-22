// Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#import <Flutter/Flutter.h>

#import <CoreBluetooth/CoreBluetooth.h>

#define NAMESPACE @"natively_bluetooth"

@interface NativelyBluetoothPlugin : NSObject<FlutterPlugin, CBCentralManagerDelegate, CBPeripheralDelegate>
@end

@interface NativelyBluetoothStreamHandler : NSObject<FlutterStreamHandler>
@property FlutterEventSink sink;
@property NSDictionary *cachedBluetoothAdapterState;
@end
