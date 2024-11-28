

Pod::Spec.new do |spec|
  spec.name         = "ZIGSDK"
  spec.version      = "1.0.16"
  spec.summary      = "ZIG SDK for ticket validation"
  spec.description  = "This SDK includes ticket validation, toll validation, and user notifications with various functionalities for ticket management."
  spec.homepage     = "https://github.com/ZIGSDK/ZIGSDK"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author             = { "ZED DIGITAL" => "kamalesh@zed.digital" }
  spec.source       = { :git => "https://github.com/ZIGSDK/ZIGSDK.git", :tag => "1.0.16" }
  spec.ios.deployment_target = '13.0'
  spec.source_files = 'MainClasses/**/*.swift'
  spec.resources     = [
    "ZIGSDK", "Resource/Assets.xcassets",
    "ZIGSDK", "Resource/**/*.storyboard",
    "ZIGSDK", "Resource/**/*.xib"
                       ]
  spec.swift_version = '5.0'
  spec.dependency 'Alamofire'
  spec.dependency 'CocoaMQTT'
  spec.dependency 'Realm'
  spec.dependency 'RealmSwift'
  spec.dependency 'MqttCocoaAsyncSocket'
  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
