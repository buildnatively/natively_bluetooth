#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_bluetooth.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_bluetooth_darwin'
  s.version          = '0.0.2'
  s.summary          = 'Flutter plugin for connecting and communicating with Bluetooth Low Energy devices, on Android and iOS'
  s.description      = 'Flutter plugin for connecting and communicating with Bluetooth Low Energy devices, on Android and iOS'
  s.homepage         = 'https://github.com/buildnatively/flutter_bluetooth'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Chip Weinberger' => 'example@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files        = 'flutter_bluetooth_darwin/Sources/flutter_bluetooth_darwin/**/*.{h,m}'
  s.public_header_files = 'flutter_bluetooth_darwin/Sources/flutter_bluetooth_darwin/include/**/*.h'
  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.14'
  s.framework = 'CoreBluetooth'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', }
end
