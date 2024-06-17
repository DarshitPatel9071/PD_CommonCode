Pod::Spec.new do |spec|

  spec.name          = "PD_CommonCode"
  spec.version       = "1.0.0"
  spec.summary       = "All Basic Common Code at One Place"
  spec.description   = <<-DESC
                      - All Basic Extension's
                      - All Required Class
                      - Google Ad
                      - Coredata 
                      - InApp Purchase and more
                       DESC

  spec.homepage              = "https://github.com/DarshitPatel9071"
  spec.license               = { :type => "MIT", :file => "LICENSE" }
  spec.author                = { "Darshit Patel" => "" }
  spec.source        	     = { :git => "https://github.com/DarshitPatel9071/PD_CommonCode.git", :tag => "#{spec.version}"}
  spec.source_files          = "PD_CommonCode/**/*.{swift}"
  spec.resources             = "PD_CommonCode/**/*.{png,storyboard,xib,xcassets,json}"
  spec.ios.deployment_target = '12.0'
  spec.swift_versions        = "5.0"
  spec.dependency              'Firebase'
  spec.dependency              'Alamofire'
  spec.dependency              'SDWebImage'
  spec.dependency              'lottie-ios'
  spec.dependency              'Toast-Swift'
  spec.dependency              'KeychainSwift'
  spec.dependency              'FirebaseRemoteConfig'
  spec.dependency              'Google-Mobile-Ads-SDK'
  spec.static_framework      = true

end