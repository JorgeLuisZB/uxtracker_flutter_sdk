Pod::Spec.new do |s|
  s.name             = 'uxtracker_flutter_sdk'
  s.version          = '1.0.0-beta.1'
  s.summary          = 'UxTracker product analytics for Flutter.'
  s.description      = 'Flutter wrapper over the native UxTracker iOS SDK.'
  s.homepage         = 'https://github.com/JorgeLuisZB/uxtracker_flutter_sdk'
  s.license          = { :type => 'Commercial', :file => '../LICENSE' }
  s.author           = { 'WZA Group' => 'jorgezb.contact@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  # Local development against an unpublished native SDK: in the app's ios/Podfile, inside the Runner target,
  #   pod 'UxTrackerSDK', :path => '/path/to/uxtracker-sdk-ios'
  s.dependency 'UxTrackerSDK', '1.0.0-beta.1'
  s.platform = :ios, '13.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.9'
  s.resource_bundles = { 'uxtracker_flutter_sdk_privacy' => ['Resources/PrivacyInfo.xcprivacy'] }
end
