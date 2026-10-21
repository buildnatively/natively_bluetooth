#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint natively_bluetooth.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'natively_bluetooth'
  s.version          = '0.0.2'
  s.summary          = 'Flutter plugin for connecting and communicating with Bluetooth Low Energy devices on iOS'
  s.description      = 'Flutter plugin for connecting and communicating with Bluetooth Low Energy devices on iOS'
  s.homepage         = 'https://github.com/buildnatively/natively_bluetooth'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Chip Weinberger' => 'example@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files        = 'natively_bluetooth/Sources/natively_bluetooth/**/*.{h,m}'
  s.public_header_files = 'natively_bluetooth/Sources/natively_bluetooth/include/**/*.h'
  s.ios.dependency 'Flutter'
  s.ios.deployment_target = '12.0'
  s.framework = 'CoreBluetooth'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', }
end
