Pod::Spec.new do |spec|
  spec.name         = "Hasura"
  spec.version      = "0.0.2"
  spec.summary      = "The iOS SDK for Hasura written in Swift"
  spec.license      = { :type => "MIT", :file => "LICENSE"}
  spec.author       = { "Jaison Titus" => "jaison@hasura.io" }
  spec.source       = { :git => "https://github.com/hasura/iOS-sdk.git", :tag => "v" + spec.version.to_s }
  spec.requires_arc = true
  spec.homepage = "https://github.com/hasura/iOS-sdk"
  spec.ios.deployment_target = '8.0'
  spec.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }

  spec.source_files  = 'Source/**/*.swift'
  spec.dependency "Alamofire", "~> 4.1"
  spec.dependency "ObjectMapper", "~> 2.2.7"
  spec.dependency "AlamofireObjectMapper", "~> 4.1.0"
end
