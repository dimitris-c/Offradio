source 'https://cdn.cocoapods.org/'

install! 'cocoapods', :generate_multiple_pod_projects => true

platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

target 'Offradio' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  # Pods for Offradio
  pod 'Alamofire', '~> 5.2'
  pod 'AlamofireNetworkActivityIndicator'
  pod 'Moya/RxSwift', '~> 14.0'
  pod 'Kingfisher'
  pod 'Fabric'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'RealmSwift', '~> 5.0'
  pod "RxRealm", '~> 3.0'
  pod 'RxCocoa'
  pod 'RxDataSources', '~> 4.0'
  pod 'AutoScrollLabel'
  pod 'ToggleSwitch', '~> 1.0'
  pod 'SwipeCellKit'
  pod 'Socket.IO-Client-Swift', '~> 15.2.0'
  pod 'StreamingKit', :git => 'https://github.com/tumtumtum/StreamingKit.git', :branch => 'master'

  target 'OffradioTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'OffradioUITests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'OffradioWatchKit Extension' do
      platform :watchos, '5.0'
      pod 'RxSwift'
      pod 'RxCocoa'
      pod 'Kingfisher'
  end
end