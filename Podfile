# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'AndShare' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AndShare

  # firebase
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Storage'
  pod 'Firebase/Messaging'

  # calendar
#  pod 'Koyomi'
  
  pod 'RxSwift',    '~> 4.0'
  pod 'RxCocoa',    '~> 4.0'
  pod 'RxGesture'
  pod 'RxDataSources', '~> 3.0'

  pod 'GoogleAPIClientForREST/Calendar', '~> 1.2.1'
  pod 'GoogleSignIn', '~> 4.1.1'

  target 'AndShareTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', '~> 4.0'
    pod 'RxTest',     '~> 4.0'
  end

  target 'AndShareUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
