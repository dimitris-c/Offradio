platform :ios, '9.0'

target 'Offradio' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Offradio
  pod 'Alamofire'
  pod 'AlamofireNetworkActivityIndicator'
  pod 'SwiftyJSON'
  pod 'Bolts'
  pod 'FBSDKCoreKit'
  pod 'FBSDKShareKit'
  pod 'FBSDKLoginKit'
  pod 'SDWebImage'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'TwitterKit'
  pod 'RealmSwift'
  pod 'RxRealm'
  pod 'RxSwift',    '~> 3.0'
  pod 'RxCocoa',    '~> 3.0'
  pod 'RxAlamofire'
  pod 'AutoScrollLabel'
  
  target 'OffradioTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'OffradioUITests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'OffradioWatchKit Extension' do
      platform :watchos, '2.0'
      pod 'RxSwift',    '~> 3.0'
      pod 'SwiftyJSON'
      pod 'SDWebImage'
      
  end
  
end

post_install do |installer|
    require 'fileutils'
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
    
    #FileUtils.cp_r('Pods/Target Support Files/Pods-Carlito/Pods-Carlito-acknowledgements.plist', 'Carlito/Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end

