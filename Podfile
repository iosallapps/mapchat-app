# Podfile for MapChat
platform :ios, '17.0'

use_frameworks!
inhibit_all_warnings!

target 'MapChat' do
  # Firebase
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Messaging'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Performance'

  # Google Sign-In
  pod 'GoogleSignIn'

  # MapBox
  pod 'MapboxMaps', '~> 11.0'

  # Image Caching
  pod 'Kingfisher', '~> 7.0'

  # Linting (development)
  pod 'SwiftLint'
end

target 'MapChatTests' do
  inherit! :search_paths
end

target 'MapChatUITests' do
  inherit! :search_paths
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
