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

  target 'OffradioTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'OffradioUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end

post_install do |installer|
    require 'fileutils'
    #FileUtils.cp_r('Pods/Target Support Files/Pods-Carlito/Pods-Carlito-acknowledgements.plist', 'Carlito/Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end